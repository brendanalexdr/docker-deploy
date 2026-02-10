FROM postgres:12

ENV POSTGRES_USER brando
ENV POSTGRES_PASSWORD i9YRhWZMd3Ja5Te0HO3GbJrGPoCQcoC46XZs5BuZrHt4qGr0PR
ENV POSTGRES_DB postgres

COPY /postgresql.conf /etc/postgresql/postgresql.conf
COPY /pg-backup/pg-backup.sh /etc/pg-backup/pg-backup.sh
COPY /pg-backup/get-month-day.sh /etc/pg-backup/get-month-day.sh
COPY /pg-backup/minus-one-day.sh /etc/pg-backup/minus-one-day.sh
COPY /pg-backup/minus-one-day-base.sh /etc/pg-backup/minus-one-day-base.sh
COPY /pg-backup/pg-delete-old-backups.sh /etc/pg-backup/pg-delete-old-backups.sh
COPY /pg-backup/entrypoint.sh /etc/pg-backup/entrypoint.sh
