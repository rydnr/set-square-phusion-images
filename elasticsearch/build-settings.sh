defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar ELASTICSEARCH_VERSION MANDATORY "The version of ElasticSearch" "7.2.0";
defineEnvVar ELASTICSEARCH_MAJOR_VERSION MANDATORY "The major version of ElasticSearch" "7";
defineEnvVar TAG MANDATORY "The elasticsearch tag" '${ELASTICSEARCH_VERSION}';
defineEnvVar SERVICE_USER MANDATORY "The ElasticSearch user" "elasticsearch";
defineEnvVar SERVICE_GROUP MANDATORY "The ElasticSearch group" "elasticsearch";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of ElasticSearch user" "/usr/share/elasticsearch";
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of ElasticSearch user" "/bin/bash";
defineEnvVar LOGSTASH_INPUT_PLUGINS MANDATORY "The space-separated list of Logstash input plugins" "logstash-input-stdin";
defineEnvVar LOGSTASH_FILTER_PLUGINS MANDATORY "The space-separated list of Logstash filter plugins" "logstash-filter-grok logstash-filter-date logstash-filter-json";
defineEnvVar LOGSTASH_OUTPUT_PLUGINS MANDATORY "The space-separated list of Logstash output plugins" "logstash-output-elasticsearch logstash-output-stdout";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
