FROM linuxserver/code-server:4.4.0
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update \
  && apt install -y \
         build-essential \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*
# TODO: Install Node
# TODO: Install Oh-My-ZSH
# TODO: Install Python 3.10
# TODO: Install Ansible
# TODO: Install Extensions
#  - ginfuru.ginfuru-better-solarized-dark-theme
#  - ms-kubernetes-tools.vscode-kubernetes-tools
#  - redhat.vscode-yaml
# TODO: Install homebrew and helm chart tooling
# TODO: add /config/.local/state/vs-kubernetes/tools to PATH