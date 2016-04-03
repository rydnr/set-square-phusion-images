defineEnvVar SOURCE_FOLDER "The folder with new configuration settings for MariaDB" "/var/local/mysql/conf.d";
defineEnvVar DESTINATION_FOLDER "The folder with configuration settings for MariaDB" "/etc/mysql/conf.d";
defineEnvVar HASH_ALGORITHM "The hash algorithm" "sha512";
defineEnvVar CHECKSUM_FILE "The checksum file" '/var/local/confd.${HASH_ALGORITHM}';
