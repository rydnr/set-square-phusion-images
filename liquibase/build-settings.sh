defineEnvVar LIQUIBASE_VERSION MANDATORY "The version of Liquibase" "3.5.2";
defineEnvVar LIQUIBASE_ARTIFACT MANDATORY "The name of the Liquibase artifact" 'liquibase-${LIQUIBASE_VERSION}-bin.tar.gz';
defineEnvVar LIQUIBASE_URL MANDATORY "The url of the Liquibase artifact" 'https://github.com/liquibase/liquibase/releases/download/liquibase-parent-${LIQUIBASE_VERSION}/${LIQUIBASE_ARTIFACT}';
overrideEnvVar ENABLE_CRON "false";
overrideEnvVar ENABLE_MONIT "false";
overrideEnvVar ENABLE_RSNAPSHOT "false";
overrideEnvVar ENABLE_SYSLOG "false";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
