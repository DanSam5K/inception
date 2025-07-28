#!/bin/sh
set -e

echo "[WP Setup] Starting WordPress setup..."

WP_PATH="/var/www/html"
DOMAIN="${DOMAIN:-localhost}"

# Check required environment variables
: "${WP_DB_NAME:?Missing WP_DB_NAME in env}"
: "${WP_DB_USER:?Missing WP_DB_USER in env}"
: "${WP_DB_PASS:?Missing WP_DB_PASS in env}"
: "${DB_HOST:?Missing DB_HOST in env}"
: "${WP_TITLE:?Missing WP_TITLE in env}"
: "${WP_ADMIN_USER:?Missing WP_ADMIN_USER in env}"
: "${WP_ADMIN_PASS:?Missing WP_ADMIN_PASS in env}"
: "${WP_ADMIN_EMAIL:?Missing WP_ADMIN_EMAIL in env}"
: "${WP_USER:?Missing WP_USER in env}"
: "${WP_USER_EMAIL:?Missing WP_USER_EMAIL in env}"
: "${WP_USER_PASS:?Missing WP_USER_PASS in env}"
: "${WP_USER_DISPLAY:?Missing WP_USER_DISPLAY in env}"

# Ensure WordPress core files are present
if [ ! -e "${WP_PATH}/wp-includes/version.php" ]; then
    echo "[WP Setup] WordPress core not found. Copying files..."
    cp -r /usr/src/wordpress/* "${WP_PATH}/"
    chown -R www:www "${WP_PATH}"
else
    echo "[WP Setup] WordPress files already exist, skipping copy."
fi

# Wait for MariaDB (rely on DB_HOST healthcheck + small delay just in case)
echo "[WP Setup] Waiting for MariaDB to respond..."
for i in $(seq 1 15); do
    if mysql -h"${DB_HOST}" -u"${WP_DB_USER}" -p"${WP_DB_PASS}" -e "SELECT 1;" >/dev/null 2>&1; then
        echo "[WP Setup] MariaDB is ready."
        break
    fi
    echo "[WP Setup] MariaDB not ready yet... ($i/15)"
    sleep 2
done

# If still not ready, exit with error
if ! mysql -h"${DB_HOST}" -u"${WP_DB_USER}" -p"${WP_DB_PASS}" -e "SELECT 1;" >/dev/null 2>&1; then
    echo "[WP Setup] ERROR: MariaDB is still not reachable."
    exit 1
fi

# Install WordPress if not configured
if [ ! -f "${WP_PATH}/wp-config.php" ]; then
    echo "[WP Setup] Creating wp-config.php..."
    wp config create \
        --path="${WP_PATH}" \
        --dbname="${WP_DB_NAME}" \
        --dbuser="${WP_DB_USER}" \
        --dbpass="${WP_DB_PASS}" \
        --dbhost="${DB_HOST}" \
        --skip-check \
        --allow-root

    echo "[WP Setup] Installing WordPress..."
    wp core install \
        --path="${WP_PATH}" \
        --url="https://${DOMAIN}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASS}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root

    echo "[WP Setup] Creating default user..."
    wp user create \
        "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASS}" \
        --role=subscriber \
        --display_name="${WP_USER_DISPLAY}" \
        --path="${WP_PATH}" \
        --allow-root

    echo "[WP Setup] Installing and activating theme 'bravada'..."
    wp theme install bravada --activate \
        --path="${WP_PATH}" \
        --allow-root
else
    echo "[WP Setup] WordPress already configured, skipping installation."
fi

echo "[WP Setup] Starting PHP-FPM 8.3..."
exec /usr/sbin/php-fpm83 -F -R

