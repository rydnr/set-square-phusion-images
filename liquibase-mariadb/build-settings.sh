defineEnvVar MARIADB_JDBC_DRIVER_VERSION MANDATORY "The version of the JDBC driver for MariaDB" "1.2.3";
defineEnvVar MARIADB_JDBC_DRIVER_ARTIFACT MANDATORY "The name of the MariaDB JDBC driver artifact" 'mariadb-java-client-${MARIADB_JDBC_DRIVER_VERSION}.jar';
defineEnvVar MARIADB_JDBC_DRIVER_URL MANDATORY "The url of the MariaDB JDBC driver artifact" 'http://central.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/${MARIADB_JDBC_DRIVER_VERSION}/${MARIADB_JDBC_DRIVER_ARTIFACT}';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
