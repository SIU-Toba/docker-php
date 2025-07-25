FROM alpine:3.15 AS cli

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
    && echo "date.timezone  = $TZ" > /etc/php7/conf.d/80-siu-timezone.ini \
    && rm -rf /var/cache/apk/*

COPY common/siu-entrypoint.d/* /siu-entrypoint.d/
COPY common/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

FROM cli AS web

RUN apk --no-cache add \
    apache2 \
    php7-apache2 \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /var/log/apache2 \
    && ln -s /dev/stderr /var/log/apache2/error.log \
    && ln -s /dev/stdout /var/log/apache2/access.log \
    #fix warning https://stackoverflow.com/a/56645177"
    && sed -i 's/^Listen 80$/Listen 0.0.0.0:8080/' /etc/apache2/httpd.conf
COPY common/apache/* /etc/apache2/conf.d/
COPY common/php/* /etc/php7/conf.d/

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
        /etc/php7/conf.d \
        /etc/apache2/conf.d \
        /var/www/localhost/htdocs \
        /siu-entrypoint.d \
    && chmod -R g=u \
        /etc/passwd \
        /var/run/apache2 \
        /var/log/apache2 \
        /etc/php7/conf.d \
        /etc/apache2/conf.d \
        /var/www/localhost/htdocs \
        /siu-entrypoint.d
USER $USER
