FROM mcr.microsoft.com/mssql-tools

WORKDIR /scripts
COPY . .

ADD https://ola.hallengren.com/scripts/MaintenanceSolution.sql /sql/MaintenanceSolution.sql

RUN apt update \
  && apt install -y --no-install-recommends \
       python3-pip \
       python3-setuptools \
  && pip3 install -r requirements.txt \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/* \
  && apt clean

ENTRYPOINT [ "python3", "log-ship.py" ]
