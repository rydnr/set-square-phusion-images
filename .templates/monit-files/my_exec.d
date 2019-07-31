#!/bin/bash

if    [ "${ENABLE_MONIT}" == "false" ] \
   || [ -n "${DISABLE_ALL}" ]; then
  rm -rf /etc/service/monit > /dev/null 2>&1
  rm -f /etc/my_init.d/*monit*.sh > /dev/null 2>&1
fi
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
