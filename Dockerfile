ARG PHP_VERSION=84

FROM laravelsail/php${PHP_VERSION}-composer:latest

ARG USER_ID=1000
ARG USER_GROUP=1000

RUN groupadd -g ${USER_GROUP} docker && \
    useradd -m -u ${USER_ID} -g ${USER_GROUP} -s /bin/bash docker

USER docker

ENV HOME="/home/docker"
ENV COMPOSER_HOME="/home/docker/.composer"

RUN composer global require laravel/installer \
    && composer global require cpx/cpx

WORKDIR /var/www/html