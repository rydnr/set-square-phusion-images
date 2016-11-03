#!/bin/bash

chmod -x /etc/service/mysql/run
mysqladmin -u root --password="${MARIADB_ROOT_PASSWORD}" -h127.0.0.1 --protocol=tcp shutdown
