defineEnvVar JENKINS_UPDATE_CENTER_JSON_BASE_URL MANDATORY "The base url of the update-center.json file" "https://updates.jenkins-ci.org/stable";
defineEnvVar JENKINS_UPDATE_CENTER_JSON MANDATORY "The update-center.json file" '${JENKINS_UPDATE_CENTER_JSON_BASE_URL}/update-center.json';
#
