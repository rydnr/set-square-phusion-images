defineEnvVar PARENT_IMAGE_TAG MANDATORY "The parent image tag" "0.11";
defineEnvVar FILEBEAT_VERSION MANDATORY "The filebeat version" '1.3.1';
defineEnvVar FILEBEAT_ARTIFACT MANDATORY "The filebeat binary file to download" 'filebeat-${FILEBEAT_VERSION}-x86_64.tar.gz'
defineEnvVar FILEBEAT_DOWNLOAD_URL MANDATORY "The url to download filebeat from" 'https://download.elastic.co/beats/filebeat/${FILEBEAT_ARTIFACT}';

defineEnvVar FILEBEAT_SPOOL_SIZE MANDATORY "Event count spool threshold - forces network flush if exceeded" '2048';
defineEnvVar FILEBEAT_IDLE_TIMEOUT MANDATORY "Defines how often the spooler is flushed. After idle_timeout the spooler is Flush even though spool_size is not reached" '5s';
defineEnvVar FILEBEAT_REGISTRY_FILE MANDATORY "Name of the registry file. Per default it is put in the current working directory. In case the working directory is changed after when running filebeat again, indexing starts from the beginning again" '.filebeat';

## ElasticSearch output ##
defineEnvVar FILEBEAT_OUTPUT_ELASTICSEARCH_HOSTS MANDATORY "Array of hosts to connect to" '["localhost:9200"]';
defineEnvVar FILEBEAT_OUTPUT_ELASTICSEARCH_WORKER MANDATORY "Number of workers per ElasticSearch host" '1';
defineEnvVar FILEBEAT_OUTPUT_ELASTICSEARCH_INDEX MANDATORY "The index name. The default is 'filebeat' and generates [filebeat-]YYYY.MM.DD keys" 'filebeat';
defineEnvVar FILEBEAT_OUTPUT_ELASTICSEARCH_PATH MANDATORY "The HTTP path in Elastic Search" '/elasticsearch';
defineEnvVar FILEBEAT_OUTPUT_ELASTICSEARCH_MAX_RETRIES MANDATORY "The number of times a particular ElasticSearch index operation is attempted. Afterwards the events are dropped" "3";
defineEnvVar FILEBEAT_OUTPUT_ELASTICSEARCH_BULK_MAX_SIZE MANDATORY "The maximum number of events to bulk in a single ElasticSearch bulk API index request" '50';
defineEnvVar FILEBEAT_OUTPUT_ELASTICSEARCH_TIMEOUT MANDATORY "The HTTP request timeout" '90';
defineEnvVar FILEBEAT_OUTPUT_ELASTICSEARCH_FLUSH_INTERVAL MANDATORY "The number of seconds to wait for new events between two bulk API index requests" '1';

## Logstash output ##
defineEnvVar FILEBEAT_OUTPUT_LOGSTASH_HOSTS MANDATORY "The logstash hosts" '["{{LOGSTASH_HOST}}:{{LOGSTASH_PORT}}"]';
defineEnvVar FILEBEAT_OUTPUT_LOGSTASH_WORKER MANDATORY "Number of workers per Logstash host" '1';
defineEnvVar FILEBEAT_OUTPUT_LOGSTASH_COMPRESSION_LEVEL MANDATORY "The gzip compression level" '3';
defineEnvVar FILEBEAT_OUTPUT_LOGSTASH_LOADBALANCE MANDATORY "Load balance the events between the Logstash hosts" 'true';
defineEnvVar FILEBEAT_OUTPUT_LOGSTASH_INDEX MANDATORY "The index name" 'filebeat';

## Console output ##
defineEnvVar FILEBEAT_OUTPUT_CONSOLE_PRETTY MANDATORY "Whether to pretty print the json events" 'false';

## SHIPPER ##
defineEnvVar FILEBEAT_SHIPPER_TAGS MANDATORY "The tags of the shipper are included in their own field with each transaction published. Tags make it easy to group servers by different logical properties" '[]';
defineEnvVar FILEBEAT_SHIPPER_IGNORE_OUTGOING MANDATORY "Ignore transactions created by the server on which the shipper is installed. This option is useful to remove duplicates if shippers are installed on multiple servers" 'false';
defineEnvVar FILEBEAT_SHIPPER_REFRESH_TOPOLOGY_FREQ MANDATORY "How often (in seconds) shippers are publishing their IPs to the topology map. The default is 10 seconds" '10';
defineEnvVar FILEBEAT_SHIPPER_TOPOLOGY_EXPIRE MANDATORY "Expiration time (in seconds) of the IPs published by a shipper to the topology map. All the IPs will be deleted afterwards. Note, that the value must be higher than refresh_topology_freq. The default is 15 seconds" '15';
defineEnvVar FILEBEAT_SHIPPER_QUEUE_SIZE MANDATORY "Internal queue size for single events in processing pipeline" '1000';

## Logging ##
defineEnvVar FILEBEAT_LOG_TO_SYSLOG MANDATORY "Send all logging output to syslog. Default is true" 'true';
defineEnvVar FILEBEAT_ENABLE_LOGGING_TO_FILES MANDATORY "Whether to enable logging to files" "false";
defineEnvVar FILEBEAT_ROTATE_LOGS_EVERY_N_BYTES MANDATORY "The log file size limit" '10485760';  # = 10MB
defineEnvVar FILEBEAT_LOG_FILE_NAMES MANDATORY "The name of the files where the logs are written to" "mybeat";
defineEnvVar FILEBEAT_LOG_FILE_PATH MANDATORY "The directory where the log files will written to" '/var/log/${FILEBEAT_LOG_FILE_NAMES}';
defineEnvVar FILEBEAT_NUMBER_OF_ROTATED_LOG_FILES_TO_KEEP MANDATORY "Number of rotated log files to keep" '7';
defineEnvVar FILEBEAT_DEBUG_OUTPUT_SELECTORS MANDATORY "Enable debug output for selected components. To enable all selectors use [\"*\"] Other available selectors are beat, publish, service Multiple selectors can be chained" "selectors: [ ]";
defineEnvVar FILEBEAT_LOG_LEVEL MANDATORY "The log level. The default log level is error. Available log levels are: critical, error, warning, info, debug" 'error';

## Default prospector ##
defineEnvVar FILEBEAT_DEFAULT_PROSPECTOR_ENCODING MANDATORY "The file encoding for reading files" '${DEFAULT_ENCODING}';
defineEnvVar FILEBEAT_DEFAULT_PROSPECTOR_DOCUMENT_TYPE MANDATORY "Type to be published in the 'type' field. For Elasticsearch output, the type defines the document type these entries should be stored in. Default: log" 'filebeat-docker-logs';
defineEnvVar FILEBEAT_DEFAULT_PROSPECTOR_MAX_BYTES MANDATORY "Maximum number of bytes a single log event can have All bytes after max_bytes are discarded and not sent. The default is 10MB." '10485760';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
