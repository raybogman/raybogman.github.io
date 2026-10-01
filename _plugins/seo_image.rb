# frozen_string_literal: true

# jekyll-seo-tag only reads `page.image`; this site's front matter uses
# `featured_image`. Map it (fallback: site.image) so og:image, twitter:image,
# twitter:card and the BlogPosting JSON-LD `image` field all come from seo-tag.
Jekyll::Hooks.register [:pages, :documents], :pre_render do |doc|
  doc.data['image'] ||= doc.data['featured_image'] || doc.site.config['image']
end
