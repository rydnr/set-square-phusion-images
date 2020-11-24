#!/bin/env dry-wit
# Copyright 2016-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

setScriptDescription "Creates a Jenkins job for a given Jenkinsfile.";

addError WORKSPACE_FOLDER_IS_NOT_SPECIFIED "Workspace folder is not specified. Define WORKSPACE environment variable";
addError WORKSPACE_FOLDER_DOES_NOT_EXIST "Workspace folder ${WORKSPACE} does not exist";
addError WORKSPACE_IS_NOT_A_FOLDER "${WORKSPACE} is not a folder";
addError CANNOT_READ_WORKSPACE_FOLDER "Cannot read folder ${WORKSPACE}";
addError CANNOT_ACCESS_WORKSPACE_FOLDER "Cannot access folder ${WORKSPACE}";
addError JENKINSFILE_IS_NOT_SPECIFIED "Jenkinsfile is not specified. Define JENKINSFILE environment variable";
addError JENKINSFILE_DOES_NOT_EXIST "${JENKINSFILE} does not exist";
addError CANNOT_READ_JENKINSFILE "Cannot read ${JENKINSFILE}";

# fun: main
# api: public
# txt: main function. dry-wit hook.
# txt: Returns 0/TRUE always, but can exit if an error occurs.
# use: main;
function main() {
  retrieve_job_name;
  local _jobName="${RESULT}";
  local _jobHome="${JOBS_FOLDER}/${_jobName}";
  local _config="${_jobHome}/config.xml";

  logDebug -n "Creating job folder ${_jobHome}";
  mkdir -p "${_jobHome}";
  if [ $? -eq 0 ]; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
  fi

  logInfo -n "Creating job definition file ${_config}";
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
  cat ${JENKINSFILE} | grep -v 'scm ' >> ${_config}
  cat <<EOF >> ${_config}
</script>
    <sandbox>false</sandbox>
  </definition>
  <triggers>
    <org.jvnet.hudson.plugins.triggers.startup.HudsonStartupTrigger plugin="startup-trigger-plugin@2.5">
      <spec></spec>
      <quietPeriod>0</quietPeriod>
    </org.jvnet.hudson.plugins.triggers.startup.HudsonStartupTrigger>
  </triggers></flow-definition>
EOF
  if [ $? -eq 0 ]; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
  fi

  logDebug -n "Creating symlink ${_jobHome}/workspace -> ${WORKSPACE}";
  ln -s ${WORKSPACE} ${_jobHome}/workspace;
  if [ $? -eq 0 ]; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
  fi

  logInfo -n "Fixing permissions of ${_jobHome}";
  chown -R ${SERVICE_USER}:${SERVICE_GROUP} ${JENKINS_HOME} ${_jobHome};
  if [ $? -eq 0 ]; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
  fi
}

# fun: retrieve_job_name
# api: public
# txt: Retrieves the name of the job.
# txt: Returns 0/TRUE always.
# txt: The variable RESULT contains the job name.
# use: retrieve_job_name; echo "Job name: ${RESULT}";
function retrieve_job_name() {
  local _result;

  if [ -e ${WORKSPACE}/.prjname ]; then
    _result="$(cat ${WORKSPACE}/.prjname)";
  fi

  if [ -z "${_result}" ]; then
    _result="${DEFAULT_PROJECT_NAME:-project}";
  fi

  export RESULT="${_result}";
}

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
