#!/bin/env dry-wit
# Copyright 2017-today OSOCO
# mod: check_admin_password.sh
# api: public
# txt: Checks the container is launched with the ADMIN_USER_NAME and ADMIN_USER_PASSWORD set.

# fun: main
# api: public
# txt: Returns 0/TRUE always.
function main() {
  echo -n "";
}

# script metadata
setScriptDescription "Checks the container is launched with the ADMIN_USER_NAME and ADMIN_USER_PASSWORD set.";

# env: ADMIN_USER_NAME: The name of the admin user.
defineEnvVar ADMIN_USER_NAME MANDATORY "The name of the admin user" "admin";
# env: ADMIN_USER_PASSWORD: The password for the admin user.
defineEnvVar ADMIN_USER_PASSWORD MANDATORY "The password for the admin user";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
