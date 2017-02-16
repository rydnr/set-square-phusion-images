defineEnvVar PARENT_IMAGE_TAG "The version of the parent image" "201702";
defineEnvVar JENKINS_VERSION "The Jenkins version" "2.46";
defineEnvVar TAG "The image tag" '${JENKINS_VERSION}';
defineEnvVar JENKINS_ARTIFACT "The Jenkins artifact" 'jenkins-war-${JENKINS_VERSION}.war';
defineEnvVar JENKINS_DOWNLOAD_URL \
             "The url to download Jenkins" \
             'http://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/${JENKINS_ARTIFACT}';
defineEnvVar JENKINS_PASSWORD "The Jenkins password" "secret" "${RANDOM_PASSWORD}";
defineEnvVar JENKINS_ENCRYPTED_PASSWORD "The Jenkins password, encrypted" "secret" 'mvn --encrypt-password ${JENKINS_PASSWORD} 2> /dev/null';
defineEnvVar JENKINS_RELEASE_ISSUE_REF "Text referencing a 'Release issue', to be used in commits done by Jenkins while releasing artifacts. ex: 'Ref T10' for Phabricator, 'refs #33' for Trac or Redmine" "";
defineEnvVar SERVICE_USER "The service user" "jenkins";
defineEnvVar SERVICE_GROUP "The service group" "jenkins";
defineEnvVar SERVICE_USER_HOME "The service user home" '/home/jenkins';
defineEnvVar SERVICE_USER_SHELL "The shell of the service user" "/bin/bash";
