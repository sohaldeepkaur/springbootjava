#!/bin/bash
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update
sudo apt-get install oracle-java8-installer -y

sudo apt-get install nginx -y

#nginx conf virtualhost

cat > /etc/nginx/sites-available/tech.conf <<'EOF'
server {
    listen 80;
    server_name springbootapp.sohaldeep.tech;
     if ($http_x_forwarded_proto != 'https') {
       return 301 https://$host$request_uri;
   }
    location / {
        proxy_pass http://127.0.0.1:8090;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/tech.conf /etc/nginx/sites-enabled/tech.conf 




sudo service springboot stop
sudo vim /etc/systemd/system/springboot.service


cat > /etc/systemd/system/springboot.service <<'EOF'
[Unit]
Description=springboot server
After=network.target
[Service]
User=nobody
WorkingDirectory=/home/ubuntu/deployjavaapp
ExecStart=java -jar /home/ubuntu/deployjavaapp/spring-boot-web-0.0.1-SNAPSHOT.jar
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


