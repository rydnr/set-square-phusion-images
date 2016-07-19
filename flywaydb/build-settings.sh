defineEnvVar FLYWAYDB_VERSION "The version of FlywayDB" "4.0.3";
defineEnvVar FLYWAYDB_ARTIFACT "The FlywayDB artifact" 'flyway-commandline-${FLYWAYDB_VERSION}-linux-x64.tar.gz';
defineEnvVar FLYWAYDB_URL "The url to download FlywayDB" 'https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAYDB_VERSION}/${FLYWAYDB_ARTIFACT}';
