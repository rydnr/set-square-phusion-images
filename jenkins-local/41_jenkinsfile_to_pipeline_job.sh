#!/bin/bash dry-wit
# Copyright 2016-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME
$SCRIPT_NAME [-h|--help]
(c) 2016-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

Creates a Jenkins job for a given Jenkinsfile.

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
  export WORKSPACE_FOLDER_IS_NOT_SPECIFIED="Workspace folder is not specified. Define WORKSPACE environment variable";
  export WORKSPACE_FOLDER_DOES_NOT_EXIST="Workspace folder ${WORKSPACE} does not exist";
  export WORKSPACE_IS_NOT_A_FOLDER="${WORKSPACE} is not a folder";
  export CANNOT_READ_WORKSPACE_FOLDER="Cannot read folder ${WORKSPACE}";
  export CANNOT_ACCESS_WORKSPACE_FOLDER="Cannot access folder ${WORKSPACE}";
  export JENKINSFILE_IS_NOT_SPECIFIED="Jenkinsfile is not specified. Define JENKINSFILE environment variable";
  export JENKINSFILE_DOES_NOT_EXIST="${JENKINSFILE} does not exist";
  export CANNOT_READ_JENKINSFILE="Cannot read ${JENKINSFILE}";

  ERROR_MESSAGES=(\
    INVALID_OPTION \
    WORKSPACE_FOLDER_IS_NOT_SPECIFIED \
    WORKSPACE_FOLDER_DOES_NOT_EXIST \
    WORKSPACE_IS_NOT_A_FOLDER \
    CANNOT_READ_WORKSPACE_FOLDER \
    CANNOT_ACCESS_WORKSPACE_FOLDER \
    JENKINSFILE_IS_NOT_SPECIFIED \
    JENKINSFILE_DOES_NOT_EXIST \
    CANNOT_READ_JENKINSFILE \
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

  if [[ -z "${WORKSPACE}" ]]; then
    exitWithErrorCode WORKSPACE_FOLDER_IS_NOT_SPECIFIED;
  fi
  if [[ ! -e "${WORKSPACE}" ]]; then
    exitWithErrorCode WORKSPACE_FOLDER_DOES_NOT_EXIST;
  fi
  if [[ ! -d "${WORKSPACE}" ]]; then
    exitWithErrorCode WORKSPACE_IS_NOT_A_FOLDER;
  fi
  if [[ ! -r "${WORKSPACE}" ]]; then
    exitWithErrorCode CANNOT_READ_WORKSPACE_FOLDER;
  fi
  if [[ ! -x "${WORKSPACE}" ]]; then
    exitWithErrorCode CANNOT_ACCESS_WORKSPACE_FOLDER;
  fi
  if [[ -z "${JENKINSFILE}" ]]; then
    exitWithErrorCode JENKINSFILE_IS_NOT_SPECIFIED;
  fi
  if [[ ! -e "${JENKINSFILE}" ]]; then
    exitWithErrorCode JENKINSFILE_DOES_NOT_EXIST;
  fi
  if [[ ! -r "${JENKINSFILE}" ]]; then
    exitWithErrorCode CANNOT_READ_JENKINSFILE;
  fi

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

## Retrieves the name of the job.
## <- RESULT: such name.
## Example:
##   retrieve_job_name;
##   echo "Job name: ${RESULT}";
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

## Main logic
## dry-wit hook
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
