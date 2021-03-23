FROM alpine:3.12
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
    apache2 \
    php7-apache2 \
    curl \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /run/apache2 \
    && echo "date.timezone=America/Argentina/Buenos_Aires" >> /etc/php7/php.ini \
    && echo "log_errors=On" >> /etc/php7/php.ini \
    && echo "ErrorLog /dev/stderr" >> /etc/apache2/httpd.conf \
    && echo "TransferLog /dev/stdout" >> /etc/apache2/httpd.conf \
    && echo "LoadModule rewrite_module modules/mod_rewrite.so" >> /etc/apache2/httpd.conf \
    && echo "ServerTokens Prod" >> /etc/apache2/httpd.conf \
    && echo "ServerSignature Off" >> /etc/apache2/httpd.conf \
    && echo "TraceEnable off" >> /etc/apache2/httpd.conf \
    && cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set environments variables in config file
RUN sed -i "s|;*memory_limit =.*|memory_limit = \$\{PHP_MEMORY_LIMIT\}|i" /etc/php7/php.ini
RUN sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = \$\{MAX_UPLOAD\}|i" /etc/php7/php.ini
RUN sed -i "s|;*max_file_uploads =.*|max_file_uploads = \$\{PHP_MAX_FILE_UPLOAD\}|i" /etc/php7/php.ini
RUN sed -i "s|;*max_input_vars =.*|max_input_vars = \$\{PHP_MAX_INPUT_VARS\}|i" /etc/php7/php.ini
RUN sed -i "s|;*post_max_size =.*|post_max_size = \$\{PHP_MAX_POST\}|i" /etc/php7/php.ini
RUN sed -i "s|;*display_errors =.*|display_errors = \$\{PHP_DISPLAY_ERRORS\}|i" /etc/php7/php.ini
RUN sed -i "s|;*log_errors =.*|log_errors = \$\{PHP_LOGS_ERRORS\}|i" /etc/php7/php.ini

# Set Environments values
ENV PHP_MEMORY_LIMIT    256M
ENV MAX_UPLOAD          16M
ENV PHP_MAX_FILE_UPLOAD 200
ENV PHP_MAX_POST        32M
ENV PHP_MAX_INPUT_VARS  1500
ENV PHP_DISPLAY_ERRORS Off
ENV PHP_LOGS_ERRORS  On


EXPOSE 80
