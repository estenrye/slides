FROM tgagor/centos:stream8

ENV ANSIBLE_CONFIG=/home/automation-user/.ansible.cfg \
    PYENV_VIRTUALENV_DISABLE_PROMPT=1

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
  && echo 'automation-user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && yum clean all

USER automation-user
WORKDIR /home/automation-user
COPY --chown=automation-user \
  .ansible.cfg .bashrc configure.yaml entrypoint.sh prereq.requirements.txt requirements.txt requirements.yml \
  /home/automation-user/
RUN git clone https://github.com/pyenv/pyenv.git /home/automation-user/.pyenv \
  && git clone https://github.com/yyuu/pyenv-virtualenv.git /home/automation-user/.pyenv/plugins/pyenv-virtualenv \
  && source /home/automation-user/.bashrc \
  && pyenv install 3.10.4 \
  && pyenv local 3.10.4 \
  && pyenv virtualenv 3.10.4 py3.10.4 \
  && pyenv activate py3.10.4 \
  && pyenv local py3.10.4 \
  && pyenv exec python -m pip install --force -r /home/automation-user/prereq.requirements.txt \
  && pyenv exec python -m pip install -r /home/automation-user/requirements.txt \
  && pyenv exec ansible-playbook -i localhost, /home/automation-user/configure.yaml \
  && pyenv exec ansible-galaxy install -r requirements.yml

ENV PYENV_VERSION=py3.10.4 \
    PYENV_ROOT=/home/automation-user/.pyenv

WORKDIR /ansible
ENTRYPOINT ["/home/automation-user/entrypoint.sh"]
