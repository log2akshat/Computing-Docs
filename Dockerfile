# This is a Dockerfile for trac
FROM quay.io/official-images/debian:bullseye-slim
LABEL description="Custom httpd container image for running trac"
MAINTAINER Akshat Singh <akshat-pg8@iiitmk.ac.in>
RUN apt-get update \
    && apt-get install -y vim git wget apache2 python2 python-setuptools python-jinja2 docutils python-pygments-doc
RUN apt-get install -y mariadb-server
RUN apt-get install -y sqlite3
RUN wget https://bootstrap.pypa.io/pip/2.7/get-pip.py \
    && python2 get-pip.py
RUN python2 -m pip --version && python2 -m pip install trac
EXPOSE 80 8000
ENV LogLevel "info"
ADD index.html /var/www/html
RUN trac-admin /usr/local/ComputingDocs initenv ComputingDocs sqlite:/usr/local/ComputingDocs/db/trac.db #mysql://root:12345@localhost:3306/trac
RUN tracd --port 8000 /usr/local/ComputingDocs
ENTRYPOINT ["apachectl"]
CMD ["-D", "FOREGROUND"]
