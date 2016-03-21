#!/bin/bash

_type=".${0#ssh-}";
if [ "${_type}" == ".private" ]; then
  _type="";
else
  _type=".pub";
fi

_format="${1:-dsa}";

if [ -e /etc/ssh/ssh_host_${_format}_key${_type} ]; then
  cat /etc/ssh/ssh_host_${_format}_key${_type};
else
  echo "/etc/ssh/ssh_host_${_format}_key${_type} not found";
fi
