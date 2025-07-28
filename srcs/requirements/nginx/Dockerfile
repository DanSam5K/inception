FROM alpine:3.21.0

LABEL maintainer="dsamuel@student.42wolfsburg.de"
LABEL description="NGINX container for secure HTTPS reverse proxy"

# Install NGINX & OpenSSL, create directories, and add user
RUN apk --no-cache upgrade && \
    apk --no-cache add nginx openssl && \
    mkdir -p /var/www/html /etc/ssl/private /etc/ssl/certs /var/lib/nginx /run/nginx && \
    adduser -D -g 'www' www && \
    chown -R www:www /var/www/html /var/lib/nginx /run/nginx

# Copy custom configuration files
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

# Generate self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42Network/OU=42Paris/CN=dsamuel.42.fr"

# Expose HTTPS port
EXPOSE 443

# Run NGINX in foreground
CMD ["nginx", "-g", "daemon off;"]

