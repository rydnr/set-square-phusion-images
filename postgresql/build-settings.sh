defineEnvVar POSTGRESQL_VERSION "The PostgreSQL version" "9.3";
defineEnvVar POSTGRESQL_ROOT_USER "The name of the admin user in PostgreSQL" "root";
defineEnvVar POSTGRESQL_ROOT_PASSWORD "The password for the admin user in PostgreSQL" "secret" "${RANDOM_PASSWORD}";
defineEnvVar LICENSE_FILE \
             "The file with the license details" \
             'LICENSE.gpl3';
defineEnvVar COPYRIGHT_PREAMBLE_FILE \
             "The file with the copyright preamble" \
             'copyright-preamble.default.txt';
