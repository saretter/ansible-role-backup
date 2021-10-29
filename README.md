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
mysql:
  backupUser: <user with permission to create dumps of alls databases mentioned>
  backupPassword: <password of backup user>
  backupHost: <database-host typically localhost>
  databases: <space separated names of databases>
  dumpDestination: <location to store sql-backups>

restic: 
  password: <the restic password>
  backupPaths: <the backup paths separated by space>
  snapshotsToKeep: <number of snapshots to keep>

backup:
  hour: <hour of backup execution>

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
