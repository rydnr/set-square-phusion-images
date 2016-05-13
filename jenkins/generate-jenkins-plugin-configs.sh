#!/bin/bash dry-wit
# Copyright 2016-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME [tool] [version]*
$SCRIPT_NAME [-h|--help]
(c) 2016-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

Generates the Jenkins configuration file for given tool.

Where:
    - tool: either groovy, gradle, grails, maven or ant.
    - version: Optional, the version(s) of the tool.
Common flags:
    * -h | --help: Display this message.
    * -v: Increase the verbosity.
    * -vv: Increase the verbosity further.
    * -q | --quiet: Be silent.
EOF
}

## Defines the errors
## dry-wit hook
function defineErrors() {
  export INVALID_OPTION="Unrecognized option";
  export TOOL_IS_MANDATORY="Tool is mandatory";
  export UNSUPPORTED_TOOL="Unsupported tool. Only gradle, groovy, grails, maven and ant are supported";
  export JENKINS_HOME_IS_UNDEFINED="JENKINS_HOME environment variable is undefined";
  export CANNOT_CREATE_GRADLE_CONFIG_FILE="Cannot create Gradle configuration file";
  export CANNOT_CREATE_GROOVY_CONFIG_FILE="Cannot create Groovy configuration file";
  export CANNOT_CREATE_GRAILS_CONFIG_FILE="Cannot create Grails configuration file";
  export CANNOT_CREATE_MAVEN_CONFIG_FILE="Cannot create Maven configuration file";
  export CANNOT_CREATE_ANT_CONFIG_FILE="Cannot create Ant configuration file";

  ERROR_MESSAGES=(\
    INVALID_OPTION \
    TOOL_IS_MANDATORY \
    UNSUPPORTED_TOOL \
    JENKINS_HOME_IS_UNDEFINED \
    CANNOT_CREATE_GRADLE_CONFIG_FILE \
    CANNOT_CREATE_GROOVY_CONFIG_FILE \
    CANNOT_CREATE_GRAILS_CONFIG_FILE \
    CANNOT_CREATE_MAVEN_CONFIG_FILE \
    CANNOT_CREATE_ANT_CONFIG_FILE \
  );

  export ERROR_MESSAGES;
}

## Validates the input.
## dry-wit hook
function checkInput() {

  local _flags=$(extractFlags $@);
  local _flagCount;
  local _currentCount;
  logDebug -n "Checking input";

  # Flags
  for _flag in ${_flags}; do
    _flagCount=$((_flagCount+1));
    case ${_flag} in
      -h | --help | -v | -vv | -q)
         shift;
         ;;
      *) logDebugResult FAILURE "failed";
         exitWithErrorCode INVALID_OPTION;
         ;;
    esac
  done

  if [[ -z "${TOOL}" ]]; then
    logDebugResult FAILURE "failed";
    exitWithErrorCode TOOL_IS_MANDATORY;
  fi
  case ${TOOL} in
    gradle | groovy | grails | maven | ant)
       ;;
    *) logDebugResult FAILURE "failed";
       exitWithErrorCode UNSUPPORTED_TOOL;
       ;;
  esac

  if [ -z "${JENKINS_HOME}" ]; then
    logDebugResult FAILURE "failed";
    exitWithErrorCode JENKINS_HOME_IS_UNDEFINED;
  fi

  logDebugResult SUCCESS "valid";
}

## Parses the input
## dry-wit hook
function parseInput() {

  local _flags=$(extractFlags $@);
  local _flagCount;
  local _currentCount;

  # Flags
  for _flag in ${_flags}; do
    _flagCount=$((_flagCount+1));
    case ${_flag} in
      -h | --help | -v | -vv | -q)
         shift;
         ;;
    esac
  done

  if [[ -z "${TOOL}" ]]; then
    export TOOL="${1}";
    shift;
  fi

  if [[ -z "${VERSIONS}" ]]; then
    export VERSIONS="$@";
    shift;
  fi
}

## PUBLIC
## Generates the Jenkins configuration file for Gradle.
## -> 1: The gradle version(s).
## -> 2: The output folder.
## Example:
##   generate_gradle_config /tmp 2.13 2.11
##   > ls /tmp | grep gradle
##   hudson.plugins.gradle.Gradle.xml
function generate_gradle_config() {
  local _outputFolder="${1}";
  shift;
  local _versions="$@";
  local _outputFile="${_outputFolder}/${GRADLE_CONFIG_FILE}";

  touch "${_outputFile}" > /dev/null
  if [ $? -ne 0 ]; then
    exitWithErrorCode CANNOT_CREATE_GRADLE_CONFIG_FILE;
  fi
  cat <<EOF > ${_outputFile}
<?xml version='1.0' encoding='UTF-8'?>
  <hudson.plugins.gradle.Gradle_-DescriptorImpl plugin="gradle@1.24">
  <installations>
    <hudson.plugins.gradle.GradleInstallation>
      <name>gradle</name>
      <home>/var/jenkins_home/.sdkman/candidates/gradle/current</home>
      <properties/>
      <gradleHome>/var/jenkins_home/.sdkman/candidates/gradle/current</gradleHome>
    </hudson.plugins.gradle.GradleInstallation>
EOF

  for v in ${_versions}; do
    cat <<EOF >> ${_outputFile}
    <hudson.plugins.gradle.GradleInstallation>
      <name>gradle-${v}</name>
      <home>/var/jenkins_home/.sdkman/candidates/gradle/${v}</home>
      <properties/>
      <gradleHome>/var/jenkins_home/.sdkman/candidates/gradle/${v}</gradleHome>
    </hudson.plugins.gradle.GradleInstallation>
EOF
  done

cat <<EOF >> ${_outputFile}
    </installations>
  </hudson.plugins.gradle.Gradle_-DescriptorImpl>
EOF
}

## PUBLIC
## Generates the Jenkins configuration file for Groovy.
## -> 1: The Groovy version(s).
## -> 2: The output folder.
## Example:
##   generate_groovy_config /tmp 2.13 2.11
##   > ls /tmp | grep groovy
##   hudson.plugins.groovy.Groovy.xml
function generate_groovy_config() {
  local _outputFolder="${1}";
  shift;
  local _versions="$@";
  local _outputFile="${_outputFolder}/${GROOVY_CONFIG_FILE}";

  touch "${_outputFile}" > /dev/null
  if [ $? -ne 0 ]; then
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
      <home>/var/jenkins_home/.sdkman/candidates/groovy/current</home>
      <properties/>
    </hudson.plugins.groovy.GroovyInstallation>
EOF

  for v in ${_versions}; do
    cat <<EOF >> ${_outputFile}
    <hudson.plugins.groovy.GroovyInstallation>
      <name>groovy-${v}</name>
      <home>/var/jenkins_home/.sdkman/candidates/groovy/${v}</home>
      <properties/>
    </hudson.plugins.groovy.GroovyInstallation>
EOF
  done

cat <<EOF >> ${_outputFile}
  </installations2>
</hudson.plugins.groovy.Groovy_-DescriptorImpl>
EOF
}

## PUBLIC
## Generates the Jenkins configuration file for Grails.
## -> 1: The Grails version(s).
## -> 2: The output folder.
## Example:
##   generate_grails_config /tmp 2.13 2.11
##   > ls /tmp | grep grails
##   hudson.plugins.grails.Grails.xml
function generate_grails_config() {
  local _outputFolder="${1}";
  shift;
  local _versions="$@";
  local _outputFile="${_outputFolder}/${GRAILS_CONFIG_FILE}";

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
      <home>/var/jenkins_home/.sdkman/candidates/grails/current</home>
      <properties/>
    </com.g2one.hudson.grails.GrailsInstallation>
EOF

  for v in ${_versions}; do
    cat <<EOF >> ${_outputFile}
    <com.g2one.hudson.grails.GrailsInstallation>
      <name>grails-${v}</name>
      <home>/var/jenkins_home/.sdkman/candidates/grails/${v}</home>
      <properties/>
    </com.g2one.hudson.grails.GrailsInstallation>
EOF
  done

cat <<EOF >> ${_outputFile}
  </installations>
</com.g2one.hudson.grails.GrailsInstallation_-DescriptorImpl>
EOF
}

## PUBLIC
## Generates the Jenkins configuration file for Maven.
## -> 1: The maven version(s).
## -> 2: The output folder.
## Example:
##   generate_maven_config /tmp 3.3.3
##   > ls /tmp | grep Maven
##   hudson.tasks.Maven.xml
function generate_maven_config() {
  local _outputFolder="${1}";
  shift;
  local _versions="$@";
  local _outputFile="${_outputFolder}/${MAVEN_CONFIG_FILE}";

  touch "${_outputFile}" > /dev/null
  if [ $? -ne 0 ]; then
    exitWithErrorCode CANNOT_CREATE_MAVEN_CONFIG_FILE;
  fi
  cat <<EOF > ${_outputFile}
<?xml version='1.0' encoding='UTF-8'?>
<hudson.tasks.Maven_-DescriptorImpl>
  <installations>
    <hudson.tasks.Maven_-MavenInstallation>
      <name>maven</name>
      <home>/var/jenkins_home/.sdkman/candidates/maven/current</home>
      <properties/>
    </hudson.tasks.Maven_-MavenInstallation>
EOF

  for v in ${_versions}; do
    cat <<EOF >> ${_outputFile}
    <hudson.tasks.Maven_-MavenInstallation>
      <name>maven-${v}</name>
      <home>/var/jenkins_home/.sdkman/candidates/maven/${v}</home>
      <properties/>
    </hudson.tasks.Maven_-MavenInstallation>
EOF
  done

cat <<EOF >> ${_outputFile}
  </installations>
</hudson.tasks.Maven_-DescriptorImpl>
EOF
}

## PUBLIC
## Generates the Jenkins configuration file for Ant.
## -> 1: The ant version(s).
## -> 2: The output folder.
## Example:
##   generate_ant_config /tmp 1.9.7
##   > ls /tmp | grep Ant
##   hudson.tasks.Ant.xml
function generate_ant_config() {
  local _outputFolder="${1}";
  shift;
  local _versions="$@";
  local _outputFile="${_outputFolder}/${ANT_CONFIG_FILE}";

  touch "${_outputFile}" > /dev/null
  if [ $? -ne 0 ]; then
    exitWithErrorCode CANNOT_CREATE_ANT_CONFIG_FILE;
  fi
  cat <<EOF > ${_outputFile}
<?xml version='1.0' encoding='UTF-8'?>
<hudson.tasks.Ant_-DescriptorImpl plugin="ant@1.2">
  <installations>
    <hudson.tasks.Ant_-AntInstallation>
      <name>ant</name>
      <home>/var/jenkins_home/.sdkman/candidates/ant/current</home>
      <properties/>
    </hudson.tasks.Ant_-AntInstallation>
EOF

  for v in ${_versions}; do
    cat <<EOF >> ${_outputFile}
    <hudson.tasks.Ant_-AntInstallation>
      <name>ant-${v}</name>
      <home>/var/jenkins_home/.sdkman/candidates/ant/${v}</home>
      <properties/>
    </hudson.tasks.Ant_-AntInstallation>
EOF
  done

cat <<EOF >> ${_outputFile}
  </installations>
</hudson.tasks.Ant_-DescriptorImpl>
EOF
}

## Main logic
## dry-wit hook
function main() {
  source ~/.sdkman/bin/sdkman-init.sh;
  for v in ${VERSIONS:- }; do
    yes no | sdk i ${TOOL} ${v}
  done

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
  esac
}
