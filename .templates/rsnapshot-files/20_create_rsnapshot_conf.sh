#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: 20_create_rsnapshot_conf
# api: public
# txt: Creates rsnapshot.conf files based on the declared volumes in the Dockerfile.

# fun: process_volume
# api: public
# txt: Process a Docker volume for backup.
# opt: volume: The volume folder.
# txt: Returns 0/TRUE always.
# txt: The variable RESULT contains the rsnapshot.conf syntax for the volume.
# use: process_volume /var/lib/mysql; echo "${RESULT}" >> /etc/rsnapshot.conf
function process_volume() {
  local _volume="${1}";
  local _result;
  local _single=${TRUE};

  checkNotEmpty volume "${_volume}" 1;

  if [ "${_volume#[}" == "${_volume}" ]; then
    _single=${TRUE}; # true, single
  else
    _single=${FALSE}; # false, multiple
  fi

  if isTrue ${_single}; then
    _result="${_aux}";
  else
    local _oldIFS="${IFS}";
    IFS='"';
    for item in $(echo ${_aux} | tr -d '[],'); do
      IFS="${_oldIFS}";
      _result="${_result} $(echo ${item} | sed -e 's/^"//g' | sed -e 's/"$//g')"
    done
    IFS="${_oldIFS}";
    _result="$(echo "${_result}" | sed -e 's/^ //g')";
  fi

  export RESULT="${_result}";
}

# fun: is_backup_volume
# api: public
# txt: Checks whether a volume is suitable of backup (it belongs to the /backup subtree).
# opt: volume: The volume.
# txt: Returns 0/TRUE if the volume is suitable of backup; 1/FALSE otherwise.
# use: is_backup_volume "/var/log/" # false
# use: is_backup_volume "/backup/data" # true
function is_backup_volume() {
  local _volume="${1}";
  local -i _rescode;

  checkNotEmpty volume "${_volume}" 1;

  if startsWith "${_volume}" "/backup"; then
    _rescode=${FALSE};
  else
    _rescode=${TRUE};
  fi

  return ${_rescode};
}

# fun: extract_volumes
# api: public
# txt: Extracts the volumes from a given Dockerfile.
# opt: dockerfile: The Dockerfile.
# txt: Returns 0/TRUE always.
# txt: The variable RESULT contains the space-separated volumes.
# use: extract_volumes /Dockerfiles/Dockerfile; echo "Volumes found: ${RESULT}";
function extract_volumes() {
  local _dockerfile="${1}"
  local -a _result=();
  local _aux;
  local _single;
  local _oldIFS="${IFS}";

  checkNotEmpty dockerfile "${_dockerfile}" 1;

  IFS="${DWIFS}";
  for _aux in $(grep VOLUME "${_dockerfile}" | grep -v 'VOLUMES' | grep -v 'VOLUMEs' | cut -d' ' -f 2- | sed -e 's/^ \+//g'); do
    IFS="${_oldIFS}";
    if is_backup_volume "${_aux}"; then
      process_volume "${_aux}";
      for v in ${RESULT}; do
        _result[${#_result[@]}]="${v}";
      done
    fi
  done
  IFS="${_oldIFS}";

  export RESULT=${_result[@]};
}

# fun: is_backup_enabled
# api: public
# txt: Checks whether backups are enabled as a whole.
# txt: Returns 0/TRUE in such case; 1/FALSE otherwise.
# use: if is_backup_enabled; then echo "backup enabled"; fi
function is_backup_enabled() {
  local -i _rescode;

  evalVar "${ENABLE_BACKUP_ENVIRONMENT_VARIABLE}";
  local _dobackup="${RESULT}";
  if isEmpty "${_doBackup}" && isTrue "${_doBackup}"; then
    _rescode=${TRUE};
  else
    rescode=${FALSE};
  fi

  return ${_rescode};
}

# fun: main
# api: public
# txt: Checks if backup is enabled, extracts the volumes from the dockerfiles, and generates the rsnapshot.conf file.
# txt: Returns 0/TRUE always.
# use: main
function main() {
  local _oldIFS="${IFS}";
  local p;
  local v;
  local f;

  if is_backup_enabled; then
    sed -i -e 's/^backup/#backup/g' ${RSNAPSHOT_CONF};

    IFS="${DWIFS}";
    for p in $(ls ${DOCKERFILES_LOCATION} | grep -v -e '^Dockerfile'); do
      IFS="${_oldIFS}";

      extract_volumes "${DOCKERFILES_LOCATION}/${p}";

      IFS="${DWIFS}";
      for v in ${RESULT}; do
        IFS="${_oldIFS}";

        logInfo -n "Annotating ${v} for backup (defined as volume in ${DOCKERFILES_LOCATION}/${p})";

        IFS="${DWIFS}";
        for f in ${CUSTOM_BACKUP_SCRIPTS_FOLDER}/${CUSTOM_BACKUP_SCRIPT_PREFIX}*; do
          IFS="${_oldIFS}";

          if [ -x "$f" ]; then
                 grep -e "^backup"$'\t'"${v}"$'\t'"$(hostname)" ${RSNAPSHOT_CONF} > /dev/null \
              || echo "backup"$'\t'"${v}"$'\t'"$(hostname)" >> ${RSNAPSHOT_CONF}
          fi
        done
        IFS="${_oldIFS}";
        logInfoResult SUCCESS "done";
      done
      IFS="${_oldIFS}";
    done
    IFS="${_oldIFS}";

  else
    logInfo "Backup disabled for this image.";
  fi
}

## Script metadata
setScriptDescription "Appends VOLUME folders declared in this image's dockerfiles, to
the rsnapshot configuration, for auto-configuring backup.";


# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
