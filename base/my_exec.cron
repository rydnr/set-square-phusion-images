#!/bin/bash

if    [ "${ENABLE_CRON}" == "false" ] \
   || [ -n "${DISABLE_ALL}" ]; then
  rm -rf /etc/service/cron > /dev/null 2>&1
fi
