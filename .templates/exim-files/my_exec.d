#!/bin/bash

if    [ "${ENABLE_LOCAL_SMTP}" == "false" ] \
   || [ -n "${DISABLE_ALL}" ]; then
  rm -rf /etc/service/exim4
fi
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
