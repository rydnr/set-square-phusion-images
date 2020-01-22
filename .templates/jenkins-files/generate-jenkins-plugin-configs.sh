#!/bin/bash dry-wit
# Copyright 2016-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

setScriptDescription "Generates the Jenkins configuration file for a given tool or plugin";
addCommandLineParameter "tool" "either groovy, gradle, grails, maven, ant, slack or nodejs." MANDATORY SINGLE;
addCommandLineParameter "versions" "The version(s) of the selected tool." OPTIONAL MULTIPLE;

DW.import file;

# fun: main
# api: public
# txt: Main logic. Gets called by dry-wit.
# txt: Returns 0/TRUE always, but may exit due to errors.
# use: main
function main() {
  local -i _sdkTool=${TRUE};
  local _v;
  local _oldIFS="${IFS}";

  source ${JENKINS_HOME}/.sdkman/bin/sdkman-init.sh;

  case ${TOOL} in
    gradle)
      generate_gradle_config "${JENKINS_HOME}" ${VERSIONS};
      ;;
    groovy)
      generate_groovy_config "${JENKINS_HOME}" ${VERSIONS};
      ;;
    grails)
      generate_grails_config "${JENKINS_HOME}" ${VERSIONS};
      ;;
    maven)
      generate_maven_config "${JENKINS_HOME}" ${VERSIONS};
      ;;
    ant)
      generate_ant_config "${JENKINS_HOME}" ${VERSIONS};
      ;;
    slack)
      generate_slack_config "${JENKINS_HOME}";
      _sdkTool=${FALSE};
      ;;
    nodejs)
      generate_nodejs_config "${JENKINS_HOME}";
      _sdkTool=${FALSE};
      ;;
  esac

  if isTrue ${_sdkTool}; then
    IFS="${DWIFS}";
    for _v in ${VERSIONS:- }; do
      IFS="${_oldIFS}";
      yes no | sdk i ${TOOL} ${_v}
    done
    IFS="${_oldIFS}";
  fi
}

# fun: generate_gradle_config
# api: public
# txt: Generates the Jenkins configuration file for Gradle.
# opt: outputFolder: The output folder.
# opt: versions: The gradle version(s).
# txt: Returns 0/TRUE always, but may exit due to errors.
# use: generate_gradle_config /tmp 2.13 2.11
function generate_gradle_config() {
  local _outputFolder="${1}";
  shift;
  local _versions="$@";
  local _outputFile="${_outputFolder}/${GRADLE_CONFIG_FILE}";
  local _v;
  local _oldIFS="${IFS}";

  touch "${_outputFile}" > /dev/null
  if isFalse $?; then
    exitWithErrorCode CANNOT_CREATE_GRADLE_CONFIG_FILE;
  fi
  cat <<EOF > ${_outputFile}
<?xml version='1.0' encoding='UTF-8'?>
  <hudson.plugins.gradle.Gradle_-DescriptorImpl plugin="gradle@1.24">
  <installations>
    <hudson.plugins.gradle.GradleInstallation>
      <name>gradle</name>
      <home>${JENKINS_HOME}/.sdkman/candidates/gradle/current</home>
      <properties/>
      <gradleHome>${JENKINS_HOME}/.sdkman/candidates/gradle/current</gradleHome>
    </hudson.plugins.gradle.GradleInstallation>
EOF

  IFS="${DWIFS}";
  for _v in ${_versions}; do
    local _oldIFS="${IFS}";
    cat <<EOF >> ${_outputFile}
    <hudson.plugins.gradle.GradleInstallation>
      <name>gradle-${_v}</name>
      <home>${JENKINS_HOME}/.sdkman/candidates/gradle/${_v}</home>
      <properties/>
      <gradleHome>${JENKINS_HOME}/.sdkman/candidates/gradle/${_v}</gradleHome>
    </hudson.plugins.gradle.GradleInstallation>
EOF
  done
  local _oldIFS="${IFS}";

  cat <<EOF >> ${_outputFile}
    </installations>
  </hudson.plugins.gradle.Gradle_-DescriptorImpl>
EOF

  changeOwnerOfFile "${_outputFile}" "${JENKINS_USER}";
}

# fun: generate_groovy_config
# api: public
# txt: Generates the Jenkins configuration file for Groovy.
# opt: outputFolder: The output folder.
# opt: versions: The Groovy version(s).
# txt: Returns 0/TRUE always, but may exit due to errors.
# use: generate_groovy_config /tmp 2.13 2.11
function generate_groovy_config() {
  local _outputFolder="${1}";
  shift;
  local _versions="$@";
  local _outputFile="${_outputFolder}/${GROOVY_CONFIG_FILE}";
  local _v;
  local _oldIFS="${IFS}";

  touch "${_outputFile}" > /dev/null
  if isFalse $?; then
    exitWithErrorCode CANNOT_CREATE_GROOVY_CONFIG_FILE;
  fi
  cat <<EOF > ${_outputFile}
<?xml version='1.0' encoding='UTF-8'?>
<hudson.plugins.groovy.Groovy_-DescriptorImpl plugin="groovy@1.29">
  <instanceCounter>
    <value>0</value>
  </instanceCounter>
  <allowMacro>false</allowMacro>
  <installations/>
  <installations2>
    <hudson.plugins.groovy.GroovyInstallation>
      <name>groovy</name>
      <home>${JENKINS_HOME}/.sdkman/candidates/groovy/current</home>
      <properties/>
    </hudson.plugins.groovy.GroovyInstallation>
EOF

  IFS="${DWIFS}";
  for _v in ${_versions}; do
    local _oldIFS="${IFS}";
    cat <<EOF >> ${_outputFile}
    <hudson.plugins.groovy.GroovyInstallation>
      <name>groovy-${_v}</name>
      <home>${JENKINS_HOME}/.sdkman/candidates/groovy/${_v}</home>
      <properties/>
    </hudson.plugins.groovy.GroovyInstallation>
EOF
  done
  local _oldIFS="${IFS}";

  cat <<EOF >> ${_outputFile}
  </installations2>
</hudson.plugins.groovy.Groovy_-DescriptorImpl>
EOF

  changeOwnerOfFile "${_outputFile}" "${JENKINS_USER}";
}

# fun: generate_grails_config
# api: public
# txt: Generates the Jenkins configuration file for Grails.
# opt: outputFolder: The output folder.
# opt: versions: The Grails version(s).
# txt: Returns 0/TRUE always, but may exit due to errors.
# use: generate_grails_config /tmp 2.13 2.11
function generate_grails_config() {
  local _outputFolder="${1}";
  shift;
  local _versions="$@";
  local _outputFile="${_outputFolder}/${GRAILS_CONFIG_FILE}";
  local _v;
  local _oldIFS="${IFS}";

  touch "${_outputFile}" > /dev/null
  if [ $? -ne 0 ]; then
    exitWithErrorCode CANNOT_CREATE_GRAILS_CONFIG_FILE;
  fi
  cat <<EOF > ${_outputFile}
<?xml version='1.0' encoding='UTF-8'?>
<com.g2one.hudson.grails.GrailsInstallation_-DescriptorImpl plugin="grails@1.7">
  <installations>
    <com.g2one.hudson.grails.GrailsInstallation>
      <name>grails-current</name>
      <home>${JENKINS_HOME}/.sdkman/candidates/grails/current</home>
      <properties/>
    </com.g2one.hudson.grails.GrailsInstallation>
EOF

  IFS="${DWIFS}";
  for _v in ${_versions}; do
    local _oldIFS="${IFS}";
    cat <<EOF >> ${_outputFile}
    <com.g2one.hudson.grails.GrailsInstallation>
      <name>grails-${_v}</name>
      <home>${JENKINS_HOME}/.sdkman/candidates/grails/${_v}</home>
      <properties/>
    </com.g2one.hudson.grails.GrailsInstallation>
EOF
  done
  local _oldIFS="${IFS}";

  cat <<EOF >> ${_outputFile}
  </installations>
</com.g2one.hudson.grails.GrailsInstallation_-DescriptorImpl>
EOF

  changeOwnerOfFile "${_outputFile}" "${JENKINS_USER}";
}

# fun: generate_maven_config
# api: public
# txt: Generates the Jenkins configuration file for Maven.
# opt: outputFolder: The output folder.
# opt: versions: The Maven version(s).
# txt: Returns 0/TRUE always, but may exit due to errors.
# use: generate_maven_config /tmp 3.3.3
function generate_maven_config() {
  local _outputFolder="${1}";
  shift;
  local _versions="$@";
  local _outputFile="${_outputFolder}/${MAVEN_CONFIG_FILE}";
  local _v;
  local _oldIFS="${IFS}";

  touch "${_outputFile}" > /dev/null
  if isFalse $?; then
    exitWithErrorCode CANNOT_CREATE_MAVEN_CONFIG_FILE;
  fi
  cat <<EOF > ${_outputFile}
<?xml version='1.0' encoding='UTF-8'?>
<hudson.tasks.Maven_-DescriptorImpl>
  <installations>
    <hudson.tasks.Maven_-MavenInstallation>
      <name>maven</name>
      <home>${JENKINS_HOME}/.sdkman/candidates/maven/current</home>
      <properties/>
    </hudson.tasks.Maven_-MavenInstallation>
EOF

  IFS="${DWIFS}";
  for _v in ${_versions}; do
    local _oldIFS="${IFS}";
    cat <<EOF >> ${_outputFile}
    <hudson.tasks.Maven_-MavenInstallation>
      <name>maven-${_v}</name>
      <home>${JENKINS_HOME}/.sdkman/candidates/maven/${_v}</home>
      <properties/>
    </hudson.tasks.Maven_-MavenInstallation>
EOF
  done
  local _oldIFS="${IFS}";

  cat <<EOF >> ${_outputFile}
  </installations>
</hudson.tasks.Maven_-DescriptorImpl>
EOF

  changeOwnerOfFile "${_outputFile}" "${JENKINS_USER}";
}

# fun: generate_ant_config
# api: public
# txt: Generates the Jenkins configuration file for Ant.
# opt: outputFolder: The output folder.
# opt: versions: The ant version(s).
# txt: Returns 0/TRUE always, but may exit due to errors.
# use: generate_ant_config /tmp 1.9.7
function generate_ant_config() {
  local _outputFolder="${1}";
  shift;
  local _versions="$@";
  local _outputFile="${_outputFolder}/${ANT_CONFIG_FILE}";
  local _v;
  local _oldIFS="${IFS}";

  touch "${_outputFile}" > /dev/null
  if isFalse $?; then
    exitWithErrorCode CANNOT_CREATE_ANT_CONFIG_FILE;
  fi
  cat <<EOF > ${_outputFile}
<?xml version='1.0' encoding='UTF-8'?>
<hudson.tasks.Ant_-DescriptorImpl plugin="ant@1.2">
  <installations>
    <hudson.tasks.Ant_-AntInstallation>
      <name>ant</name>
      <home>${JENKINS_HOME}/.sdkman/candidates/ant/current</home>
      <properties/>
    </hudson.tasks.Ant_-AntInstallation>
EOF

  IFS="${DWIFS}";
  for _v in ${_versions}; do
    IFS="${_oldIFS}";
    cat <<EOF >> ${_outputFile}
    <hudson.tasks.Ant_-AntInstallation>
      <name>ant-${_v}</name>
      <home>${JENKINS_HOME}/.sdkman/candidates/ant/${_v}</home>
      <properties/>
    </hudson.tasks.Ant_-AntInstallation>
EOF
  done
  IFS="${_oldIFS}";

  cat <<EOF >> ${_outputFile}
  </installations>
</hudson.tasks.Ant_-DescriptorImpl>
EOF

  changeOwnerOfFile "${_outputFile}" "${JENKINS_USER}";
}

# fun: generate_slack_config
# api: public
# txt: Generates the Jenkins configuration file for Slack plugin.
# opt: outputFolder: The output folder.
# txt: Returns 0/TRUE always, but may exit due to errors.
# use:  generate_slack_config /tmp
function generate_slack_config() {
  local _outputFolder="${1}";
  shift;
  local _outputFile="${_outputFolder}/${SLACK_CONFIG_FILE}";

  touch "${_outputFile}" > /dev/null
  if isFalse $?; then
    exitWithErrorCode CANNOT_CREATE_SLACK_CONFIG_FILE;
  fi
  cat <<EOF > ${_outputFile}
<?xml version='1.0' encoding='UTF-8'?>
<jenkins.plugins.slack.SlackNotifier_-DescriptorImpl plugin="slack@2.0.1">
  <teamDomain>${SLACK_TEAM_DOMAIN:-${SQ_SLACK_TEAM_DOMAIN}}</teamDomain>
  <token>${SLACK_TOKEN:-${SQ_SLACK_TOKEN}}</token>
  <room>${SLACK_ROOM:-${SQ_SLACK_ROOM}}</room>
  <buildServerUrl>${SLACK_BUILD_SERVER_URL}</buildServerUrl>
</jenkins.plugins.slack.SlackNotifier_-DescriptorImpl>
EOF

  changeOwnerOfFile "${_outputFile}" "${JENKINS_USER}";
}

# fun: generate_nodejs_config
# api: public
# txt: Generates the Jenkins configuration file for the NodeJS plugin.
# opt: outputFolder: The output folder.
# txt: Returns 0/TRUE always, but may exit due to errors.
# use: generate_nodejs_config /tmp
function generate_nodejs_config() {
  local _outputFolder="${1}";
  shift;
  local _outputFile="${_outputFolder}/${NODEJS_CONFIG_FILE}";

  touch "${_outputFile}" > /dev/null
  if isFalse $?; then
    exitWithErrorCode CANNOT_CREATE_NODEJS_CONFIG_FILE;
  fi
  cat <<EOF > ${_outputFile}
<?xml version='1.0' encoding='UTF-8'?>
<jenkins.plugins.nodejs.NodeJSPlugin plugin="nodejs@0.2.1">
  <installations>
    <jenkins.plugins.nodejs.tools.NodeJSInstallation>
      <name>nodejs</name>
      <home></home>
      <properties/>
      <nodeJSHome></nodeJSHome>
    </jenkins.plugins.nodejs.tools.NodeJSInstallation>
  </installations>
</jenkins.plugins.nodejs.NodeJSPlugin>
EOF

  changeOwnerOfFile "${_outputFile}" "${JENKINS_USER}";
}

addError TOOL_IS_MANDATORY "Tool is mandatory";
addError UNSUPPORTED_TOOL "Only gradle, groovy, grails, maven and ant are supported. Unsupported ";
addError JENKINS_HOME_IS_UNDEFINED "JENKINS_HOME environment variable is undefined";
addError CANNOT_CREATE_GRADLE_CONFIG_FILE "Cannot create Gradle configuration file";
addError CANNOT_CREATE_GROOVY_CONFIG_FILE "Cannot create Groovy configuration file";
addError CANNOT_CREATE_GRAILS_CONFIG_FILE "Cannot create Grails configuration file";
addError CANNOT_CREATE_MAVEN_CONFIG_FILE "Cannot create Maven configuration file";
addError CANNOT_CREATE_ANT_CONFIG_FILE "Cannot create Ant configuration file";
addError CANNOT_CREATE_SLACK_CONFIG_FILE "Cannot create Slack configuration file";
addError CANNOT_CREATE_NODEJS_CONFIG_FILE "Cannot create NodeJS configuration file";

# fun: dw_parse_tool_cli_parameter
# api: public
# txt: Parses the "tool" cli parameter value (dry-wit hook).
# opt: paramValue: The parameter value.
# txt: Returns 0/TRUE always.
function dw_parse_tool_cli_parameter() {
  export TOOL="${1}";
}

# fun: dw_parse_versions_cli_parameter
# api: public
# txt: Parses the "versions" cli parameter value (dry-wit hook).
# opt: paramValue: The parameter value.
# txt: Returns 0/TRUE always.
function dw_parse_versions_cli_parameter() {
  export VERSIONS="${@}";
}

# fun: dw_check_tool_cli_parameter
# api: public
# txt: Checks the "tool" cli parameter value (dry-wit hook).
# txt: Returns 0/TRUE always, but may exit if the TOOL variable is not valid.
function dw_check_tool_cli_parameter() {
  case ${TOOL} in
    gradle | groovy | grails | maven | ant | slack | nodejs )
       ;;
    *) exitWithErrorCode UNSUPPORTED_TOOL "${TOOL}";
       ;;
  esac
}
#
