# This is a Dockerfile for trac
FROM quay.io/official-images/debian:bullseye-slim
LABEL description="Custom httpd container image for running trac"
MAINTAINER Akshat Singh <akshat-pg8@iiitmk.ac.in>
ARG MARIADB_USER=db_user
ARG MARIADB_ROOT_PASSWORD=db_pw
ARG TRAC_USER=trac_user
ARG TRAC_PASSWORD=trac_pw
ARG TRAC_PROJECT_NAME=trac_project_name
ARG MARIADB_DATABASE=db_name
ARG MARIADB_HOST=db_host
ARG MARIADB_PORT=db_port
ENV MARIADB_USER=$MARIADB_USER \
    MARIADB_ROOT_PASSWORD=$MARIADB_ROOT_PASSWORD \
    MARIADB_DATABASE=$MARIADB_DATABASE \
    MARIADB_HOST=$MARIADB_HOST \
    MARIADB_PORT=$MARIADB_PORT \
    TRAC_USER=$TRAC_USER \
    TRAC_PASSWORD=$TRAC_PASSWORD \
    TRAC_PROJECT_NAME=$TRAC_PROJECT_NAME \
    TRAC_LOCATION=/usr/local/trac \
    LogLevel="info"
RUN apt-get update \
    && apt-get install -y vim wget git apache2 apache2-dev python2 python2-dev python-is-python2 mariadb-client default-libmysqlclient-dev
RUN wget https://bootstrap.pypa.io/pip/2.7/get-pip.py \
    && python2 get-pip.py
RUN python2 -m pip install setuptools Jinja2 babel Pygments docutils pytz textile PyMySQL trac TracTags genshi mod_wsgi
EXPOSE 80
#ADD trac.conf /etc/apache2/sites-available/trac.conf
ADD db/dumps/trac_ComputingDocs_09May2022.sql /opt/akstrac/db_backup/trac_ComputingDocs.sql
ADD configs/trac.conf /opt/akstrac/trac.conf
ADD configs/trac.ini_customization /opt/akstrac/trac.ini_customization
ADD configs/ComputingDocs.wsgi /opt/akstrac/ComputingDocs.wsgi
ADD entrypoint.sh /opt/akstrac/entrypoint.sh
ADD configs/theme.html /opt/akstrac/theme.html
ADD images /opt/akstrac/images
ADD git/UsefulScripts /opt/akstrac/UsefulScripts
RUN chmod 777 /opt/akstrac/entrypoint.sh
WORKDIR /opt/akstrac
ENTRYPOINT ["./entrypoint.sh"]
