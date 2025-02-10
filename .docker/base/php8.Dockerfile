FROM php:8.4-rc-fpm-alpine3.20
ARG USER_ID
ARG GROUP_ID
ARG DOCKER_USER

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.20/main" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/v3.20/community" >> /etc/apk/repositories

RUN apk update \
    && apk upgrade \
    && apk add --no-cache \
    wget \
    zip \
    unzip \
    autoconf \
    g++ \
    make \
    libaio \
    libnsl \
    libc6-compat \
    mariadb-connector-c \
    dumb-init \
    && chmod +x $(readlink -f /usr/bin/dumb-init)

RUN addgroup -S ${GROUP_ID} \
    && adduser -u ${USER_ID} -G ${GROUP_ID} -h /home/${DOCKER_USER} -D ${DOCKER_USER} \
    && mkdir /var/www || exit 0 \
    && chown -R ${USER_ID}:${GROUP_ID} /var/www \
    && chmod 755 /var/www

ENV IPE_INSTANTCLIENT_BASIC=1
ENV TNS_ADMIN=/usr/lib/oracle/21.1/client64/lib/

RUN install-php-extensions \
    intl \
    zip \
    mysqli \
    exif \
    bcmath \
    pdo_mysql \
    pcntl \
    opcache \
    redis \
    amqp \
    http \
    apcu \
    ldap \
    sqlsrv \
    pdo_oci \
    oci8
