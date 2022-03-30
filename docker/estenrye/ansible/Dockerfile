FROM tgagor/centos:stream8

ENV PYENV_VIRTUALENV_DISABLE_PROMPT=1

RUN yum -y update \
  && yum -y upgrade \
  && yum install -y epel-release \
  && yum install -y \
      bzip2-devel \
      curl \
      git \
      gcc \
      libffi-devel \
      openssl-devel \
      openssh-clients \
      perl \
      python3 \
      python3-pip \
      readline-devel \
      sudo \
      sqlite-devel \
      zlib-devel \
  && adduser automation-user \
  && usermod -aG wheel automation-user \
  && echo 'automation-user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER automation-user
COPY --chown=automation-user .bashrc /home/automation-user/.
RUN git clone https://github.com/pyenv/pyenv.git /home/automation-user/.pyenv \
  && git clone https://github.com/yyuu/pyenv-virtualenv.git /home/automation-user/.pyenv/plugins/pyenv-virtualenv \
  && source /home/automation-user/.bashrc \
  && pyenv install 3.10.4

WORKDIR /home/automation-user

COPY prereq.requirements.txt requirements.txt /tmp/src/

RUN source /home/automation-user/.bashrc \
  && pyenv local 3.10.4 \
  && pyenv virtualenv 3.10.4 py3.10.4 \
  && pyenv activate py3.10.4 \
  && pyenv local py3.10.4 \
  && pyenv exec python -m pip install --force -r /tmp/src/prereq.requirements.txt \
  && pyenv exec python -m pip install -r /tmp/src/requirements.txt

COPY configure.yaml /tmp/src/
RUN source /home/automation-user/.bashrc \
  && pyenv exec ansible-playbook -i localhost, /tmp/src/configure.yaml
COPY entrypoint.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
