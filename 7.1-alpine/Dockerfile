FROM alpine:3.7 AS sodium
RUN apk add \
    php7 \
    php7-pear \
    php7-dev \
    gcc \
    musl-dev \
    make \
    libsodium \
    libsodium-dev \
    && pecl install -f libsodium-1.0.6

FROM alpine:3.7

# Set Environments values for PHP
ENV PHP_MEMORY_LIMIT    256M
ENV PHP_MAX_UPLOAD_SIZE 16M
ENV PHP_MAX_FILE_UPLOAD 200
ENV PHP_MAX_POST        32M
ENV PHP_MAX_INPUT_VARS  1500
ENV PHP_DISPLAY_ERRORS Off
ENV PHP_LOGS_ERRORS  On

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
    php7-mcrypt \
    php7-memcached \
    php7-opcache \
    php7-openssl \
    php7-pcntl \
    php7-pdo_pgsql \
    php7-phar \
    php7-session \
    php7-simplexml \
    php7-tokenizer \
    php7-zip \
    php7-xml \
    php7-xmlwriter \
    php7-xsl \
    libsodium \
    apache2 \
    php7-apache2 \
    curl \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /run/apache2 \
    && echo "extension=libsodium.so" >> /etc/php7/php.ini \    
    && echo "ErrorLog /dev/stderr" >> /etc/apache2/httpd.conf \
    && echo "TransferLog /dev/stdout" >> /etc/apache2/httpd.conf \
    && echo "LoadModule rewrite_module modules/mod_rewrite.so" >> /etc/apache2/httpd.conf \
    && echo "ServerTokens Prod" >> /etc/apache2/httpd.conf \
    && echo "ServerSignature Off" >> /etc/apache2/httpd.conf \
    && echo "TraceEnable off" >> /etc/apache2/httpd.conf \
    && cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY --from=sodium /usr/lib/php7/modules/libsodium.so /usr/lib/php7/modules/

# Set environments variables in config file
COPY setup_php_ini.sh /
RUN /setup_php_ini.sh /etc/php7/php.ini

EXPOSE 80

