---
title: 'Magento PWA Studio Production setup'
date: 2019-10-20 00:00:00
description: 'Build your own Magento PWA Studio production setup using Nginx proxy.'
featured_image: '/assets/images/magento-pwa-studio-production-setup.jpg'
tags: [magento, pwa-studio]
---

It's have been some time since my last blog or any writing at all. My latest work dates back to the [**Magento 2 Cookbook**](https://raybogman.com/magento-2-cookbook) published in 2016. I am a big fan of small tutorials or recipes style blogs and could not resist creating a new one on **Magento's PWA Studio**.

All thought there are many routes to Rome I am picking the high road on this one. Easy setup using a clean Ubuntu 16.04 including Nginx as a **reverse proxy** for SSL termination.

So please follow me on a journey to run Magento's PWA Studio on a production-like setup.

### Install the essentials
Please run the following command from the shell on a clean setup.

```
apt-get install -y nodejs yarn nginx build-essential
```

Create dhparam file

```
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
```

Create your free SSL certificate or use your own SSL certs and move/replace them within your SSL directory like **/etc/ssl/certs**.

Remove the 'default' symlink in **/etc/nginx/sites-enabled** and create a new config file like **pwa.conf** and add the following config.

```nginx
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
    ssl_prefer_server_ciphers on;
    ssl_dhparam /etc/ssl/certs/dhparam.pem;
}
```

Save and close the file and run:

```
service nginx configtest
```

If the result is **"Testing Nginx configuration [ OK ]"** you are ready to restart Nginx:

```
service nginx restart
```

### Setup PWA studio

Now Nginx is ready, we can setup your PWA project. Please review the [PWA Studio official guidelines](https://magento.github.io/pwa-studio/venia-pwa-concept/setup/) as well.

```
git clone https://github.com/magento/pwa-studio.git
yarn install
```

Copy the following **.env** data to the packages/venia-concept directory:

```
MAGENTO_BACKEND_URL=https://www.backend-url.com/
CUSTOM_ORIGIN_EXACT_DOMAIN=www.frontend-url.com
STAGING_SERVER_HOST=0.0.0.0
STAGING_SERVER_PORT=8080
```

Now run the following command to create custom SSL certificate:

```
yarn buildpack create-custom-origin packages/venia-concept
```

The last step will build the PWA Studio setup and run venia in staging mode:

```
yarn run build && yarn run stage:venia
```

Happy PWA Studio time!

#### Some useful commands

```
lsof -i :8080          # check which process runs on port 8080
kill -9 'PID'          # in case ctrl+c does not work
netstat -tulpn         # shows all ports and applications
```
