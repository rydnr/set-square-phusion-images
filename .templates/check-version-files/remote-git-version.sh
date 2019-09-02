#!/bin/bash dry-wit
# Copyright 2016-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: check-version/remote-git-version
# api: public
# txt: Retrieves the latest version of a remote git repository, either cloned locally or using its URL.

setScriptDescription "Retrieves the latest version of a remote git repository, either cloned locally or using its URL.";

addError EITHER_LOCAL_OR_REMOTE_MUST_BE_SPECIFIED "Either -l or -r must be specified";
addError LOCAL_REPOSITORY_DOES_NOT_EXIST "The local repository ${LOCAL_REPOSITORY} does not exist";
addError CANNOT_RETRIEVE_HEAD_FROM_LOCAL_REPOSITORY "Could not retrieve the HEAD hash of the remote ${BRANCH} branch in ${LOCAL_REPOSITORY}";
addError ERROR_ANALYZING_REMOTE_URL "Error analyzing the remote URL ${REMOTE_URL}";
addError CANNOT_RETRIEVE_HEAD_FROM_REMOTE_URL "Could not retrieve the HEAD hash of the ${BRANCH} branch in ${REMOTE_URL}";

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
      -h | --help | -v | -vv | -q | -l | --local | -r | --remote )
         shift;
         ;;
      --)
        shift;
        break;
        ;;
      *) logDebugResult FAILURE "failed";
         exitWithErrorCode INVALID_OPTION;
         ;;
    esac
  done

  if    isTrue "${LOCAL_FLAG}" \
     || isTrue "${REMOTE_FLAG}"; then
    if    isTrue "${LOCAL_FLAG}" \
       && isEmpty "${LOCAL_REPOSITORY}"; then
      logDebugResult FAILURE "failed";
      exitWithErrorCode LOCAL_REPOSITORY_IS_MANDATORY;
    fi

    if    isTrue "${REMOTE_FLAG}" \
       && isEmpty "${REMOTE_URL}"; then
      logDebugResult FAILURE "failed";
      exitWithErrorCode REMOTE_URL_IS_MANDATORY;
    fi
  else
    logDebugResult FAILURE "failed";
    exitWithErrorCode EITHER_LOCAL_OR_REMOTE_MUST_BE_SPECIFIED;
  fi

  if isEmpty "${BRANCH}"; then
    logDebugResult FAILURE "failed";
    exitWithErrorCode BRANCH_IS_MANDATORY;
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
      --)
        shift;
        break;
        ;;
      -l | --local)
        shift;
        LOCAL_REPOSITORY="${1}";
        LOCAL_FLAG=${TRUE};
        shift;
        ;;
      -r | --remote)
        shift;
        REMOTE_URL="${1}";
        REMOTE_FLAG=${TRUE};
        shift;
        ;;
    esac
  done

  BRANCH="${1}";
  shift;
}

# fun: main
# api: public
# txt: 
# txt: Returns 0/TRUE always.
# use: main
function main() {
  local _result;
  local _hash;

  if isTrue "${LOCAL_FLAG}"; then
    logDebug -n "Retrieving HEAD for remote ${BRANCH} in ${LOCAL_REPOSITORY}";
    if retrieveGitRemoteHead "${LOCAL_REPOSITORY}" "${BRANCH}"; then
        _hash="${RESULT}";
        logDebugResult SUCCESS "${_hash}";
    else
      logDebugResult FAILURE "failed";
      exitWithErrorCode CANNOT_RETRIEVE_HEAD_FROM_LOCAL_REPOSITORY;
    fi
  else
    logDebug -n "Retrieving HEAD for remote ${BRANCH} in ${REMOTE_URL}";
    if retrieveGitRemoteHeadFromURL "${REMOTE_URL}" "${BRANCH}"; then
      _hash="${RESULT}";
      logDebugResult SUCCESS "${_hash}";
    else
      logDebugResult FAILURE "failed";
      exitWithErrorCode CANNOT_RETRIEVE_HEAD_FROM_REMOTE_URL;
    fi
  fi
  echo "${_hash}";
}




