#!/bin/bash

if [ "${ENABLE_LOG_STASH}" == "true" ]; then
  exec logstash agent -f /etc/logstash/conf.d/cron.conf
fi
