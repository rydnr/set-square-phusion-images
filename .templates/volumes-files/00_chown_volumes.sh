#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

# fun: chown_volume
# api: public
# txt: Changes the ownership of a Docker volume specification.
# opt: user: The user.
# opt: group: The group.
# opt: folder: The volume folder.
# txt: Returns 0/TRUE if all volumes are processed successfully; 1/FALSE otherwise.
# use: if chown_volume mysql mysql /var/lib/mysql; then echo "Permissions on /var/lib/mysql changed successfully"; fi
function chown_volume() {
  local _user="${1}";
  local _group="${2}";
  local _volume="${3}";
  local -i _rescode=${TRUE};
  local _single;
  local _item;
  local _oldIFS;
  local _aux;

  checkNotEmpty "user" "${_user}" 1;
  checkNotEmpty "group" "${_group}" 2;
  checkNotEmpty "volume" "${_volume}" 3;

  if [ "${_volume#[}" == "${_volume}" ]; then
      _single=${TRUE};
  else
    _single=${FALSE};
  fi

  if isTrue ${_single}; then
    _volume="$(echo ${_volume} | sed 's ^"  g' | sed 's "$  g')";
    chown -R ${_user}:${_group} "${_volume}" > /dev/null 2>&1;
    _rescode=$?;
    if isFalse ${_rescode}; then
        export ERROR="$(chown -R ${_user}:${_group} "${_volume}" 2>&1)";
    fi
  else
    _oldIFS="${IFS}";
    IFS='"';
    for _item in $(echo ${_volume} | tr -d '[],'); do
      IFS="${_oldIFS}";
      _item="$(echo ${_item} | sed 's ^"  g' | sed 's "$  g')";
      chown -R ${_user}:${_group} "${_item}";
      _aux=$?;
      if isTrue ${_rescode}; then
          _rescode=${_aux};
      else
        export ERROR="$(chown -R ${_user}:${_group} "${_item}" 2>&1)";
      fi
    done
    IFS="${_oldIFS}";
  fi

  return ${_rescode};
}

# fun: process_volumes
# api: public
# txt: Processes the volumes from a given Dockerfile.
# opt: user: The user.
# opt: group: The group.
# opt: dockerfile: The Dockerfile.
# txt: Returns 0/TRUE always.
# use: process_volumes mysql mysql /Dockerfiles/Dockerfile
function process_volumes() {
  local _user="${1}";
  local _group="${2}";
  local _dockerfile="${3}";
  local _aux;
  local _item;
  local _volumes;

  checkNotEmpty "user" "${_user}" 1;
  checkNotEmpty "group" "${_group}" 2;
  checkNotEmpty "dockerfile" "${_dockerfile}" 3;

  grep -e '^\s*VOLUME\s' "${_dockerfile}" > /dev/null 2>&1
  if isTrue $?; then
      local _oldIFS="${IFS}";
      IFS=$'\n';
      _volumes="$(grep -e '^\s*VOLUME\s' "${_dockerfile}" 2> /dev/null | cut -d' ' -f 2- | sed -e 's/^ \+//g')";
      _volumes="$(echo ${_volumes} | tr -d '[' | tr -d ']' | tr -d ',' | tr -d '\"')";
      for _aux in ${_volumes}; do
        IFS=$' ';
        for _entry in ${_aux}; do
          IFS="${_oldIFS}";
          logInfo -n "Changing the ownership of ${_entry} to ${_user}/${_group} (from ${DOCKERFILES_LOCATION}/${p})";
          chown_volume "${_user}" "${_group}" "${_entry}";
          logInfoResult SUCCESS "done";
        done
        IFS="${_oldIFS}";
      done
      IFS="${_oldIFS}";
  fi
}

# fun: main
# api: public
# txt:  Main logic
# txt: Returns 0/TRUE always.
# use: main
function main() {
  local _user="${SERVICE_USER}";
  if isEmpty "${SERVICE_USER}"; then
    logInfo "SERVICE_USER environment variable not found. Assuming root.";
    _user="root";
  fi
  local _group="${SERVICE_GROUP}";
  if isEmpty "${SERVICE_GROUP}"; then
    logInfo "SERVICE_GROUP environment variable not found. Assuming ${_user}.";
    _group="${_user}";
  fi
  for p in $(ls ${DOCKERFILES_LOCATION} | grep -v -e '^Dockerfile'); do
    process_volumes "${_user}" "${_group}" "${DOCKERFILES_LOCATION}/${p}";
  done
}

## Script metadata and CLI settings.

setScriptDescription "Changes the ownership of all declared volumes."
