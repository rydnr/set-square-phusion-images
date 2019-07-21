defineEnvVar TOMCAT_MAJOR_VERSION MANDATORY "The major version of Tomcat" "8";
defineEnvVar TOMCAT_VERSION MANDATORY "The version of the Apache Tomcat server" "8.5.5" 'curl -s -k http://apache.mirrors.pair.com/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/ | grep folder.gif | tail -n 1 | cut -d ">" -f 3 | cut -d "/" -f 1 | sed "s_^v__g"';
defineEnvVar TAG MANDATORY "The image tag" "${TOMCAT_VERSION}";
defineEnvVar SERVICE_USER MANDATORY "The user to run Tomcat" "tomcat";
defineEnvVar SERVICE_GROUP MANDATORY 'The main group of ${SERVICE_USER}' "tomcat";
defineEnvVar SERVICE_USER_SHELL MANDATORY 'The shell of ${SERVICE_USER}' "/bin/bash";
defineEnvVar SERVICE_USER_HOME MANDATORY 'The home of ${SERVICE_USER}' '${TOMCAT_HOME}';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
