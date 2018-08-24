defineEnvVar RUNDECK_VERSION "The Rundeck version" "3.0.2" "wget -o /dev/null -O- http://dl.bintray.com/rundeck/rundeck-deb/ | grep deb | tail -n 1 | sed 's <.\?pre>  g' | cut -d '>' -f 2 | cut -d '<' -f 1 | sed 's ^rundeck-  g' | sed 's_\.deb$__g'";
defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "0.11";
overrideEnvVar TAG '${RUNDECK_VERSION}';
overrideEnvVar GIT_TAG 'v${RUNDECK_VERSION}';d
defineEnvVar DEFAULT_ADMIN_USER "The Rundeck admin user, by default" "admin";
defineEnvVar DEFAULT_ADMIN_PASSWORD "The Rundeck admin password, by default" "secret" "${RANDOM_PASSWORD}";
defineEnvVar SERVICE_USER "The service user" "rundeck";
defineEnvVar SERVICE_GROUP "The service group" "rundeck";
defineEnvVar SERVICE_USER_HOME "The home of the service user" '/home/${SERVICE_USER}';
defineEnvVar SERVICE_USER_SHELL "The shell of the service user" "/bin/bash";
defineEnvVar DEFAULT_LOCALE "The default locale" "en_US";
defineEnvVar DEFAULT_ENCODING "The default encoding" "UTF-8";
defineEnvVar DEFAULT_JAVA_OPTS "The default JAVA_OPTS" "";
#
