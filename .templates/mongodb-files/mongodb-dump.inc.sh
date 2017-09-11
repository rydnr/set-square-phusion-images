defineEnvVar MONGODB_HOST "The MongoDB host" "localhost";
defineEnvVar MONGODB_USER "The MongoDB user" "";
defineEnvVar MONGODB_PASSWORD 'The MongoDB password for ${MONGODB_USER}' "";
defineEnvVar MONGODB_AUTHENTICATION_DATABASE 'The MongoDB authentication database for logging in as ${MONGODB_USER}' 'admin';
defineEnvVar MONGODB_AUTHENTICATION_MECHANISM 'The MongoDB authentication mechanism for logging in as ${MONGODB_USER}' 'SCRAM-SHA-1';
