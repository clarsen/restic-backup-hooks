FROM alpine:latest as rclone

# Get rclone executable
ADD https://downloads.rclone.org/rclone-current-linux-amd64.zip /
RUN unzip rclone-current-linux-amd64.zip && mv rclone-*-linux-amd64/rclone /bin/rclone && chmod +x /bin/rclone

FROM alpine:latest

COPY --from=rclone /bin/rclone /bin/rclone

RUN \
    mkdir -p /mnt/restic /var/spool/cron/crontabs /var/log; \
    touch /var/log/cron.log;

ENV RESTIC_REPOSITORY=/mnt/restic
ENV RCLONE_SYNC_CRON="0 */6 * * *"
ENV RCLONE_SYNC_INTERVAL_SECONDS=86400
ENV RCLONE_DESTINATION=""
ENV RCLONE_BWLIMIT="16:00,200 01:00,700 Sat-16:00,700 Sun-16:00,700"

# /data is the dir where you have to put the data to be backed up
VOLUME /data

COPY entry.sh /entry.sh
COPY rclone-sync.sh /bin/rclone-sync

WORKDIR "/"

ENTRYPOINT ["/entry.sh"]
CMD ["tail","-fn0","/var/log/cron.log"]
