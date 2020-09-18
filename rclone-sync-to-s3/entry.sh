#!bin/sh

echo "Starting container ..."

if [ -n "${NFS_TARGET}" ]; then
    echo "Mounting NFS based on NFS_TARGET: ${NFS_TARGET}"
    mount -o nolock -v ${NFS_TARGET} /mnt/restic
fi

# restic snapshots &>/dev/null
# status=$?
# echo "Check Repo status $status"

# if [ $status != 0 ]; then
#     echo "Restic repository '${RESTIC_REPOSITORY}' does not exists. Running restic init."
#     restic init

#     init_status=$?
#     echo "Repo init status $init_status"

#     if [ $init_status != 0 ]; then
#         echo "Failed to init the repository: '${RESTIC_REPOSITORY}'"
#         exit 1
#     fi
# fi

echo "Setting up rclone sync cron job with expression RCLONE_SYNC_CRON: ${RCLONE_SYNC_CRON}"
echo "${RCLONE_SYNC_CRON} /usr/bin/flock -n /var/run/rclone.lock /bin/rclone-sync >> /var/log/cron.log 2>&1" > /var/spool/cron/crontabs/root

# Make sure the file exists before we start tail
touch /var/log/cron.log

# start the cron deamon
crond

echo "Container started."

exec "$@"