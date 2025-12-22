# nfrastack/container-wordpress

## About

This repository will build a container image for running [Wordpress](https://wordpress.org/). A Content Management System.

## Maintainer

* [Nfrastack](https://www.nfrastack.com)

## Table of Contents

* [About](#about)
* [Maintainer](#maintainer)
* [Table of Contents](#table-of-contents)
* [Prerequisites and Assumptions](#prerequisites-and-assumptions)
* [Installation](#installation)
  * [Build from Source](#build-from-source)
  * [Prebuilt Images](#prebuilt-images)
    * [Multi-Architecture Support](#multi-architecture-support)
* [Configuration](#configuration)
  * [Quick Start](#quick-start)
  * [Persistent Storage](#persistent-storage)
  * [Environment Variables](#environment-variables)
    * [Base Images used](#base-images-used)
    * [Core Configuration](#core-configuration)
  * [Users and Groups](#users-and-groups)
  * [Networking](#networking)
* [Maintenance](#maintenance)
  * [Shell Access](#shell-access)
  * [Local Development / Changing Site Name & Ports](#local-development--changing-site-name--ports)
  * [Command Line](#command-line)
* [Support & Maintenance](#support--maintenance)
* [License](#license)
* [References](#references)

## Installation

### Prebuilt Images

Feature limited builds of the image are available on the [Github Container Registry](https://github.com/nfrastack/container-wordpress/pkgs/container/container-wordpress) and [Docker Hub](https://hub.docker.com/r/nfrastack/nginx-php-fpm).

To unlock advanced features, one must provide a code to be able to change specific environment variables from defaults. Support the development to gain access to a code.

To get access to the image use your container orchestrator to pull from the following locations:

```
ghcr.io/nfrastack/container-wordpress:(image_tag)
docker.io/nfrastack/wordpress:(image_tag)
```

Image tag syntax is:

`<image>:<optional tag>-<optional phpversion>-<optional distro>-<optional distro_variant>`

Example:

`docker.io/nfrastack/container-wordpress:latest` or

`ghcr.io/nfrastack/container-wordpress:1.0-php84-alpine`

* `latest` will be the most recent commit

* An optional `tag` may exist that matches the [CHANGELOG](CHANGELOG.md) - These are the safest

| PHP version | OS     | Tag       |
| ----------- | ------ | --------- |
| 8.4.x       | Alpine | `:php8.4` |

Have a look at the container registries and see what tags are available.

#### Multi-Architecture Support

Images are built for `amd64` by default, with optional support for `arm64` and other architectures.

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for your use.

* Map [persistent storage](#persistent-storage) for access to configuration and data files for backup.
* Set various [environment variables](#environment-variables) to understand the capabilities of this image.

### Persistent Storage

The following directories/files should be mapped for persistent storage in order to utilize the container effectively.

| Directory        | Description                |
| ---------------- | -------------------------- |
| `/www/wordpress` | Root Wordpress Directory   |
| `/logs`          | Nginx and php-fpm logfiles |

### Environment Variables

#### Base Images used

This image relies on a customized base image in order to work.
Be sure to view the following repositories to understand all the customizable options:

| Image                                                                 | Description         |
| --------------------------------------------------------------------- | ------------------- |
| [OS Base](https://github.com/nfrastack/container-base/)               | Base Image          |
| [Nginx](https://github.com/nfrastack/container-nginx/)                | Nginx Webserver     |
| [Nginx PHP-FPM](https://github.com/nfrastack/container-nginx-php-fpm) | PHP-FPM Interpreter |

Below is the complete list of available options that can be used to customize your installation.

* Variables showing an 'x' under the `Advanced` column can only be set if the containers advanced functionality is enabled.

#### Core Configuration

| Parameter                    | Description                                                                                                       | Default            | `_FILE` |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------- | ------------------ | ------- |
| `ADMIN_EMAIL`                | Email address for the Administrator - Needed for initial startup                                                  |                    | x       |
| `ADMIN_USER`                 | Username for the Administrator - Needed for initial startup                                                       | `admin`            | x       |
| `ADMIN_PASS`                 | Password for the Administrator - Needed for initial startup                                                       |                    | x       |
| `ENABLE_HTTPS_REVERSE_PROXY` | Tweak nginx to run behind a reverse proxy for URLs `TRUE` / `FALSE`                                               | `TRUE`             |         |
| `DB_CHARSET`                 | MariaDB character set for tables                                                                                  | `utf8mb4`          |         |
| `DB_HOST`                    | MariaDB external container hostname (e.g. wordpress-db)                                                           |                    | x       |
| `DB_NAME`                    | MariaDB database name i.e. (e.g. wordpress)                                                                       |                    | x       |
| `DB_USER`                    | MariaDB username for database (e.g. wordpress)                                                                    |                    | x       |
| `DB_PASS`                    | MariaDB password for database (e.g. userpassword)                                                                 |                    | x       |
| `DB_PORT`                    | MariaDB port for database                                                                                         | `3306`             | x       |
| `DB_PREFIX`                  | MariaDB Prefix for `DB_NAME`                                                                                      | `wp_`              | x       |
| `DEBUG_MODE`                 | Enable Debug Mode (verbosity) for the container installation/startup and in application - `TRUE` / `FALSE`        | `FALSE`            |         |
| `ROTATE_KEYS`                | Rotate Salts and Keys on subsequent reboots `TRUE` / `FALSE`                                                      | `FALSE`            |         |
| `SITE_LOCALE`                | What Locale to set site                                                                                           | `en_US`            |         |
| `SITE_PORT`                  | What Port does wordpress deliver assets to                                                                        | `80`               |         |
| `SITE_TITLE`                 | The title of the Website                                                                                          | `Docker Wordpress` |         |
| `SITE_URL`                   | The Full site URL of the installation e.g. `wordpress.example.com` - Needed for initial startup                   |                    |         |
| `SITE_URL_UPDATE_MODE`       | After first install, perform modifications to wp-config.php and DB if different Site URL `FILE` `DB` `ALL` `NONE` | `ALL`              |         |
| `UPDATE_MODE`                | `ALL` to enable all major, minor updates, `MINOR` to only allow minor updates `NONE` to disable all updates       | `minor`            |         |

* * *

## Maintenance

### Shell Access

For debugging and maintenance, `bash` and `sh` are available in the container.

### Local Development / Changing Site Name & Ports

Wordpress assets are delivered by means of the initial Site URL, and if you wish to develop locally or on a different port you will experience strange results. If you are performing local development then you would want to setup your environment variables as such:

* `ENABLE_HTTPS_REVERSE_PROXY=FALSE`
* `SITE_URL=localhost`
* `SITE_PORT=8000` (or whatever port you are exposing)

When you are ready to deploy to a production URL - you would change it as such:

* `ENABLE_HTTPS_REVERSE_PROXY=TRUE`
* `SITE_URL=www.domain.com`

The system will rotate the URLs in the wordpress configuration files and database automatically upon restart of the container.

### Command Line

If you wish to use the included wp-cli tool to perform maintenance use it as such:

````bash
cd /www/wordpress
wp-cli <argument>
````

## Support & Maintenance

* For community help, tips, and community discussions, visit the [Discussions board](/discussions).
* For personalized support or a support agreement, see [Nfrastack Support](https://nfrastack.com/).
* To report bugs, submit a [Bug Report](issues/new). Usage questions will be closed as not-a-bug.
* Feature requests are welcome, but not guaranteed. For prioritized development, consider a support agreement.
* Updates are best-effort, with priority given to active production use and support agreements.

## References

* <https://wordpress.net/>
* <https://github.com/wordpress-helpdesk/wordpress/wiki/Installation-Guide>

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
