FROM mcr.microsoft.com/mssql-tools

COPY sql /sql
COPY entrypoint.sh entrypoint.sh

ADD https://github.com/olahallengren/sql-server-maintenance-solution/blob/master/MaintenanceSolution.sql /sql/MaintenanceSolution.sql

ENTRYPOINT [ "/entrypoint.sh" ]
