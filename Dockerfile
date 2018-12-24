FROM httpd:2.4

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl vim wget software-properties-common\
    && rm -r /var/lib/apt/lists/*
 
ARG WEB_USER=www-data
ARG WEB_GROUP=www-data
ARG APACHE_ROOT_DIR=/usr/local/apache2
 
COPY httpd-vhosts.conf ${APACHE_ROOT_DIR}/conf/extra/httpd-vhosts.conf
COPY httpd.conf ${APACHE_ROOT_DIR}/conf/httpd.conf
 
RUN chgrp -R ${WEB_GROUP} ${APACHE_ROOT_DIR}/conf/httpd.conf \
 && chgrp -R ${WEB_GROUP} ${APACHE_ROOT_DIR}/conf/extra/httpd-vhosts.conf
 
RUN usermod -u 1000 ${WEB_USER} \
 && groupmod -g 1000 ${WEB_GROUP} \
 && chgrp -R ${WEB_GROUP} ${APACHE_ROOT_DIR}