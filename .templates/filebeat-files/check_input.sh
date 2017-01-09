#!/bin/bash

grep "elasticsearch" /etc/hosts > /dev/null 2>&1
_elasticSearchEnabled=$?;

if [ ${_elasticSearchEnabled} -eq 0 ]; then
    curl -XPUT 'http://${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT}/_template/filebeat' -d@/etc/filebeat/filebeat.template.json
fi

grep "logstash" /etc/hosts > /dev/null 2>&1
_logstashEnabled=$?;

if [ ${_elasticSearchEnabled} -ne 0 ] && [ ${_logstashEnabled} -ne 0 ]; then
  echo "Neither ElasticSearch nor Logstash are enabled. Skipping filebeat"
  rm -rf /etc/service/filebeat
fi
