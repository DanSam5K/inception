FROM alpine:3.21.0

LABEL maintainer="dsamuel@student.42wolfsburg.de"
LABEL description="WordPress container with PHP-FPM 8.3 for Inception project"

# Install PHP 8.3, extensions, MariaDB client, curl, and unzip
RUN apk --no-cache upgrade && \
    apk --no-cache add \
    php83 php83-fpm php83-bcmath php83-bz2 php83-calendar php83-cli php83-ctype \
    php83-curl php83-dom php83-exif php83-fileinfo php83-gd php83-gmp \
    php83-iconv php83-imap php83-intl php83-json php83-mbstring \
    php83-mysqli php83-mysqlnd php83-openssl php83-pcntl php83-pdo php83-pdo_mysql \
    php83-session php83-simplexml php83-soap php83-sockets php83-sodium \
    php83-tokenizer php83-xml php83-xmlreader php83-xmlwriter php83-xsl \
    php83-zip php83-zlib php83-phar \
    mariadb-client curl unzip tar less bash

# Configure php-fpm to listen on external port
RUN sed -i 's|listen = 127.0.0.1:9000|listen = 9000|' /etc/php83/php-fpm.d/www.conf

# Create www user and group
RUN adduser -D -g 'www' www

# Increase PHP memory limit
RUN echo "memory_limit = 512M" > /etc/php83/conf.d/99-memory-limit.ini

# Install WP-CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp

# Pre-download WordPress core into /usr/src/wordpress
RUN mkdir -p /usr/src/wordpress && \
    wp core download --path=/usr/src/wordpress --allow-root

# Create working directory for runtime WordPress files
RUN mkdir -p /var/www/html && \
    chown -R www:www /var/www/html

# Copy custom entrypoint script
COPY ./tools/wordpress-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/docker-entrypoint.sh"]

