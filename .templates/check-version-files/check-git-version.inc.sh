_aux="$(basename ${SCRIPT_NAME} .sh)";
_aux="$(basename ${_aux} .inc)";
_name="${_aux#check-version-}";
defineEnvVar REPOSITORY_NAME MANDATORY "The name of the repository" "${_name}";
defineEnvVar LOCAL_REPOSITORY MANDATORY "The local repository" '/opt/${REPOSITORY_NAME}';
defineEnvVar CHECK_VERSION_SCRIPT MANDATORY "The check-version.sh script" 'check-version.sh';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
