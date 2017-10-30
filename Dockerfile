FROM ubuntu:16.04
RUN apt-get update && apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
  apache2 libapache2-mod-php7.0 php7.0-mysql php7.0-gd php7.0-mcrypt php-pear php7.0-curl php7.0-opcache curl lynx-cur msmtp rsyslog php7.0-mbstring dos2unix php-memcache php-soap

ENV APACHE_RUN_USER=www-data \
    APACHE_RUN_GROUP=www-data \
    APACHE_LOG_DIR=/var/log/apache2 \
    APACHE_LOCK_DIR=/var/lock/apache2 \
    APACHE_RUN_DIR=/var/run/apache2 \
    APACHE_PID_FILE=/var/run/apache2.pid 

COPY ./scripts/boot.sh /root/scripts/boot.sh
RUN chmod +x /root/scripts/* && rm -f /var/www/html/index.html

COPY ./conf/conf-available/* /etc/apache2/conf-available/
COPY ./conf/mods-available/* /etc/apache2/mods-available/
RUN a2enmod remoteip && a2enconf remoteip && a2enmod php7.0 && a2enmod rewrite
RUN dos2unix /root/scripts/boot.sh
RUN chmod +x /root/scripts/* && chown -R www-data:www-data /var/www/html && chown -R www-data:www-data /var/lib/php

EXPOSE 80
CMD ["/root/scripts/boot.sh"]