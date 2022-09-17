#!/bin/bash

echo '========================================================'
echo '=== PASO 1: INSTALACIÓN DE PREREQUISITOS PARA DOCKER ==='
echo '========================================================'
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
        ca-certificates \
        curl \
        unzip \
        gnupg-agent \
        software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

echo '=============================================================='
echo '=== PASO 2: AGREGAR REPOSITORIO PARA LA INSTALACIÓN DOCKER ==='
echo '=============================================================='
sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
sudo apt-get update

echo '====================================='
echo '=== PASO 3: INSTALACIÓN DE DOCKER ==='
echo '====================================='
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
# Iniciar Docker junto con el Arranque del Sistema Operativo
sudo systemctl enable docker
# Agregar Usuario Actual al Grupo de Docker
sudo usermod -aG docker ubuntu

echo '============================================='
echo '=== PASO 4: INSTALACIÓN DE DOCKER-COMPOSE ==='
echo '============================================='
sudo curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo '==============================================================='
echo '=== PASO 5: INICIAR DOCKER AL ARRANCAR EL SISTEMA OPERATIVO ==='
echo '==============================================================='
sudo systemctl enable docker

echo '========================================================='
echo '=== PASO 6: AGREGAR USUARIO ACTUAL AL GRUPO DE DOCKER ==='
echo '========================================================='
sudo usermod -aG docker ubuntu

echo '========================================='
echo '=== PASO 7: INSTALAR HERRAMIENTA CTOP ==='
echo '========================================='
echo "deb http://packages.azlux.fr/debian/ buster main" | sudo tee /etc/apt/sources.list.d/azlux.list
wget -qO - https://azlux.fr/repo.gpg.key | sudo apt-key add -
sudo apt update
sudo apt install docker-ctop

echo '=============================================='
echo '=== PASO 8: CREAR DIRECTORIOS DE VOLUMENES ==='
echo '=============================================='
sudo mkdir -p /volumes/www
cd /volumes/www

echo '=================================================='
echo '=== PASO 9: CLONAR RESPOSITORIOS DE SITIOS WEB ==='
echo '=================================================='
sudo git clone https://github.com/Flicomastic/powerjgym.git


sudo mv powerjgym portal


echo '================================================'
echo '=== PASO 10: CLONAR REPOSITORIO CONTENEDORES ==='
echo '================================================'
cd /volumes
sudo git clone https://github.com/rsilvao/rds.git
sudo mv rds deploy 

echo '================================'
echo '=== PASO 11: REALIZAR DEPLOY ==='
echo '================================'
docker-compose -f deploy/docker-compose2.yml up -d