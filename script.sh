#!/bin/bash

#Ejecutar como super usuario (root)
USER=ec2-user
echo "Enter Public Ip addres from jitsi main instance "
read PUBLIC_IP

echo "Enter JVB_AUTH_PASSWORD value from jitsi main instance "
read JVB_PASSWORD

yum update -y

# Instalar Docker
yum install -y docker
service docker start
usermod -a -G docker $USER
chkconfig docker on

# Instalar Git
yum install -y git

# Instalar Docker-Compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Descargar repo jitsi video bridge
wget https://github.com/Genaro-Coronel-Gtz/video_bridge/archive/refs/heads/main.zip -P /home/$USER
unzip /home/$USER/main.zip -d /home/$USER
mv /home/$USER/video_bridge-main /home/$USER/video_bridge
cd /home/$USER/video_bridge

cp env.example .env

# Setear configuraciones para poder utilizar mas instancias de jitsi video bridge
sed -i "s/DOCKER_HOST_ADDRESS=192.168.0.10/DOCKER_HOST_ADDRESS=$PUBLIC_IP/" .env
sed -i "s/XMPP_SERVER=192.168.0.10/XMPP_SERVER=$PUBLIC_IP/" .env
sed -i "s#XMPP_BOSH_URL_BASE=http://xmpp.meet.jitsi:5280#XMPP_BOSH_URL_BASE=http://$PUBLIC_IP:5280#g" .env
sed -i "s/JVB_AUTH_PASSWORD=JVB_AUTH_PASSWORD/JVB_AUTH_PASSWORD=$JVB_PASSWORD/" .env

mkdir -p /home/$USER/video_bridge/jitsi-meet-cfg/{web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

sudo -u $USER /usr/local/bin/docker-compose pull
sudo -u $USER /usr/local/bin/docker-compose up -d
sudo -u $USER /usr/local/bin/docker-compose start

# Eliminar el archivo zip del repo de jitsi_main
rm /home/$USER/main.zip
