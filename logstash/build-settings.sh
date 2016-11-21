defineEnvVar PARENT_IMAGE_TAG "The version of the parent image" "201611";
defineEnvVar LOGSTASH_VERSION "The logstash version" "1:5.0.1-1";
overrideEnvVar TAG '5.0.1';
defineEnvVar SERVICE_USER "The logstash user" "logstash";
defineEnvVar SERVICE_GROUP "The logstash group" "logstash";
defineEnvVar SERVICE_USER_HOME "The home of the logstash user" "/usr/share/logstash";
defineEnvVar SERVICE_USER_SHELL "The shell of the logstash user" "/bin/bash";
