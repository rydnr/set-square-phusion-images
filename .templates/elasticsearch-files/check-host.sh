#!/bin/bash dry-wit
# Copyright 2014-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: elasticsearch/00_check_host
# api: public
# txt: Checks the host satisfies mandatory requirements for ElasticSearch.

# fun: main
# api: public
# txt: Checks the host satisfies mandatory requirements for ElasticSearch.
# txt: Returns 0/TRUE always, unless the VM_MAX_MAP_COUNT value is too low.
function main() {
  local _maxMapCount;

  logInfo -n "Checking vm.max_map_count system value is at least 262144";
  _maxMapCount=$(sysctl vm.max_map_count | cut -d'=' -f 2 | tr -d ' ');
  if isTrue $?; then
    if isLessThan ${_maxMapCount} 262144; then
      logInfoResult FAILURE "${_maxMapCount}";
      exitWithErrorCode VM_MAX_MAP_COUNT_TOO_LOW ${_maxMapCount};
    else
      logInfoResult SUCCESS "${_maxMapCount}";
    fi
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode COULD_NOT_RETRIEVE_VM_MAX_MAP_COUNT;
  fi
}

## Script metadata and CLI options
setScriptDescription "Checks the host satisfies mandatory requirements for ElasticSearch.";
addError VM_MAX_MAP_COUNT_TOO_LOW "VM_MAX_MAP_COUNT value is too low";
addError COULD_NOT_RETRIEVE_VM_MAX_MAP_COUND "Could not read the value of vm.max_map_count";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
