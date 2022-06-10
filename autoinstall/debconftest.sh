
echo "slapd	slapd/internal/adminpw	password	$passwd" | debconf-set-selections
echo "slapd	slapd/password2	password	$passwd" | debconf-set-selections
echo "slapd	slapd/password1	password	$passwd" | debconf-set-selections
echo "slapd	slapd/internal/generated_adminpw	password	$passwd" | debconf-set-selections
echo "slapd	slapd/purge_database	boolean	false" | debconf-set-selections
echo "slapd	slapd/dump_database	select	when needed" | debconf-set-selections
echo "slapd	slapd/invalid_config	boolean	true" | debconf-set-selections
echo "slapd	slapd/upgrade_slapcat_failure	error"	 | debconf-set-selections
echo "slapd	slapd/domain	string	$domain" | debconf-set-selections
echo "slapd	slapd/ppolicy_schema_needs_update	select	abort installation" | debconf-set-selections
echo "slapd	slapd/unsafe_selfwrite_acl	note"	 | debconf-set-selections
echo "slapd	slapd/move_old_database	boolean	true" | debconf-set-selections
echo "slapd	slapd/password_mismatch	note"	 | debconf-set-selections
echo "slapd	shared/organization	string	$orgName" | debconf-set-selections
echo "slapd	slapd/dump_database_destdir	string	/var/backups/slapd-VERSION" | debconf-set-selections
echo "slapd	slapd/no_configuration	boolean	false"  | debconf-set-selections
