FROM php:7.3-apache
MAINTAINER "Xavier Garnier"

ENV VERSION=1.1.16
ENV DOWNLOAD_URL=https://framagit.org/framasoft/framadate/framadate/uploads/3509507f6cf95e7b8e35ea9531bfea75/framadate-1.1.16.zip
ENV SERVERNAME=localhost
ENV ADMIN_PASSWORD=admin

# App configuration
ENV APP_NAME=Framadate
ENV EMAIL_ADRESS=noreply@example.org
ENV DB_HOST=db
ENV DB_NAME=framadate
ENV DB_USER=framadate
ENV DB_PASSWORD=password
ENV SMTP_HOST=smtp.example.com
ENV SMTP_AUTH=true
ENV SMTP_USERNAME=admin
ENV SMTP_PASSWORD=admin
ENV SMTP_SECURE=tls
ENV SMTP_PORT=587
ENV SHOW_WHAT_IS_THAT=true
ENV SHOW_THE_SOFTWARE=true
ENV SHOW_CULTIVATE_YOUR_GARDEN=true
ENV DEFAULT_POLL_DURATION=365
ENV USER_CAN_ADD_IMG_OR_LINK=true
ENV MARKDOWN_EDITOR_BY_DEFAULT=true
ENV PROVIDE_FORK_AWESOME=true

ENV ALLOWED_LANGUAGES=\$ALLOWED_LANGUAGES
ENV config=\$config

COPY apache.conf /apache.conf
COPY config.php /config.php
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
    envsubst < /config.php > /usr/local/framadate/app/inc/config.php && \
    chown -R www-data:www-data /usr/local/framadate && chmod 750 -R /usr/local/framadate && \
    apache2-foreground
