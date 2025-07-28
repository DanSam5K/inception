#!/bin/sh

echo "[DB Setup] Initializing MariaDB configuration..."

# Ensure the runtime directory for MariaDB exists and has correct ownership
if [ ! -d "/run/mysqld" ]; then
  echo "[DB Setup] Creating and setting permissions for /run/mysqld..."
  mkdir -p /run/mysqld
  chown -R mysql:mysql /run/mysqld
fi

# Check if MariaDB data directory is already initialized
if [ -d "/var/lib/mysql/mysql" ]; then
  echo "[DB Setup] MariaDB data directory already exists. Skipping initialization."
else
  echo "[DB Setup] Setting up MariaDB data directory..."
  chown -R mysql:mysql /var/lib/mysql

  mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null

  echo "[DB Setup] Data directory setup complete."

  echo "[DB Setup] Preparing database initialization SQL statements..."

  TMPFILE=/tmp/mariadb_init.sql

  cat <<EOF > ${TMPFILE}
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';
CREATE DATABASE ${WP_DB_NAME};
CREATE USER '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASS}';
GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

  echo "[DB Setup] Executing initial SQL commands..."

  # Bootstrap MariaDB with initial SQL
  /usr/bin/mysqld --user=mysql --bootstrap < ${TMPFILE}

  rm -f ${TMPFILE}

  echo "[DB Setup] Database initialization finished."
fi

echo "[DB Setup] Configuring MariaDB for remote access..."

# Enable network access by adjusting MariaDB config file
sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

echo "[DB Setup] Launching MariaDB daemon on default port 3306..."

exec /usr/bin/mysqld --user=mysql --console

