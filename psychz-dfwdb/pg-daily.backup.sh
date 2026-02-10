#!/bin/bash

# Configuration variables
PG_HOST="localhost"           # PostgreSQL host
PG_PORT="5432"                # PostgreSQL port
PG_USER="postgres"            # User with replication privileges
BACKUP_DIR="/tmp/pgbackups" # Directory to store backups
DATE=$(date +%Y-%m-%-d)   # Timestamp for backup directory
LOG_FILE="$BACKUP_DIR/pg_basebackup.log"

#su -u postgres
echo '-------------------------'
echo $USER

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Create a timestamped directory for the current backup
CURRENT_BACKUP_DIR="$BACKUP_DIR/$DATE"
mkdir -p "$CURRENT_BACKUP_DIR"
chown postgres "$CURRENT_BACKUP_DIR"
# Execute pg_basebackup

echo "Starting pg_basebackup at $DATE..." | tee -a "$LOG_FILE"
sudo -u postgres pg_basebackup -D "$CURRENT_BACKUP_DIR" -F t -z -v --wal-method=stream 2>&1 | tee -a "$LOG_FILE"

DEST_BACKUP_DIR="/mnt/pgbackups/$DATE"

mv "$CURRENT_BACKUP_DIR" "$DEST_BACKUP_DIR"

# Check the exit status of pg_basebackup
if [ $? -eq 0 ]; then
    echo "pg_basebackup completed successfully to $CURRENT_BACKUP_DIR" | tee -a "$LOG_FILE"
else
    echo "pg_basebackup failed. Check $LOG_FILE for details." | tee -a "$LOG_FILE"
fi

# Optional: Clean up old backups (e.g., keep last 7 days)
# find "$BACKUP_DIR" -maxdepth 1 -type d -name "2*" -mtime +7 -exec rm -rf {} \;
# echo "Old backups cleaned up." | tee -a "$LOG_FILE"
