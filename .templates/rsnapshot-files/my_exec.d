#!/bin/bash

if    [ "${ENABLE_RSNAPSHOT}" == "false" ] \
   || [ -n "${DISABLE_ALL}" ]; then
  rm -f /etc/cron.*/rsnapshot* > /dev/null 2>&1
  rm -f /etc/my_init.d/*rsnapshot* > /dev/null 2>&1
fi
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
