defineEnvVar PARENT_IMAGE_TAG MANDATORY "The version of the parent image" "latest"
defineEnvVar UBUNTU_VERSION MANDATORY "The version available in Ubuntu" "$(docker run --rm -it ${BASE_IMAGE_64BIT}:${PARENT_IMAGE_TAG} remote-ubuntu-version mariadb-server | sed 's/^.*://g' | sed 's/[^0-9a-zA-Z\._-]//g')"
overrideEnvVar TAG '${UBUNTU_VERSION}'
defineEnvVar MARIADB_ROOT_PASSWORD MANDATORY "The password for the root user" "${RANDOM_PASSWORD}"
defineEnvVar MARIADB_ADMIN_USER MANDATORY "The admin user" "dbadmin"
defineEnvVar MARIADB_ADMIN_PASSWORD MANDATORY "The password for the admin user" "${RANDOM_PASSWORD}"
defineEnvVar MARIADB_ADMIN_PRIVILEGES MANDATORY "The default privileges for the admin user" "ALL PRIVILEGES"
defineEnvVar DEFAULT_INNODB_BUFFER_POOL_SIZE_FACTOR MANDATORY "The default pool size factor for InnoDB" "0.4"
defineEnvVar DEFAULT_INNODB_BUFFER_POOL_SIZE_FACTOR_CONFIG_FILE MANDATORY "The location of the config file to customize the InnoDB buffer pool size factor" "/etc/mysql/conf.d/mysqld_innodb_buffer_pool_size.cnf"
defineEnvVar DEFAULT_ENABLE_STRICT_MODE MANDATORY "Whether to enable strict mode" ${TRUE}
defineEnvVar DEFAULT_ENABLE_STRICT_MODE_CONFIG_FILE MANDATORY "The path of the configuration file to enable strict mode" "/etc/mysql/conf.d/mysqld_enable_strict_mode.cnf"
defineEnvVar DEFAULT_ENABLE_LOCAL_INFILE MANDATORY "Whether to enable LOAD DATA LOCAL INFILE" ${TRUE}
defineEnvVar DEFAULT_ENABLE_LOCAL_INFILE_CONFIG_FILE MANDATORY "The location of the config file to enable LOAD DATA LOCAL INFILE" "/etc/mysql/conf.d/mysqld_local_infile.cnf"
overrideEnvVar ENABLE_CRON false
overrideEnvVar ENABLE_MONIT true
overrideEnvVar ENABLE_RSNAPSHOT false
overrideEnvVar ENABLE_SYSLOG true
overrideEnvVar ENABLE_LOGSTASH false
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
