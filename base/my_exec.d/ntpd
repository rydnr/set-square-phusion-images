#!/bin/bash

if    [ "${ENABLE_NTP}" == "false" ] \
   || [ -n "${DISABLE_ALL}" ]; then
  rm -rf /etc/service/ntpd > /dev/null 2>&1
  rm -f /etc/my_init.d/*ntp*.sh > /dev/null 2>&1
fi
