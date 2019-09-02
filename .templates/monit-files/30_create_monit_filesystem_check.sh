#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: monit/30_create_monit_filesystem_check.sh
# api: public
# txt: Creates Monit configuration to check disk usage for the root partition.

# fun: retrieve_root_path
# api: public
# txt: Retrieves the root path.
# txt: Returns 0/TRUE always, but it can exit with CANNOT_FIND_OUT_THE_DEVICE_FOR_THE_ROOT_FILESYSTEM.
# txt: The variable RESULT contains the device where the root filesystem is stored.
# use: retrieve_root_path; echo "The root filesystem is in ${RESULT}";
function retrieve_root_path() {
  local _result;

  logInfo -n "Finding out where the root filesystem is";
  _result="$(mount 2> /dev/null | grep ' on / ' | cut -d' ' -f1)";
  if isNotEmpty "${_result}"; then
    logInfoResult SUCCESS "done";
    export RESULT="${_result}";
  else
    logInfoResult FAILED "failed";
    exitWithErrorCode CANNOT_FIND_OUT_THE_DEVICE_FOR_THE_ROOT_FILESYSTEM;
  fi
}

# fun: main
# api: public
# txt: Creates Monit configuration to check disk usage for the root partition.
# txt: Returns 0/TRUE always.
# use: main
function main() {
  local _rootPath;
  retrieve_root_path;
  _rootPath="${RESULT}";

  logInfo -n "Creating monit check for root filesystem";
  cat <<EOF > ${MONIT_CONF_FILE}
check filesystem rootDisk with path / #(${_rootPath})
	if space usage > ${DISK_SPACE_THRESHOLD} for ${DISK_SPACE_POSITIVES} times within ${DISK_SPACE_CYCLES} cycles then alert
	if inode usage > ${INODE_USAGE_THRESHOLD} for ${INODE_USAGE_POSITIVES} times within ${INODE_USAGE_CYCLES} cycles then alert
EOF
  logInfoResult SUCCESS "done";
}

## Script metadata and CLI options
setScriptDescription "Creates Monit configuration to check disk usage for the root partition"
checkReq cut;
checkReq mount;
addError CANNOT_FIND_OUT_THE_DEVICE_FOR_THE_ROOT_FILESYSTEM "Cannot find out the device for the root filesystem";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
