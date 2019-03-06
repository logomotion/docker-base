FROM httpd:2.4

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl vim wget software-properties-common\
    && rm -r /var/lib/apt/lists/*
 
ENV PHP_SERVER_HOST=php
ENV SERVER_HOST_NAME=app.local
ENV DOCROOT=web

COPY httpd-vhosts.conf /usr/local/apache2/conf/extra/httpd-vhosts.conf
COPY httpd.conf /usr/local/apache2/conf/httpd.conf

RUN usermod -u 1000 www-data