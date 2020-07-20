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
setScriptDescription "Checks the container is launched with the ADMIN_PASSWORD set.";

# env: ADMIN_PASSWORD: The password for the admin user.
defineEnvVar ADMIN_PASSWORD MANDATORY "The password for the admin user";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
