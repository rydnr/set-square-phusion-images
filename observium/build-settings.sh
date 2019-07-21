defineEnvVar OBSERVIUM_DB_NAME MANDATORY "The Observium database name" "observium";
defineEnvVar OBSERVIUM_DB_USER MANDATORY "The Observium database user" "observium";
defineEnvVar OBSERVIUM_DB_USER MANDATORY "The Observium database password" "${RANDOM_PASSWORD}";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
