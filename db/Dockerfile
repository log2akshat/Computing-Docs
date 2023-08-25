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

#    This is a Dockerfile for MariaDB to be used with trac

FROM docker.io/mariadb:latest
LABEL description="Custom mariadb container image for running trac"
MAINTAINER Akshat Singh <akshat-pg8@iiitmk.ac.in>
ARG MARIADB_USER=db_user
ARG MARIADB_ROOT_PASSWORD=db_pw
ENV MARIADB_USER $MARIADB_USER
ENV MARIADB_ROOT_PASSWORD $MARIADB_ROOT_PASSWORD
EXPOSE 3306
CMD ["mysqld"]
