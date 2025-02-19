defineEnvVar PARENT_IMAGE_TAG MANDATORY "The version of the parent image" "latest"
# defineEnvVar POSTGRESQL_VERSION MANDATORY "The PostgreSQL version" "14.13"
defineEnvVar TAG MANDATORY "The image tag" '${POSTGRESQL_VERSION}'
defineEnvVar POSTGRESQL_ROOT_USER MANDATORY "The name of the admin user in PostgreSQL" "root"
defineEnvVar POSTGRESQL_ROOT_PASSWORD MANDATORY "The password for the admin user in PostgreSQL" "secret" "${RANDOM_PASSWORD}"
defineEnvVar BACKUP_HOST_SSH_PORT MANDATORY "The SSH port of the backup host" "$(grep -e postgresql sshports.txt || echo postgresql 22 | awk '{print $2;}')"
defineEnvVar SERVICE_USER MANDATORY "The user the Postgres process runs as" "postgres"
defineEnvVar SERVICE_GROUP MANDATORY "The group the Postgres process runs as" "postgres"
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the PostgreSQL account" "/var/lib/postgresql"
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the PostgreSQL account" "/bin/false"
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
