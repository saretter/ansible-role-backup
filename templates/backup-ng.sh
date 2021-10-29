#!/bin/bash

# MySQL settings
MUSER={{mysql_backupUser}}
MPASS={{mysql_backupPassword}}
MHOST={{mysql_backupHost}}
MSQLDUMPDEST={{mysql_dumpDestination}}
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
GZIP="$(which gzip)"
# if you leave this empty no Database-Backup will be performed
DATABASES="{{mysql_databases}}"

# Restic settings
export RESTIC_PASSWORD={{restic_password}}
export AWS_ACCESS_KEY_ID={{restic_s3_key_id}}
export AWS_SECRET_ACCESS_KEY={{restic_s3_key_secret}}

RESTIC_BACKUP_PATHS="{{restic_backupPaths}}"
RESTIC_BACKUP_REPOSITORY={{restic_backupRepository}}
RESTIC_SNAPSHOTS_TO_KEEP={{restic_snapshotsToKeep}}

# Create SQL dumps# Create DB-Dumps
if [ "$DATABASES" != "" ]; then
  FILE=$MSQLDUMPDEST/mysql-$(date +"%Y-%m-%d_%T").gz
  $MYSQLDUMP -u $MUSER -h $MHOST -p$MPASS --databases $DATABASES | $GZIP -9 > $FILE
fi

# Cleanup old db-dumps
if [ "$MYSQLDUMPDEST" != "" ]; then 
  find $MYSQLDUMPDEST \( -name '*' \) -mtime +$RESTIC_SNAPSHOTS_TO_KEEP -exec rm -rf {} \;
fi
# Create Restic backup
restic -r $RESTIC_BACKUP_REPOSITORY backup $RESTIC_BACKUP_PATHS

# Prune old backups
restic -r $RESTIC_BACKUP_REPOSITORY forget --keep-last $RESTIC_SNAPSHOTS_TO_KEEP

# Unset several environment variables containing credentials
unset RESTIC_PASSWORD
unset MPASS
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY