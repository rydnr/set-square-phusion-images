#!/bin/bash

if [ -n "$1" ] && [ "$1" == "install" ]; then
  cat /tmp/INSTALL
else
  /usr/local/bin/help.base.sh
fi
