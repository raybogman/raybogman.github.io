---
title: 'Jekyll+Travis+Lighthouse+Heroku=CI/CD'
date: 2020-01-01 00:00:00
description: 'Use Lighthouse Server now and monitor your Jekyll Performance on every Git push.'
featured_image: '/assets/images/jekyll-travis-lighthouse-heroku-ci-cd.jpg'
tags: [Jekyll, Travis, Lighthouse, Heroku, ci/cd]
---

Ever since Github started supporting **Jekyll** within **[Github Pages](https://pages.github.com/)** I was sold. So when it comes to easy, fast, stable, flexible, security free and **high-performance websites** I like to build them in Jekyll.

But choosing **Jekyll** is not the topic of this blog. I like to share a topic on **Continuous development** and **Continuous Integration**. When working with **Magento** I always preferred to be aware of the code quality I or my team wrote.

The following steps will guide you on how to setup a **Continuous development** and **Continuous Integration** developing stream on **Jekyll** using **Lighthouse CI**, **Lighthouse Server**, **Travis CI**, and **Heroku**.

And keep in mind always **Design for Performance**!

### Summary Steps
1. [Install lighthouse-ci locally](#1-install-lighthouse-ci-locally)
2. [Signup and create .travis.yml file](#2-signup-and-create-travisyml-file)
3. [Create lighthouserc.yml with the following config](#3-create-lighthousercyml-with-the-following-config)
4. [Create LHCI_GITHUB_APP_TOKEN and add it to env in Travis](#4-create-lhci_github_app_token-and-add-it-to-environment-variables-in-travis)
5. [Signup at Heroku](#5-signup-at-heroku)
6. [Install Heroku CLI](#6-install-heroku-cli)
7. [Create Heroku config and push the app to production](#7-create-heroku-config-and-push-the-app-to-production)
8. [Run lhci wizard](#8-run-lhci-wizard)
9. [Add LHCI_TOKEN to env in Travis](#9-add-lhci_token-to-environment-variables-in-travis)
10. [Update serverBaseUrl in lighthouserc.yml](#10-update-serverbaseurl-in-lighthousercyml)
11. [Push code to Git and let the magic do its thing!](#11-push-code-to-git-and-let-the-magic-do-its-thing)

### 1. Install lighthouse-ci locally

```
npm install -g @lhci/cli@0.3.x
```

### 2. Signup and create .travis.yml file

If not already, signup for [Travis-ci](https://travis-ci.com/) and connect the Travis CI [Github Apps](https://github.com/apps/travis-ci) to your Github profile repository.

![Approve & Install Travis CI](/assets/images/approve-install-travis-ci.jpg)

Once Travis CI is connected to your Github account create `.travis.yml` in your root directory:

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

### 4. Create LHCI_GITHUB_APP_TOKEN and add it to Environment Variables in Travis

Click this [link](https://github.com/apps/lighthouse-ci) and add it to your Github account. Make sure to copy/paste the **LHCI_GITHUB_APP_TOKEN** since this will be only shared once.

![LHCI_GITHUB_APP_TOKEN](/assets/images/lhci-github-app-token.jpg)

Add 'Name': LHCI_GITHUB_APP_TOKEN and the 'Value': 'token' into the Travis CI settings.

![add LHCI_GITHUB_APP_TOKEN into Travis](/assets/images/lhci-github-travis.jpg)

### 5. Signup at Heroku

Create a **[Heroku](https://signup.heroku.com/)** account. Remember every FREE Heroku app has 550 free dyno hours per month.

### 6. Install Heroku CLI

Download and install the **[Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)** toolset.

```
brew tap heroku/brew && brew install heroku
heroku login
```

### 7. Create Heroku config and push the app to production

```bash
mkdir lhci-heroku && cd lhci-heroku && git init
curl https://raw.githubusercontent.com/GoogleChrome/lighthouse-ci/master/docs/recipes/heroku-server/package.json > package.json
curl https://raw.githubusercontent.com/GoogleChrome/lighthouse-ci/master/docs/recipes/heroku-server/server.js > server.js
git add -A && git commit -m 'Initial commit'
heroku create
heroku addons:create heroku-postgresql:hobby-dev
git push heroku master
heroku ps:scale web=1
heroku open
```

### 8. Run lhci wizard

```
lhci wizard
```

### 9. Add LHCI_TOKEN to Environment Variables in Travis

![add LHCI_TOKEN into Travis](/assets/images/lhci-token-travis.jpg)

### 10. Update serverBaseUrl in lighthouserc.yml

Update the Heroku app url in `lighthouserc.yml` in the `serverBaseUrl` section.

### 11. Push code to Git and let the magic do its thing!

```
git add -A && git commit -m 'LHCI first run'
git push origin master
```

![Travis CI Build](/assets/images/travis-ci-build.jpg)

![Lighthouse Dashboard](/assets/images/lhci-dashboard.jpg)

![Lighthouse Dashboard Details](/assets/images/lhci-dashboard-details.jpg)

![GitHub Status Check](/assets/images/github-status-check.jpg)

### It's a wrap!

I hope you liked building it, well it did when prepping this.

### Manual LHCI autorun

```
lhci autorun
```

### Reference:
- [Getting Started](https://github.com/GoogleChrome/lighthouse-ci/blob/master/docs/getting-started.md)
- [Heroku Server Recipe](https://github.com/GoogleChrome/lighthouse-ci/tree/master/docs/recipes/heroku-server)
