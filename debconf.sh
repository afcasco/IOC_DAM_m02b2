#!/bin/bash

cat > ~/debconf-slapd.conf << 'EOF'
slapd slapd/password1 password admin
slapd slapd/internal/adminpw password admin
slapd slapd/internal/generated_adminpw password admin
slapd slapd/password2 password admin
slapd slapd/unsafe_selfwrite_acl note
slapd slapd/purge_database boolean false
slapd slapd/domain string phys.ethz.ch
slapd slapd/ppolicy_schema_needs_update select abort installation
slapd slapd/invalid_config boolean true
slapd slapd/move_old_database boolean false
slapd slapd/backend select MDB
slapd shared/organization string ETH Zurich
slapd slapd/dump_database_destdir string /var/backups/slapd-VERSION
slapd slapd/no_configuration boolean false
slapd slapd/dump_database select when needed
slapd slapd/password_mismatch note
EOF
export DEBIAN_FRONTEND=noninteractive
cat ~/debconf-slapd.conf | debconf-set-selections
apt install ldap-utils slapd -y
