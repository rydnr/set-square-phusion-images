#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME
$SCRIPT_NAME [-h|--help]
(c) 2015-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

Appends VOLUME folders declared in this image's dockerfiles, to
the rsnapshot configuration, for auto-configuring backup.

Common flags:
    * -h | --help: Display this message.
    * -v: Increase the verbosity.
    * -vv: Increase the verbosity further.
    * -q | --quiet: Be silent.
EOF
}

## Defines the errors
## dry-wit hook
function defineErrors() {
  export INVALID_OPTION="Unrecognized option";

  ERROR_MESSAGES=(\
    INVALID_OPTION \
  );

  export ERROR_MESSAGES;
}

## Validates the input.
## dry-wit hook
function checkInput() {

  local _flags=$(extractFlags $@);
  local _flagCount;
  local _currentCount;
  logDebug -n "Checking input";

  # Flags
  for _flag in ${_flags}; do
    _flagCount=$((_flagCount+1));
    case ${_flag} in
      -h | --help | -v | -vv | -q)
         shift;
         ;;
      *) logDebugResult FAILURE "failed";
         exitWithErrorCode INVALID_OPTION;
         ;;
    esac
  done

  logDebugResult SUCCESS "valid";
}

## Parses the input
## dry-wit hook
function parseInput() {

  local _flags=$(extractFlags $@);
  local _flagCount;
  local _currentCount;

  # Flags
  for _flag in ${_flags}; do
    _flagCount=$((_flagCount+1));
    case ${_flag} in
      -h | --help | -v | -vv | -q)
         shift;
         ;;
    esac
  done
}

## Process a Docker volume for backup.
## -> 1: The volume folder.
## <- RESULT: the rsnapshot.conf syntax for the folder.
## Example:
##   process_volume /var/lib/mysql
##   echo "${RESULT}" >> /etc/rsnapshot.conf
function process_volume() {
  local _volume="${1}";
  local _result;
  local _single=0;
  if [ "${_volume#[}" == "${_volume}" ]; then
    _single=0; # true, single
  else
    _single=1; # false, multiple
  fi
  if [ ${_single} -eq 0 ]; then
    _result="${_aux}"
  else
    local _oldIFS="${IFS}";
    IFS='"';
    for item in $(echo ${_aux} | tr -d '[],'); do
      IFS="${_oldIFS}";
      _result="${_result} $(echo ${item} | sed -e 's/^"//g' | sed -e 's/"$//g')"
    done
    _result="$(echo "${_result}" | sed -e 's/^ //g')";
  fi
  export RESULT="${_result}";
}

## Checks whether a volume is suitable of backup.
## -> 1: The volume
## <- RESULT: 0 if so, 1 otherwise.
## Example:
##   is_backup_volume "/var/log/" -> false
##   is_backup_volume "/backup/data" -> true
function is_backup_volume() {
  local _volume="${1}";
  local _result;
  if [ "x${_volume##/backup}" == "x${_volume}" ]; then
    _result=1;
  else
    result=0;
  fi
  return ${_result};
}

## Extracts the volumes from a given Dockerfile.
## -> 1: the Dockerfile.
## <- RESULT: the space-separated volumes.
## Example:
##   extract_volumes /Dockerfiles/Dockerfile
##   echo "Volumes found: ${RESULT}"
function extract_volumes() {
  local _dockerfile="${1}"
  local _result=();
  local _aux;
  local _single;
  local _oldIFS="${IFS}";
  IFS=$'\n';
  for _aux in $(grep VOLUME "${_dockerfile}" | cut -d' ' -f 2- | sed -e 's/^ \+//g'); do
    IFS="${_oldIFS}";
    if is_backup_volume "${_aux}"; then
      process_volume "${_aux}";
      for v in ${RESULT}; do
        _result[${#_result[@]}]="${v}";
      done
    fi
  done
  export RESULT=${_result[@]}
}

## Main logic
## dry-wit hook
function main() {
  local _suffix;
  local _destFolder;
  chmod -x /etc/my_init.d/*
  for s in $(ls /etc/service | grep -v sshd | grep -v syslog ); do
    rm -rf /etc/service/${s}
  done
  logInfoResult SUCCESS "done";
  logInfo -n "Enabling SSH";
  rm -f /etc/service/sshd/down
  chmod +x /etc/service/sshd/run
  export DISABLE_ALL=true
  export ENABLE_SSH=true
  logInfoResult SUCCESS "done";
  logInfo -n "Configuring SSH key";
  mkdir /backup/.ssh
  chmod 700 /backup/.ssh
  cat /etc/ssh/*.pub >> /backup/.ssh/authorized_keys2
  chmod 600 /backup/.ssh/authorized_keys2
  sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
  sed -i 's|^#AuthorizedKeysFile\(\s+\).ssh/authorized_keys|AuthorizedKeysFile .ssh/authorized_keys|g' /etc/ssh/sshd_config
  chown -R ${SQ_BACKUP_USER}:backup /backup
  logInfoResult SUCCESS "done";
  usermod -s /bin/bash ${SQ_BACKUP_USER}
  /sbin/my_init
}
