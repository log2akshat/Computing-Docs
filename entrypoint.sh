#!/bin/sh

#    Copyright (C) <2022>  <Akshat Singh>
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

#    This is the entrypoint script for trac

echo "***** Creating Trac Environment base location"
mkdir -p ${TRAC_LOCATION}

echo "\n***** Creating empty database with default utf8mb4 character_set and collation"
mysql -u${MARIADB_USER} -p${MARIADB_ROOT_PASSWORD} -h ${MARIADB_HOST} -P ${MARIADB_PORT} -e "DROP DATABASE IF EXISTS ${MARIADB_DATABASE};"
mysql -u${MARIADB_USER} -p${MARIADB_ROOT_PASSWORD} -h ${MARIADB_HOST} -P ${MARIADB_PORT} -e "CREATE DATABASE ${MARIADB_DATABASE} CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_bin;"

echo "\n***** Initializing the Trac environment"
trac-admin ${TRAC_LOCATION}/${TRAC_PROJECT_NAME} initenv ${TRAC_PROJECT_NAME} mysql://${MARIADB_USER}:${MARIADB_ROOT_PASSWORD}@${MARIADB_HOST}:${MARIADB_PORT}/${MARIADB_DATABASE}

echo "\n***** Populating the database from the backup"
mysql -u${MARIADB_USER} -p${MARIADB_ROOT_PASSWORD} -h ${MARIADB_HOST} -P ${MARIADB_PORT} ${MARIADB_DATABASE} < /opt/akstrac/db_backup/trac_ComputingDocs.sql

echo "\n***** Fixing permission for the Trac base location"
chmod -R 777 ${TRAC_LOCATION}

echo "\n***** Configuring Trac to work with mod_wsgi"
cat trac.conf >> /etc/apache2/apache2.conf
cat ports.conf > /etc/apache2/ports.conf
cat trac.ini_customization >> ${TRAC_LOCATION}/${TRAC_PROJECT_NAME}/conf/trac.ini
mkdir -p ${TRAC_LOCATION}/${TRAC_PROJECT_NAME}/apache
mv ${TRAC_PROJECT_NAME}.wsgi ${TRAC_LOCATION}/${TRAC_PROJECT_NAME}/apache

echo "\n***** Customising the trac UI"
mv theme.html /usr/local/lib/python2.7/dist-packages/trac/templates/theme.html
cp -rpf images/* ${TRAC_LOCATION}/${TRAC_PROJECT_NAME}/htdocs
cp -rpf images/akshat.jpg /usr/local/lib/python2.7/dist-packages/trac//htdocs

echo "\n***** Configuring git to browse the source for my Useful Scripts"
mv UsefulScripts ${TRAC_LOCATION}/${TRAC_PROJECT_NAME}

echo "\n***** Upgrading the Trac environment after populating the database"
trac-admin "${TRAC_LOCATION}/${TRAC_PROJECT_NAME}" upgrade
trac-admin "${TRAC_LOCATION}/${TRAC_PROJECT_NAME}" wiki upgrade

echo "\n***** Creating the username and password for Basic authentication"
htpasswd -dbc ${TRAC_LOCATION}/.htpasswd ${TRAC_USER} ${TRAC_PASSWORD}

## Uncomment if you want to test the trac on it's default server
#tracd --port 8000 --basic-auth="ComputingDocs,${TRAC_LOCATION}/.htpasswd,ComputingDocs" ${TRAC_LOCATION}/${TRAC_PROJECT_NAME} &
## [If mod_python module is used] Enabling the trac site on apache2
#a2ensite trac.conf

userid=`whoami`
echo "\n***** Running the apache2 in the foreground with the user $userid"
sed -i "s/APACHE_RUN_USER=www-data/APACHE_RUN_USER=$userid/g" /etc/apache2/envvars
apachectl -DFOREGROUND
