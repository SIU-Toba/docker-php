FROM alpine:3.16 AS cli

# Por defecto se utiliza la timezone de Buenos Aires
ENV TZ=America/Argentina/Buenos_Aires

RUN apk --no-cache add \
    bash \
    tzdata \
    php8 \
    php8-ctype \
    php8-curl \
    php8-dom \
    php8-exif \
    php8-fileinfo \
    php8-gd \
    php8-gmp \
    php8-iconv \
    php8-json \
    php8-mbstring \
    php8-opcache \
    php8-openssl \
    php8-pcntl \
    php8-pdo_pgsql \
    php8-phar \
    php8-session \
    php8-simplexml \
    php8-sodium \
    php8-tokenizer \
    php8-zip \
    php8-xml \
    php8-xmlwriter \
    php8-xsl \
    php8-pecl-memcached \    
    libsodium \
    curl \
    && echo "date.timezone  = $TZ" > /etc/php8/conf.d/80-siu-timezone.ini \
    && rm -rf /var/cache/apk/*

# https://gitlab.alpinelinux.org/alpine/aports/-/issues/12308
RUN ln -s /usr/bin/php8 /usr/bin/php

COPY common/siu-entrypoint.d/* /siu-entrypoint.d/
COPY common/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]



FROM cli AS web

RUN apk --no-cache add \
    apache2 \
    php8-apache2 \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /var/log/apache2 \
    && ln -s /dev/stderr /var/log/apache2/error.log \
    && ln -s /dev/stdout /var/log/apache2/access.log \
    #fix warning https://stackoverflow.com/a/56645177"
    && sed -i 's/^Listen 80$/Listen 0.0.0.0:8080/' /etc/apache2/httpd.conf
COPY common/apache/* /etc/apache2/conf.d/
COPY common/php/* /etc/php8/conf.d/

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
        /etc/php8/conf.d \
        /etc/apache2/conf.d \
        /var/www/localhost/htdocs \
        /siu-entrypoint.d \
    && chmod -R g=u \
        /etc/passwd \
        /var/run/apache2 \
        /var/log/apache2 \
        /etc/php8/conf.d \
        /etc/apache2/conf.d \
        /var/www/localhost/htdocs \
        /siu-entrypoint.d
USER $USER
