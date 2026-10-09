# frozen_string_literal: true

require "json"
require "cgi"

# FAQPage JSON-LD for blog posts: reads the rendered "Frequently asked questions"
# section (H2, then H3 question + paragraph answer pairs) and injects a FAQPage
# script before </head>. Product/project pages keep their hand-written includes.
# ponytail: regex over Jekyll's own HTML, not a DOM parser; answers are the
# paragraphs up to the next heading/hr, tags stripped.
Jekyll::Hooks.register :posts, :post_render do |post|
  out = post.output
  next unless out
  m = out.match(%r{<h2[^>]*>[^<]*questions[^<]*</h2>(.*?)(?=<h2|<hr|</article>)}mi)
  next unless m

  faqs = m[1].scan(%r{<h3[^>]*>(.*?)</h3>\s*((?:<p>.*?</p>\s*)+)}m).map do |q, a|
    strip = ->(h) { CGI.unescapeHTML(h.gsub(/<[^>]+>/, "")).gsub(/\s+/, " ").strip }
    { "@type" => "Question", "name" => strip.call(q),
      "acceptedAnswer" => { "@type" => "Answer", "text" => strip.call(a) } }
  end
  next if faqs.empty?

  ld = { "@context" => "https://schema.org", "@type" => "FAQPage", "mainEntity" => faqs }
  post.output = out.sub("</head>", "<script type=\"application/ld+json\">#{JSON.generate(ld)}</script>\n</head>")
end
