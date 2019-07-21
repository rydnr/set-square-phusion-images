defineEnvVar GRAPHITE_SECRET_KEY MANDATORY "The secret key for graphite" "${RANDOM_PASSWORD}";
defineEnvVar GRAPHITE_TIME_ZONE MANDATORY "The time zone for Graphite" 'Europe/Madrid';
defineEnvVar GRAPHITE_DB_NAME MANDATORY "The database name of the Graphite database" "graphite";
defineEnvVar GRAPHITE_DB_USERNAME MANDATORY "The database user to access the Graphite database" "graphite";
defineEnvVar GRAPHITE_DB_PASSWORD MANDATORY "The password to access the Graphite database" "${RANDOM_PASSWORD}";
defineEnvVar GRAPHITE_DB_HOST MANDATORY "The Graphite database host" 'graphitedb';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
