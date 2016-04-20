#!/bin/bash

if [ "$AWS_ACCESS_KEY_ID" = "" ]
then
    echo "AWS_ACCESS_KEY_ID does not exist. Skipping Wal-E setup."
    exit
fi

if [ "$AWS_SECRET_ACCESS_KEY" = "" ]
then
    echo "AWS_SECRET_ACCESS_KEY does not exist. Skipping Wal-E setup."
    exit
fi

if [ "$WALE_S3_PREFIX" = "" ]
then
    echo "WALE_S3_PREFIX does not exist. Skipping Wal-E setup."
    exit
fi

if [ "$AWS_REGION" = "" ]
then
    echo "AWS_REGION does not exist. Skipping Wal-E setup."
    exit
fi

# Assumption: the group is trusted to read secret information
umask u=rwx,g=rx,o=
mkdir -p /etc/wal-e.d/env

echo "$AWS_SECRET_ACCESS_KEY" > /etc/wal-e.d/env/AWS_SECRET_ACCESS_KEY
echo "$AWS_ACCESS_KEY_ID" > /etc/wal-e.d/env/AWS_ACCESS_KEY_ID
echo "$WALE_S3_PREFIX" > /etc/wal-e.d/env/WALE_S3_PREFIX
echo "$AWS_REGION" > /etc/wal-e.d/env/AWS_REGION
chown -R root:postgres /etc/wal-e.d

# wal-e specific
echo "wal_level = archive" >> /var/lib/postgresql/data/postgresql.conf
echo "archive_mode = on" >> /var/lib/postgresql/data/postgresql.conf
echo "archive_command = 'envdir /etc/wal-e.d/env /usr/local/bin/wal-e wal-push %p'" >> /var/lib/postgresql/data/postgresql.conf
echo "archive_timeout = 60" >> /var/lib/postgresql/data/postgresql.conf

# no cron in the image, use systemd timer on host instead
#su - postgres -c "crontab -l | { cat; echo \"0 3 * * * /usr/bin/envdir /etc/wal-e.d/env /usr/local/bin/wal-e backup-push /var/lib/postgresql/data\"; } | crontab -"
#su - postgres -c "crontab -l | { cat; echo \"0 4 * * * /usr/bin/envdir /etc/wal-e.d/env /usr/local/bin/wal-e delete --confirm retain 7\"; } | crontab -"
