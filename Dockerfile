FROM debian:8.1

RUN apt-get update \
    && apt-get -y -q install php5-cli php5-mysql git curl build-essential\
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && curl -sL https://deb.nodesource.com/setup_4.x | bash - \
    && apt-get install -y -q nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8000

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
# \
#    && node_modules/bower/bin/bower install --allow-root \
#    && node node_modules/gulp/bin/gulp.js --production

VOLUME /music

ADD env .env
ADD run.sh run.sh

CMD ["/app/koel/run.sh"]