defineEnvVar POSTGRESQL_JDBC_DRIVER_VERSION MANDATORY "The version of the JDBC driver for PostgreSQL" "9.4-1204";
defineEnvVar POSTGRESQL_JDBC_DRIVER_TYPE MANDATORY "The type of the JDBC driver for PostgreSQL. Either 'jdbc4', 'jdbc41', 'jbdc42' or 'jdbc3'" "jdbc42";
defineEnvVar POSTGRESQL_JDBC_DRIVER_ARTIFACT MANDATORY "The name of the PostgreSQL JDBC driver artifact" 'postgresql-${POSTGRESQL_JDBC_DRIVER_VERSION}.${POSTGRESQL_JDBC_DRIVER_TYPE}.jar';
defineEnvVar POSTGRESQL_JDBC_DRIVER_URL MANDATORY "The url of the PostgreSQL JDBC driver artifact" 'https://jdbc.postgresql.org/download/${POSTGRESQL_JDBC_DRIVER_ARTIFACT}';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
