---
title: "AI WordPress Sync for Jekyll & GitHub Pages: Edit in WordPress, Publish to GitHub"
date: "2026-06-01 09:00:00 +0000"
description: "I built and released a free, open-source WordPress plugin that publishes posts to Jekyll on GitHub Pages — with optional AI for SEO descriptions and image alt text. Download from GitHub today."
featured_image: "/assets/images/ai-wordpress-sync-for-jekyll-github-pages.png"
tags: [AI, WordPress, Jekyll, GitHub Pages, Open Source, Plugin]
---

**Most static-site evangelists will tell you the trade-off is fair: lose the WordPress editor to gain Jekyll's speed, security, and near-zero hosting cost. I'm here to tell you that trade-off is no longer necessary.**

After months of running this exact site (the one you're reading right now) on a hybrid setup — WordPress for writing, Jekyll on GitHub Pages for hosting — I built the missing piece and released it as free, open-source software.

It's called **[AI WordPress Sync for Jekyll & GitHub Pages](/products/ai-wordpress-jekyll-sync/)**, and it's [available on GitHub today](https://github.com/raybogman/raybogman-ai-sync-for-jekyll). The WordPress.org listing is currently under review — once it ships, you'll be able to install it like any other plugin from the official directory.


## The Conventional Wisdom

The prevailing belief is that you have to pick a side. Either you commit to WordPress and accept the hosting bill, the database backups, the plugin update cycle, and the eternal performance optimization treadmill. Or you commit to a static site generator like Jekyll, give up the WordPress editor, and accept that every post means writing Markdown by hand, uploading images manually, and rewriting your internal links every time.

Most "WP-to-static" exporters reinforce this binary thinking — they run a one-shot dump and leave you with a folder of Markdown files you now have to maintain by hand. The migration is treated as a one-way door. Once you walk through it, the WordPress editor is gone.


## A Different Perspective

**You don't have to pick a side. You can have the WordPress editor _and_ Jekyll's performance, with AI cleaning up the boring bits in between.**

That's the entire premise of AI WordPress Sync for Jekyll & GitHub Pages. You write in WordPress as normal. The plugin watches for publishes, converts your HTML to clean Markdown with YAML front matter that matches your existing Jekyll site's conventions, uploads featured and inline images to your Jekyll repository, rewrites internal links, and commits everything to GitHub — all in one click.

The "AI" part isn't a gimmick. The plugin uses Claude or OpenAI (your choice, your API key) for two genuinely tedious tasks:

- **SEO meta descriptions** — when Yoast or RankMath haven't been filled in, the AI drafts a 1-2 sentence description on demand
- **Image alt text** — vision models look at the actual image content and write real alt text, not filename guesses

Disable AI entirely and the plugin still does the heavy lifting. The AI is the optional cherry on top — bring your own key, switch it on per task, or never switch it on at all.


## What's Actually In It

A short tour of what makes this different from every other WP-to-static plugin I've tried:

- **Style-aware conversion** — reads your existing Jekyll site's `_config.yml` and a sample of posts to match your front matter schema, Markdown conventions, and permalink patterns. No find-replace cleanup after the first sync.
- **GitHub OAuth login** — one click to connect. No personal access tokens to paste, copy, or rotate.
- **Two-way sync** — pull Jekyll posts back into WordPress as drafts. Edit them in the WordPress UI and re-push.
- **Featured + inline image upload** — every image in your post body lands in your Jekyll `assets/images/` folder, deduplicated, with URLs rewritten in the Markdown.
- **Internal link rewriting** — WordPress domain links become Jekyll site URLs automatically.
- **Per-post diff and verify** — colour-coded comparison against the live Jekyll version, plus hash verification against the GitHub copy so you spot drift before re-pushing.
- **Scheduled background sync and auto-push on publish** — set it and forget it.
- **GitHub Actions workflow trigger** — the plugin can fire your build pipeline after each push, so deploys happen automatically.


> "The technology stack you choose for your blog should match the way you actually want to work — not the other way around. WordPress for writing, Jekyll for serving, GitHub for version control, AI for the boring bits. That's the setup I run. That's the setup this plugin is designed for."


## Where This Fits — and Where It Doesn't

Let me be honest about what this plugin is *for*. WordPress is a serious platform with serious capabilities — e-commerce, membership sites, learning management systems, complex forms, dynamic dashboards, custom post types backed by hundreds of plugins. **If you need any of that, keep running WordPress as your live site. Don't sync to Jekyll. The static side can't do server-side things.**

This plugin is for the specific case where WordPress is being used as **an editor** — nothing more. If your site is a blog, a personal brand site, a portfolio, a documentation hub, a developer site, or anything else that's fundamentally static content rendered to readers, then **WordPress is overkill for serving but unbeatable for writing**. Pair it with Jekyll on GitHub Pages and you get the best of both: the editor you already know, zero hosting cost, near-instant page loads, and full version control on every post.

In other words: if WordPress's database, plugins, and admin are the product, run WordPress. If the *writing experience* is the only thing you actually need from WordPress, this plugin lets you keep the writing and drop the rest.


## Acknowledging the Counterarguments

Some will say: "Why not just use a headless CMS and skip WordPress entirely?" Fair point — but headless CMS solutions cost money, lock you into proprietary editors, and lose the entire WordPress plugin ecosystem (Yoast, RankMath, Advanced Custom Fields, the lot). If you already have a WordPress instance you like, the cost of staying is zero.

Others will argue: "Markdown is fine, I can write it directly." Yes — you can. But have you ever tried writing a 3,000-word post with twelve images, six internal links, and a code block in pure Markdown directly into a GitHub repository? It's not impossible. It's just slower than necessary, and far more error-prone than letting the WordPress editor handle the heavy lifting.

And some will say: "Why the AI? Plain conversion is enough." Then disable the AI features. The plugin still works. The AI is optional, byok, and disabled by default.


## What This Means for WordPress Developers and Jekyll Enthusiasts

**If you've ever wished WordPress could publish to GitHub Pages with one click, this is for you.**

Concrete use cases I'm already seeing:

- **Agencies maintaining client Jekyll sites** while letting clients write in WordPress — clients get the editor they know, agencies get the performance and version control of a static site.
- **Developers running personal Jekyll blogs** who miss the WordPress editor — write in WordPress, publish to Jekyll, get the best of both worlds.
- **Teams migrating from WordPress to Jekyll** who don't want to lose the writing UX — run a one-shot bulk sync, keep using the plugin for ongoing edits.
- **Technical writers** who want Markdown output that matches their existing site's conventions — style-aware mode handles this automatically.


## What Should You Do About It

Here are my direct, actionable recommendations:

1. **Download the plugin from GitHub today** — it's GPL-2.0-or-later, open source, and free forever. [github.com/raybogman/raybogman-ai-sync-for-jekyll](https://github.com/raybogman/raybogman-ai-sync-for-jekyll)
2. **Create a GitHub OAuth App** on your own GitHub account (free, takes two minutes). The plugin's settings page tells you exactly what callback URL to use.
3. **Point it at your existing Jekyll repository** — style detection runs automatically against your `_config.yml` and existing posts.
4. **Approve a test post and push it** — preview the Markdown output before committing if you want. Diff it against your existing posts to verify the style match.
5. **Bring your own AI key (optional)** — Anthropic Claude or OpenAI. Costs go directly to the provider. Typical: ~$0.001 per SEO description, ~$0.01 per AI alt-text generation.

If you'd rather wait, the WordPress.org listing is currently under review — once it ships you'll be able to install it like any other plugin from the official directory. The GitHub release is the same code, ready to go today.


## Frequently Asked Questions


### Is it really free?
Yes. GPL-2.0-or-later. No paid tier, no premium upgrade, no telemetry. The full source is on GitHub. The only optional cost is AI generation, which uses your own API key and bills you directly.


### Does it work with my existing Jekyll site?
Yes. Style-aware mode reads your `_config.yml` and a sample of existing posts to match your conventions. It detects front matter schema, Markdown style (heading style, list markers, emphasis, fences), permalink patterns, and image paths automatically.


### What about Yoast SEO or RankMath?
Both are auto-detected. Meta description, focus keyphrase, and (where present) Open Graph fields are mapped into the Jekyll front matter. You don't have to choose between SEO plugins on WordPress and clean front matter on Jekyll — you get both.


### Can I migrate my whole WordPress site to Jekyll with this?
Yes — that's a primary use case. Run a one-shot bulk sync to push every post into a fresh Jekyll repo, then keep using the plugin for ongoing edits. The migration becomes a continuous process instead of a one-way door.


### When is the WordPress.org listing coming?
It's currently under review at WordPress.org. The GitHub release contains the same code — install it manually now, switch to the WordPress.org auto-update channel once the listing goes live.


### Is this related to AI Content Orchestrator?
They're independent plugins that compose well. Use [AI Content Orchestrator](/products/ai-content-orchestrator/) to *generate* content with AI inside WordPress, then use [AI WordPress Sync](/products/ai-wordpress-jekyll-sync/) to *publish* it to your Jekyll site. Neither requires the other.


---

**The technology stack you choose for your blog should match the way you actually want to work.** If WordPress is where you think best, keep writing there. If Jekyll on GitHub Pages is where you want to serve, keep serving there. Stop letting the gap between the two cost you hours every week.

Try it today: [github.com/raybogman/raybogman-ai-sync-for-jekyll](https://github.com/raybogman/raybogman-ai-sync-for-jekyll) — and let me know what you'd like to see in version 1.1. Drop a comment below, or [get in touch](/contact/) directly.
