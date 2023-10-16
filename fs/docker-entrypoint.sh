#!/bin/sh

if [ -f "/opt/bootstrap.sh" ]
then
    chmod +x /opt/bootstrap.sh
    /opt/bootstrap.sh
fi

exec /usr/sbin/php-fpm8 -R --nodaemonize