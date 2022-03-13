Role Name
=========

Simple ansible-role to install and configure [restic](https://restic.net).

Requirements
------------
This role was created for Debian 10.x (Buster). 

The role currently supports mounting a webdav-url, creates a restic repository and a cronjob for regular-backups.

Role Variables
--------------

The following variables don't have defaults. You need to specify them either in a file in group_vars, host_vars directory or via command-line.
```yaml

backup_hour: <hour of backup execution>
backup_dumpDestination: <location to store sql-backups>

mysql_backupUser: <user with permission to create dumps of alls databases mentioned>
mysql_backupPassword: <password of backup user>
mysql_backupHost: <database-host typically localhost>
mysql_databases: <space separated names of databases>
  
postgre:
  
restic_password: <the restic password>
restic_s3_key_id
restic_s3_key_secret
restic_backupPaths: <the backup paths separated by space>
restic_snapshotsToKeep: <number of snapshots to keep>
```

Example Playbook
----------------

This role can be easily used in a playbook like this: 

```yaml
- hosts: froxlor-servers
  roles:
      - ansible-role-backup
```

License
-------
GNU GENERAL PUBLIC LICENSE VERSION 3

Author Information
------------------
[blog.retter.jetzt](https://blog.retter.jetzt)
