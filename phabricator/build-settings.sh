defineEnvVar PARENT_IMAGE_TAG MANDATORY "The version of the parent image" "0.11";
defineEnvVar GITHUB_PHABRICATOR_HASH MANDATORY "The hash of Phabricator's stable branch in github" "$(.templates/check-version-files/remote-git-version.sh -r https://github.com/phacility/phabricator.git stable)";
defineEnvVar GITHUB_ARCANIST_HASH MANDATORY "The hash of Arcanist's stable branch in github" "$(.templates/check-version-files/remote-git-version.sh -r https://github.com/phacility/arcanist.git stable)";
defineEnvVar GITHUB_LIBPHUTIL_HASH MANDATORY "The hash of Libphutil's stable branch in github" "$(.templates/check-version-files/remote-git-version.sh -r https://github.com/phacility/libphutil.git stable)";
overrideEnvVar TAG '${GITHUB_PHABRICATOR_HASH}';
defineEnvVar PHABRICATOR_VIRTUAL_HOST MANDATORY "The virtual host of the Phabricator installation" 'phabricator.${DOMAIN}';
defineEnvVar SERVICE_USER MANDATORY "The service user" "phabricator";
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "phabricator";
defineEnvVar SERVICE_USER_SHELL MANDATORY "The service account shell" "/bin/bash";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" "/opt/phabricator";
defineEnvVar PHABRICATOR_PORT MANDATORY "The port used by Phabricator" "8000";
defineEnvVar PHABRICATOR_DB_NAME MANDATORY "The database name" "phabricator";
defineEnvVar PHABRICATOR_DB_USER MANDATORY "The database user" "phabricator";
defineEnvVar PHABRICATOR_DB_PASSWORD MANDATORY "The database password" '${RANDOM_PASSWORD}';
defineEnvVar PHABRICATOR_FROM_ADDRESS MANDATORY "The from email address" 'noreply@${DOMAIN}';
defineEnvVar LIQUIBASE_VERSION MANDATORY "The version of Liquibase" "3.6.3";
defineEnvVar LIQUIBASE_ARTIFACT MANDATORY "The name of the Liquibase artifact" 'liquibase-${LIQUIBASE_VERSION}-bin.tar.gz';
defineEnvVar LIQUIBASE_URL MANDATORY "The url of the Liquibase artifact" 'https://github.com/liquibase/liquibase/releases/download/liquibase-parent-${LIQUIBASE_VERSION}/${LIQUIBASE_ARTIFACT}';
defineEnvVar MARIADB_VERSION MANDATORY "The MariaDB version" "10.3.14-ubuntu-18.04";
defineEnvVar MARIADB_JDBC_DRIVER_VERSION MANDATORY "The version of the JDBC driver for MariaDB" "2.3.0-1";
defineEnvVar MARIADB_JDBC_DRIVER_ARTIFACT MANDATORY "The name of the MariaDB JDBC driver artifact" 'libmariadb-java-${MARIADB_JDBC_DRIVER_VERSION}.jar';
defineEnvVar MARIADB_JDBC_DRIVER_URL MANDATORY "The url of the MariaDB JDBC driver artifact" 'http://central.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/${MARIADB_JDBC_DRIVER_VERSION}/${MARIADB_JDBC_DRIVER_ARTIFACT}';
defineEnvVar MARIADB_JDBC_DRIVER MANDATORY "The class name of the JDBC driver for MariaDB" "org.mariadb.jdbc.Driver";
defineEnvVar MYSQL_VERSION MANDATORY "The MySQL version" "$(docker run --rm -it ${NAMESPACE}-phusion/base:${PARENT_IMAGE_TAG} remote-ubuntu-version mysql-server | sed 's/[^0-9a-zA-Z\._-]//g')";
defineEnvVar MYSQL_JDBC_DRIVER_VERSION MANDATORY "The version of the JDBC driver for MySQL" "6.0.6";
defineEnvVar MYSQL_JDBC_DRIVER_ARTIFACT MANDATORY "The name of the MySQL JDBC driver artifact" 'mysql-connector-java-${MYSQL_JDBC_DRIVER_VERSION}.jar';
defineEnvVar MYSQL_JDBC_DRIVER_URL MANDATORY "The url of the MySQL JDBC driver artifact" 'http://central.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_JDBC_DRIVER_VERSION}/${MYSQL_JDBC_DRIVER_ARTIFACT}';
defineEnvVar MYSQL_JDBC_DRIVER MANDATORY "The class name of the JDBC driver for MySQL" "com.mysql.cj.jdbc.Driver";
defineEnvVar DEFAULT_TIMEZONE MANDATORY "The default timezone. See http://php.net/manual/en/timezones.php" "Europe/Madrid";
defineEnvVar BACKUP_HOST_SSH_PORT MANDATORY \
             "The SSH port of the backup host" \
             "$(grep -e phabricator sshports.txt || echo phabricator 22 | awk '{print $2;}')";
defineEnvVar INVALID_PATCHES MANDATORY \
             "Patches that are invalid for some reason" \
             "resources/sql/autopatches/20161026.calendar.01.importtriggers.sql";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
