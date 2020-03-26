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
setScriptLicenseSummary "Distributed under the terms of the GNU General Public License v3";
setScriptCopyright "Copyleft 2015-today Automated Computing Machinery S.L.";

addError COULD_NOT_RETRIEVE_LATEST_VERSION "Error retrieving the latest revision";

defineEnvVar LOCAL_REPOSITORY MANDATORY "The local repository" "${SQ_LOCAL_REPOSITORY}";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
