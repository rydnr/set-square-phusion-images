#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: base
# api: public
# txt: Creates symlinks for all cron jobs under /usr/local/bin folder

# fun: is_backup_enabled
# api: public
# txt: Checks whether backups are enabled as a whole.
# txt: Returns 0/TRUE if backups are enabled; 1 otherwise.
# use: if is_backup_enabled; then "backup is enabled"; fi
function is_backup_enabled() {
  local -i _rescode;

  _evalVar "${ENABLE_BACKUP_ENVIRONMENT_VARIABLE}";
  local _dobackup="${RESULT}";
  if isEmpty ${_dobackup}; then
    _rescode=${FALSE};
  else
    _rescode=${TRUE};
  fi

  return ${_rescode};
}

# fun: main
# api: public
# txt: Main logic.
# txt: Returns 0/TRUE always.
function main() {
  local _oldIFS;
  if is_backup_enabled; then
    _oldIFS="${IFS}";
    IFS="${DWIFS}";
    for period in hourly daily weekly monthly; do
      IFS="${_oldIFS}";
      logInfo -n "Enabling ${period} cron jobs";
      IFS="${DWIFS}";
      for f in /usr/local/bin/backup*.${period}; do
        IFS="${_oldIFS}";
        ln -sf ${f} /etc/cron.${period}/$(basename $f) 2> /dev/null;
      done
      IFS="${_oldIFS}";
      logInfoResult SUCCESS "done";
    done
    IFS="${_oldIFS}";
  else
    logInfo "Backup disabled for this image.";
  fi
}

setScriptDescription "Creates symlinks for all cron jobs under /usr/local/bin folder";

defineEnvVar ENABLE_BACKUP_ENVIRONMENT_VARIABLE OPTIONAL "undefined";
#
