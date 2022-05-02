# This is a Dockerfile for MariaDB to be used with trac
FROM docker.io/mariadb:latest
LABEL description="Custom mariadb container image for running trac"
MAINTAINER Akshat Singh <akshat-pg8@iiitmk.ac.in>
ARG MARIADB_USER=db_user
ARG MARIADB_ROOT_PASSWORD=db_pw
ENV MARIADB_USER $MARIADB_USER
ENV MARIADB_ROOT_PASSWORD $MARIADB_ROOT_PASSWORD
EXPOSE 3306
CMD ["mysqld"]
