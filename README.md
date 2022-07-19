# Computing Docs

## Introduction
I have documented most of the Software and Technologies on which I have worked on the Trac Wiki, categorized it in terms of General Documentation on software libraries and tools, Languages specific documentation, Cheat Sheets, Command Line Interface Help, Cloud, and BigData Technologies. I have also documented the Interesting Articles on technologies and their installations and system configurations. I have also documented the OpenShift course DO080, provided by RedHat along with other container technologies like Podman, Docker, Kubernetes, and Google Cloud Platform.

## Deployment
This documentation is deployed on OpenShift4, comprises of two services, one for the Trac environment and the other service is running MariaDB holding the database for the Trac. These services are using the Images pushed to the quay.io registry. Each of the services is running on the pods with one replica.

## Code for the Deployment
This repo contains the code for creating and maintaining Computing Docs written by me on the Trac wiki. This code is ready to be deployed on RedHat OpenShift environment. This repo also contains the Database backup of Computing Docs wiki where I have documented all the major software and hardware Installations and Configurations related to it.

### Docker Images of MariaDB and trac on Debian with Apache 2 on Quay.io
MariaDB: [![Docker Repository on Quay](https://quay.io/repository/akshat/mariadb-custom/status?token=cc40cc41-02a9-4b04-8424-d746929fcd5b "Docker Repository on Quay")](https://quay.io/repository/akshat/mariadb-custom)

Trac: [![Docker Repository on Quay](https://quay.io/repository/akshat/trac-httpd-debian-openshift/status?token=2190bbac-fd81-413c-8134-8bc0671c21cd "Docker Repository on Quay")](https://quay.io/repository/akshat/trac-httpd-debian-openshift)

## Commands
### Command to build the MariaDB image.
```
Build db image without arguments
$ podman build -t mariadb-image-name:v1 .

With arguments
$ podman build --build-arg MARIADB_USER=username --build-arg MARIADB_ROOT_PASSWORD=topsecret -t mariadb-image-name:v1 .
```

### Command to run the built MariaDB image
```
$ podman run --name akshat-trac-mariadb -dt --network my_shared_network -p 3307:3306/tcp mariadb-image-name:v1
```

### Command to build the Trac image.
```
$ podman build --build-arg MARIADB_USER=username --build-arg MARIADB_ROOT_PASSWORD=topsecret --build-arg MARIADB_DATABASE=dbname --build-arg MARIADB_HOST=10.0.0.1 --build-arg MARIADB_PORT=3306 --build-arg TRAC_PROJECT_NAME=ComputingDocs --build-arg TRAC_USER=tracuser --build-arg TRAC_PASSWORD=tracpassword -t trac-httpd-debian-openshift:v1 .
```

### Command to run the Trac image
```
$ podman run --name akshat-trac -dt --network aks_shared_network -p 8081:8080/tcp trac-httpd-debian-openshift:v1
```

### Creating a podman network
```
$ podman network create akshat_shared_network
/home/akshat/.config/cni/net.d/akshat_shared.conflist
```
