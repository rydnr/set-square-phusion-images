defineEnvVar RUNDECK_VERSION MANDATORY "The Rundeck version" "3.0.2" "wget -o /dev/null -O- http://dl.bintray.com/rundeck/rundeck-deb/ | grep deb | tail -n 1 | sed 's <.\?pre>  g' | cut -d '>' -f 2 | cut -d '<' -f 1 | sed 's ^rundeck-  g' | sed 's_\.deb$__g'";
defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
overrideEnvVar TAG '${RUNDECK_VERSION}';
overrideEnvVar GIT_TAG 'v${RUNDECK_VERSION}';
defineEnvVar DEFAULT_VIRTUAL_HOST MANDATORY "The Rundeck virtual host, by default" 'rundeck.${DOMAIN}';
defineEnvVar VIRTUAL_HOST MANDATORY "The Rundeck virtual host" '${DEFAULT_VIRTUAL_HOST}';
defineEnvVar DEFAULT_VIRTUAL_PORT MANDATORY "The default port of the Rundeck virtual host, by default" '8080';
defineEnvVar VIRTUAL_PORT MANDATORY "The port of the Rundeck virtual host" '${DEFAULT_VIRTUAL_PORT}';
defineEnvVar DEFAULT_ADMIN_USERNAME MANDATORY "The Rundeck admin user, by default" "admin";
defineEnvVar DEFAULT_ADMIN_PASSWORD MANDATORY "The Rundeck admin password, by default" "secret" "${RANDOM_PASSWORD}";
defineEnvVar SERVICE_USER MANDATORY "The service user" "rundeck";
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "rundeck";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '/var/lib/${SERVICE_USER}';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" "/bin/bash";
defineEnvVar DEFAULT_LOCALE MANDATORY "The default locale" "en_US";
defineEnvVar DEFAULT_ENCODING MANDATORY "The default encoding" "UTF-8";
defineEnvVar DEFAULT_JAVA_OPTS MANDATORY "The default JAVA_OPTS" "";
defineEnvVar LOGSTASH_INPUT_PLUGINS MANDATORY "The space-separated list of Logstash input plugins" "logstash-input-stdin";
defineEnvVar LOGSTASH_FILTER_PLUGINS MANDATORY "The space-separated list of Logstash filter plugins" "logstash-filter-grok logstash-filter-date logstash-filter-json";
defineEnvVar LOGSTASH_OUTPUT_PLUGINS MANDATORY "The space-separated list of Logstash output plugins" "logstash-output-stdout";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
