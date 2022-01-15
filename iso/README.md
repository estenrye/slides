# Custom Ubuntu Autoinstall ISO

## Building Docker Image

```bash
DOCKER_BUILDKIT=1 docker build -t estenrye/ubuntu-autoinstall-iso ~/src/slides/iso
```

## Building Custom ISOs

```bash
mkdir -p ~/src/slides/iso/.output
docker run --rm -it \
  -v ~/src/slides/iso/.output:/output \
  -v ~/src/slides/iso/ansible:/ansible:ro \
  estenrye/ubuntu-autoinstall-iso \
  ansible-playbook \
    -i /ansible/inventories/bare_metal.yml \
    /ansible/playbooks/playbook.yml
```
