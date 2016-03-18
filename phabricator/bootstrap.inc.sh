defineEnvVar DEFAULT_DB_VENDOR "The default database vendor" "mariadb";
defineEnvVar SQL_DDL_FOLDER "The folder with the SQL files" "/usr/local/share/sql/";
defineEnvVar LIQUIBASE_CHANGELOGS_FOLDER "The folder with the Liquibase changelogs" "/usr/local/share/liquibase/";
_db_schemas=($(cat /usr/local/share/liquibase/phabricator-schemas.txt));
defineEnvVar PHABRICATOR_DB_SCHEMAS "The Phabricator schemas" "${_db_schemas[*]}";
