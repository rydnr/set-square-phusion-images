defineEnvVar JENKINS_VERSION "The Jenkins version" "2.23";
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
defineEnvVar DEFAULT_JENKINS_MEMORY_MIN "The default Xms setting" "-Xms512m";
defineEnvVar DEFAULT_JENKINS_MEMORY_MAX "The default Xmx setting" "-Xmx1024m";
defineEnvVar JENKINS_DEFAULT_VIRTUAL_HOST "The default virtual host for Jenkins" 'jenkins.${DOMAIN}';
defineEnvVar JENKINS_PHABRICATOR_URL "The Phabricator url should Jenkins uses it" 'http://phabricator.${DOMAIN}';
_jm="";
_jm+="ace-editor ansible async-http-client authentication-tokens ";
_jm+="bouncycastle-api branch-api build-pipeline build-pipeline-plugin ";
_jm+="cloudbees-folder conditional-buildstep credentials-binding";
_jm+="deployment-notification docker-commons dockerhub-notification docker-workflow downstream-buildview durable-task ";
_jm+="email-ext emailext-template ";
_jm+="fail-the-build-plugin ";
_jm+="gcal git git-client git-server gradle grails graphiteIntegrator groovy groovyaxis groovy-events-listener-plugin ";
_jm+="handlebars hckrnews html-audio-notifier html5-notifier-plugin ";
_jm+="ifttt-build-notifier instant-messaging ircbot ";
_jm+="jabber javadoc jquery jquery-detached ";
_jm+="logstash ";
_jm+="parameterized-trigger pipeline-build-step plain-credentials pipeline-input-step pipeline-rest-api pipeline-stage-step pipeline-stage-view pipeline-utility-steps";
_jm+="mail-watcher-plugin maven-plugin maven-deployment-linker momentjs monitoring ";
_jm+="nodejs notification ";
_jm+="rundeck run-condition ";
_jm+="scm-api script-security sidebar-update-notification slack sms snsnotify sounds speaks ssh-agent startup-trigger-plugin stashNotifier structs swarm ";
_jm+="websocket workflow-aggregator workflow-api workflow-basic-steps workflow-cps workflow-cps-global-lib workflow-durable-task-step workflow-job workflow-multibranch workflow-remote-loader workflow-scm-step workflow-step-api workflow-support ";
defineEnvVar JENKINS_MODULES "The space-separated list of Jenkins modules to include out-of-the-box" "${_jm}";
defineEnvVar GROOVY_DEFAULT_VERSION "The default Groovy version" "2.4.6";
defineEnvVar GROOVY_VERSIONS "The versions of Groovy to include" '${GROOVY_DEFAULT_VERSION}';
defineEnvVar GRADLE_DEFAULT_VERSION "The default Gradle version" "3";
defineEnvVar GRADLE_VERSIONS "The versions of Gradle to include" '${GRADLE_DEFAULT_VERSION}';
defineEnvVar MAVEN_DEFAULT_VERSION "The default Maven version" "3.3.9";
defineEnvVar MAVEN_VERSIONS "The versions of Maven to include" '${MAVEN_DEFAULT_VERSION}';
defineEnvVar GRAILS_DEFAULT_VERSION "The Grails default version" "3.1.12";
defineEnvVar GRAILS_VERSIONS "The versions of Grails to include" '${GRAILS_DEFAULT_VERSION} 2.5.5';
defineEnvVar ANT_DEFAULT_VERSION "The default Ant version" "1.9.7";
defineEnvVar ANT_VERSIONS "The versions of Ant" '${ANT_DEFAULT_VERSION}';
defineEnvVar SLACK_TEAM_DOMAIN "The team domain in Slack" "${NAMESPACE}";
defineEnvVar SLACK_TOKEN "The Slack token" "secret";
defineEnvVar SLACK_ROOM "The Slack room" "${DOMAIN}";
defineEnvVar NODEJS_MAJOR_VERSION "The major version of the NodeJS" "6";
defineEnvVar NODEJS_ZEROCONF_URL "The url of the Zeroconf script to set up the repositories hosting NodeJS releases" 'https://deb.nodesource.com/setup_${NODEJS_MAJOR_VERSION}.x';
defineEnvVar SWARM_CLIENT_VERSION "The version of the Swarm client" "2.2";
defineEnvVar SWARM_CLIENT_ARTIFACT "The Swarm client artifact" 'swarm-client-${SWARM_CLIENT_VERSION}-jar-with-dependencies.jar';
defineEnvVar SWARM_CLIENT_DOWNLOAD_URL "The url to download the Swarm agent" 'https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${SWARM_CLIENT_VERSION}/${SWARM_CLIENT_ARTIFACT}';
