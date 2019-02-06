FROM ubuntu:16.04
MAINTAINER Peerasan Buranasanti <peerasan@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# add NGINX official stable repository
RUN echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu xenial main" > /etc/apt/sources.list.d/nginx.list  && \
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C  && \
echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main " > /etc/apt/sources.list.d/php.list  && \
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C

#RUN sed -i -e "s/archive.ubuntu.com/mirror.ku.ac.th/g" /etc/apt/sources.list

# Install Composer
ENV COMPOSER_VERSION master
ENV COMPOSER_HOME /var/tmp/composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# install packages
RUN apt-get update && apt-get -y install apt-utils

RUN apt-get -y --no-install-recommends install \
curl wget openssh-client wget curl git ffmpeg nano ca-certificates \
nginx php7.1 php7.1-fpm php7.1-common php7.1-tokenizer php7.1-curl php7.1-gd php7.1-intl php7.1-json php7.1-mbstring php7.1-mcrypt php7.1-mysql php7.1-opcache php7.1-pgsql php7.1-soap php7.1-sqlite3 php7.1-xml php7.1-xmlrpc php7.1-xsl php7.1-zip \
libssh2-1-dev libssh2-1 \
pecl install ssh2 \
docker-php-ext-enable ssh2 \
php-imagick php-ghostscript && \
cp -r /etc/php /etc/php.orig && \
cp -r /etc/nginx /etc/nginx.orig && \
apt-get autoclean && apt-get -y autoremove && \
echo "<?php phpinfo();?>" > /var/www/html/info.php && \
mkdir -p /run/php

# VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx"]
# # NGINX mountable directory for apps
# VOLUME ["/var/www"]

COPY fs /

# NGINX ports
EXPOSE 80 443

ADD run.sh /root/run.sh
CMD /bin/sh /root/run.sh
