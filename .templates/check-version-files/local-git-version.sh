#!/bin/bash dry-wit
# Copyright 2016-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: check-version/local-git-version
# api: public
# txt: Retrieves the latest revision of the git repository.

DW.import git;

# fun: main
# api: public
# txt: Retrieves the latest revision of the git repository.
# txt: Returns 0/TRUE always.
# use: main
function main() {
  if retrieveGitHeadRevision "${LOCAL_REPOSITORY}"; then
    echo "${RESULT}";
  else
    exitWithErrorCode COULD_NOT_RETRIEVE_LATEST_VERSION;
  fi
}

## Script metadata and CLI options
setScriptDescription "Retrieves the latest revision of the git repository.";

addError LOCAL_REPOSITORY_NOT_AVAILABLE "The local repository ${LOCAL_REPOSITORY} is not available";
addError COULD_NOT_RETRIEVE_LATEST_VERSION "Error retrieving the latest revision";

function dw_check_local_repository_cli_envvar() {
  if isEmpty "${LOCAL_REPOSITORY}"; then
    exitWithErrorCode LOCAL_REPOSITORY_NOT_AVAILABLE;
  fi
}
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
