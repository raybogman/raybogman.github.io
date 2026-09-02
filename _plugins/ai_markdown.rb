# frozen_string_literal: true

#
# ai_markdown.rb
#
# Generates a Markdown "twin" for every page (served at <url>.md, e.g.
# /about/ -> /about.md) plus an llms.txt index, so AI agents can read the site
# as clean Markdown. Runs on `jekyll build`.
#
# It writes straight into site.dest in a :post_write hook. That is deliberate:
# registering the twins as Jekyll pages with a `.md` name would make Jekyll run
# the Markdown->HTML converter on them. Writing the files ourselves keeps them
# as raw Markdown.
#
# ponytail: one plugin owns .md twins + llms.txt. Bodies are Liquid-rendered so
# {% include %}/{{ }} resolve, with a raw-source fallback if rendering raises —
# cheap insurance, not a full MDX pipeline.

require "yaml"
require "fileutils"

module AiMarkdown
  FRONTMATTER = /\A---\s*\n.*?\n---\s*\n/m

  # Sections in the order they appear in llms.txt. "Optional" is the spec's
  # bucket for low-value/skippable pages and always sits last.
  SECTION_ORDER = ["Pages", "Blog", "Projects", "Mage-Coach", "Magento 2 Cookbook", "Optional"].freeze

  # Page slugs that belong under the "Optional" section (utility/thin pages).
  OPTIONAL_SLUGS = %w[tags thanks].freeze

  # Repo/meta files that are not site content (matched case-insensitively, no ext).
  SKIP_BASENAMES = %w[readme changelog license licence contributing code_of_conduct 404].freeze

  module_function

  # /about/ -> "about.md" ; /blog/slug/ -> "blog/slug.md" ; / -> nil
  def twin_rel_path(url)
    parts = url.split("/").reject(&:empty?)
    return nil if parts.empty?

    File.join(*parts) + ".md"
  end

  # magecoach/aboutus/index.md -> "magecoach/aboutus.md"
  # mage2cookbook/chat.html    -> "mage2cookbook/chat.md"
  def twin_from_source(rel_source)
    noext = rel_source.sub(/\.[^.\/]+\z/, "")
    noext = noext.sub(/\/index\z/, "")
    noext.empty? ? nil : noext + ".md"
  end

  def strip_frontmatter(raw)
    raw.sub(FRONTMATTER, "")
  end

  def parse_frontmatter(raw)
    m = raw.match(/\A---\s*\n(.*?)\n---\s*\n/m)
    return {} unless m

    # Trusted, first-party build content.
    YAML.load(m[1]) || {} # rubocop:disable Security/YAMLLoad
  rescue StandardError
    {}
  end

  def render_liquid(site, body, page_payload)
    info = {
      registers: { site: site },
      strict_filters: false,
      strict_variables: false,
    }
    template = site.liquid_renderer.file("(ai-markdown)").parse(body)
    template.render!(site.site_payload.merge("page" => page_payload), info)
  rescue StandardError
    body
  end

  def build_file(title, url_abs, description, body)
    front = { "title" => title.to_s, "url" => url_abs }
    front["description"] = description.to_s unless description.to_s.strip.empty?
    "#{YAML.dump(front)}---\n\n#{body.strip}\n"
  end

  def write(site, rel_path, contents)
    dest = File.join(site.dest, rel_path)
    FileUtils.mkdir_p(File.dirname(dest))
    File.write(dest, contents)
  end
end

Jekyll::Hooks.register :site, :post_write do |site|
  base = site.config["url"].to_s.chomp("/")
  index = []      # each: { section:, title:, url:, description: }
  full_docs = []  # main-site pages/posts, for llms-full.txt

  # -- Jekyll documents (pages collection, posts, projects, ...) ------------

  emit_doc = lambda do |doc, section|
    rel = AiMarkdown.twin_rel_path(doc.url)
    next if rel.nil?

    raw = File.read(doc.path)
    body = AiMarkdown.render_liquid(site, AiMarkdown.strip_frontmatter(raw), doc.to_liquid)
    title = doc.data["title"] || File.basename(doc.path, ".*")
    description = doc.data["description"]
    url_abs = "#{base}#{doc.url.sub(%r{/\z}, '')}.md"

    # Utility/thin pages go under "Optional" rather than the main list.
    slug = File.basename(rel, ".md")
    section = "Optional" if AiMarkdown::OPTIONAL_SLUGS.include?(slug)

    AiMarkdown.write(site, rel, AiMarkdown.build_file(title, url_abs, description, body))
    index << { section: section, title: title.to_s, url: url_abs, description: description }
    full_docs << { title: title.to_s, url: url_abs, body: body }
  end

  # Root front-matter pages that are Markdown (skips index.html, 404.html, css, feeds…).
  site.pages.each do |page|
    next unless page.path.end_with?(".md", ".markdown")

    emit_doc.call(page, "Pages")
  end

  site.posts.docs.each { |doc| emit_doc.call(doc, "Blog") }

  site.collections.each do |name, collection|
    next if name == "posts"

    section = name == "pages" ? "Pages" : name.capitalize
    collection.docs.each { |doc| emit_doc.call(doc, section) }
  end

  # -- Excluded mini-sites: read source from disk, emit .md twins -----------
  # These nested sites are excluded from the HTML build; we still expose their
  # Markdown. Their own Liquid won't resolve here, so render_liquid falls back
  # to raw source.
  # ponytail: skip `_`-prefixed dirs (their _layouts/_includes/_posts); top-level
  # content pages are the ones worth exposing. Widen later if the posts matter.
  mini_sites = {
    "magecoach" => { section: "Mage-Coach", glob: "**/*.md" },
    "mage2cookbook" => { section: "Magento 2 Cookbook", glob: "**/*.html" },
  }

  mini_sites.each do |dir, cfg|
    root = File.join(site.source, dir)
    next unless Dir.exist?(root)

    Dir.glob(File.join(root, cfg[:glob])).sort.each do |abs|
      rel_source = abs.sub("#{site.source}/", "")
      next if rel_source.split("/").any? { |seg| seg.start_with?("_") }
      next if AiMarkdown::SKIP_BASENAMES.include?(File.basename(abs, ".*").downcase)

      rel = AiMarkdown.twin_from_source(rel_source)
      next if rel.nil?

      raw = File.read(abs)
      fm = AiMarkdown.parse_frontmatter(raw)
      body = AiMarkdown.render_liquid(site, AiMarkdown.strip_frontmatter(raw), {})
      title = fm["title"] || File.basename(abs, ".*").tr("-_", "  ").capitalize
      description = fm["description"]
      url_abs = "#{base}/#{rel}"

      AiMarkdown.write(site, rel, AiMarkdown.build_file(title, url_abs, description, body))
      index << { section: cfg[:section], title: title.to_s, url: url_abs, description: description }
    end
  end

  # -- Curated extras (blockquote summary + knowledge appendix) -------------
  # _llms-extra.md holds hand-maintained, high-value content the page list
  # can't express: a `>` summary, then (after a `---`) Key facts / certs /
  # expertise / contact. Split on the first horizontal rule.
  summary_block = nil
  appendix_block = nil
  extra_path = File.join(site.source, "_llms-extra.md")
  if File.exist?(extra_path)
    parts = File.read(extra_path).split(/^---\s*$/, 2)
    summary_block = parts[0].to_s.strip
    appendix_block = parts[1].to_s.strip
  end

  # -- llms.txt index (Claude's format: links point at the .md versions) ----

  title_line = [site.config["title"], site.config["tagline"]].compact.reject(&:empty?).join(" — ")
  lines = ["# #{title_line}", ""]
  lines << (summary_block && !summary_block.empty? ? summary_block : "> #{site.config['description']}")
  lines << ""
  lines << "Every page is mirrored as Markdown at the same path with a `.md` suffix. The full text of the site is at #{base}/llms-full.txt."
  lines << ""

  ordered = index.group_by { |e| e[:section] }
  section_names = (AiMarkdown::SECTION_ORDER & ordered.keys) + (ordered.keys - AiMarkdown::SECTION_ORDER)

  section_names.each do |section|
    lines << "## #{section}"
    lines << ""
    ordered[section].sort_by { |e| e[:title].downcase }.each do |e|
      desc = e[:description].to_s.strip
      suffix = desc.empty? ? "" : " - #{desc}"
      lines << "- [#{e[:title]}](#{e[:url]})#{suffix}"
    end
    lines << ""
  end

  if appendix_block && !appendix_block.empty?
    lines << appendix_block
    lines << ""
  end

  AiMarkdown.write(site, "llms.txt", lines.join("\n").rstrip + "\n")

  # -- llms-full.txt (full Markdown of every main-site page, concatenated) --

  full = ["# #{title_line}", ""]
  full << (summary_block && !summary_block.empty? ? summary_block : "> #{site.config['description']}")
  full << ""
  full << "Full Markdown of every page on #{base}."
  full << ""
  full_docs.each do |d|
    full << "# #{d[:title]}"
    full << ""
    full << "Source: #{d[:url]}"
    full << ""
    full << d[:body].strip
    full << ""
    full << "---"
    full << ""
  end
  full << appendix_block if appendix_block && !appendix_block.empty?

  AiMarkdown.write(site, "llms-full.txt", full.join("\n").rstrip + "\n")

  Jekyll.logger.info "AiMarkdown:", "wrote #{index.size} .md twins + llms.txt + llms-full.txt"
end
