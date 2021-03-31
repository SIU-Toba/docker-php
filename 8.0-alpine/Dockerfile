FROM alpine:3.13

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

## Falta agregar  php8-memcached que no esta en el repo aun

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
    libsodium \
    apache2 \
    php8-apache2 \
    curl \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /run/apache2 \
    && echo "ErrorLog /dev/stderr" >> /etc/apache2/httpd.conf \
    && echo "TransferLog /dev/stdout" >> /etc/apache2/httpd.conf \
    && echo "LoadModule rewrite_module modules/mod_rewrite.so" >> /etc/apache2/httpd.conf \
    && echo "ServerTokens Prod" >> /etc/apache2/httpd.conf \
    && echo "ServerSignature Off" >> /etc/apache2/httpd.conf \
    && echo "TraceEnable off" >> /etc/apache2/httpd.conf \
    && cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set environments variables in config file
COPY setup_php_ini.sh /
RUN /setup_php_ini.sh /etc/php8/php.ini
    
EXPOSE 80
