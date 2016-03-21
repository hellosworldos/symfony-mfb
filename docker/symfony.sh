#!/bin/sh

if [ "$(ls -A /var/www/symfony_volume)" ]; then
    rm -rf /var/www/symfony
    ln -s /var/www/symfony_volume /var/www/symfony
fi

DB_PORT_3306_TCP_ADDR=${DB_PORT_3306_TCP_ADDR:-127.0.0.1}
DB_PORT_3306_TCP_PORT=${DB_PORT_3306_TCP_PORT:-3306}
DB_ENV_MYSQL_USER=${DB_ENV_MYSQL_USER:-user}
DB_ENV_MYSQL_PASS=${DB_ENV_MYSQL_PASS:-pass}
DB_ENV_MYSQL_DBNAME=${DB_ENV_MYSQL_DBNAME:-dbname}

if [ -n "$IS_DEV" ]; then
    sed -i "s/app\.php/app_dev.php/g" /etc/nginx/conf.d/symfony.conf
    supervisorctl restart nginx
fi

# install symfony

cd /var/www/symfony/app/config/
cp parameters.yml.docker parameters.yml.tmp
sed -i "s/{{db_host}}/$DB_PORT_3306_TCP_ADDR/g" parameters.yml.tmp
sed -i "s/{{db_port}}/$DB_PORT_3306_TCP_PORT/g" parameters.yml.tmp
sed -i "s/{{db_user}}/$DB_ENV_MYSQL_USER/g" parameters.yml.tmp
sed -i "s/{{db_pass}}/$DB_ENV_MYSQL_PASS/g" parameters.yml.tmp
sed -i "s/{{db_name}}/$DB_ENV_MYSQL_DBNAME/g" parameters.yml.tmp
cp parameters.yml.tmp parameters.yml
rm -rf parameters.yml.tmp

cd /var/www/symfony

if [ -n "$IS_DEV" ]; then
  composer update -n
fi

# Install database updates
./app/console cache:clear -n
#./app/console doctrine:migrations:migrate -n

chown -R www-data:www-data /var/www/symfony
rm -rf /var/www/symfony/app/cache/*
rm -rf /var/www/symfony/app/logs/*
chmod -R 0777 /var/www/symfony/app/cache/
chmod -R 0777 /var/www/symfony/app/logs/
