#!/usr/bin/env bash
set -euxo pipefail

cat /etc/hosts

yum update -y
yum install epel-release -y
yum install git mariadb-server -y

systemctl start mariadb
systemctl enable mariadb

printf 'Y\nadmin123\nadmin123\nY\nY\nY\nY\n' | mysql_secure_installation >/dev/null 2>&1 || true

mysql -u root -padmin123 -e "CREATE DATABASE IF NOT EXISTS accounts; GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'%' IDENTIFIED BY 'admin123'; FLUSH PRIVILEGES;"

if [ ! -d /opt/vprofile-project ]; then
  git clone -b main https://github.com/hkhcoder/vprofile-project.git /opt/vprofile-project
fi

cd /opt/vprofile-project
mysql -u root -padmin123 accounts < src/main/resources/db_backup.sql
mysql -u root -padmin123 accounts -e "SHOW TABLES;"

systemctl restart mariadb
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --get-active-zones || true
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --reload
systemctl restart mariadb
