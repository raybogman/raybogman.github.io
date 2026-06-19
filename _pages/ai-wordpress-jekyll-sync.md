---
title: AI WordPress Sync for Jekyll & GitHub Pages — Free WordPress Plugin
subtitle: AI-assisted WordPress → Jekyll on GitHub Pages sync. One click.
description: 'AI WordPress Sync for Jekyll & GitHub Pages — open-source WordPress plugin that converts posts and pages to Jekyll Markdown with YAML front matter and pushes them straight to a GitHub Pages repository. Free, GPL-licensed, with style-aware conversion, two-way sync, GitHub OAuth, and optional AI for SEO descriptions and image alt text.'
featured_image: /assets/images/ai-content-orchestrator.png
permalink: /products/ai-wordpress-jekyll-sync/
redirect_from:
  - /products/ai-jekyll-sync/
seo:
  type: WebPage
---

## The AI bridge from WordPress to Jekyll on GitHub Pages.

Jekyll on GitHub Pages is great for performance, version control, and zero hosting cost. WordPress is great for writing. **AI WordPress Sync for Jekyll & GitHub Pages** is the bridge — write in WordPress, click publish, and your post lands in your Jekyll repository as Markdown with the right front matter, the right images, and the right internal links. Optional Claude or OpenAI fills in SEO meta and image alt text on the way. No copy-paste. No format drift. No manual image uploads.

**100% free. GPL-licensed. Open source. Submitted to WordPress.org.**

---

## How it works — 3 moving parts

A simple pipeline that runs entirely from your WordPress admin.

### 1 — Connect your GitHub repo
One-click GitHub OAuth login (no personal access tokens to paste). Pick your repo and branch from a live dropdown. Done.

### 2 — Approve and push
Posts you mark as "Approved" are pushed to GitHub as Markdown with YAML front matter. Featured images, inline images, and internal links are converted automatically. Or enable **auto-push on publish** — every WordPress publish becomes a Jekyll commit.

### 3 — Jekyll rebuilds itself
Optional GitHub Actions workflow trigger fires after each push, so your Jekyll site rebuilds and deploys with no manual step.

---

## What's inside

### Style-aware conversion
This is the feature that sets it apart from every other "WP-to-static" plugin. Point it at your existing Jekyll site and it **reads `_config.yml` and your existing posts** to detect:

- Front matter schema (title, date, categories, tags, layout, permalink, custom fields)
- Markdown style (heading style, list style, emphasis, fence syntax)
- Permalink patterns
- Yoast SEO and RankMath field mapping

Pushed content matches your existing Jekyll conventions instead of imposing a new format. No find-replace cleanup after the first sync.

### GitHub OAuth (no tokens)
Standard OAuth App flow. Click "Connect to GitHub" → authorize → you're in. No personal access tokens to generate, paste, or rotate.

### Two-way sync
Pulls Jekyll posts back into WordPress as drafts so you can edit existing posts in WordPress and re-push them. Solo authors stay sane; teams stay aligned.

### Inline + featured image sync
Featured images and every inline `<img>` in your post body are uploaded to your Jekyll `assets/images/` folder, deduplicated, and the URLs rewritten in the Markdown. No more broken images on the static side.

### Internal link rewriting
Internal links to your WordPress domain are rewritten to your Jekyll site URL (auto-detected from `_config.yml` or set manually). External links are left alone.

### Optional AI for SEO and accessibility
Bring your own Claude (Anthropic) or OpenAI key. The plugin can generate:

- **SEO meta descriptions** — when Yoast / RankMath are missing one
- **Image alt text** — using vision models on the actual image content (real alt text, not filename guesses)

Disabled by default. Bring your key, switch it on per-task. Costs go directly to your AI provider.

### Scheduled background sync
WP-Cron runs every 1, 6, 12, or 24 hours to catch posts you missed approving manually. Two modes: push everything new, or only push posts with the "Approved" flag.

### Per-post diff + verify
- **Diff view** — colour-coded comparison (green additions, red deletions) between your current WordPress content and the live Jekyll version
- **Verify** — file-hash comparison against the GitHub copy to detect external edits (e.g. someone edited the Markdown directly on GitHub)

### Articles dashboard
- Per-row actions: Push, Preview Markdown, AI-generate, Diff, Delete, Verify
- Bulk actions, type filter (Posts / Pages), search
- Approve toggle for the auto-push workflow
- Stats panel: total posts, published, outdated, not-published, approved
- Recent activity log

### Author and path control
- Choose which WordPress author's posts get synced
- Configure separate paths for posts (`_posts/`) and pages (`_pages/`)
- Skip drafts, private, password-protected, and trashed posts automatically

---

## Who it's for

- **Developers running a Jekyll blog** who miss the WordPress editor
- **Teams migrating from WordPress to Jekyll** without losing the writing UX
- **Technical writers** who want Markdown output that matches their existing site's conventions
- **Agencies maintaining client Jekyll sites** while letting clients write in WordPress
- **Anyone tired of copy-pasting posts between two systems**

---

## What makes it different

| Other WP-to-static plugins | AI WordPress Sync for Jekyll |
|---|---|
| Generate a static site, you handle deploy | Pushes Markdown straight to GitHub, GH Actions handles deploy |
| Personal access tokens to paste | GitHub OAuth — one click |
| Imposes a fixed Markdown / front-matter format | Reads your existing Jekyll site, matches its conventions |
| One-way export | Two-way sync — pull Jekyll posts back as WP drafts |
| Featured images only | Featured + inline images, deduplicated |
| Manual image alt text | Optional AI alt-text via Claude / OpenAI vision |
| You write your own SEO descriptions | Auto-fills missing Yoast / RankMath descriptions via AI |
| No way to verify drift | Per-post hash verify + colour-coded diff |
| Paid or freemium | 100% free, GPL, open source |

---

## Technical details

- **WordPress** 5.8 – 6.7+ (tested up to 6.7)
- **PHP** 7.4+
- **Pure PHP + jQuery** — no heavy frameworks, lightweight
- **No custom database tables** — uses WordPress options and post meta
- **Security** — nonce verification, capability checks, input sanitization, output escaping, prepared SQL
- **i18n ready** — full translation support
- **External services** (only when used): GitHub REST API, Anthropic Claude API (optional), OpenAI API (optional). All documented in the readme with terms/privacy links.
- **License** — GPL-2.0-or-later

---

## Get it

<div class="contact-actions" markdown="0">
  <a href="https://github.com/raybogman/raybogman-ai-sync-for-jekyll" class="button button--large">
    <i class="fab fa-github"></i> Download from GitHub
  </a>
</div>

<p style="text-align: center; opacity: 0.7; margin-top: 0.75rem;"><em>Free and open source — install from GitHub today. A WordPress.org listing is on the way.</em></p>

100% free, forever. No paid tier, no upsells, no telemetry. Optional AI features use your own Claude or OpenAI key — costs go directly to the provider. Typical: $0.001 per SEO description, $0.01 per AI alt-text generation.

---

## FAQ

### What does this plugin do?
Converts WordPress posts and pages to Markdown with YAML front matter, uploads featured + inline images to your Jekyll repository's `assets/images/` folder, rewrites internal links, and commits everything to GitHub — all from inside WordPress admin.

### Is it really free?
Yes. GPL-2.0-or-later. No paid tier, no premium upgrade, no telemetry. The full source is open. The only optional cost is AI generation, which uses your own Claude or OpenAI key and bills you directly.

### How does the GitHub login work?
Standard OAuth App flow. Click "Connect to GitHub" in the plugin settings, authorize the app on github.com, and you're in. No personal access tokens to generate, copy, or rotate.

### What is "style-aware" conversion?
The plugin reads your existing Jekyll site (`_config.yml` plus a sample of existing posts) and detects your front matter schema, Markdown conventions (heading style, list style, emphasis, fences), and permalink patterns. Pushed content then matches your site's conventions automatically — no find-replace cleanup after the first sync.

### How does URL rewriting work?
Internal links pointing at your WordPress domain are rewritten to your Jekyll site URL — taken from `_config.yml`'s `url` field or set manually in the plugin's Content tab. External links are left alone.

### Can I auto-publish on WordPress publish?
Yes. Toggle "Auto-push on publish" and every approved post is pushed to GitHub the moment you click Publish in WordPress.

### Can I preview the Markdown before pushing?
Yes. The Articles list has a Preview button that opens a modal showing the exact Markdown output the plugin would push.

### What is the Diff view?
A colour-coded comparison (green for additions, red for deletions) between your current WordPress content and the live version on Jekyll. Useful for spotting drift before a re-push.

### What is Verify?
A file-hash comparison against the GitHub copy. If someone edited the Markdown directly in the GitHub repo, Verify flags it so you don't accidentally overwrite their edit.

### Does the AI feature cost extra?
The plugin is free. AI usage is optional and uses your own Claude or OpenAI API key — costs go directly to the provider. Disable AI entirely and the plugin works fully without it.

### Will this work with Yoast SEO / RankMath?
Yes. Both are auto-detected. SEO title, meta description, focus keyphrase, and (where present) Open Graph fields are mapped into the Jekyll front matter.

### Does it support Pages, not just Posts?
Yes. Toggle Posts and Pages independently in the Content tab. Each has its own target path in the repo (`_posts/` and `_pages/` by default — configurable).

### Can I migrate an existing WordPress site to Jekyll with this?
Yes — that's a primary use case. Run a one-shot bulk sync to push every post into a fresh Jekyll repo, then keep using the plugin for ongoing edits.

### Is this related to AI Content Orchestrator?
They're independent plugins. Use [AI Content Orchestrator](/products/ai-content-orchestrator/) to *generate* content with AI inside WordPress, then use AI WordPress Sync to *publish* it to your Jekyll site. They compose well, but neither requires the other.

---

### Built by Ray Bogman

25+ years in tech, ex-Adobe Head of Commerce Customer Engineering, AWS Certified AI Practitioner, Oxford AI Programme alumnus, currently Head of Innovation at Alumio. This site you're reading right now is published with this plugin. [Learn more about Ray →](/about/)

{% include reviews.html %}
