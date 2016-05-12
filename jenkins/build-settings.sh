defineEnvVar JENKINS_VERSION "The Jenkins version" "1.651.2";
defineEnvVar JENKINS_ARTIFACT "The Jenkins artifact" 'jenkins-war-${JENKINS_VERSION}.war';
defineEnvVar JENKINS_DOWNLOAD_URL \
             "The url to download Jenkins" \
             'http://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/${JENKINS_ARTIFACT}';
defineEnvVar JENKINS_PASSWORD "The Jenkins password" "secret" "${RANDOM_PASSWORD}";
defineEnvVar JENKINS_ENCRYPTED_PASSWORD "The Jenkins password, encrypted" "secret" 'mvn --encrypt-password ${JENKINS_PASSWORD} 2> /dev/null';
defineEnvVar JENKINS_RELEASE_ISSUE_REF "Text referencing a 'Release issue', to be used in commits done by Jenkins while releasing artifacts. ex: 'Ref T10' for Phabricator, 'refs #33' for Trac or Redmine" "";
defineEnvVar TOMCAT_HOME \
             "The home directory of Tomcat" \
             "/opt/tomcat";
defineEnvVar JENKINS_HOME \
             "The home directory of Jenkins" \
             "/var/jenkins_home";
defineEnvVar TOMCAT_USER \
             "The Tomcat user" \
             'tomcat';
defineEnvVar TOMCAT_GROUP \
             "The Tomcat group" \
             'tomcat';
defineEnvVar JENKINS_DEFAULT_VIRTUAL_HOST "The default virtual host for Jenkins" 'jenkins.${DOMAIN}';
defineEnvVar JENKINS_PHABRICATOR_URL "The Phabricator url should Jenkins uses it" 'http://phabricator.${DOMAIN}';
defineEnvVar JENKINS_MODULES \
             "The space-separated list of Jenkins modules to include out-of-the-box" \
             "gradle grails groovy git cloudbees-folder branch-api build-pipeline-plugin workflow-multibranch workflow-durable-task-step pipeline-input-step pipeline-stage-step workflow-basic-steps workflow-aggregator workflow-api workflow-cps workflow-cps-global-lib workflow-job workflow-remote-loader workflow-scm-step workflow-step-api workflow-support build-pipeline pipeline-utility-steps pipeline-stage-view pipeline-build-step jquery parameterized-trigger jquery-detached handlebars pipeline-rest-api scm-api git-server git-client ace-editor durable-task structs momentjs startup-trigger-plugin";
