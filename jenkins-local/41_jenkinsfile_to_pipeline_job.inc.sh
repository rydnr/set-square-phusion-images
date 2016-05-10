defineEnvVar WORKSPACE "The workspace folder" "/workspace";
defineEnvVar JENKINSFILE "The Jenkinsfile file" '${WORKSPACE}/Jenkinsfile';
defineEnvVar JOBS_FOLDER "The folder where the jobs are defined" "${JENKINS_HOME}/jobs";
