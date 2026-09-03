#!/usr/bin/env bash
set -euxo pipefail

cat /etc/hosts

yum update -y
yum install epel-release -y
yum install wget -y

cd /tmp/
dnf -y install centos-release-rabbitmq-38
dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server
systemctl enable --now rabbitmq-server

sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
rabbitmqctl add_user test test || true
rabbitmqctl set_user_tags test administrator || true
systemctl restart rabbitmq-server

firewall-cmd --add-port=5672/tcp --runtime-to-permanent
systemctl start rabbitmq-server
systemctl enable rabbitmq-server
systemctl status rabbitmq-server
