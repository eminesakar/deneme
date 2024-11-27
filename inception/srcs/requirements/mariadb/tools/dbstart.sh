#!/bin/bash

service mariadb start

sleep 3

mariadb -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE_NAME;"
mariadb -e "CREATE USER IF NOT EXISTS '$(cat /var/run/secrets/credentials)'@'%' IDENTIFIED BY '$(cat /var/run/secrets/mysql_password)';"
mariadb -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE_NAME.* TO '$(cat /var/run/secrets/credentials)'@'%';"
mariadb -e "FLUSH PRIVILEGES;"
mariadb -e "SHUTDOWN;"

exec "$@"