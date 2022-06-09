#!/bin/bash

####################################################################################################

# Script para la autoinstalacion de phpldapadmin y todos sus requisitos

####################################################################################################

# Cambia solo los datos de la primera seccion!

# Password para comandos que usan sudo
passwd=5mouse1

# Obtiene interfaz por defecto para usar en configuracion netplan
interface=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}' | head -1)

# Ip para assginar a la interfaz de red por defecto
ip=192.168.0.100

# Puerta de enlace predeterminada
gateway=192.168.0.1

# Servidor dns, 1.1.1.1 es cloudflare, puedes uar 8.8.8.8 para google o el servidor dns que quieras
dns=1.1.1.1

####################################################################################################

# echo $passwd | touch ~/Desktop/netplan/00-installer-config.yaml

file=~/Desktop/00-installer-config.yaml 
if [ -f $file ]; then rm $file; fi


# Creacion automatica del archivo de configuracion de red
touch $file
printf "network:\n\tethernets:\n\t\t$interface:\n\t\t\taddresses: [$ip/24]\n\t\t\tgateway4: $gateway\n\t\t\tnameservers:\n\t\t\t\taddresses: [$dns]\n\tversion: 2" >> $file

# Movemos el archivo al directorio correcto (se crea en caso de que no exista)
if ! [ -d /etc/netplan ]; then echo $passwd | sudo -S mkdir -p /etc/netplan; fi
echo $passwd | sudo -S mv $file /etc/netplan
echo $passwd | sudo -S netplan apply

#Actualizamos repos y el sistema en caso de ser necesario
echo $passwd | sudo -S apt update && sudo -S apt upgrade

#Instalacion de todos los paquetes necesarios
echo $passwd | sudo -S apt install -y slapd ldap-utils mysql-server mysql-client apache2 php7.4 libapache2-mod-php7.4 php7.4-mysql php7.4-ldap php7.4-xml php7.4-opcache php7.4-apcu
