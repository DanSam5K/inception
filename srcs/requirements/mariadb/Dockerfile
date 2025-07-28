FROM alpine:3.21.0

LABEL maintainer="dsamuel@student.42wolfsburg.de"
LABEL description="MariaDB service container for Inception project"

# Install MariaDB and its client without caching package index
RUN apk --no-cache upgrade && \
    apk --no-cache add mariadb mariadb-client

# Copy custom initialization script
COPY ./tools/mariadb-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 3306

# Define entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]
