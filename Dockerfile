############################
#
# build for laravel web app
#
############################
FROM litsoftware/php:8-fpm AS fpm

WORKDIR /var/www

COPY . .

RUN composer -V \
    && composer install --no-dev --no-progress -o


############################
#
# build for laravel cli
#
############################
FROM litsoftware/php:8-cli AS cli

WORKDIR /var/www

COPY --from=fpm /var/www/.  /var/www
COPY ./docker/start.sh /usr/local/bin/start
RUN chomd +x /usr/local/bin/start

CMD ["/usr/local/bin/start"]


############################
#
# build for nginx
#
############################
FROM nginx:latest AS web

WORKDIR /var/www

COPY --from=fpm /var/www/.  /var/www
