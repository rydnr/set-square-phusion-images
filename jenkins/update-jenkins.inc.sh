defineEnvVar JENKINS_UPDATE_CENTER_JSON_BASE_URL "The base url of the update-center.json file" "https://updates.jenkins-ci.org/stable/latest";
defineEnvVar JENKINS_UPDATE_CENTER_JSON "The update-center.json file" '${JENKINS_UPDATE_CENTER_JSON_BASE_URL}/update-center.json';
