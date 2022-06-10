#Crear configuracion para instalacion desatendida de slapd
touch ~/debconf-sldap.conf
export DEBIAN_FRONTEND=noninteractive
echo "slapd	slapd/internal/adminpw	password	$passwd">> ~/debconf-sldap.conf
echo "slapd	slapd/password2	password	$passwd" >> ~/debconf-sldap.conf
echo "slapd	slapd/password1	password	$passwd" >> ~/debconf-sldap.conf
echo "slapd	slapd/internal/generated_adminpw	password	$passwd" >> ~/debconf-sldap.conf
echo "slapd	slapd/purge_database	boolean	false" >> ~/debconf-sldap.conf
echo "slapd	slapd/dump_database	select	when needed" >> ~/debconf-sldap.conf
echo "slapd	slapd/invalid_config	boolean	true" >> ~/debconf-sldap.conf
echo "slapd	slapd/upgrade_slapcat_failure	error"	 >> ~/debconf-sldap.conf
echo "slapd	slapd/domain	string	$domain" >> ~/debconf-sldap.conf
echo "slapd	slapd/ppolicy_schema_needs_update	select	abort installation" >> ~/debconf-sldap.conf
echo "slapd	slapd/unsafe_selfwrite_acl	note"	 >> ~/debconf-sldap.conf
echo "slapd	slapd/move_old_database	boolean	true" >> ~/debconf-sldap.conf
echo "slapd	slapd/password_mismatch	note"	 >> ~/debconf-sldap.conf
echo "slapd	shared/organization	string	$orgName" >> ~/debconf-sldap.conf
echo "slapd	slapd/dump_database_destdir	string	/var/backups/slapd-VERSION" >> ~/debconf-sldap.conf
echo "slapd	slapd/no_configuration	boolean	false"  >> ~/debconf-sldap.conf
cat ~/debconf-slapd.conf | debconf-set-selections
apt-get -y install slapd ldap-utils
