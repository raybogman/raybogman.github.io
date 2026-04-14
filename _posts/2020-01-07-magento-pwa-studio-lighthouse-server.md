---
title: 'Magento PWA Studio Lighthouse server'
date: 2020-01-07 00:00:00
description: 'Magento + PWA Studio = High Performance! Use Lighthouse Server now and monitor your Magento PWA Studio Performance on every Git push.'
featured_image: '/assets/images/magento-pwa-studio-lighthouse-server.jpg'
tags: [Magento, PWA, Lighthouse, ci/cd]
---

**Magento** + **PWA Studio** = **High Performance**! OOTB (Out Of The Box).

But please keep in mind that every custom theme/layout/template or whatever style you prefer to implement could have some minor or major drawbacks in regards to web performance.

So unless you have not read my previous blog on how to build a **[Lighthouse server](https://raybogman.com/jekyll-travis-lighthouse-heroku-ci-cd)**, please do before you continue.

When it comes to using **Google Lighthouse Server** I think it's possible to use two approaches:
1. Basic - Using a CI server and testing your URL(s) remotely.
2. Advanced - Using a CI server and testing your internally build URL(s).

For this blog, I prefer addressing the "Basic" version. The recipe is really simple: PWA Studio codebase, Lighthouse Server, Travis CI, Github account, .travis.yml and lighthouserc.yml.

And keep in mind always **Design for Performance**!

### Summary Steps
1. [Install lighthouse-ci locally](#1-install-lighthouse-ci-locally)
2. [Signup and create .travis.yml file](#2-signup-and-create-travisyml-file)
3. [Create lighthouserc.yml](#3-create-lighthousercyml-with-the-following-config)
4. [Create LHCI_GITHUB_APP_TOKEN](#4-create-lhci_github_app_token-and-add-it-to-environment-variables-in-travis)
5. [Signup at Heroku](#5-signup-at-heroku)
6. [Install Heroku CLI](#6-install-heroku-cli)
7. [Create Heroku config](#7-create-heroku-config-and-push-the-app-to-production)
8. [Run lhci wizard](#8-run-lhci-wizard)
9. [Add LHCI_TOKEN to Travis](#9-add-lhci_token-to-environment-variables-in-travis)
10. [Update serverBaseUrl](#10-update-serverbaseurl-in-lighthousercyml)
11. [Push code to Git!](#11-push-code-to-git-and-let-the-magic-do-its-thing)

### 1. Install lighthouse-ci locally

```
npm install -g @lhci/cli@0.3.x
```

### 2. Signup and create .travis.yml file

![Magento PWA Studio & Install Travis CI](/assets/images/pwa-studio-install-travis-ci.jpg)

```yaml
language:
  - node_js
node_js:
  - '10'
addons:
  chrome: stable
before_install:
  - npm install -g @lhci/cli@0.3.x
script:
  - echo "Notice - no test specified"
after_success:
  - lhci autorun
```

### 3. Create lighthouserc.yml with the following config

```yaml
ci:
  collect:
    numberOfRuns: 3
    additive: true
    url:
      - https://your-url.com/
      - https://your-url.com/catalog-page/
      - https://your-url.com/product-page/
  assert:
    lighthouse: all
    assertions:
      offscreen-images: 'on'
      uses-webp-images: 'on'
      color-contrast: 'on'
      first-contentful-paint:
        - error
        - maxNumericValue: 2000
          aggregationMethod: optimistic
      interactive:
        - error
        - maxNumericValue: 5000
          aggregationMethod: optimistic
  upload:
    target: lhci
    serverBaseUrl: https://your-app-url.herokuapp.com/
    token: $LHCI_TOKEN
```

### 4-10. Setup Steps

Follow the same steps as outlined in my [previous blog post](/blog/jekyll-travis-lighthouse-heroku-ci-cd) for setting up LHCI tokens, Heroku, and the wizard.

### 11. Push code to Git and let the magic do its thing!

```
git add -A && git commit -m 'LHCI first run'
git push origin master
```

![PWA Studio Travis CI Build](/assets/images/pwa-studio-travis-ci-build.jpg)

![PWA Studio Lighthouse Dashboard](/assets/images/pwa-studio-lhci-dashboard.jpg)

![PWA Studio Lighthouse Dashboard Details](/assets/images/pwa-studio-lhci-dashboard-details.jpg)

![PWA Studio GitHub Status Check](/assets/images/pwa-studio-github-status-check.jpg)

### It's a wrap!

I hope you liked building it, well it did when prepping this.

### Manual LHCI autorun

```
lhci autorun
```

### Reference:
- [Getting Started](https://github.com/GoogleChrome/lighthouse-ci/blob/master/docs/getting-started.md)
- [Heroku Server Recipe](https://github.com/GoogleChrome/lighthouse-ci/tree/master/docs/recipes/heroku-server)
