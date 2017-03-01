defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "201702";
defineEnvVar ELASTICSEARCH_VERSION "The version of ElasticSearch" "5.1.2";
defineEnvVar ELASTICSEARCH_MAJOR_VERSION "The major version of ElasticSearch" "5";
defineEnvVar TAG "The elasticsearch tag" '${ELASTICSEARCH_VERSION}';
defineEnvVar SERVICE_USER "The ElasticSearch user" "elasticsearch";
defineEnvVar SERVICE_GROUP "The ElasticSearch group" "elasticsearch";
defineEnvVar SERVICE_USER_HOME "The home of ElasticSearch user" "/usr/share/elasticsearch";
defineEnvVar SERVICE_USER_SHELL "The shell of ElasticSearch user" "/bin/bash";
