FROM alpine:3.21 AS cli

# Por defecto se utiliza la timezone de Buenos Aires
ENV TZ=America/Argentina/Buenos_Aires

RUN apk --no-cache add \
    bash \
    tzdata \
    php82 \
    php82-ctype \
    php82-curl \
    php82-dom \
    php82-exif \
    php82-fileinfo \
    php82-gd \
    php82-gmp \
    php82-iconv \
    php82-json \
    php82-mbstring \
    php82-opcache \
    php82-openssl \
    php82-pcntl \
    php82-pdo_pgsql \
    php82-phar \
    php82-session \
    php82-simplexml \
    php82-sodium \
    php82-tokenizer \
    php82-zip \
    php82-xml \
    php82-xmlwriter \
    php82-xsl \
    php82-pecl-memcached \
    libsodium \
    curl \
    && echo "date.timezone  = $TZ" > /etc/php82/conf.d/80-siu-timezone.ini \
    && rm -rf /var/cache/apk/*

# https://gitlab.alpinelinux.org/alpine/aports/-/issues/12308
# RUN ln -s /usr/bin/php82 /usr/bin/php

COPY common/siu-entrypoint.d/* /siu-entrypoint.d/
COPY common/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

FROM cli AS web

RUN apk --no-cache add \
    apache2 \
    php82-apache2 \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /var/log/apache2 \
    && ln -s /dev/stderr /var/log/apache2/error.log \
    && ln -s /dev/stdout /var/log/apache2/access.log \
    #fix warning https://stackoverflow.com/a/56645177"
    && sed -i 's/^Listen 80$/Listen 0.0.0.0:8080/' /etc/apache2/httpd.conf
COPY common/apache/* /etc/apache2/conf.d/
COPY common/php/* /etc/php82/conf.d/
# COPY common/siu-entrypoint.d/* /siu-entrypoint.d/
# COPY common/entrypoint.sh /usr/local/bin/entrypoint.sh

# ENTRYPOINT ["entrypoint.sh"]

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
        /etc/php82/conf.d \
        /etc/apache2/conf.d \
        /var/www/localhost/htdocs \
        /siu-entrypoint.d \
    && chmod -R g=u \
        /etc/passwd \
        /var/run/apache2 \
        /var/log/apache2 \
        /etc/php82/conf.d \
        /etc/apache2/conf.d \
        /var/www/localhost/htdocs \
        /siu-entrypoint.d
USER $USER
