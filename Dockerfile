FROM uqlibrary/alpine:3.20.6

ENV COMPOSER_VERSION=2.8.8

COPY ./fs/docker-entrypoint.sh /usr/sbin/docker-entrypoint.sh

RUN apk upgrade --update --no-cache && \
    apk add --update --no-cache \
    ca-certificates \
    curl \
    bash \
    git sqlite mysql-client libmemcached musl

RUN apk add --update --no-cache \
        php82-session php82-soap php82-openssl php82-gmp php82-pdo_odbc php82-json php82-dom php82-pdo php82-zip \
        php82-mysqli php82-sqlite3 php82-pdo_pgsql php82-bcmath php82-gd php82-odbc php82-pdo_mysql php82-pdo_sqlite \
        php82-gettext php82-xmlreader php82-xmlwriter php82-xml php82-simplexml php82-bz2 php82-iconv php82-xsl php82-sodium \
        php82-pdo_dblib php82-curl php82-ctype php82-pcntl php82-posix php82-phar php82-opcache php82-mbstring php82-zlib \
        php82-fileinfo php82-tokenizer php82-sockets php82-phar php82-intl php82-ldap php82-phpdbg php82-fpm php82 \
    #
    # Install PHP8.2 extensions XDebug, igbinary and memcached using packaged PECL builds
    && apk add --update --no-cache php82-pecl-xdebug php82-pecl-igbinary php82-pecl-memcached \
    #
    # Add Postgresql Client
    && apk add --update --no-cache postgresql-client \
    #
    # Add MySQL/MariaDB Client Lib
    && apk add --update --no-cache mariadb-connector-c \
    #
    # Add media handling tools
    && apk add --update --no-cache exiftool mediainfo \
    #
    # Add generic symlinks for php8 binaries
    && ln -s phar82 /usr/bin/phar \
    && ln -s php82 /usr/bin/php \
    && ln -s phpdbg82 /usr/bin/phpdbg \
    && ln -s php-fpm82 /usr/sbin/php-fpm \
    && ln -s php82 /etc/php \
    #
    # Composer 2.x
    && curl -sS https://getcomposer.org/installer | php82 -- --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
    #
    # Remove build deps
    && rm -rf /var/cache/apk/* \
    #
    # Make scripts executable
    && chmod +x /usr/sbin/docker-entrypoint.sh

ADD fs /

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 9000

WORKDIR /app
