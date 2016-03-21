FROM hellosworldos/webserver

ADD /etc/nginx/conf.d/symfony.conf /etc/nginx/conf.d/symfony.conf
ADD /etc/php5/fpm/conf.d/20-xdebug.ini /etc/php5/fpm/conf.d/20-xdebug.ini

RUN mkdir /root/symfony

ADD /init.py /root/symfony/init.py
ADD /symfony.sh /root/symfony/symfony.sh

RUN apt-get update \
    && apt-get -y upgrade \
    && composer self-update -n \
    && apt-get install -y \
    php5-xdebug

RUN chmod +x /root/symfony/*.py
RUN chmod +x /root/symfony/*.sh

VOLUME ["/var/www/symfony_volume"]

CMD ["/root/symfony/init.py"]

