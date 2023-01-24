# github.com/tiredofit/s3ql

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-s3ql?style=flat-square)](https://github.com/tiredofit/docker-s3ql/releases/latest)
[![Build Status](https://img.shields.io/github/workflow/status/tiredofit/docker-s3ql/build?style=flat-square)](https://github.com/tiredofit/docker-s3ql/actions?query=workflow%3Abuild)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/s3ql.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/s3ql/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/s3ql.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/s3ql/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

## About

This will build a Docker Image for [S3QL](http://www.rath.org/s3ql-docs/)), A deduplicating, compressing virtual filesystem that works on S3 compatible buckets.

## Maintainer

- [Dave Conroy](https://github.com/tiredofit/)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Prerequisites and Assumptions](#prerequisites-and-assumptions)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
    - [Multi Architecture](#multi-architecture)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [Container Options](#container-options)
    - [S3QL Options](#s3ql-options)
- [Maintenance](#maintenance)
  - [File System Maintenance](#file-system-maintenance)
  - [Transport endpoint not connected](#transport-endpoint-not-connected)
  - [Shell Access](#shell-access)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)
- [References](#references)

## Prerequisites and Assumptions
*  Allow container to have `SYS_ADMIN` capabilities

## Installation
### Build from Source
Clone this repository and build the image with `docker build -t (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/s3ql) and is the recommended method of installation.

```bash
docker pull tiredofit/s3ql:(imagetag)
```
The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Container OS | Tag       |
| ------------ | --------- |
| Alpine       | `:latest` |

#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
* Set `SYS_ADMIN` capabilities

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory  | Description                             |
| ---------- | --------------------------------------- |
| `/cache/`  | (Optional) Cache Files                  |
| `/data/`   | Mount directory for S3QL Filesysten     |
| `/config/` | (Optional) Configuration file directory |
| `/logs/`   | Log files                               |

* * *
### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`,`nano`,`vim`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/) | Customized Image based on Alpine Linux |


#### Container Options

| Variable     | Description          | Default   |
| ------------ | -------------------- | --------- |
| `CACHE_PATH` | Cache Directory Path | `/cache/` |
| `CONFIG_FILE`             | Configuration File with credentials                                                      | `s3ql.conf` |
| `CONFIG_PATH`             | Configuration Path                                                                       | `/config/`  |
| `DATA_PATH`               | Path to mount S3QL File System                                                           | `/data/`    |
| `LOG_PATH`                | Path for Log Files                                                                       | `/logs/`    |
| `LOG_TYPE`                | `CONSOLE` or `FILE`                                                                      | `FILE`      |
| `SETUP_MODE`              | Automatically create configuration files on container startup from environment variables | `AUTO`      |

#### S3QL Options

| Variable                  | Description                                                               | Default  |
| ------------------------- | ------------------------------------------------------------------------- | -------- |
| `COMPRESSION`             | Compresion type `none` `bzip` `lzma` `zlib` and compression level `0-9`   | `lzma-6` |
| `ENABLE_CACHE`            | Enable Cache on File system                                               | `TRUE`   |
| `ENABLE_PERSISTENT_CACHE` | Enable Cache even after filesystem is not mounted                         | `TRUE`   |
| `FSCK_ARGS`               | Arguments to pass to fsck process on container start                      | ``       |
| `MKFS_ARGS`               | Arguments to pass to mkfs process when making filesystem                  | ``       |
| `S3_KEY_ID`               | S3 Key ID                                                                 | ``       |
| `S3_KEY_SECRET`           | S3 Key Secret                                                             | ``       |
| `S3_URI`                  | URI of S3 Bucket eg `s3c://s3.ca-central-1.wasabisys.com:443/bucket_name` | ``       |
| `S3QL_ARGS`               | Arguments to pass to mount.s3ql process                                   | ``       |
| `S3QL_PASS`               | (Optional) Encrypted password for S3QL Filesystem                         |          |

## Maintenance
### File System Maintenance
- If you would like to perform file system maintenance, first make sure the file system is dismounted by executing `service_down 10-s3ql` and then execute `fsck-now` . Make sure to mount the filesystem again by executing `service_up 10-s3ql`

### Transport endpoint not connected
- If at some time you experience the issue of not being able to unmount your filesystem, try entering into the container and executing `force-dismount` which should allow the filesystem to be dismounted.

### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is) bash
```
## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) personalized support.
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.

## References

* [<http://www.rath.org/s3ql-docs>](http://www.rath.org/s3ql-docs/)
