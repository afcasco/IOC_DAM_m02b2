#!/bin/bash

####################################################################################################

# Script para la autoinstalacion de phpldapadmin y todos sus requisitos

####################################################################################################

# CAMBIAR SOLO DATOS DE LINEAS 12, 15, 16 Y 17

# Password para comandos que usan sudo
passwd=afernandez

# A editar con la configuracion que cuadre con tu red de casa
ip=192.168.1.120
gateway=192.168.1.1
dns=1.1.1.1

####################################################################################################

# Obtiene interfaz por defecto para usar en configuracion netplan
interface=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}' | head -1)

# Eliminar archivo de configuracion antiguo si lo habia
file=~/00-installer-config.yaml 
if [ -f $file ]; then rm $file; fi

# Creacion automatica del archivo de configuracion de red
touch $file
printf "network:\n  ethernets:\n  $interface:\n    addresses: [$ip/24]\n    gateway4: $gateway\n    nameservers:\n      addresses: [$dns]\n  version: 2" >> $file

# Movemos el archivo al directorio correcto (se crea en caso de que no exista)
# Y aplicamos la configuracion de red
if ! [ -d /etc/netplan ]; then echo $passwd | sudo -S mkdir -p /etc/netplan; fi
echo $passwd | sudo -S mv $file /etc/netplan
echo $passwd | sudo -S netplan apply

#Actualizamos repos y el sistema que siempre va bine :)
echo $passwd | sudo -S apt update && sudo -S apt upgrade


#for php7.4 installation
echo $passwd | sudo apt install software-properties-common apt-transport-https -y
echo $passwd | sudo add-apt-repository ppa:ondrej/php -y
echo $passwd | sudo -S apt update && sudo -S apt upgrade
echo $passwd | sudo apt install php7.4 php7.4-common libapache2-mod-php7.4 php7.4-cli php-xml
echo $passwd | sudo -S apt install -y mysql-server mysql-client apache2 php7.4 libapache2-mod-php7.4 php7.4-mysql php7.4-ldap php7.4-xml php7.4-opcache php7.4-apcu

#echo $passwd | sudo -S apt install -y slapd ldap-utils

echo $passwd | sudo -S cp /var/www/html/phpldapadmin/config/config.php.example /var/www/html/phpldapadmin/config/config.php

#php-ldap

#mysql-server mysql-client
