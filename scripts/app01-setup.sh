#!/usr/bin/env bash
set -euxo pipefail

cat /etc/hosts

yum update -y
yum install epel-release -y
dnf -y install java-11-openjdk java-11-openjdk-devel
dnf install git maven wget -y

cd /tmp/
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz
rm -rf /tmp/apache-tomcat-9.0.75
rm -rf /usr/local/tomcat
mkdir -p /usr/local/tomcat
tar xzvf apache-tomcat-9.0.75.tar.gz -C /tmp/
useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat || true
cp -r /tmp/apache-tomcat-9.0.75/* /usr/local/tomcat/
chown -R tomcat.tomcat /usr/local/tomcat

cat >/etc/systemd/system/tomcat.service <<'TOMCAT'
[Unit]
Description=Tomcat
After=network.target

[Service]
User=tomcat
WorkingDirectory=/usr/local/tomcat
Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINE_BASE=/usr/local/tomcat
ExecStart=/usr/local/tomcat/bin/catalina.sh run
ExecStop=/usr/local/tomcat/bin/shutdown.sh
SyslogIdentifier=tomcat-%i

[Install]
WantedBy=multi-user.target
TOMCAT

systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat

systemctl start firewalld
systemctl enable firewalld
firewall-cmd --get-active-zones || true
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --reload

if [ ! -d /opt/vprofile-project ]; then
  git clone -b main https://github.com/hkhcoder/vprofile-project.git /opt/vprofile-project
fi

cd /opt/vprofile-project
cat > src/main/resources/application.properties <<'APPCFG'
# backend server details
db.host=db01
db.port=3306
db.name=accounts
db.user=admin
db.password=admin123
redis.host=mc01
redis.port=11211
rabbitmq.host=rmq01
rabbitmq.port=5672
rabbitmq.username=test
rabbitmq.password=test
APPCFG

mvn install
systemctl stop tomcat
rm -rf /usr/local/tomcat/webapps/ROOT*
cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
chown tomcat.tomcat /usr/local/tomcat/webapps -R
systemctl start tomcat
systemctl restart tomcat
