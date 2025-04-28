FROM alpine:3.21 AS cli

# Por defecto se utiliza la timezone de Buenos Aires
ENV TZ=America/Argentina/Buenos_Aires

RUN apk --no-cache add \
    bash \
    tzdata \
    php84 \
    php84-ctype \
    php84-curl \
    php84-dom \
    php84-exif \
    php84-fileinfo \
    php84-gd \
    php84-gmp \
    php84-iconv \
    php84-json \
    php84-mbstring \
    php84-opcache \
    php84-openssl \
    php84-pcntl \
    php84-pdo_pgsql \
    php84-phar \
    php84-session \
    php84-simplexml \
    php84-sodium \
    php84-tokenizer \
    php84-zip \
    php84-xml \
    php84-xmlwriter \
    php84-xsl \
    php84-pecl-memcached \
    libsodium \
    curl \
    && echo "date.timezone  = $TZ" > /etc/php84/conf.d/80-siu-timezone.ini \
    && rm -rf /var/cache/apk/*

# https://gitlab.alpinelinux.org/alpine/aports/-/issues/12308
RUN ln -s /usr/bin/php84 /usr/bin/php

COPY common/siu-entrypoint.d/* /siu-entrypoint.d/
COPY common/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

FROM cli AS web

RUN apk --no-cache add \
    apache2 \
    php84-apache2 \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /var/log/apache2 \
    && ln -s /dev/stderr /var/log/apache2/error.log \
    && ln -s /dev/stdout /var/log/apache2/access.log \
    #fix warning https://stackoverflow.com/a/56645177"
    && sed -i 's/^Listen 80$/Listen 0.0.0.0:8080/' /etc/apache2/httpd.conf
COPY common/apache/* /etc/apache2/conf.d/
COPY common/php/* /etc/php84/conf.d/
## COPY common/siu-entrypoint.d/* /siu-entrypoint.d/
## COPY common/entrypoint.sh /usr/local/bin/entrypoint.sh
 
## ENTRYPOINT ["entrypoint.sh"] 

CMD ["httpd", "-D", "FOREGROUND"]

EXPOSE 8080

FROM web AS rootless

ARG USER=siu
ENV USER=$USER
ARG UID=222

RUN adduser -h /usr/local/app -u $UID -G www-data -S $USER \
    && chown -R $USER:0 \
        /var/run/apache2 \
        /var/log/apache2 \
        /etc/php84/conf.d \
        /etc/apache2/conf.d \
        /var/www/localhost/htdocs \
        /siu-entrypoint.d \
    && chmod -R g=u \
        /etc/passwd \
        /var/run/apache2 \
        /var/log/apache2 \
        /etc/php84/conf.d \
        /etc/apache2/conf.d \
        /var/www/localhost/htdocs \
        /siu-entrypoint.d
USER $USER
