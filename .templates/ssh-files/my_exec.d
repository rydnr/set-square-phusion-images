#!/bin/bash

if    [ "${ENABLE_SSH}" == "false" ] \
   || [ -n "${DISABLE_ALL}" ]; then
  rm -rf /etc/service/sshd
fi
