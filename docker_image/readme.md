# Docker Image: estenrye/ansible

This image provides my consistent base upon which I execute
the ansible automation in this lab.

## Key Features

- Preinstalls all Ansible Galaxy roles/collections and PyPi packages.
- Includes cookiecutter and molecule.
- Includes docker-ce-cli for docker in docker.
- Includes packer for building vm templates.

## Building

This image is continuously integrated using Github actions and published to Docker Hub.

To build on the command line:

```bash
git clone https://github.com/estenrye/slides.git
cd slides

DOCKER_BUILDKIT=1 docker build -t estenrye/ansible -f ./docker_image/Dockerfile ./docker_image
```
