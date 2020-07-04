#!/bin/bash dry-wit
# Copyright 2017-today OSOCO
# mod: bootstrap.sh
# api: public
# txt: Bootstraps Contestia exchanges and queues in a local RabbitMQ server.

DW.import rabbitmq;

# fun: main
# api: public
# txt: Bootstraps Contestia exchanges and queues in a local RabbitMQ server.
# txt: Returns 0/TRUE always, but can exit in case of error.
# use: main
function main() {
  rabbitmqMigrate;
}

# fun: rabbitmq_patch
# api: public
# txt: Patches the RabbitMQ instance. It's actually a hook of rabbitmq.rabbitmqMigrate;
# txt: Returns 0/TRUE always, but can exit in case of error.
# use: rabbitmq_patch;
function rabbitmq_patch() {
  logDebug -n "Adding monitoring user";
  if add_user monitoring ${MONITORING_PASSWORD}; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    releaseBootstrapLockIfFailFast;
    exitWithErrorCodeIfFailFast CANNOT_ADD_MONITORING_USER;
  fi

  logDebug -n "Set users' tags";
  if set_users_tags; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    releaseBootstrapLockIfFailFast;
    exitWithErrorCodeIfFailFast CANNOT_SET_THE_TAGS;
  fi

  logDebug -n "Set users' permissions";
  if set_users_permissions; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    releaseBootstrapLockIfFailFast;
    exitWithErrorCodeIfFailFast CANNOT_SET_THE_USERS_PERMISSIONS;
  fi

  logDebug -n "Declaring the virtual hosts";
  if declare_virtual_hosts; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    releaseBootstrapLockIfFailFast;
    exitWithErrorCodeIfFailFast CANNOT_DECLARE_THE_VIRTUAL_HOSTS;
  fi

  logDebug -n "Declaring the alternate exchanges";
  if declare_virtual_hosts; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    releaseBootstrapLockIfFailFast;
    exitWithErrorCodeIfFailFast CANNOT_DECLARE_THE_ALTERNATE_EXCHANGES;
  fi
}

# fun: set_users_tags
# api: public
# txt: Sets the correct tags for the microservices' users.
# txt: Returns 0/TRUE if the tags are set successfully; 1/FALSE otherwise.
# use: if set_users_tags; then
# use:   echo "Users' tag set successfully";
# use: fi
function set_users_tags() {
  local -i _rescode;

  setUserTags "${ADMIN_USER}" "${ADMIN_TAGS}";
  _rescode=$?;

  if isTrue ${_rescode}; then
    setUserTags "${MONITORING_USER}" "${MONITORING_TAGS}";
    _rescode=$?;
  fi

  return ${_rescode};
}

# fun: set_users_permissions
# api: public
# txt: Sets the microservices' users permissions.
# txt: Returns 0/TRUE if the permissions are set successfully; 1/FALSE otherwise.
# use: if set_users_permissions; then echo "Users' permissions set successfully"; fi
function set_users_permissions() {
  local -i _rescode;

  setPermissions / "${ADMIN_USER}" "${ADMIN_CONFIGURE_PERMISSIONS}" "${ADMIN_WRITE_PERMISSIONS}" "${ADMIN_READ_PERMISSIONS}";
  _rescode=$?;

  if isTrue ${_rescode}; then
    # TODO: FIX ME
    setPermissions / "${MONITORING_USER}" "${MONITORING_CONFIGURE_PERMISSIONS}" "${MONITORING_WRITE_PERMISSIONS}" "${MONITORING_READ_PERMISSIONS}";
    _rescode=$?;
  fi

  return ${_rescode};
}

# fun: declare_virtual_hosts
# api: public
# txt: Declares the virtual hosts.
# txt: Returns 0/TRUE if the virtual host gets created successfully; 1/FALSE otherwise.
# use: if declare_virtual_hosts; then
# use:   echo "Virtual hosts declared successfully";
# use: fi
function declare_virtual_hosts() {
  local -i _rescode=${TRUE};

  #  add_vhost /;

  return ${_rescode};
}

# fun: declare_alternate_exchanges
# api: public
# txt: Declares the alternate exchanges.
# txt: Returns 0/TRUE if the alternate exchanges get created successfully; 1/FALSE otherwise.
# use: if declare_alternate_exchanges; then
# use:   echo "Alternate exchanges created successfully";
# use: fi
function declare_alternate_exchanges() {
  local -i _rescode=${TRUE};

  #    declare_exchange core-alt fanout;

  return ${_rescode};
}

# Script metadata

setScriptDescription "Bootstraps BBVA-ATS exchanges and queues in a local RabbitMQ server.";
addCommandLineFlag failFast "f" "Whether to fail as soon as any step in the bootstrap process fails." OPTIONAL NO_ARGUMENT;
addCommandLineFlag force "F" "Forces the bootstrap process, regardless of whether it's been done already or it's currently in progress." OPTIONAL NO_ARGUMENT;

checkReq wget WGET_NOT_INSTALLED;
checkReq chmod CHMOD_NOT_INSTALLED;
checkReq rabbitmqctl RABBITMQCTL_NOT_INSTALLED;

addError CANNOT_ACQUIRE_LOCK "Cannot acquire lock";
addError RABBITMQ_NOT_RUNNING "RabbitMQ is not running";
addError CANNOT_RETRIEVE_RABBITMQADMIN "Cannot retrieve rabbitmqadmin";
addError CANNOT_FIX_RABBITMQADMIN "Cannot patch rabbitmqadmin";
addError CANNOT_ENABLE_RABBITMQ_PLUGIN_MANAGEMENT "Cannot enable plugin management";
addError CANNOT_ADD_ADMIN_USER "Cannot add admin user";
addError CANNOT_ADD_MONITORING_USER "Cannot add monitoring user";
addError CANNOT_DELETE_GUEST_USER "Cannot delete guest user";
addError CANNOT_ADD_THE_USERS "Cannot add microservices' users";
addError CANNOT_SET_THE_TAGS "Cannot set the users' tags";
addError CANNOT_SET_THE_PERMISSIONS "Cannot set the users' permissions";
addError CANNOT_DECLARE_THE_VIRTUAL_HOSTS "Cannot declare the virtual hosts";
addError CANNOT_DECLARE_THE_ALTERNATE_EXCHANGES "Cannot declare the alternate exchanges";

# env: BOOTSTRAPPED_FILE: The file indicating if the bootstrapped is already done.
defineEnvVar BOOTSTRAPPED_FILE MANDATORY "The file indicating if the bootstrapped is already done";
# env: LOCK_FILE: The file indicating if the bootstrap is running.
defineEnvVar LOCK_FILE MANDATORY "The file indicating if the bootstrap is running";
# env: ADMIN_PASSWORD: The password for the admin user.
defineEnvVar ADMIN_PASSWORD MANDATORY "The password for the admin user";
# env: MONITORING_PASSWORD: The password for the monitoring user.
defineEnvVar MONITORING_PASSWORD MANDATORY "The password for the monitoring user";

# env: ADMIN_USER: The name of the admin user.
defineEnvVar ADMIN_USER MANDATORY "The name of the admin user" admin;
# env: ADMIN_TAGS: The tags of the admin user.
defineEnvVar ADMIN_TAGS MANDATORY "The tags of the admin user" "administrator";
# env: ADMIN_CONFIGURE_PERMISSIONS: The configure permissions for the Admin user.
defineEnvVar ADMIN_CONFIGURE_PERMISSIONS MANDATORY "The configure permissions for the Admin user" ".*";
# env: ADMIN_WRITE_PERMISSIONS: The write permissions for the Admin user.
defineEnvVar ADMIN_WRITE_PERMISSIONS MANDATORY "The write permissions for the Admin user" ".*";
# env: ADMIN_READ_PERMISSIONS: The read permissions for the Admin user.
defineEnvVar ADMIN_READ_PERMISSIONS MANDATORY "The read permissions for the Admin user" ".*";

# env: MONITORING_USER: The name of the monitoring user.
defineEnvVar MONITORING_USER MANDATORY "The name of the monitoring user" monitoring;
# env: MONITORING_TAGS: The tags of the monitoring user.
defineEnvVar MONITORING_TAGS MANDATORY "The tags of the monitoring user" "administrator";
# env: MONITORING_CONFIGURE_PERMISSIONS: The configure permissions for the Monitoring user.
defineEnvVar MONITORING_CONFIGURE_PERMISSIONS MANDATORY "The configure permissions for the Monitoring user" ".*";
# env: MONITORING_WRITE_PERMISSIONS: The write permissions for the Monitoring user.
defineEnvVar MONITORING_WRITE_PERMISSIONS MANDATORY "The write permissions for the Monitoring user" ".*";
# env: MONITORING_READ_PERMISSIONS: The read permissions for the Monitoring user.
defineEnvVar MONITORING_READ_PERMISSIONS MANDATORY "The read permissions for the Monitoring user" ".*";

# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
