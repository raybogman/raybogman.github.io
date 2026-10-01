# frozen_string_literal: true

require "json"

# Enriches the JSON-LD that jekyll-seo-tag emits (it has no hooks for this):
# links author/publisher to the sitewide #person/#organization entities,
# adds @id, inLanguage, isPartOf, keywords, wordCount, and drops the fake
# datePublished (= build time) that seo-tag puts on non-post pages.
Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  out = doc.output
  next unless out && out.include?("<!-- Begin Jekyll SEO tag")

  site = doc.site
  base = site.config["url"]
  website = { "@type" => "WebSite", "@id" => "#{base}/#website", "name" => site.config["title"], "url" => "#{base}/" }
  re = %r{(<!-- Begin Jekyll SEO tag.*?<script type="application/ld\+json">\s*)(\{.*?\})(\s*</script>)}m

  doc.output = out.sub(re) do
    pre, json, post = Regexp.last_match(1), Regexp.last_match(2), Regexp.last_match(3)
    ld = JSON.parse(json)
    url = ld["url"] || "#{base}#{doc.url}"
    # seo-tag types anything with a date as BlogPosting; collection pages get a
    # build-time date, so only real posts may stay BlogPosting.
    is_post = doc.respond_to?(:collection) && doc.collection.label == "posts"
    ld["@type"] = "WebPage" if ld["@type"] == "BlogPosting" && !is_post
    ld["inLanguage"] = site.config["lang"] || "en"
    ld["author"] = ld["author"].merge("@id" => "#{base}/#person") if ld["author"].is_a?(Hash)
    ld["publisher"] = ld["publisher"].merge("@id" => "#{base}/#organization") if ld["publisher"].is_a?(Hash)

    case ld["@type"]
    when "WebSite"
      ld["@id"] = "#{base}/#website"
    when "BlogPosting"
      ld["@id"] = "#{url}#article"
      ld["isPartOf"] = website
      ld["articleSection"] = "Blog"
      tags = doc.data["tags"]
      ld["keywords"] = tags.join(", ") if tags.is_a?(Array) && !tags.empty?
      ld["wordCount"] = doc.content.to_s.gsub(/<[^>]+>/, " ").split.size
    else
      ld["@id"] = "#{url}#webpage"
      ld["isPartOf"] = website
      ld.delete("datePublished")
      ld.delete("dateModified")
      ld["mainEntity"] = { "@id" => "#{base}/#person" } if ld["@type"] == "ProfilePage"
    end

    pre + JSON.generate(ld) + post
  end
end
