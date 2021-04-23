FROM php:7.3-apache
MAINTAINER "Xavier Garnier"

ENV VERSION=1.1.16
ENV DOWNLOAD_URL=https://framagit.org/framasoft/framadate/framadate/uploads/3509507f6cf95e7b8e35ea9531bfea75/framadate-1.1.16.zip
ENV SERVERNAME=localhost
ENV ADMIN_PASSWORD=admin

COPY apache.conf /apache.conf
COPY php.ini /usr/local/etc/php/conf.d/framadate-php.ini

RUN set -x && \
    apt-get update && \
    apt-get install -y gettext-base libicu-dev zip && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl && \
    docker-php-ext-install mysqli pdo pdo_mysql && \
    a2enmod rewrite && \
    curl ${DOWNLOAD_URL} -o framadate.zip && \
    unzip framadate.zip && \
    mv framadate /usr/local/framadate && \
    chown -R www-data:www-data /usr/local/framadate && chmod 750 -R /usr/local/framadate && \
    cat /apache.conf | envsubst > /etc/apache2/sites-available/framadate.conf && \
    a2ensite framadate

WORKDIR /usr/local/framadate
COPY .htaccess /usr/local/framadate/.htaccess
COPY .htaccess_admin /usr/local/framadate/admin/.htaccess

CMD htpasswd -bc /usr/local/framadate/admin/.htpasswd admin ${ADMIN_PASSWORD} && \
    envsubst < /apache.conf > /etc/apache2/sites-available/framadate.conf && \
    apache2-foreground
