#!/bin/bash

if [ -n "$1" ] && [ "$1" == "install" ]; then
  /usr/local/bin/process-file.sh -o /INSTALL /usr/local/share/INSTALL.tmpl
else
  /usr/local/bin/help.base.sh
fi
