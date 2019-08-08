#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: backup/backup
# api: public
# txt: Appends VOLUME folders declared in this image's dockerfiles, to the rsnapshot configuration, for auto-configuring backup.

# fun: main
# api: public
# txt: Appends VOLUME folders declared in this image's dockerfiles, to the rsnapshot configuration, for auto-configuring backup.
# txt: Returns 0/TRUE always, unless an error is thrown.
# use: main
function main() {
  local _suffix;
  local _destFolder;
  local s;
  local _oldIFS="${IFS}";

  logInfo -n "Disabling services";
  chmod -x /etc/my_init.d/*;
  IFS="${DWIFS}";
  for s in $(ls /etc/service | grep -v sshd | grep -v syslog ); do
    IFS="${_oldIFS}";
    rm -rf /etc/service/${s};
  done
  IFS="${_oldIFS}";
  logInfoResult SUCCESS "done";

  logInfo -n "Enabling SSH";
  rm -f /etc/service/sshd/down;
  chmod +x /etc/service/sshd/run;
  export DISABLE_ALL=true;
  export ENABLE_SSH=true;
  export VIRTUAL_HOST="";
  logInfoResult SUCCESS "done";

  logInfo -n "Configuring SSH key";
  mkdir /backup/.ssh;
  chmod 700 /backup/.ssh;
  cat /etc/ssh/*.pub >> /backup/.ssh/authorized_keys2;
  chmod 600 /backup/.ssh/authorized_keys2;
  sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config;
  sed -i 's|^#AuthorizedKeysFile\(\s+\).ssh/authorized_keys|AuthorizedKeysFile .ssh/authorized_keys|g' /etc/ssh/sshd_config;
  chown -R ${SQ_BACKUP_USER}:${SQ_BACKUP_GROUP} /backup;
  logInfoResult SUCCESS "done";
  usermod -s /bin/bash ${SQ_BACKUP_USER};
  /sbin/my_init;
}

# fun: process_volume
# api: public
# txt: Process a Docker volume for backup.
# opt: volume: The volume folder.
# txt: Returns 0/TRUE if the volume is processed successfully; 1/FALSE otherwise.
# txt: If the function returns 0/TRUE, the variable RESULT contains the rsnapshot.conf syntax for the folder.
# use: if process_volume /var/lib/mysql; then echo "${RESULT}" >> /etc/rsnapshot.conf; fi
function process_volume() {
  local _volume="${1}";
  local _result;
  local item;
  local -i _rescode;
  local -i _single=${TRUE};
  local _oldIFS="${IFS}";

  checkNotEmpty volume "${_volume}" 1;

  if startsWith "${_volume}" "["; then
    _single=${TRUE}; # single
  else
    _single=${FALSE}; # multiple
  fi

  if isTrue ${_single}; then
    _result="${_aux}"
  else
    IFS='"';
    for item in $(echo ${_aux} | tr -d '[],'); do
      IFS="${_oldIFS}";
      _result="${_result} $(echo ${item} | sed -e 's/^"//g' | sed -e 's/"$//g')";
      _rescode=$?;
    done
    IFS="${_oldIFS}";
    _result="$(echo "${_result}" | sed -e 's/^ //g')";
    _rescode=$?;
  fi

  if isTrue ${_rescode} && isNotEmpty "${_result}"; then
    export RESULT="${_result}";
  fi

  return ${_rescode};
}

# fun: is_backup_volume
# api: public
# txt: Checks whether a volume is suitable of backup.
# opt: volume: The volume.
# txt: Returns 0/TRUE if the volume is affected by backup; 1/FALSE otherwise.
# use: Assert.isFalse is_backup_volume "/var/log/"
# use: Assert.isTrue is_backup_volume "/backup/data"
function is_backup_volume() {
  local _volume="${1}";
  local -i _rescode;

  checkNotEmpty volume "${_volume}" 1;

  if startsWith "${_volume}" "/backup"; then
    _recode=${TRUE};
  else
    rescode=${FALSE};
  fi

  return ${_rescode};
}

# fun: extract_volumes
# api: public
# txt: Extracts the volumes from a given Dockerfile.
# opt: dockerfile: the Dockerfile.
# txt: Returns 0/TRUE if the volumes could be extracted from the Dockerfile; 1/FALSE otherwise.
# txt: If the function returns 0/TRUE, the variable RESULT contains the space-separated volumes.
# use: if extract_volumes /Dockerfiles/Dockerfile; then echo "Volumes found: ${RESULT}"; fi
function extract_volumes() {
  local _dockerfile="${1}";
  local -i _rescode;
  local -A _result=();
  local _aux;
  local _v;
  local _oldIFS="${IFS}";

  checkNotEmpty dockerfile "${_dockerfile}" 1;

  IFS=$'\n';
  for _aux in $(grep VOLUME "${_dockerfile}" | cut -d' ' -f 2- | sed -e 's/^ \+//g'); do
    IFS="${_oldIFS}";
    if is_backup_volume "${_aux}"; then
      if process_volume "${_aux}"; then
        _rescode=${TRUE};
        for _v in ${RESULT}; do
          _result[${#_result[@]}]="${_v}";
        done
      else
        _rescode=${FALSE};
        break;
      fi
    fi
  done
  IFS="${_oldIFS}";

  if isTrue ${_rescode}; then
    export RESULT="${_result[@]}";
  fi

  return ${_rescode};
}

## Script metadata and CLI options
setScriptDescription "Appends VOLUME folders declared in this image's dockerfiles, to the rsnapshot configuration, for auto-configuring backup.";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
