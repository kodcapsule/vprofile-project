#!/bin/bash
sudo yum update -y
sudo yum install wget -y
sudo yum install java-17-openjdk -y
sudo mkdir /app && cd /app

sudo wget -O nexus.tar.gz  https://download.sonatype.com/nexus/3/nexus-3.79.1-04-linux-x86_64.tar.gz

sudo tar -xvf nexus.tar.gz
sudo adduser nexus
sudo chown -R nexus:nexus /app/nexus
sudo chown -R nexus:nexus /app/sonatype-work

#sudo vi  /app/nexus/bin/nexus.rc

cat <<EOT>> /etc/systemd/system/nexus.service
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/app/nexus/bin/nexus start
ExecStop=/app/nexus/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target

EOT

sudo chkconfig nexus on

sudo systemctl start nexus

cat /app/sonatype-work/nexus3/admin.password