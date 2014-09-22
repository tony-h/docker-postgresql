# https://github.com/instructure/canvas-lms/wiki/Production-Start#installing-postgres
# https://docs.docker.com/examples/postgresql_service/

FROM ubuntu:12.04

RUN apt-get -y update

RUN apt-get -y install postgresql-9.1 postgresql-contrib-9.1

EXPOSE 5432

ADD pg_hba.conf /etc/postgresql/9.1/main/
ADD postgresql.conf /etc/postgresql/9.1/main/

USER postgres

RUN service postgresql start && \
    psql --command "CREATE USER canvas WITH NOSUPERUSER NOCREATEDB NOCREATEROLE PASSWORD 'geheim';" && \
    createdb canvas_production --owner=canvas && \
    createdb canvas_queue_production --owner=canvas

CMD ["/usr/lib/postgresql/9.1/bin/postgres", "-D", "/var/lib/postgresql/9.1/main", "-c", "config_file=/etc/postgresql/9.1/main/postgresql.conf"]
