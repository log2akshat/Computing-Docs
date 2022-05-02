# This is a Dockerfile for trac
FROM quay.io/official-images/debian:bullseye-slim
LABEL description="Custom httpd container image for running trac"
MAINTAINER Akshat Singh <akshat-pg8@iiitmk.ac.in>
ARG MARIADB_USER=db_user
ARG MARIADB_ROOT_PASSWORD=db_pw
ARG MARIADB_DATABASE=db_name
ARG MARIADB_HOST=db_host
ARG MARIADB_PORT=db_port
ENV MARIADB_USER $MARIADB_USER
ENV MARIADB_ROOT_PASSWORD $MARIADB_ROOT_PASSWORD
ENV MARIADB_DATABASE $MARIADB_DATABASE
ENV MARIADB_HOST $MARIADB_HOST
ENV MARIADB_PORT $MARIADB_PORT
ENV TRAC_LOCATION /usr/local/trac
RUN apt-get update \
    && apt-get install -y aptitude vim git wget gcc apache2 python2 python2-dev mariadb-client default-libmysqlclient-dev 
RUN wget https://bootstrap.pypa.io/pip/2.7/get-pip.py \
    && python2 get-pip.py
RUN python2 -m pip --version && python2 -m pip install setuptools Jinja2 babel Pygments docutils pytz textile PyMySQL trac TracTags
EXPOSE 80 8000
ENV LogLevel "info"
ADD index.html /var/www/html
ADD db/trac_ComputingDocs_03May22.sql /opt/akstrac/db_backup/trac_ComputingDocs.sql
COPY entrypoint.sh /opt/akstrac/entrypoint.sh
RUN chmod 777 /opt/akstrac/entrypoint.sh
WORKDIR /opt/akstrac
ENTRYPOINT ["./entrypoint.sh"]
