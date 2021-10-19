<p align="center">
    <a href="https://github.com/DockerToolbox/">
        <img src="https://cdn.wolfsoftware.com/assets/images/github/organisations/dockertoolbox/black-and-white-circle-256.png" alt="DockerToolbox logo" />
    </a>
    <br />
    <a href="https://github.com/DockerToolbox/tfenv/actions/workflows/pipeline.yml">
        <img src="https://img.shields.io/github/workflow/status/DockerToolbox/tfenv/pipeline/master?style=for-the-badge" alt="Github Build Status">
    </a>
    <a href="https://github.com/DockerToolbox/tfenv/releases/latest">
        <img src="https://img.shields.io/github/v/release/DockerToolbox/tfenv?color=blue&label=Latest%20Release&style=for-the-badge" alt="Release">
    </a>
    <a href="https://github.com/DockerToolbox/tfenv/releases/latest">
        <img src="https://img.shields.io/github/commits-since/DockerToolbox/tfenv/latest.svg?color=blue&style=for-the-badge" alt="Commits since release">
    </a>
    <br />
    <a href=".github/CODE_OF_CONDUCT.md">
        <img src="https://img.shields.io/badge/Code%20of%20Conduct-blue?style=for-the-badge" />
    </a>
    <a href=".github/CONTRIBUTING.md">
        <img src="https://img.shields.io/badge/Contributing-blue?style=for-the-badge" />
    </a>
    <a href=".github/SECURITY.md">
        <img src="https://img.shields.io/badge/Report%20Security%20Concern-blue?style=for-the-badge" />
    </a>
    <a href="https://github.com/DockerToolbox/tfenv/issues">
        <img src="https://img.shields.io/badge/Get%20Support-blue?style=for-the-badge" />
    </a>
    <br />
    <a href="https://wolfsoftware.com/">
        <img src="https://img.shields.io/badge/Created%20by%20Wolf%20Software-blue?style=for-the-badge" />
    </a>
</p>

## Overview

This is a selection of Docker containers preinstalled with [tfenv](https://github.com/tfutils/tfenv) so that you can use any version of [Terraform](https://www.terraform.io/) you want, or even install multiple versions.

We use our [anyenv](https://github.com/DockerToolbox/anyenv) containers as the base to keep the install simple and consistent.

## Supported Operating Systems

| Operating System             | Docker Hub Repo                                                                                 | Docker Hub Tags             |
| ---------------------------- | ----------------------------------------------------------------------------------------------- | --------------------------- |
| Alpine Linux 3.11            | [wolfsoftwareltd/tfenv-alpine](https://hub.docker.com/r/wolfsoftwareltd/tfenv-alpine)           | 3.11                        |
| Alpine Linux 3.12            | [wolfsoftwareltd/tfenv-alpine](https://hub.docker.com/r/wolfsoftwareltd/tfenv-alpine)           | 3.12                        |
| Alpine Linux 3.13            | [wolfsoftwareltd/tfenv-alpine](https://hub.docker.com/r/wolfsoftwareltd/tfenv-alpine)           | 3.13                        |
| Alpine Linux 3.14            | [wolfsoftwareltd/tfenv-alpine](https://hub.docker.com/r/wolfsoftwareltd/tfenv-alpine)           | 3.14, latest                |
| Amazon Linux 1               | [wolfsoftwareltd/tfenv-amazonlinux](https://hub.docker.com/r/wolfsoftwareltd/tfenv-amazonlinux) | 1                           |
| Amazon Linux 2               | [wolfsoftwareltd/tfenv-amazonlinux](https://hub.docker.com/r/wolfsoftwareltd/tfenv-amazonlinux) | 2, latest                   |
| Centos 7                     | [wolfsoftwareltd/tfenv-centos](https://hub.docker.com/r/wolfsoftwareltd/tfenv-centos)           | 7,                          |
| Centos 8                     | [wolfsoftwareltd/tfenv-centos](https://hub.docker.com/r/wolfsoftwareltd/tfenv-centos)           | 8, latest                   |
| Debian 9 (Stretch)           | [wolfsoftwareltd/tfenv-debian](https://hub.docker.com/r/wolfsoftwareltd/tfenv-debian)           | 9, stretch                  |
| Debian 9 (Stretch Slim)      | [wolfsoftwareltd/tfenv-debian](https://hub.docker.com/r/wolfsoftwareltd/tfenv-debian)           | 9-slim, stretch-slim        |
| Debian 10 (Buster)           | [wolfsoftwareltd/tfenv-debian](https://hub.docker.com/r/wolfsoftwareltd/tfenv-debian)           | 10, buster                  |
| Debian 10 (Buster Slim)      | [wolfsoftwareltd/tfenv-debian](https://hub.docker.com/r/wolfsoftwareltd/tfenv-debian)           | 10-slim, buster-slim        |
| Debian 11 (Bullseye)]        | [wolfsoftwareltd/tfenv-centos](https://hub.docker.com/r/wolfsoftwareltd/tfenv-centos)           | 11, bullseye, latest        |
| Debian 11 (Bullseye Slim)    | [wolfsoftwareltd/tfenv-debian](https://hub.docker.com/r/wolfsoftwareltd/tfenv-debian)           | 11-slim, bullseye-slim      |
| Debian 12 (Bookworm)         | [wolfsoftwareltd/tfenv-centos](https://hub.docker.com/r/wolfsoftwareltd/tfenv-centos)           | 12, bookworm                |
| Debian 12 (Bookworm Slim)    | [wolfsoftwareltd/tfenv-debian](https://hub.docker.com/r/wolfsoftwareltd/tfenv-debian)           | 12-slim, bookworm-slim      |
| Ubuntu 14.04 (Trusty Tahr)   | [wolfsoftwareltd/tfenv-ubuntu](https://hub.docker.com/r/wolfsoftwareltd/tfenv-ubuntu)           | 14.04, trusty               |
| Ubuntu 16.04 (Xenial Xerus)  | [wolfsoftwareltd/tfenv-ubuntu](https://hub.docker.com/r/wolfsoftwareltd/tfenv-ubuntu)           | 16.04, xenial               |
| Ubuntu 18.04 (Bionic Beaver) | [wolfsoftwareltd/tfenv-ubuntu](https://hub.docker.com/r/wolfsoftwareltd/tfenv-ubuntu)           | 18.04, bionic               |
| Ubuntu 20.04 (Focal Fossa)   | [wolfsoftwareltd/tfenv-ubuntu](https://hub.docker.com/r/wolfsoftwareltd/tfenv-ubuntu)           | 20.04, focal, latest        |

> Docker containers are automatically rebuilt and published weekly (Mondays 3am)

## Naming convention

### Local containers

```
tfenv-<os>-<version> e.g. tfenv-debian-10
```

### Published containers

```
wolfsoftwareltd/tfenv-<os>:<version> e.g. wolfsoftwareltd/tfenv-debian:10
```

## Development

We do not include Dockerfiles with the repository as these are generated dynamically when required. We supply a helper script to do a lot of the heavy listing.
The helper script is called `manage-all.sh` and can be from any level of the directory tree and is recursive.

> If you are in the top level directory you will need to use `manage.sh` instead of `manage-all.sh`

### Generate Dockerfiles

```
./manage-all.sh generate
```

### Build Containers

```
./manage-all.sh build [clean]
```

### Scan Containers

```
./manage-all.sh scan         
```

### Publish Containers

```
./manage-all.sh publish
```

If you want to publish the containers you will need to update the [utils.sh](Scripts/utils.sh#L5) script and change the following line.

```
DOCKER_HUB_ORG='wolfsoftwareltd'
```
