#    Copyright (C) <2022-2023>  <Akshat Singh>
#    <akshat-pg8@iiitmk.ac.in>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

#    This is a Dockerfile for trac

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
    && apt-get install -y wget git apache2 apache2-utils apache2-dev libcap2-bin python2 python2-dev python-is-python2 mariadb-client default-libmysqlclient-dev subversion
RUN wget https://bootstrap.pypa.io/pip/2.7/get-pip.py \
    && python2 get-pip.py
RUN python2 -m pip install setuptools Jinja2 babel Pygments docutils pytz textile PyMySQL trac TracTags genshi mod_wsgi
RUN python2 -m pip install svn+https://trac-hacks.org/svn/tocmacro/0.11
RUN a2enmod lbmethod_byrequests
RUN apt-get purge -y subversion
    #&& setcap 'cap_net_bind_service=+ep' /usr/sbin/apache2
EXPOSE 8080
#ADD trac.conf /etc/apache2/sites-available/trac.conf
ADD db/dumps/trac_ComputingDocs_19Jul23.sql /opt/akstrac/db_backup/trac_ComputingDocs.sql
ADD configs/trac.conf /opt/akstrac/trac.conf
ADD configs/ports.conf /opt/akstrac/ports.conf
ADD configs/trac.ini_customization /opt/akstrac/trac.ini_customization
ADD configs/ComputingDocs.wsgi /opt/akstrac/ComputingDocs.wsgi
ADD configs/theme.html /opt/akstrac/theme.html
ADD images /opt/akstrac/images
ADD git/UsefulScripts /opt/akstrac/UsefulScripts
ADD entrypoint.sh /opt/akstrac/entrypoint.sh
WORKDIR /opt/akstrac
RUN chmod -R 777 /usr/local \
    && chmod -R 777 /opt/akstrac \
    && chmod -R 777 /etc/apache2 \
    && chmod -R 777 /var/run \
    && chmod -R 777 /var/log/apache2 \
    && chmod -R 777 /var/lock \
    && chmod 777 /opt/akstrac/entrypoint.sh
USER 1001
ENTRYPOINT ["./entrypoint.sh"]
