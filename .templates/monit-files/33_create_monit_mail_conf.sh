#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: monit/33_create_monit_mail_conf
# api: public
# txt: Creates Monit configuration file to send alerts via email.

export DW_DISABLE_ANSI_COLORS=TRUE;

# fun: main
# api: public
# txt: Creates Monit configuration file to send alerts via email.
# txt: Returns the result of processing MONIT_MAIL_TEMPLATE_FILE.
# use: main
function main() {

  if isEmpty "${SMTP_HOST}"; then
    export SMTP_HOST="localhost";
  fi

  process-file.sh -o ${MONIT_MAIL_OUTPUT_FILE} ${MONIT_MAIL_TEMPLATE_FILE};
}

## Script metadata and CLI options
setScriptDescription "Creates Monit configuration file to send alerts via email";
addError PROCESSFILE_NOT_INSTALLED "process-file.sh is not installed";
checkReq "process-file.sh" PROCESSFILE_NOT_INSTALLED;
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
