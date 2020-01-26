defineEnvVar WORKSPACE MANDATORY "The workspace folder" "/workspace";
defineEnvVar JENKINSFILE MANDATORY "The Jenkinsfile file" '${WORKSPACE}/Jenkinsfile';
defineEnvVar JOBS_FOLDER MANDATORY "The folder where the jobs are defined" "${JENKINS_HOME}/jobs";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
