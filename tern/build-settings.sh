defineEnvVar SERVICE_USER MANDATORY "The service user" '${NAMESPACE}';
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "users";
defineEnvVar SERVICE_PORT MANDATORY "The port used by ternjs" "36515";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
