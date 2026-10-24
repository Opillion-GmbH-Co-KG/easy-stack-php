FROM php:8.5.12-fpm-alpine3.24@sha256:f09d9172dd28b8696aef729ca2c2081a132c1f8d581218c99497d552c82a92df
RUN printf 'session.upload_progress.enabled=0\n' > /usr/local/etc/php/conf.d/zz-security.ini
ARG USER_ID
ARG GROUP_ID
ARG DOCKER_USER

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

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
