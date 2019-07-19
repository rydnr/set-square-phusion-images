#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

# fun: is_backup_enabled
# api: public
# txt: Checks whether backups are enabled as a whole.
# txt: Returns 0/TRUE if backups are enabled; 1 otherwise.
# use: if is_backup_enabled; then "backup is enabled"; fi
function is_backup_enabled() {
  local -i _result;
  _evalVar "${ENABLE_BACKUP_ENVIRONMENT_VARIABLE}";
  local _dobackup="${RESULT}";
  if [ -z ${_dobackup+x} ]; then
    _result=${TRUE};
  else
    result=${FALSE};
  fi
  return ${_result};
}

# fun: main
# api: public
# txt: Main logic.
# txt: Returns 0/TRUE always.
function main() {
  if is_backup_enabled; then
    for period in hourly daily weekly monthly; do
      logInfo -n "Enabling ${period} cron jobs";
      for f in /usr/local/bin/backup*.${period}; do
        ln -sf ${f} /etc/cron.${period}/$(basename $f) 2> /dev/null;
      done
      logInfoResult SUCCESS "done";
    done
  else
    logInfo "Backup disabled for this image.";
  fi
}

setScriptDescription "Creates symlinks for all cron jobs under /usr/local/bin folder";
addError INVALID_OPTION "Unrecognized option";
#
