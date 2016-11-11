defineEnvVar TOMCAT_MAJOR_VERSION \
             "The major version of Tomcat" \
             "8";
defineEnvVar TOMCAT_VERSION \
             "The version of the Apache Tomcat server" \
             "8.5.5" \
             'curl -s -k http://apache.mirrors.pair.com/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/ | grep folder.gif | tail -n 1 | cut -d ">" -f 3 | cut -d "/" -f 1 | sed "s_^v__g"';
defineEnvVar TAG "The image tag" "${TOMCAT_VERSION}";
defineEnvVar SERVICE_USER "The user to run Tomcat" "tomcat";
defineEnvVar SERVICE_GROUP 'The main group of ${SERVICE_USER}' "tomcat";
defineEnvVar SERVICE_USER_SHELL 'The shell of ${SERVICE_USER}' "/bin/bash";
defineEnvVar SERVICE_USER_HOME 'The home of ${SERVICE_USER}' '${TOMCAT_HOME}';
