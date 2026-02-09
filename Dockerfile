# Base Ubuntu
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias
RUN apt update && apt install -y \
    apache2 \
    php php-gd php-mysql php-curl php-mbstring php-intl php-gmp php-bcmath php-xml php-zip \
    mariadb-server \
    redis-server \
    curl wget gnupg2 ca-certificates lsb-release \
    supervisor

# Instalar Nextcloud
WORKDIR /var/www/
RUN wget https://download.nextcloud.com/server/releases/latest.zip \
    && apt install -y unzip \
    && unzip latest.zip \
    && chown -R www-data:www-data nextcloud

# Instalar OnlyOffice Document Server
RUN curl -fsSL https://download.onlyoffice.com/GPG-KEY-ONLYOFFICE | gpg --dearmor -o /usr/share/keyrings/onlyoffice.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main" > /etc/apt/sources.list.d/onlyoffice.list \
    && apt update \
    && apt install -y onlyoffice-documentserver

# Apache config
RUN echo "<VirtualHost *:80>\n\
DocumentRoot /var/www/nextcloud\n\
<Directory /var/www/nextcloud>\n\
AllowOverride All\n\
Require all granted\n\
</Directory>\n\
</VirtualHost>" > /etc/apache2/sites-available/000-default.conf

# Supervisor para correr todo
RUN echo "[supervisord]\n\
nodaemon=true\n\
\n\
[program:apache]\n\
command=/usr/sbin/apache2ctl -D FOREGROUND\n\
\n\
[program:mariadb]\n\
command=/usr/bin/mysqld_safe\n\
\n\
[program:redis]\n\
command=/usr/bin/redis-server\n\
\n\
[program:onlyoffice]\n\
command=/usr/bin/documentserver-start" > /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord"]
