#!/bin/bash

# MySQL settings
MUSER={{mysql_backupUser}}
MPASS={{mysql_backupPassword}}
MHOST={{mysql_backupHost}}
DUMPDEST={{backup_dumpDestination}}
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
PGDUMP="$(which pg_dump)"
PGUSER={{pg_backupUser}}
PGHOST={{pg_backupHost}}

GZIP="$(which gzip)"
# if you leave this empty no Database-Backup will be performed
MYSQLDATABASES="{{mysql_databases}}"
PGDATABASES="{{pg_databases}}"

# Restic settings
export RESTIC_PASSWORD={{restic_password}}
export RESTIC_REPOSITORY={{restic_backupRepository}}
export AWS_ACCESS_KEY_ID={{restic_s3_key_id}}
export AWS_SECRET_ACCESS_KEY={{restic_s3_key_secret}}

RESTIC_BACKUP_PATHS="{{restic_backupPaths}}"
RESTIC_SNAPSHOTS_TO_KEEP={{restic_snapshotsToKeep}}

# Create MYSQL dumps# Create DB-Dumps
if [ "$MYSQLDATABASES" != "" ]; then
  FILE=$DUMPDEST/mysql-$(date +"%Y-%m-%d_%H-%M").gz
  $MYSQLDUMP -u $MUSER -h $MHOST -p$MPASS --databases $MYSQLDATABASES | $GZIP -9 > $FILE
fi

# Create PostgreSQL Dumps
if [ "$PGDATABASES" != "" ]; then
  read -ra DBs <<< "$PGDATABASES"
  for i in  "${DBs[@]}";
  do
    FILE=$DUMPDEST/pgsql-$i-$(date +"%Y-%m-%d_%H-%M").gz
    sudo -i -u $PGUSER $PGDUMP --dbname $i | $GZIP -9 > $FILE
  done
fi

# Cleanup old db-dumps
if [ "$DUMPDEST" != "" ]; then 
  find $DUMPDEST \( -name '*' \) -mtime +$RESTIC_SNAPSHOTS_TO_KEEP -exec rm -rf {} \;
fi
# Create Restic backup
restic backup $RESTIC_BACKUP_PATHS

# Prune old backups
restic forget --keep-last $RESTIC_SNAPSHOTS_TO_KEEP

# Unset several environment variables containing credentials
unset RESTIC_PASSWORD
unset RESTIC_REPOSITORY
unset MPASS
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY