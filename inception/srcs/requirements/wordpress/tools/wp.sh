#!/bin/bash

chown -R www-data: /var/www/*;
chmod -R 755 /var/www/*;
mkdir -p /run/php/;
touch /run/php/php7.4-fpm.pid;

if [ ! -f /var/www/html/wp-config.php ]; then
    mkdir -p /var/www/html;
    cd /var/www/html;

    wp-cli core download --allow-root;

    wp-cli config create --allow-root \
        --dbname=$MYSQL_DATABASE_NAME \
        --dbuser=$(cat /var/run/secrets/credentials) \
        --dbpass=$(cat /var/run/secrets/mysql_password) \
        --dbhost=mariadb;

    echo "WordPress installation has started. Wait until the installation is completed."

    wp-cli core install --allow-root \
        --url=$DOMAIN_NAME \
        --title=$TITLE \
        --admin_user=$(cat /var/run/secrets/credentials) \
        --admin_password=$(cat /var/run/secrets/wordpress_admin_password) \
        --admin_email=$WORDPRESS_ADMIN_EMAIL;

    wp-cli user create --allow-root \
        $MYSQL_USER $MYSQL_EMAIL \
        --user_pass=$(cat /var/run/secrets/mysql_password);
fi

echo "You can visit $DOMAIN_NAME in your browser."

exec "$@"