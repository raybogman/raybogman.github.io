---
layout: post
cover: 'assets/images/magento-pwa-studio-lighthouse-server.jpg'
title: Magento PWA Studio Lighthouse server
description: 'Magento + PWA Studio = High Performance! OOTB (Out Of The Box). Use Lighthouse Server now and monitor your Magento PWA Studio Performance on every Git push.'
date: 2020-01-07 00:00:00
tags: Magento PWA Studio Travis Lighthouse Heroku ci/cd
author: Ray Bogman
img1: assets/images/1x1/magento-pwa-studio-lighthouse-server.jpg
img4: assets/images/4x3/magento-pwa-studio-lighthouse-server.jpg
img16: assets/images/16x9/magento-pwa-studio-lighthouse-server.jpg
---

<strong>Magento</strong> + <strong>PWA Studio</strong> = <strong>High Performance</strong>! OOTB (Out Of The Box) ;-)
But please keep in mind that every custom theme/layout/template or whatever style you prefer to implement could have some minor or major drawbacks in regards to web performance. Making sure your <strong>Magento PWA</strong> still fires up when requesting a page is pretty important.

So unless you have not read my previous blog on how to build a <strong>[Lighthouse server](https://raybogman.com/jekyll-travis-lighthouse-heroku-ci-cd)</strong>, please do before you continue.
Or continue this one and switch back on some of the tips and tricks from the previous one if needed ;-).

When it comes to using <strong>Google Lighthouse Server</strong> I think it's possible to use two approaches.
1. Basic  - Using a CI server (Travis CI, Circle CI, Jenkins, AWS CodeBuild etc...) and testing your URL(s) remotely.
2. Advanced - Using a CI server (Travis CI, Circle CI, Jenkins, AWS CodeBuild etc...) and testing your internally build URL(s).

For this blog, I prefer addressing the "Basic" version for now. Maybe later I will create an "Advanced" version as well. The main reason for the "Basic" is that I like to test the live "realtime" public-facing version, running on a production environment. Compare to the "Advanced" version it shows the real performance metric on the actual speed of your application.

The recipe is really simple, we need a PWA Studio codebase, Lighthouse Server, Travis CI, Github account, .travis.yml and lighthouserc.yml.

And keep in mind always <strong>Design for Performance</strong>!

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
Install Lighthouse CI, easy to run a manual test run and configure the LCHI Wizard for later use.
<pre>
npm install -g @lhci/cli@0.3.x
</pre>

### 2. Signup and create .travis.yml file
If not already, signup for [Travis-ci](https://travis-ci.com/) and connect the Travis CI [Github Apps](https://github.com/apps/travis-ci) to your Github profile repository. (Detailed config is beyond the scope of this blog if you need more help on how to setup Travis CI or any other CI tool please search the internet ;-) )

<amp-img src="/assets/images/pwa-studio-install-travis-ci.jpg" width="531" height="692" layout="responsive" alt="Magento PWA Studio & Install Travis CI"></amp-img>

Once Travis CI is connected to your Github account create <code>.travis.yml</code> in your root directory from your repository and copy the following config.
{% highlight language-x %}
language:
  - node_js # Node 10 LTS or later required
node_js:
  - '10'
addons:
  chrome: stable # make Chrome available
before_install:
  - npm install -g @lhci/cli@0.3.x # install LHCI
script:
  - echo "Notice - no test specified" # skip 'npm test' and run LHCI
after_success:
#  - lhci autorun --upload.target=temporary-public-storage # run lighthouse CI against your static site
  - lhci autorun
{% endhighlight %}

Notice some tweak options in the config if you need to run it to "temporary public storage".
The echo "Notice - no test specified" row is to skip the <code>npm test</code> command and automatically run the Lighthouse CI command. We will not use Travis CI for any Magento PWA Studio additional test. This could be a part of the "Advanced" version.

### 3. Create lighthouserc.yml with the following config

Now let's create the <code>lighthouserc.yml</code> in your root directory from your repository and copy the following config.
{% highlight language-x %}
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
    serverBaseUrl: https://your-app-url.herokuapp.com/ #Only Static URL is Allowed
    token: $LHCI_TOKEN
{% endhighlight %}
If needed you can tweak <code>numberOfRuns</code>, <code>url</code>, <code>assertions</code> and much much more to your needs. Besides <code>url</code>, the 2 most important elements, for now, are <code>serverBaseUrl</code> and <code>token</code>. We will configure those at the end.

### 4. Create LHCI_GITHUB_APP_TOKEN and add it to Environment Variables in Travis
Let's create the LHCI_GITHUB_APP_TOKEN, this will link <code>Lighthouse CI</code> to your Github account and will show the passing results to your commit.

Click this [link](https://github.com/apps/lighthouse-ci) and add it to your Github account.
Make sure to copy/paste the <strong>LHCI_GITHUB_APP_TOKEN</strong> since this will be only shared once.
<amp-img src="/assets/images/lhci-github-app-token.jpg" width="611" height="263" layout="responsive" alt="LHCI_GITHUB_APP_TOKEN"></amp-img>

Please open Travis CI and go to 'settings' under need your repository and look for 'Environment Variables'.
Add 'Name': LHCI_GITHUB_APP_TOKEN and the 'Value': 'token' into the settings. The LHCI_GITHUB_APP_TOKEN will be used later during the built and will update your Github "Status Checks" in the 'commit' section.
<amp-img src="/assets/images/lhci-github-travis.jpg" width="600" height="186" layout="responsive" alt="add LHCI_GITHUB_APP_TOKEN into Travis"></amp-img>

### 5. Signup at Heroku
The next step is hosting and building a serverless app where all reports will be shown. Lighthouse CI offers two options: Docker and Heroku. For the scope of this blog, we only will focus on Heroku. The main reason is that is easy and free.

Create a <strong>[Heroko](https://signup.heroku.com/)</strong> account, add follow all the steps. That's it!
All next steps will be done using the <strong>Heroku CLI tools</strong>, so no need to create the app here.

Remember every FREE Heroku app has 550 free dyno hours per month which will be fine for this project scale.

Note from Heroku:
Personal accounts are given a base of 550 free dyno hours each month. In addition to these base hours, accounts that verify with a credit card will receive an additional 450 hours added to the monthly free dyno quota. This means you can receive a total of 1000 free dyno hours per month if you verify your account with a credit card.
More info: [Free Dyno Hours](https://devcenter.heroku.com/articles/free-dyno-hours)

### 6. Install Heroku CLI
Now lets download and install the <strong>[Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)</strong> toolset.
When using macOS you may use <code>brew tap heroku/brew && brew install heroku</code>.

When done lets login:
<code>heroku login</code>

### 7. Create Heroku config and push the app to production
Building and running the serverless app can be managed via the CLI.
Use the following commands:
{% highlight language-x %}
# Create a directory and repo for your heroku project
mkdir lhci-heroku && cd lhci-heroku && git init
# Setup the LHCI files
curl https://raw.githubusercontent.com/GoogleChrome/lighthouse-ci/master/docs/recipes/heroku-server/package.json > package.json
curl https://raw.githubusercontent.com/GoogleChrome/lighthouse-ci/master/docs/recipes/heroku-server/server.js > server.js
# Create the project's first commit
git add -A && git commit -m 'Initial commit'

# Create a new project on heroku
heroku create
# Add a free database to your project - https://elements.heroku.com/addons/heroku-postgresql
heroku addons:create heroku-postgresql:hobby-dev
# Deploy your code to heroku
git push heroku master

# Ensure heroku is running your app and open the URL
heroku ps:scale web=1
heroku open
{% endhighlight %}

If everything works out fine it should look something like: <code>https://serene-ridge-48368.herokuapp.com/</code>

If needed update your serverless app to the latest LHCI version.
{% highlight language-x %}
# Update LHCI
npm install --save @lhci/server@latest
# Create a commit with your update
git add -A && git commit -m 'update LHCI'
# Deploy your update to heroku
git push heroku master
{% endhighlight %}

### 8. Run lhci wizard
Since we installed <strong>lhci</strong> during the first step we are now able to run the lhci wizard and connect our app to the <strong>Heroku LHCI Dashboard</strong>.

Run the following commands and follow the correct steps:
<code>lhci wizard</code>
{% highlight language-x %}
? Which wizard do you want to run? new-project
? What would you like to name the project? Project Name
? Where is the project's code hosted? https://github.com/your-project/your-repo
Created project Project Name (00db0b2e-84c8-4ba4-ad3d-d5b885dd47c4)!
Use token MyToken-00b5-436b-9819-0b79a064d6a3 to connect.
{% endhighlight %}

Again store the <strong>LHCI_TOKEN</strong> somewhere safe.

### 9. Add LHCI_TOKEN to Environment Variables in Travis
Now lets store the <strong>LHCI_TOKEN</strong> in the Environment Variables setting section in Travis.
<amp-img src="/assets/images/lhci-token-travis.jpg" width="600" height="210" layout="responsive" alt="add LHCI_TOKEN into Travis"></amp-img>

### 10. Update serverBaseUrl in lighthouserc.yml
Update the Heroku app url in <code>lighthouserc.yml</code> in the <code>serverBaseUrl</code> section.

### 11. Push code to Git and let the magic do its thing!
Now the moment of truth is about to happen, save your files and:
git add -A && git commit -m 'LHCI first run'
git push origin master

Let's follow the build in <strong>Travis CI</strong> and open your Travis project link.
<amp-img src="/assets/images/pwa-studio-travis-ci-build.jpg" width="563" height="603" layout="responsive" alt="PWA Studio Travis CI Build"></amp-img>

Within this example we see two export TOKENS, install of LHCI, skipping npm test, validate configuration of the LHCI settings, running URLs and test results including upload to our LHCI server and Github repository.
<amp-img src="/assets/images/pwa-studio-lhci-dashboard.jpg" width="653" height="624" layout="responsive" alt="PWA Studio Lighthouse Dashboard"></amp-img>

<amp-img src="/assets/images/pwa-studio-lhci-dashboard-details.jpg" width="653" height="584" layout="responsive" alt="PWA Studio Lighthouse Dashboard"></amp-img>

Don't forget visiting your Github commit section including the new 'status checks'. This hopefully helps to create better-performing code out there ;-).
<amp-img src="/assets/images/pwa-studio-github-status-check.jpg" width="495" height="268" layout="responsive" alt="PWA Studio Lighthouse Dashboard"></amp-img>

### It's a wrap!
I hope you liked building it, well it did when prepping this.

Beside <strong>Magento PWA Studio</strong>, many other solutions could benefit from a <strong>Continuous development</strong> and <strong>Continuous Integration</strong> building stream.

My next blog could be introducing <strong>Lighthouse CI</strong> using <strong>Magento PWA Studio "Advanced"</strong> or <strong>Lighthouse CI</strong> using <strong>Magento Cloud</strong>.
So until next time!

### Manual LHCI autorun
In case you prefer to test Lighthouse CI manually before you use Travis CI, run the following command from your shell.
<code>lhci autorun</code>

### Reference:
[https://github.com/GoogleChrome/lighthouse-ci/blob/master/docs/getting-started.md](https://github.com/GoogleChrome/lighthouse-ci/blob/master/docs/getting-started.md)
[https://github.com/GoogleChrome/lighthouse-ci/tree/master/docs/recipes/heroku-server](https://github.com/GoogleChrome/lighthouse-ci/tree/master/docs/recipes/heroku-server)