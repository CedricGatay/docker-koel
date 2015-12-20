FROM php:7-apache

RUN apt-get update \
    && apt-get -y -q install git curl build-essential\
    && docker-php-ext-install pdo_mysql mbstring\
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && curl -sL https://deb.nodesource.com/setup_4.x | bash - \
    && apt-get install -y -q nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN groupadd -r koel -g 1000 \
    && useradd -u 1000 -r -g koel -d /app -s /sbin/nologin -c "Docker image user" koel\ 
    && mkdir -p /app \
    && chown -R koel:koel /app

USER koel

WORKDIR /app


RUN git clone https://github.com/phanan/koel \
    && cd koel \
    && composer install

WORKDIR /app/koel

RUN npm install

VOLUME /music

COPY env .env
COPY run.sh run.sh

USER root

ADD 000-koel.conf /etc/apache2/sites-enabled/000-koel.conf

RUN chown -R koel:koel /app \
    && sed -i 's/Listen 80/Listen 8000/' /etc/apache2/apache2.conf \
    && usermod -aG koel www-data \
    && a2enconf charset \
    && a2enmod rewrite


CMD ["/app/koel/run.sh"]