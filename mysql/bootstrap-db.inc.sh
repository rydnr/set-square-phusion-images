defineEnvVar MYSQL_DATA_FOLDER "The database folder" "/backup/mysql-db";
defineEnvVar SQL_TEMPLATE "The SQL template file" "/usr/local/src/setup.sql.tpl";
defineEnvVar SERVICE_USER "The service user" "mysql";
defineEnvVar SERVICE_GROUP "The service group" "mysql";
defineEnvVar SLEEP_WHEN_SHUTTING_DOWN_DB "The number of seconds to wait before checking if the database has shut down" 2;
defineEnvVar SLEEP_UNTIL_DB_IS_READY "The number of seconds to wait before checking if the database is ready" 2;
defineEnvVar MAX_RETRIES_TO_SHUT_DOWN_DB "The maximum number of retries trying to shut down the database" 20;
defineEnvVar MAX_RETRIES_TO_START_DB "The maximum number of retries trying to start MySQL" 20;
defineEnvVar MYSQL_ROOT_PASSWORD "The root password of the database" "7d79c7b43ad5913189a7bd455f94f1a10f4d4091";

