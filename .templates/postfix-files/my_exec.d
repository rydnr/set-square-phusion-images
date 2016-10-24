#!/bin/bash

if    [ "${ENABLE_LOCAL_SMTP}" == "false" ] \
   || [ -n "${DISABLE_ALL}" ]; then
  rm -rf /etc/service/postfix
fi
