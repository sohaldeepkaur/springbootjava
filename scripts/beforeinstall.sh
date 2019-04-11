#!/bin/bash
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update
sudo apt-get install oracle-java8-installer -y

sudo vim /etc/systemd/system/springboot.service

cat > /etc/systemd/system/springboot.service <<'EOF'
[Unit]
Description=springboot server
After=network.target
[Service]
User=nobody
WorkingDirectory=/home/ubuntu/springbootjava
ExecStart=java -jar /home/ubuntu/springbootjava/target/spring-boot-web-0.0.1-SNAPSHOT.jar
Restart=always
RestartSec=500ms
StartLimitInterval=0
[Install]
WantedBy=multi-user.target
EOF

systemctl enable reload-configuration

# remove old directory
rm -rf /home/ubuntu/springbootjava

# create directory deploy
mkdir -p /home/ubuntu/springbootjava


