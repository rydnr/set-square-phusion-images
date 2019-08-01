#!/bin/bash

if    [ "${ENABLE_SYSLOG}" == "false" ] \
   || [ -n "${DISABLE_ALL}" ]; then
  rm -rf /etc/service/syslog-ng > /dev/null 2>&1
fi
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
