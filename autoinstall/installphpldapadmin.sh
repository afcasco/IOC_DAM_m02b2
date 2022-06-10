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

#Crear debconf para instalacion desatendida de slapd
touch ~/debconf-slapd.conf
echo "slapd	slapd/internal/adminpw	password" >> ~/debconf-slapd
echo "slapd	slapd/password2	password" >> ~/debconf-slapd
echo "slapd	slapd/password1	password" >> ~/debconf-slapd
echo " slapd	slapd/internal/generated_adminpw	password" >> ~/debconf-slapd
# Do you want the database to be removed when slapd is purged?
echo "slapd	slapd/purge_database	boolean	false" >> ~/debconf-slapd
echo "slapd	slapd/dump_database	select	when needed" >> ~/debconf-slapd
echo "slapd	slapd/invalid_config	boolean	true" >> ~/debconf-slapd
echo "slapd	slapd/upgrade_slapcat_failure	error" >> ~/debconf-slapd
echo "slapd	slapd/domain	string	eu-west-3.compute.internal" >> ~/debconf-slapd
echo "slapd	slapd/ppolicy_schema_needs_update	select	abort installation" >> ~/debconf-slapd
# Potentially unsafe slapd access control configuration
echo "slapd	slapd/unsafe_selfwrite_acl	note" >> ~/debconf-slapd
echo "slapd	slapd/move_old_database	boolean	true" >> ~/debconf-slapd
ehco "slapd	slapd/password_mismatch	note" >> ~/debconf-slapd
echo "slapd	shared/organization	string	eu-west-3.compute.internal" >> ~/debconf-slapd
echo "slapd	slapd/dump_database_destdir	string	/var/backups/slapd-VERSION" >> ~/debconf-slapd
echo "slapd	slapd/no_configuration	boolean	false" >> ~/debconf-slapd
export DEBIAN_FRONTEND=noninteractive
cat ~/debconf-slapd.conf | debconf-set-selections
apt install ldap-utils slapd -y

# modificar /etc/ldap/ldap.conf
# BASE	dc=dragon,dc=lab
#URI	ldap://ldap.dragon.lab


#instalar phpldapadmin clonando del repositorio de github
git clone https://github.com/leenooks/phpLDAPadmin.git

# falta pasar variable de configuracion para no tener que editar el config.php

# // $servers->setValue('server','host','127.0.0.1'); -> $servers->setValue('server','host','SERVER_IP');
# $servers->setValue('server','base',array()); -> $servers->setValue('server','base',array('dc=example,dc=com));
# //$servers->setValue('server','tls',false); -> $servers->setValue('server','tls',false);
# //$servers->setValue('login','anon_bind',true); -> $servers->setValue('login','anon_bind',false);


mv ./phpLDAPadmin /var/www/html/phpldapadmin

#for php7.4 installation
echo $passwd | sudo apt install software-properties-common apt-transport-https -y
echo $passwd | sudo add-apt-repository ppa:ondrej/php -y
echo $passwd | sudo -S apt update && sudo -S apt upgrade
echo $passwd | sudo apt install php7.4 php7.4-common libapache2-mod-php7.4


#copiar archivo de ejemplo de configuracion de phpldapadmin a config.php
# esto hay que conseguir que no haga falta
#echo $passwd | sudo -S cp /var/www/html/phpldapadmin/config/config.php.example /var/www/html/phpldapadmin/config/config.php

