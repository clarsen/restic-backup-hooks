#!/bin/sh
set -euo pipefail
echo "Running post-backup hook..."

# Check if time to run
run=false
if [ ! -f $RESTIC_REPOSITORY/last_rclone_sync ]; then
  run=true
else
  lastrun=`stat -c "%Z" $RESTIC_REPOSITORY/last_rclone_sync`
  now=`date +%s`
  ago=`expr $now - $lastrun`
  if [ $ago -gt $RCLONE_SYNC_INTERVAL_SECONDS ]; then
    echo "last sync was $ago seconds ago"
    run=true
  fi
fi

if $run; then
  echo "Would rclone sync to S3"
  RCLONE_CONFIG=/mnt/rclone/.rclone.conf
  rclone --config $RCLONE_CONFIG listremotes
  rclone --config $RCLONE_CONFIG \
    sync \
    --bwlimit  "16:00,200 01:00,700 Sat-16:00,700 Sun-16:00,700" \
    --progress \
    $RESTIC_REPOSITORY $RCLONE_DESTINATION
  touch $RESTIC_REPOSITORY/last_rclone_sync
fi

echo "Could post metric"
