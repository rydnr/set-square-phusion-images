defineEnvVar GRAPHITE_SECRET_KEY \
             "The secret key for graphite" \
             "${RANDOM_PASSWORD}";
defineEnvVar GRAPHITE_TIME_ZONE \
             "The time zone for Graphite" \
             'Europe/Madrid';
defineEnvVar GRAPHITE_DB_NAME \
             "The database name of the Graphite database" \
             "graphite";
defineEnvVar GRAPHITE_DB_USERNAME \
             "The database user to access the Graphite database" \
             "graphite";
defineEnvVar GRAPHITE_DB_PASSWORD \
             "The password to access the Graphite database" \
             "${RANDOM_PASSWORD}";
defineEnvVar GRAPHITE_DB_HOST \
             "The Graphite database host" \
             'graphitedb';
