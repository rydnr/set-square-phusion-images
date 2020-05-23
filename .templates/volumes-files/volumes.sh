#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

# fun: list_volumes
# api: public
# txt: Lists the volumes from a given Dockerfile.
# opt: dockerfile: The Dockerfile.
# txt: Returns 0/TRUE always.
# use: list_volumes /Dockerfiles/Dockerfile;
function list_volumes() {
  local _dockerfile="${1}";
  local _aux;
  local _single;

  grep -e '^\s*VOLUME\s' "${_dockerfile}" > /dev/null 2>&1
  if isTrue $?; then
    local _oldIFS="${IFS}";
    IFS="${DWIFS}";
    for _volume in $(grep -e '^\s*VOLUME\s' "${_dockerfile}" 2> /dev/null | cut -d' ' -f 2- | sed -e 's/^ \+//g'); do
      IFS="${_oldIFS}";
      logDebug "${_volume} (from ${DOCKERFILES_LOCATION}/${p})";
      echo "${_aux}";
    done
    IFS="${_oldIFS}";
  fi
}

# fun: main
# api: public
# txt: Main logic.
# txt: Returns 0/TRUE always.
# use: main;
function main() {
  local p;
  local _oldIFS="${IFS}";
  IFS="${DWIFS}";
  for p in $(ls ${DOCKERFILES_LOCATION} | grep -v -e '^Dockerfile'); do
    IFS="${_oldIFS}";
    list_volumes "${DOCKERFILES_LOCATION}/${p}";
  done
  IFS="${_oldIFS}";
}

## Script metadata and CLI settings.

setScriptDescription "Lists all volumes defined in this image (including ancestors')";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
