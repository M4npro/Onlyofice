FROM nextcloud:apache

# Instala utilidades básicas (opcional pero recomendable)
RUN apt-get update && apt-get install -y \
    ffmpeg \
    smbclient \
    && rm -rf /var/lib/apt/lists/*

# Ajustes de PHP recomendados
RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory-limit.ini \
    && echo "upload_max_filesize=10G" > /usr/local/etc/php/conf.d/uploads.ini \
    && echo "post_max_size=10G" >> /usr/local/etc/php/conf.d/uploads.ini

# Puerto que Render espera
EXPOSE 10000

ENV APACHE_PORT 10000
