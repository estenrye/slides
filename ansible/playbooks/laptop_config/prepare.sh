sudo apt update
sudo apt upgrade -y
sudo apt install -y \
  git \
  python3-pip \
  python3-virtualenv
pip3 install -r ~/src/slides/docker_image/install/requirements.txt
ansible-galaxy install -r ~/src/slides/docker_image/install/requirements.yml