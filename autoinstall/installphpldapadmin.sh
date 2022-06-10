#!/bin/bash

####################################################################################################

# Script para la autoinstalacion de slapd phpldapadmin y todos sus requisitos

####################################################################################################

# CAMBIAR SOLO DATOS DE LINEAS 12, 15, 16 Y 17

# Password para ldap y comandos que usan sudo 
passwd=afernandez

# A editar con la configuracion que cuadre con tu red de casa (la vm debe estar en modo bridge!)
ip=192.168.1.120
gateway=192.168.1.1
dns=1.1.1.1
domain=example.com
orgName="Eaxample com"

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

#Actualizamos repos y el sistema que siempre va bien :)
echo $passwd | sudo -S apt update && sudo -S apt upgrade

#Crear archivo de configuracion para instalacion desatendida de slapd
export DEBIAN_FRONTEND=noninteractive
echo -e "
slapd	slapd/internal/adminpw	password	$passwd
slapd	slapd/password2	password	$passwd
slapd	slapd/password1	password	$passwd
slapd	slapd/internal/generated_adminpw	password	$passwd
slapd	slapd/purge_database	boolean	false
slapd	slapd/dump_database	select	when needed
slapd	slapd/invalid_config	boolean	true
slapd	slapd/upgrade_slapcat_failure	error	
slapd	slapd/domain	string	$domain
slapd	slapd/ppolicy_schema_needs_update	select	abort installation
slapd	slapd/unsafe_selfwrite_acl	note	
slapd	slapd/move_old_database	boolean	true
slapd	slapd/password_mismatch	note	
slapd	shared/organization	string	$orgName
slapd	slapd/dump_database_destdir	string	/var/backups/slapd-VERSION
slapd	slapd/no_configuration	boolean	false" | debconf-set-selections
apt-get -y install slapd ldap-utils




echo -e " 
slapd    slapd/internal/generated_adminpw    password   openstack
slapd    slapd/password2    password    openstack
slapd    slapd/internal/adminpw    password openstack
slapd    slapd/password1    password    openstack
" | sudo debconf-set-selections

sudo apt-get install -y slapd ldap-utils

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

