defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar SUPERSET_VERSION MANDATORY "The version of Superset" "0.19.1";
overrideEnvVar TAG '${SUPERSET_VERSION}';
defineEnvVar SUPERSET_DEFAULT_VIRTUAL_HOST MANDATORY "The default virtual host" 'superset.${DOMAIN}';
defineEnvVar SUPERSET_ADMIN_USER MANDATORY "The admin user" "admin";
defineEnvVar SUPERSET_ADMIN_PASSWORD MANDATORY "The password of the admin user" '${RANDOM_PASSWORD}';
defineEnvVar SUPERSET_ADMIN_FIRSTNAME MANDATORY "The firstname of the admin user" '${AUTHOR_FIRSTNAME}';
defineEnvVar SUPERSET_ADMIN_LASTNAME MANDATORY "The lastname of the admin user"  '${AUTHOR_LASTNAME}';
defineEnvVar SUPERSET_ADMIN_EMAIL MANDATORY "The email of the admin user" '${AUTHOR_EMAIL}';
defineEnvVar SUPERSET_LOAD_EXAMPLES MANDATORY "Whether to load examples into Superset database or not" "true";
defineEnvVar SERVICE_USER MANDATORY "The service user" "superset";
defineEnvVar SERVICE_GROUP MANDATORY "The group of the service user" "superset";
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" "/bin/bash";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '/opt/superset';
defineEnvVar SERVICE_USER_PASSWORD MANDATORY "The password of the service user" '${RANDOM_PASSWORD}';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
