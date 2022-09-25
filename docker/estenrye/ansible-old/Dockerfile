FROM redhat/ubi8-minimal:8.5-243

ENV ANSIBLE_CONFIG=/home/automation-user/.ansible.cfg \
    PYENV_VIRTUALENV_DISABLE_PROMPT=1

RUN microdnf install \
      bzip2-devel \
      curl \
      git \
      gcc \
      glibc \
      libffi-devel \
      openssl-devel \
      openssh-clients \
      perl \
      readline \
      sudo \
      sqlite-devel \
      tar \
      zlib-devel \
  && adduser automation-user \
  && usermod -aG wheel automation-user \
  && echo 'automation-user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER automation-user
WORKDIR /home/automation-user

RUN git clone https://github.com/pyenv/pyenv.git /home/automation-user/.pyenv \
  && git clone https://github.com/yyuu/pyenv-virtualenv.git /home/automation-user/.pyenv/plugins/pyenv-virtualenv

COPY --chown=automation-user .bashrc /home/automation-user/
RUN source /home/automation-user/.bashrc \
  && pyenv install 3.10.4 --verbose \
  && pyenv global 3.10.4

COPY --chown=automation-user prereq.requirements.txt /home/automation-user/
RUN source /home/automation-user/.bashrc \
  && pyenv exec python -m pip install --force -r /home/automation-user/prereq.requirements.txt

COPY --chown=automation-user requirements.txt /home/automation-user/
RUN source /home/automation-user/.bashrc \
  && pyenv exec python -m pip install --force -r /home/automation-user/requirements.txt

COPY --chown=automation-user .ansible.cfg configure.yaml vendor /home/automation-user/
RUN source /home/automation-user/.bashrc \
  && pyenv exec ansible-playbook -i localhost, /home/automation-user/configure.yaml

COPY --chown=automation-user requirements.yml /home/automation-user/
RUN source /home/automation-user/.bashrc \
  && pyenv exec ansible-galaxy install -r requirements.yml

ENV PYENV_VERSION=3.10.4 \
    PYENV_ROOT=/home/automation-user/.pyenv

COPY --chown=automation-user entrypoint.sh /home/automation-user/
WORKDIR /ansible
ENTRYPOINT ["/home/automation-user/entrypoint.sh"]
