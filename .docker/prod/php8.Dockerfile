ARG BASE_IMAGE_TAG=latest
FROM opillion/php8:${BASE_IMAGE_TAG}

ARG USER_ID
ARG GROUP_ID
ARG DOCKER_USER

RUN echo "$DOCKER_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN apk update \
    && apk upgrade \
    && apk add --no-cache \
    libffi-dev \
    bash \
    bash-completion \
    htop \
    libmcrypt-dev \
    libltdl \
    mysql-client \
    git \
    inotify-tools

RUN install-php-extensions \
    sodium

ADD .docker/prod/php8/conf.d /usr/local/etc/php/conf.d
ADD .docker/prod/php8/entrypoint.sh /usr/sbin
RUN chmod 655 /usr/sbin/entrypoint.sh

COPY ./php /var/www
RUN chmod 655 /usr/sbin/entrypoint.sh \
    && chown -R ${USER_ID}:${GROUP_ID} /var/www \
    && chmod -R 755 /var/www

WORKDIR /var/www

USER ${USER_ID}:${GROUP_ID}

ENTRYPOINT ["dumb-init", "--"]
