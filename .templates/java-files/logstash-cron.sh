#!/bin/bash

if [ "${ENABLE_LOG STASH}" == "true" ]; then
  exec logstash agent -f /etc/logstash/conf.d/cron.conf
fi
