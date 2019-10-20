---
layout: post
cover: 'assets/images/magento-pwa-studio-production-setup.jpg'
title: Magento PWA Studio Production setup
date: 2018-10-20 00:00:00
tags: magento 2019 pwa studio 2.3.3
author: Ray Bogman
---

It's have been some time since my last blog or any writing at all. My latest work dates back to the **Magento 2 Cookbook** published in 2016. I myself are a big fan of small tutorials or recipes style blogs and could not resist to created a new one on **Magento's PWA Studio**. And the main reason for this was while search on the internet I could not find any good stuff on this yet. So I like to share an approach which did the trick for me. Time will tell if this is the correct approach. So please be aware where running this on a production site. It works great for a demo or any kind of testing.

All thought there are many routes to Rome I am picking the highroad on this one. Easy setup using a clean Ubuntu 16.04 including Nginx as a **reverse proxy** for SSL termination. I am aware using **docker**, but for this case I needed to use Nginx for multiple ports on the background and not only serving **PWA Studio**. And I didn't want to built a very complex **docker-compose** script to serve multiple vhost. Using this approach I could create multiple Nginx vhost and connect them to many ports and multiple single docker apps during on the background.

So please follow me on a journey to run Magento's PWA Studio on a production like setup.

### Install the essentials
Please run the following command from the shell on a clean setup.
<pre>
apt-get install -y nodejs yarn nginx build-essential
</pre>

Create dhparam file
<pre>
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
</pre>

Create your free [https://www.sslforfree.com/](https://www.sslforfree.com/) SSL certificate or use your own SSL certs and move/replace them within your SSL directory like **/etc/ssl/certs**.

Remove the ‘default’ symlink in **/etc/nginx/sites-enabled** and create a new config file like **pwa.conf**
and add the following config.  

<pre>
server {
    listen 80;
    server_name www.frontend-url.com;
    rewrite ^/(.*) https://$host/$1 permanent;
    }

server {
    listen 443 ssl http2;
    port_in_redirect off;
    server_name www.frontend-url.com;

    access_log /var/log/nginx/pwa-access.log;
    error_log /var/log/nginx/pwa-error.log;

    location / {
        proxy_pass https://www.frontend-url.com:8080;
        proxy_set_header X-Real-IP  $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Forwarded-Port 443;
        proxy_set_header Host $host;
        proxy_set_header Connection "";
    }

    ssl_certificate /etc/ssl/certs/www.frontend-url.com.crt;
    ssl_certificate_key /etc/ssl/certs/www.frontend-url.com.key;

    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:50m;

    resolver 8.8.8.8;
    resolver_timeout 10s;

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers 'ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:!DSS';

    ssl_prefer_server_ciphers on;
    ssl_dhparam /etc/ssl/certs/dhparam.pem;
    }
</pre>

Update the following config elements incl. your personal setup need: server_name, proxy_pass, ssl_certificate, ssl_certificate_key

Save and close the file and run the following command.

<pre>
service nginx configtest
</pre>

If the result is **"Testing Nginx configuration [ OK ]”** you are ready to restart the Nginx server using the following command.

<pre>
service nginx restart
</pre>

### Setup PWA studio

Now Nginx is ready, we can setup your PWA project. Please review the [PWA Studio official guidelines](https://magento.github.io/pwa-studio/venia-pwa-concept/setup/) as well.

For this setup we use our **/home** directory as a base.
<pre>
git clone https://github.com/magento/pwa-studio.git
</pre>

<pre>
yarn install
</pre>

Copy the following **.env** data to the packages/venia-concept directory (and update to your specific needs).
<pre>
MAGENTO_BACKEND_URL=https://www.backend-url.com/
#CUSTOM_ORIGIN_ENABLED=true
#CUSTOM_ORIGIN_ADD_UNIQUE_HASH=true
#CUSTOM_ORIGIN_SUBDOMAIN=
CUSTOM_ORIGIN_EXACT_DOMAIN=www.frontend-url.com
#DEV_SERVER_HOST=
#DEV_SERVER_PORT=
#DEV_SERVER_SERVICE_WORKER_ENABLED=
#DEV_SERVER_WATCH_OPTIONS_USE_POLLING=
STAGING_SERVER_HOST=0.0.0.0
STAGING_SERVER_PORT=8080
#IMAGE_SERVICE_PUBLIC_PATH=/img/
#IMAGE_SERVICE_CACHE_EXPIRES=1 hour
#IMAGE_SERVICE_CACHE_DEBUG=
#IMAGE_SERVICE_CACHE_REDIS_CLIENT=
#UPWARD_JS_UPWARD_PATH=upward.yml
#UPWARD_JS_BIND_LOCAL=true
#UPWARD_JS_LOG_URL=true
#CHECKOUT_BRAINTREE_TOKEN=sandbox_8yrzsvtm_s2bg8fs563crhqzk
</pre>

Now run the following command to create custom SSL certificate based on your domain set (CUSTOM_ORIGIN_EXACT_DOMAIN)  in the **.env** file.
<pre>
yarn buildpack create-custom-origin packages/venia-concept
</pre>

The last step will built the PWA Studio setup and will run venia in staging mode.
<pre>
yarn run build && yarn run stage:venia
</pre>

Lets check if everything is working fine, submit your PWA url in your browser and your mobile device of course.
Happy PWA Studio time!

#### Some use full command along the line.
<pre>
lsof -i :8080 = check which process runs on port 8080 (most likely nodejs in this case. The PID id may be need to kill the process)
kill -9 'PID id nodejs' = incase ctrl + c  does not work killing nodejs
netstat -tulpn = shows all ports and applications
</pre>
