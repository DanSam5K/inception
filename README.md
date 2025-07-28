nception

Welcome to **Inception**, a Docker-based system architecture project for the 42 curriculum. This project aims to set up a secure, scalable WordPress website using NGINX, MariaDB, and Docker, following good DevOps practices.

## 📦 Project Overview

**Inception** is about building a system composed of several Docker containers that work together to serve a basic web service. The main components are:

- 🔐 **NGINX**: acts as a secure reverse proxy with SSL support
- 📝 **WordPress**: the CMS platform for the website
- 🗃️ **MariaDB**: provides the backend database service for WordPress
- 🐳 **Docker Compose**: manages multi-container orchestration

All services are containerized and isolated, following best practices for service decoupling.

---

## 🧬 Project Structure

.
├── srcs/
│ ├── requirements/
│ │ ├── mariadb/
│ │ │ ├── Dockerfile
│ │ │ ├── tools/mariadb-entrypoint.sh
│ │ ├── nginx/
│ │ │ ├── Dockerfile
│ │ │ ├── conf/nginx.conf
│ │ │ ├── conf/default.conf
│ │ ├── wordpress/
│ │ │ ├── Dockerfile
│ │ │ ├── tools/wp-setup.sh
│ ├── .env
│ └── docker-compose.yml


---

## 🔧 Services & Ports

| Service    | Port | Description                         |
|------------|------|-------------------------------------|
| NGINX      | 443  | HTTPS reverse proxy (SSL enabled)   |
| WordPress  | 9000 | Served behind NGINX                 |
| MariaDB    | 3306 | WordPress database backend          |

---

## ⚙️ Environment Variables

All secrets and configurations are managed through a `.env` file:

```ini
# MariaDB
DB_HOST= *****
DB_ROOT_PASS=****
WP_DB_NAME= ****
WP_DB_USER= ****
WP_DB_PASS= ****

# WordPress Admin
WP_TITLE=Inception
WP_ADMIN_USER= ****
WP_ADMIN_PASS= ***
WP_ADMIN_EMAIL= ****

# WordPress Visitor
WP_USER= *****
WP_USER_PASS= ****
WP_USER_EMAIL= ******
WP_USER_DISPLAY= *****

# Domain
LOGIN= login
DOMAIN= login.42.fr

🚀 How to Run
Clone the repository

```
git clone https://github.com/<your-repo>/inception.git
cd inception/srcs
Create .env
cp .env.example .env

# Then update it with your values
Build and run containers

make
Access the site

Visit:
🔗 https://login.42.fr (replace with your domain or localhost if testing)

📌 Features Implemented
✅ Multi-container Docker setup using Docker Compose

✅ WordPress auto-install with CLI configuration

✅ MariaDB with secured credentials and persistent data

✅ NGINX reverse proxy with HTTPS (self-signed certs)

✅ SSL configuration via OpenSSL

✅ Organized volume and network setup

✅ Environment-based configuration management

📁 Volumes & Data Persistence
The following Docker volumes are used:

srcs_mariadb-data → /var/lib/mysql

srcs_wordpress-data → /var/www/html

These ensure that WordPress and database data persist across container restarts.

🧪 Testing
Use docker exec -it <container> sh to manually check services

Confirm access via https://<your-domain>

Validate SSL certificate (self-signed)

Try logging into /wp-admin using admin credentials

🔒 Security Considerations
Avoid committing real .env files to public repos

Replace self-signed certs with Let's Encrypt for production

Secure database users and passwords properly

Firewall/NGINX config can be extended for rate limiting, headers, etc.

📚 References
Docker Compose Docs

MariaDB Official

NGINX SSL Configuration

WordPress CLI

🧠 Author
dsamuel – [42Wolfsburg Student]
Maintainer: dsamuel@student.42wolfsburg.de

🏁 License
This project is part of the 42 School curriculum and is meant for educational purposes only.

