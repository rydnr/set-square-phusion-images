#!/bin/bash dry-wit
# Copyright 2017-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

setScriptDescription "Copies the latest changes in Jenkins configurations so that they survive restarts.";

## Main logic
## dry-wit hook
function main() {

  rsync -az --exclude '.sdkman/*' ${JENKINS_HOME}/ ${BACKUP_FOLDER}/
}
#
