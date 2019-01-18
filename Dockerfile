FROM httpd:2.4

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl vim wget software-properties-common\
    && rm -r /var/lib/apt/lists/*
 
ARG WEB_USER=www-data
ARG WEB_GROUP=www-data
ARG USER_ID=1000
ARG GROUP_ID=1000

COPY httpd-vhosts.conf /usr/local/apache2/conf/extra/httpd-vhosts.conf
COPY httpd.conf /usr/local/apache2/conf/httpd.conf
 
RUN chgrp -R ${WEB_GROUP} /usr/local/apache2/conf/httpd.conf \
 && chgrp -R ${WEB_GROUP} /usr/local/apache2/conf/extra/httpd-vhosts.conf
 
RUN if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then \
    userdel -f www-data &&\
    if getent group www-data ; then groupdel www-data; fi &&\
    groupadd -g ${GROUP_ID} www-data &&\
    useradd -l -u ${USER_ID} -g www-data www-data &&\
    install -d -m 0755 -o www-data -g www-data /home/www-data &&\
    chown --changes --silent --no-dereference --recursive \
          --from=33:33 ${USER_ID}:${GROUP_ID} \
        /home/www-data \
        /.composer \
        /var/run/php-fpm \
        /var/lib/php/sessions \
;fi
        
USER www-data

RUN usermod -u 1000 ${WEB_USER} \
 && groupmod -g 1000 ${WEB_GROUP} \
 && chgrp -R ${WEB_GROUP} /usr/local/apache2