# SPDX-FileCopyrightText: © 2026 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

ARG \
    BASE_IMAGE

FROM docker.io/xyksolutions1/container-nginx-php-fpm:latest

LABEL \
        org.opencontainers.image.title="Wordpress" \
        org.opencontainers.image.description="Containerized Content management system and blogging platform" \
        org.opencontainers.image.url="https://hub.docker.com/r/xyksolutions1/wordpress" \
        org.opencontainers.image.documentation="https://github.com/xyksolutions1/container-wordpress/blob/main/README.md" \
        org.opencontainers.image.source="https://github.com/xyksolutions1/container-wordpress.git" \
        org.opencontainers.image.authors="xyksolutions1" \
        org.opencontainers.image.vendor="xyksolutions1" \
        org.opencontainers.image.licenses="MIT"

ENV \
    IMAGE_NAME="xyksolutions1/wordpress" \
    IMAGE_REPO_URL="https://github.com/xyksolutions1/container-wordpress/"

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

RUN echo "" && \
    BUILD_ENV=" \
                10-nginx/NGINX_WEBROOT=/www/wordpress \
                10-nginx/NGINX_SITE_ENABLED=wordpress \
                10-nginx/NGINX_INDEX_FILE=index.php \
                10-nginx/NGINX_CREATE_SAMPLE_HTML=FALSE \
                20-php-fpm/PHP_ENABLE_CREATE_SAMPLE_PHP=FALSE \
                20-php-fpm/PHP_MODULE_ENABLE_EXIF=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_GD=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_IGBINARY=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_IMAGICK=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_MYSQLI=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_REDIS=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_SHMOP=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_SIMPLEXML=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_XML=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_XMLREADER=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_ZIP=TRUE \
              " && \
    \
    WORDPRESS_RUN_DEPS_ALPIME=" \
                                xmlstarlet \
                              " \
                              && \
    \
    source /container/base/functions/container/build && \
    container_build_log && \
    package update && \
    package upgrade && \
    package install \
                        WORDPRESS_RUN_DEPS \
                    && \
    php-ext prepare && \
    php-ext reset && \
    php-ext enable core && \
    curl -o /usr/local/bin/wp-cli https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp-cli && \
    package cleanup

COPY rootfs /
