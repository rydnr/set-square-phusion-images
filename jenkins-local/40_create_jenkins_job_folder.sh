#!/bin/env dry-wit
# Copyright 2016-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

setScriptDescription "Creates a Jenkins job for a given Jenkinsfile.";

# fun: main
# api: public
# txt: main function. dry-wit hook.
# txt: Returns 0/TRUE always, but can exit if an error occurs.
# use: main;
function main() {
  local _jobHome="/var/jenkins_home/jobs/project";
  local _config="${_jobHome}/config.xml";
  mkdir -p "${_jobHome}";

  cat <<EOF > ${_config}
<?xml version='1.0' encoding='UTF-8'?>
<flow-definition plugin="workflow-job@2.1">
  <actions/>
  <description></description>
  <keepDependencies>false</keepDependencies>
  <properties/>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition" plugin="workflow-cps@2.2">
    <script>
EOF
  cat ${JENKINSFILE} >> ${_config}
  cat <<EOF >> ${_config}
</script>
    <sandbox>false</sandbox>
  </definition>
  <triggers/>
</flow-definition>
EOF

  ln -s ${WORKSPACE} ${_jobHome}/workspace;
}

addError JENKINS_HOME_FOLDER_IS_NOT_SPECIFIED "Home folder is not specified. Define JENKINS_HOME environment variable";
addError JENKINS_HOME_FOLDER_DOES_NOT_EXIST "Workspace folder ${JENKINS_HOME} does not exist";
addError JENKINS_HOME_IS_NOT_A_FOLDER "${JENKINS_HOME} not a folder";
addError CANNOT_READ_JENKINS_HOME_FOLDER "Cannot read folder ${JENKINS_HOME}";
addError CANNOT_ACCESS_JENKINS_HOME_FOLDER "Cannot access folder ${JENKINS_HOME}";
addError CANNOT_CREATE_JOB_FOLDER "Cannot create job folder in ${JENKINS_HOME}";

function dw_check_workspace_cli_envvar() {
  if isEmpty "${WORKSPACE}"; then
    exitWithErrorCode WORKSPACE_FOLDER_IS_NOT_SPECIFIED;
  fi
  if ! fileExists "${WORKSPACE}"; then
    exitWithErrorCode WORKSPACE_FOLDER_DOES_NOT_EXIST;
  fi
  if ! folderExists "${WORKSPACE}"; then
    exitWithErrorCode WORKSPACE_IS_NOT_A_FOLDER;
  fi
  if ! fileIsReadable "${WORKSPACE}"; then
    exitWithErrorCode CANNOT_READ_WORKSPACE_FOLDER;
  fi
  if ! isExecutable "${WORKSPACE}"; then
    exitWithErrorCode CANNOT_ACCESS_WORKSPACE_FOLDER;
  fi
}

function dw_check_jenkinsfile_cli_envvar() {
  if isEmpty "${JENKINSFILE}"; then
    exitWithErrorCode JENKINSFILE_IS_NOT_SPECIFIED;
  fi
  if ! fileExists "${JENKINSFILE}"; then
    exitWithErrorCode JENKINSFILE_DOES_NOT_EXIST;
  fi
  if ! fileIsReadable "${JENKINSFILE}"; then
    exitWithErrorCode CANNOT_READ_JENKINSFILE;
  fi
}
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
