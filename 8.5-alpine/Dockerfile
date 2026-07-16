FROM alpine:3.23 AS cli

# Por defecto se utiliza la timezone de Buenos Aires
ENV TZ=America/Argentina/Buenos_Aires

RUN apk --no-cache add \
    bash \
    tzdata \
    php85 \
    php85-ctype \
    php85-curl \
    php85-dom \
    php85-exif \
    php85-fileinfo \
    php85-gd \
    php85-gmp \
    php85-iconv \
    php85-mbstring \
    php85-openssl \
    php85-pcntl \
    php85-pdo_pgsql \
    php85-phar \
    php85-session \
    php85-simplexml \
    php85-sodium \
    php85-tokenizer \
    php85-zip \
    php85-xml \
    php85-xmlwriter \
    php85-xsl \
    php85-pecl-memcached \
    libsodium \
    curl \
    && echo "date.timezone  = $TZ" > /etc/php85/conf.d/80-siu-timezone.ini \
    && rm -rf /var/cache/apk/*

# https://gitlab.alpinelinux.org/alpine/aports/-/issues/12308
RUN ln -s /usr/bin/php85 /usr/bin/php

COPY common/siu-entrypoint.d/* /siu-entrypoint.d/
COPY common/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

FROM cli AS web

RUN apk --no-cache add \
    apache2 \
    php85-apache2 \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /var/log/apache2 \
    && ln -s /dev/stderr /var/log/apache2/error.log \
    && ln -s /dev/stdout /var/log/apache2/access.log \
    #fix warning https://stackoverflow.com/a/56645177"
    && sed -i 's/^Listen 80$/Listen 0.0.0.0:8080/' /etc/apache2/httpd.conf
COPY common/apache/* /etc/apache2/conf.d/
COPY common/php/* /etc/php85/conf.d/

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
        /etc/php85/conf.d \
        /etc/apache2/conf.d \
        /var/www/localhost/htdocs \
        /siu-entrypoint.d \
    && chmod -R g=u \
        /etc/passwd \
        /var/run/apache2 \
        /var/log/apache2 \
        /etc/php85/conf.d \
        /etc/apache2/conf.d \
        /var/www/localhost/htdocs \
        /siu-entrypoint.d
USER $USER
