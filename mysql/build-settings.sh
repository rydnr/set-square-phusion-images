defineEnvVar PARENT_IMAGE_TAG MANDATORY "The version of the parent image" "0.11";
defineEnvVar UBUNTU_VERSION MANDATORY "The version available in Ubuntu" "5.7.31"; #$(docker run --rm -it ${BASE_IMAGE_64BIT}:${PARENT_IMAGE_TAG} remote-ubuntu-version mysql-server | sed 's/^.*://g' | sed 's/[^0-9a-zA-Z\._-]//g')";
overrideEnvVar TAG '${UBUNTU_VERSION}';
defineEnvVar MYSQL_ROOT_PASSWORD MANDATORY "The password for the root user" "${RANDOM_PASSWORD}";
defineEnvVar MYSQL_ADMIN_USER MANDATORY "The admin user" "dbadmin";
defineEnvVar MYSQL_ADMIN_PASSWORD MANDATORY "The password for the admin user" "${RANDOM_PASSWORD}";
defineEnvVar MYSQL_ADMIN_PRIVILEGES MANDATORY "The default privileges for the admin user" "ALL PRIVILEGES";
defineEnvVar INNODB_DEFAULT_POOL_SIZE_FACTOR MANDATORY "The default pool size factor for InnoDB" "0.4";
defineEnvVar SERVICE_USER MANDATORY "The service user" "mysql";
defineEnvVar SERVICE_USER_PASSWORD MANDATORY "The password of the service user" "${RANDOM_PASSWORD}";
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "mysql";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '/backup/${IMAGE}';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" "/bin/bash";
overrideEnvVar ENABLE_CRON false;
overrideEnvVar ENABLE_MONIT true;
overrideEnvVar ENABLE_RSNAPSHOT false;
overrideEnvVar ENABLE_SYSLOG true;
overrideEnvVar ENABLE_LOGSTASH true;
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
