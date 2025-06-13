FROM alpine:3.16 AS cli

# Por defecto se utiliza la timezone de Buenos Aires
ENV TZ=America/Argentina/Buenos_Aires

RUN apk --no-cache add \
    bash \
    tzdata \
    php81 \
    php81-ctype \
    php81-curl \
    php81-dom \
    php81-exif \
    php81-fileinfo \
    php81-gd \
    php81-gmp \
    php81-iconv \
    php81-json \
    php81-mbstring \
    php81-opcache \
    php81-openssl \
    php81-pcntl \
    php81-pdo_pgsql \
    php81-phar \
    php81-session \
    php81-simplexml \
    php81-sodium \
    php81-tokenizer \
    php81-zip \
    php81-xml \
    php81-xmlwriter \
    php81-xsl \
    php81-pecl-memcached \
    libsodium \
    curl \
    && echo "date.timezone  = $TZ" > /etc/php81/conf.d/80-siu-timezone.ini \
    && rm -rf /var/cache/apk/*

# https://gitlab.alpinelinux.org/alpine/aports/-/issues/12308
RUN ln -s /usr/bin/php81 /usr/bin/php

COPY common/siu-entrypoint.d/* /siu-entrypoint.d/
COPY common/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]


FROM cli AS web

RUN apk --no-cache add \
    apache2 \
    php81-apache2 \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /var/log/apache2 \
    && ln -s /dev/stderr /var/log/apache2/error.log \
    && ln -s /dev/stdout /var/log/apache2/access.log \
    #fix warning https://stackoverflow.com/a/56645177"
    && sed -i 's/^Listen 80$/Listen 0.0.0.0:8080/' /etc/apache2/httpd.conf
COPY common/apache/* /etc/apache2/conf.d/
COPY common/php/* /etc/php81/conf.d/

CMD ["httpd", "-D", "FOREGROUND"]

EXPOSE 8080

FROM web AS rootless

ARG USER=siu
ENV USER=$USER
ARG UID=222

RUN adduser -h /usr/local/app -u $UID -G www-data -S $USER \
    && chown -R $USER.0 \
        /var/run/apache2 \
        /var/log/apache2 \
        /etc/php81/conf.d \
        /etc/apache2/conf.d \
        /var/www/localhost/htdocs \
        /siu-entrypoint.d \
    && chmod -R g=u \
        /etc/passwd \
        /var/run/apache2 \
        /var/log/apache2 \
        /etc/php81/conf.d \
        /etc/apache2/conf.d \
        /var/www/localhost/htdocs \
        /siu-entrypoint.d
USER $USER
