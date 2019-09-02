#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: backup/backup-volumes
# api: public
# txt: Backs up VOLUMEs defined in the Dockerfiles.

# fun: main
# api: public
# txt: Backs up VOLUMEs defined in the Dockerfiles.
# txt: Returns 0/TRUE if the VOLUMEs are backed up successfully; 1/FALSE otherwise.
# use: main
function main() {
  local p;
  local -i _rescode;

  if isFalse "${DOBACKUP}"; then
    logDebug "Backup disabled";
  else
    for p in $(ls ${DOCKERFILES_LOCATION} | grep -v -e '^Dockerfile'); do
      process_volumes "${DOCKERFILES_LOCATION}/${p}";
      _rescode=$?;
      if isFalse ${_rescode}; then
        exitWithErrorCode CANNOT_BACKUP_VOLUME_IN_DOCKERFILE "${DOCKERFILES_LOCATION}/${pe;}"
      fi
    done
  fi
}

# fun: process_volumes
# api: public
# txt: Processes the volumes from a given Dockerfile.
# opt: dockerfile: The Dockerfile.
# txt: Returns 0/TRUE if the volumes are processed successfully, but it can throw an error if any of them don't.
# use: if process_volumes /Dockerfiles/Dockerfile; then echo "Volumes processed successfully"; fi
function process_volumes() {
  local _dockerfile="${1}";
  local _aux;
  local _single;
  local -i _rescode;
  local _oldIFS="${IFS}";

  grep -e '^\s*VOLUME\s' "${_dockerfile}" > /dev/null 2>&1
  _rescode=$?;

  if isTrue ${_rescode}; then
    IFS=$'\n';
    for _aux in $(grep -e '^\s*VOLUME\s' "${_dockerfile}" 2> /dev/null | cut -d' ' -f 2- | sed -e 's/^ \+//g'); do
      IFS="${_oldIFS}";
      logInfo -n "Backing up ${_aux} to ${SQ_IMAGE}-backup";
      /usr/local/bin/backup-folder.sh "${_aux}" "${_aux}";
      _rescode=$?;
      if isTrue ${_rescode}; then
        logInfoResult SUCCESS "done";
      else
        logInfoResult SUCCESS "failed";
      fi
    done
    IFS="${_oldIFS}";
  else
    _rescode=${TRUE};
  fi

  return ${_rescode};
}

## Script metadata and CLI options
setScriptDescription "Backs up VOLUMEs defined in the Dockerfiles.";
addError CANNOT_BACKUP_VOLUME_IN_DOCKERFILE "Could not backup a VOLUME in ";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
