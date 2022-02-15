#!/bin/bash
/opt/mssql-tools/bin/sqlcmd \
  -S ${SQL_SERVER_HOSTNAME} \
  -U ${SQL_SERVER_LOGIN} \
  -P "${SQL_SERVER_PASSWORD}" \
  -N -C \
  -i $@
