#!/usr/bin/env bash
set -euxo pipefail

cat /etc/hosts

apt update
apt upgrade -y
apt install nginx -y

cat >/etc/nginx/sites-available/vproapp <<'NGINX'
upstream vproapp {
    server app01:8080;
}

server {
    listen 80;
    location / {
        proxy_pass http://vproapp;
    }
}
NGINX

rm -rf /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp
systemctl restart nginx
