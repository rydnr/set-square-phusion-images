defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "0.11";
defineEnvVar ELASTICSEARCH_VERSION "The version of ElasticSearch" "6.4.0";
defineEnvVar ELASTICSEARCH_MAJOR_VERSION "The major version of ElasticSearch" "6";
defineEnvVar TAG "The elasticsearch tag" '${ELASTICSEARCH_VERSION}';
defineEnvVar SERVICE_USER "The ElasticSearch user" "elasticsearch";
defineEnvVar SERVICE_GROUP "The ElasticSearch group" "elasticsearch";
defineEnvVar SERVICE_USER_HOME "The home of ElasticSearch user" "/usr/share/elasticsearch";
defineEnvVar SERVICE_USER_SHELL "The shell of ElasticSearch user" "/bin/bash";
defineEnvVar LOGSTASH_INPUT_PLUGINS "The space-separated list of Logstash input plugins" "logstash-input-stdin";
defineEnvVar LOGSTASH_FILTER_PLUGINS "The space-separated list of Logstash filter plugins" "logstash-filter-grok logstash-filter-date logstash-filter-json";
defineEnvVar LOGSTASH_OUTPUT_PLUGINS "The space-separated list of Logstash output plugins" "logstash-output-elasticsearch logstash-output-stdout";
#
