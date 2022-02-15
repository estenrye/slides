FROM mcr.microsoft.com/mssql-tools

COPY sql /sql
COPY entrypoint.sh /entrypoint.sh

ADD https://ola.hallengren.com/scripts/MaintenanceSolution.sql /sql/MaintenanceSolution.sql

ENTRYPOINT [ "/entrypoint.sh" ]
