FROM alpine:3.13 as cli

# Por defecto se utiliza la timezone de Buenos Aires
ENV TZ=America/Argentina/Buenos_Aires

RUN apk --no-cache add \
    bash \
    tzdata \
    php7 \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-exif \
    php7-fileinfo \
    php7-gd \
    php7-gmp \
    php7-iconv \
    php7-json \
    php7-mbstring \
    php7-memcached \
    php7-opcache \
    php7-openssl \
    php7-pcntl \
    php7-pdo_pgsql \
    php7-phar \
    php7-session \
    php7-simplexml \
    php7-sodium \
    php7-tokenizer \
    php7-zip \
    php7-xml \
    php7-xmlwriter \
    php7-xsl \
    libsodium \
    curl \
    && rm -rf /var/cache/apk/*

FROM cli as web

RUN apk --no-cache add \
    apache2 \
    php7-apache2 \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /var/log/apache2 \
    && ln -s /dev/stderr /var/log/apache2/error.log \
    && ln -s /dev/stdout /var/log/apache2/access.log
COPY common/apache/* /etc/apache2/conf.d/
COPY common/php/* /etc/php7/conf.d/
COPY common/siu-entrypoint.d/* /siu-entrypoint.d/
COPY common/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

CMD ["httpd", "-D", "FOREGROUND"]

EXPOSE 80

FROM web as rootless

ARG USER=siu
ARG UID=222

RUN adduser -h /usr/local/app -u $UID -G www-data -S $USER \
    && chown -R siu.www-data \
        /var/run/apache2 \
        /var/log/apache2 \
        /etc/php7/conf.d \
        /etc/apache2/conf.d \
        /var/www/localhost/htdocs
USER $USER
