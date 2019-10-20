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

Create free (https://www.sslforfree.com/) SSL certificate or use your own SSL certs and move/replace them within your pwa-studio project directory like **/home/pwa-studio/docker/certs**

Remove the ‘default’ symlink in **/etc/nginx/sites-enabled** and create a new config file like **pwa.conf**
and add the following config.  

<pre>
server {
    listen 80;
    server_name pwa.bogman.info;
    rewrite ^/(.*) https://$host/$1 permanent;
    }

server {
    listen 443 ssl http2;
    port_in_redirect off;
    server_name pwa.bogman.info;

    access_log /var/log/nginx/pwa-access.log;
    error_log /var/log/nginx/pwa-error.log;

    location / {
        proxy_pass https://pwa.bogman.info:8080;
        proxy_set_header X-Real-IP  $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Forwarded-Port 443;
        proxy_set_header Host $host;
        proxy_set_header Connection "";
    }

    ssl_certificate /home/pwa-studio/docker/certs/pwa.bogman.info.crt;
    ssl_certificate_key /home/pwa-studio/docker/certs/pwa.bogman.info.key;

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
