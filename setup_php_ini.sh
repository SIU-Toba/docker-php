#!/bin/sh 

# Set environments variables in config file
sed -i \
 -e "s|;*memory_limit =.*|memory_limit = \$\{PHP_MEMORY_LIMIT\}|i" \
 -e "s|;*upload_max_filesize =.*|upload_max_filesize = \$\{MAX_UPLOAD\}|i" \
 -e "s|;*max_file_uploads =.*|max_file_uploads = \$\{PHP_MAX_FILE_UPLOAD\}|i" \
 -e "s|;*max_input_vars =.*|max_input_vars = \$\{PHP_MAX_INPUT_VARS\}|i" \
 -e "s|;*post_max_size =.*|post_max_size = \$\{PHP_MAX_POST\}|i" \
 -e "s|;*display_errors =.*|display_errors = \$\{PHP_DISPLAY_ERRORS\}|i" \
 -e "s|;*log_errors =.*|log_errors = \$\{PHP_LOGS_ERRORS\}|i" \
 -e "s|;*date.timezone  =.*|date.timezone = \$\{TZ\}|i" \
 -e "s|expose_php =.*|expose_php = Off|i" \
    /etc/php7/php.ini
