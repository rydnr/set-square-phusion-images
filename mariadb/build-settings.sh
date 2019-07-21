defineEnvVar PARENT_IMAGE_TAG MANDATORY "The version of the parent image" "0.11";
defineEnvVar UBUNTU_VERSION MANDATORY "The version available in Ubuntu" "$(docker run --rm -it ${REGISTRY}/${NAMESPACE}/base:${PARENT_IMAGE_TAG} remote-ubuntu-version mariadb-server | sed 's/[^0-9a-zA-Z\._-]//g')";
overrideEnvVar TAG '${UBUNTU_VERSION}';
defineEnvVar MARIADB_ROOT_PASSWORD MANDATORY "The password for the root user" "${RANDOM_PASSWORD}";
defineEnvVar MARIADB_ADMIN_USER MANDATORY "The admin user" "dbadmin";
defineEnvVar MARIADB_ADMIN_PASSWORD MANDATORY "The password for the admin user" "${RANDOM_PASSWORD}";
defineEnvVar MARIADB_ADMIN_PRIVILEGES MANDATORY "The default privileges for the admin user" "ALL PRIVILEGES";
defineEnvVar INNODB_DEFAULT_POOL_SIZE_FACTOR MANDATORY "The default pool size factor for InnoDB" "0.4";
overrideEnvVar ENABLE_CRON false;
overrideEnvVar ENABLE_MONIT true;
overrideEnvVar ENABLE_RSNAPSHOT false;
overrideEnvVar ENABLE_SYSLOG true;
overrideEnvVar ENABLE_LOGSTASH true;
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
