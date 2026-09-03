#!/usr/bin/env bash
set -euxo pipefail

cat /etc/hosts

yum update -y
dnf install epel-release -y
dnf install memcached -y

systemctl start memcached
systemctl enable memcached
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached
systemctl restart memcached

firewall-cmd --add-port=11211/tcp --runtime-to-permanent
firewall-cmd --add-port=11111/udp --runtime-to-permanent
memcached -p 11211 -U 11111 -u memcached -d
