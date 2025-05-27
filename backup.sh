#!/bin/bash

# Create backup directories if they don't exist
mkdir -p backup/postgres
mkdir -p backup/ldap

# Backup PostgreSQL
echo "Backing up PostgreSQL..."
docker exec postgres pg_dump -U $POSTGRES_USER $POSTGRES_DB > backup/postgres/backup_$(date +%Y%m%d_%H%M%S).sql

# Backup LDAP
echo "Backing up LDAP..."
docker exec openldap ldapsearch -x -H ldap://localhost:389 -b $LDAP_ROOT -D "cn=$LDAP_ADMIN_USERNAME,$LDAP_ROOT" -w $LDAP_ADMIN_PASSWORD > backup/ldap/backup_$(date +%Y%m%d_%H%M%S).ldif

# Keep only last 7 days of backups
find backup/postgres -name "backup_*.sql" -mtime +7 -delete
find backup/ldap -name "backup_*.ldif" -mtime +7 -delete

echo "Backup completed successfully!" 