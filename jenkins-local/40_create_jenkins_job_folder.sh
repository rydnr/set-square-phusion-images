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
  export JENKINS_HOME_FOLDER_IS_NOT_SPECIFIED="Home folder is not specified. Define JENKINS_HOME environment variable";
  export JENKINS_HOME_FOLDER_DOES_NOT_EXIST="Workspace folder ${JENKINS_HOME} does not exist";
  export JENKINS_HOME_IS_NOT_A_FOLDER="${JENKINS_HOME} not a folder";
  export CANNOT_READ_JENKINS_HOME_FOLDER="Cannot read folder ${JENKINS_HOME}";
  export CANNOT_ACCESS_JENKINS_HOME_FOLDER="Cannot access folder ${JENKINS_HOME}";
  export CANNOT_CREATE_JOB_FOLDER="Cannot create job folder in ${JENKINS_HOME}";

  ERROR_MESSAGES=(\
    INVALID_OPTION \
    JENKINS_HOME_FOLDER_IS_NOT_SPECIFIED \
    JENKINS_HOME_FOLDER_DOES_NOT_EXIST \
    JENKINS_HOME_IS_NOT_A_FOLDER \
    CANNOT_READ_JENKINS_HOME_FOLDER \
    CANNOT_ACCESS_JENKINS_HOME_FOLDER \
    CANNOT_CREATE_JOB_FOLDER \
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

## Main logic
## dry-wit hook
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
