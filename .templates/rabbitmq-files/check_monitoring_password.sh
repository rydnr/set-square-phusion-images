#!/bin/bash dry-wit
# Copyright 2017-today OSOCO
# mod: check_input.sh
# api: public
# txt: Checks the container is launched with the required runtime parameters.

# fun: main
# api: public
# txt: Returns 0/TRUE always.
function main() {
  echo -n "";
}

# script metadata
setScriptDescription "Checks the container is launched with the MONITORING_PASSWORD set.";

# env: MONITORING_PASSWORD: The password for the monitoring user.
defineEnvVar MONITORING_PASSWORD MANDATORY "The password for the monitoring user";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
