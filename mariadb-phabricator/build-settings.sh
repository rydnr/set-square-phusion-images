defineEnvVar GITHUB_PHABRICATOR_HASH MANDATORY "The hash of Phabricator's stable branch in github" "$(.templates/check-version-files/remote-git-version.sh -r https://github.com/phacility/phabricator.git stable)";
defineEnvVar UBUNTU_VERSION MANDATORY "The version available in Ubuntu" "$(docker run --rm -it ${BASE_IMAGE_64BIT}:0.11 remote-ubuntu-version mariadb-server | sed 's/^.*://g' | sed 's/[^0-9a-zA-Z\._-]//g')";
defineEnvVar PARENT_IMAGE_TAG MANDATORY "The version of the parent image" "${UBUNTU_VERSION}";
overrideEnvVar TAG "${GITHUB_PHABRICATOR_HASH}";

cp mariadb-bootstrap/service mariadb-phabricator/mariadb-bootstrap;

sqlIndex=0;

for cmd in create-db-user change-db-password db-grants sql; do
  ((sqlIndex++));
  file="$(printf "%03d" ${sqlIndex})-${cmd}.sql";
  if ! fileExists mariadb-phabricator/${file}; then
    logInfo -n "Extracting ${file}";
    (docker run -it --rm ${CUSTOM_NAMESPACE}/phabricator:${GITHUB_PHABRICATOR_HASH} ${cmd}) > mariadb-phabricator/${file}
    logInfoResult SUCCESS "done";
  fi
done

logInfo -n "Extracting the names of all databases";
defineEnvVar PHABRICATOR_DATABASES MANDATORY "The Phabricator databases to bootstrap" "$(docker run -it --rm ${CUSTOM_NAMESPACE}/phabricator:${GITHUB_PHABRICATOR_HASH} databases | sed 's///g')";
logInfoResult SUCCESS "done";

for db in ${PHABRICATOR_DATABASES}; do
  ((sqlIndex++));
  file="$(printf "%03d" ${sqlIndex})-liquibase-${db}.yml";
  if ! fileExists mariadb-phabricator/${file}; then
    logInfo -n "Extracting ${file}";
    (docker run -it --rm ${CUSTOM_NAMESPACE}/phabricator:${GITHUB_PHABRICATOR_HASH} liquibase ${db}) > mariadb-phabricator/${file}
    logInfoResult SUCCESS "done";
  fi
done

logInfo -n "Extracting db password";
defineEnvVar PHABRICATOR_DB_PASSWORD MANDATORY "The database password of the Phabricator user" "$(docker run -it --rm ${CUSTOM_NAMESPACE}/phabricator:${GITHUB_PHABRICATOR_HASH} echo ${SQ_PHABRICATOR_DB_PASSWORD})";
logInfoResult SUCCESS "done";

# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
