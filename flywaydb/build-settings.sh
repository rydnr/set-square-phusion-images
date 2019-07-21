defineEnvVar FLYWAYDB_VERSION MANDATORY "The version of FlywayDB" "4.0.3";
defineEnvVar FLYWAYDB_ARTIFACT MANDATORY "The FlywayDB artifact" 'flyway-commandline-${FLYWAYDB_VERSION}-linux-x64.tar.gz';
defineEnvVar FLYWAYDB_URL MANDATORY "The url to download FlywayDB" 'https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAYDB_VERSION}/${FLYWAYDB_ARTIFACT}';
defineEnvVar SERVICE_USER MANDATORY "The flyway user" "flyway";
defineEnvVar SERVICE_GROUP MANDATORY "The flyway group" "flyway";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
