defineEnvVar PARENT_IMAGE_TAG "The version of the parent image" "0.9.22";
defineEnvVar POSTGRESQL_VERSION "The PostgreSQL version" "9.6";
defineEnvVar TAG '${POSTGRESQL_VERSION}';
defineEnvVar POSTGRESQL_ROOT_USER "The name of the admin user in PostgreSQL" "root";
defineEnvVar POSTGRESQL_ROOT_PASSWORD "The password for the admin user in PostgreSQL" "secret" "${RANDOM_PASSWORD}";
defineEnvVar BACKUP_HOST_SSH_PORT \
             "The SSH port of the backup host" \
             "$(grep -e postgresql sshports.txt || echo postgresql 22 | awk '{print $2;}')";
defineEnvVar SERVICE_USER "The user the Postgres process runs as" "postgres";
defineEnvVar SERVICE_GROUP "The group the Postgres process runs as" "postgres";
defineEnvVar SERVICE_USER_HOME "The home of the PostgreSQL account" "/var/lib/postgresql";
defineEnvVar SERVICE_USER_SHELL "The shell of the PostgreSQL account" "/bin/false";
