# Migrage Postgres Db

## 1. [Setup FTP](ftp-setup.md)

(if has not already been done)

## 2. [Setup Azure BlobFuse](azure-blob-fuse.md)

## 3. Install Postgres DB

### a) Add the PostgreSQL Repository

```bash
# Install prerequisites
sudo apt install -y postgresql-common ca-certificates curl

# Run the official setup script to add the PGDG repo
sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
```

### b) Install PostgreSQL 18

```bash
# Update your package list
sudo apt update

# Install the server, client, and common extensions
sudo apt install -y postgresql-18 postgresql-contrib-18
```

### c) Verify Installation

```bash
sudo systemctl status postgresql
```

### d) Edit postgres.conf

Use [pgtune](https://pgtune.leopard.in.ua/?dbVersion=18&osType=linux&dbType=web&cpuNum=4&totalMemory=32&totalMemoryUnit=GB&connectionNum=&hdType=ssd) to generate proper postgres.conf settings.

### e) Edit pg_hba.conf

```
# Database administrative login by Unix domain socket
local   all             postgres                                peer

# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            scram-sha-256
# IPv6 local connections:
host    all             all             ::1/128                 scram-sha-256
# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            scram-sha-256
host    replication     all             ::1/128                 scram-sha-256

# Allow casa connection
host    all             all             187.190.187.52/24       trust

# Allow vacation connection
host    all             all             187.189.198.209/24      trust

# Connection from app server
host    all             all             199.71.214.49/24        trust
```

### f) Open port 5432

```bash
sudo ufw allow 5432/tcp
```

### g) Restart postgres

```bash
sudo systemctl restart postgresql
```

Check the logs to ensure everything initialized correctly:

```bash
sudo tail -f /var/log/postgresql/postgresql-18-main.log
```

### h) Set the postgres user password

First, switch to the system's postgres user and enter the interactive terminal:

```bash
sudo -i -u postgres
psql
```

Once you see the postgres=# prompt, run the following SQL command (replace 'your_new_password' with a strong password):

```bash
ALTER USER postgres WITH PASSWORD 'your_new_password';
```

### i) Check connection with Datagrip

![Datagrip](pg_db_datagrip_screenshot.png)

## 3. Migrate Postgres Data

### a) Create the target database (if it doesn't exist yet):

```bash
sudo -u postgres createdb eventec_db
```

### b) Restore the database:

```bash
sudo -u postgres psql eventec_db < /path/to/your/backup_file.sql
```

## 4. setup backup script to the new server

### a)create the following backup script

```bash
sudo mkdir /bin/pg-backup
sudo touch /bin/pg-backup/pg-daily-backup.sh
```

### b) add the following bash script to pg-daily-backup.sh

```bash
!/bin/bash

# Configuration
BACKUP_DIR="/mnt/pgbackups"
DB_NAME="eventec_db"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
FILE_NAME="$BACKUP_DIR/$DB_NAME-$DATE.sql.gz"

# Ensure backup directory exists
mkdir -p $BACKUP_DIR

# Run pg_dump and compress the output
sudo -u postgres pg_dump $DB_NAME | gzip > $FILE_NAME

# Optional: Delete backups older than 7 days to save space
find $BACKUP_DIR -type f -mtime +7 -name "*.sql.gz" -delete
```

## 5. conifgure crontab

```bash
0 3 * * * /bin/bash /usr/bin/pg-scripts/pg-daily.backup.sh
@reboot sudo blobfuse /mnt/pgbackups --tmp-path=/tmp/pgbackups  --config-file=/etc/fuse_azure_connection.yml

0 3 * * * /bin/bash /bin/pg-backup/pg-daily-backup.sh
@reboot sudo blobfuse2 mount /mnt/pgbackups --tmp-path=/tmp/pgbackups --config-file=/etc/fuse_azure_connection.yml

```
