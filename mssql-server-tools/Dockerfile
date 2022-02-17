FROM ubuntu:focal

WORKDIR /scripts
COPY . .

ADD https://ola.hallengren.com/scripts/MaintenanceSolution.sql /sql/MaintenanceSolution.sql

RUN apt update \
  && apt install -y --no-install-recommends\
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
  && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
  && echo 'deb https://packages.microsoft.com/ubuntu/20.04/prod focal main' >> /etc/apt/sources.list \
  && cat /etc/apt/sources.list \
  && apt update \
  && apt upgrade -y \
  && apt install -y --no-install-recommends \
       mssql-tools \
       python3-dev \
       python3-pip \
       python3-setuptools \
       python3-wheel \
       unixodbc-dev \
  && pip3 install --upgrade pip \
  && pip3 install wheel \
  && pip3 install -r requirements.txt \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/* \
  && apt clean

ENTRYPOINT [ "python3", "log-ship.py" ]
