---
title: Mage.coach
subtitle: Your Magento Performance Coach (2016 – archived)
description: 'Mage.coach — open-source Magento frontend performance analysis tool by Ray Bogman and Ronald Bethlehem (2016 – archived). Built on Sitespeed.io.'
featured_image: /assets/images/mage-coach-hero.jpg
---

> **Note:** Mage.coach is a historical / archived project. This page documents what it was, how it worked, and the community around it. The live service is no longer active.

**Mage.coach** was a set of open-source tools created to help developers and merchants analyze and optimize the **performance of Magento 1 and Magento 2 websites**. Launched as a public beta in **March 2017**, it was built on top of [Sitespeed.io](https://www.sitespeed.io/) and extended with Magento-specific "coach" rules based on YSlow and PageSpeed best practices.

---

## The idea

Magento performance optimization has always been 80% frontend, 20% backend. Mage.coach focused squarely on the **frontend 80%** — UX, UI, SEO, rendering, asset delivery — using a Docker-based test runner with real Chrome/Firefox browsers to simulate how a real user experiences a page load.

The project was born out of a passion for speedy websites, and a gap in the Magento tooling space: while there were plenty of generic web performance tools, there wasn't a **Magento-specific performance coach** that would tell you exactly what to fix and why.

---

## How it worked

1. Submit a Magento page URL at `run.mage.coach`
2. Mage.coach spun up a Docker-based test runner with the latest Chrome or Firefox
3. Each page was scored against:
   - **Web performance best-practice rules** (YSlow, PageSpeed, Magento-specific rules)
   - **Timing metrics** via the Navigation Timing API
4. Results came back with actionable recommendations, aimed at both developers and merchants

### Configurable scanning options

- **Runs per URL** — 1, 2, or 3 runs for a stable median result
- **Multi-page scans** — automatically follow links on the submitted page
- **Depth level** — up to 3 levels deep for full-site analysis
- **Connection types** — test under realistic conditions:
  - Mobile 3G (fast/slow/gem variants)
  - Mobile 2G
  - Cable
  - Native (unthrottled)

---

## Milestones

### March 2017 — Public Beta opens
Mage.coach launched as an open beta at `run.mage.coach` — a free, browser-based tool for analyzing any Magento page against a curated ruleset of performance best practices.

### August 2017 — v0.1.1 released
New scanning features: configurable runs-per-URL, multi-page crawling, configurable depth, and a Premium tier for Partners/Sponsors offering 50+ scans and extended features.

### September 2017 — Meet Magento Poland, Belgium, Spain
Mage.coach was presented at three European Meet Magento events, introducing the community to Magento-specific frontend performance analysis.

### 2017 – 2020 — Community & conference circuit
Presented at Meet Magento Madrid (2017), Meet Magento Poland (2017), and featured in performance-focused talks at Webperfdays Amsterdam and other European Magento events.

---

## The team

Mage.coach was a two-person open-source project built in spare time.

### Ray Bogman
Creator, performance lead, and Magento evangelist. [Read more about Ray →](/about)

### Ronald Bethlehem
Co-creator. [Connect with Ronald on LinkedIn](https://www.linkedin.com/in/ronald-bethlehem-65456782/).

With thanks to **Peter Hedenskog**, creator of [Sitespeed.io](https://www.sitespeed.io/), the engine underneath Mage.coach.

---

## Legacy

While the live service is no longer running, the lessons baked into Mage.coach — that **Magento performance is overwhelmingly a frontend problem**, and that **continuous measurement beats one-off audits** — continue to shape my consulting and training work today. Many of the rules Mage.coach applied are now baseline expectations in modern Magento/PWA delivery.

If you're working on Magento performance now, the modern tools to reach for are [Sitespeed.io](https://www.sitespeed.io/), [Lighthouse CI](https://github.com/GoogleChrome/lighthouse-ci), and [Core Web Vitals](https://web.dev/vitals/) — all of which I've written about in the [blog](/).

{% include reviews.html %}
