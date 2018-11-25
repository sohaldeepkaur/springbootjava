#!/bin/bash
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update
sudo apt-get install oracle-java8-installer -y

sudo service springboot stop

# create springboot service
cat > /etc/init/springboot.conf <<'EOF'

description "springboot Server"

  start on runlevel [2345]
  stop on runlevel [!2345]
  respawn
  respawn limit 10 5

  # run as non privileged user 
  # add user with this command:
  ## adduser --system --ingroup www-data --home /opt/apache-tomcat apache-tomcat
  # Ubuntu 12.04: (use 'exec sudo -u apache-tomcat' when using 10.04)
  setuid ubuntu
  setgid ubuntu

  # adapt paths:
  
  exec java -jar /home/ubuntu/deploy/spring-boot-web-0.0.1-SNAPSHOT.jar  

  # cleanup temp directory after stop
  post-stop script
  end script
EOF

sudo initctl reload-configuration


# remove old directory
rm -rf /home/ubuntu/deploy

# create directory deploy
mkdir -p /home/ubuntu/deploy 


