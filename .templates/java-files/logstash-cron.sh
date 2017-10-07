#!/bin/bash

if [ "${ENABLE_LOG_STASH}" == "true" ]; then
    exec /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/cron.conf
fi
