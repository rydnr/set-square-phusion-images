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
  export CANNOT_CREATE_GRADLE_CONFIG_FILE="Cannot create Gradle configuration file";
  export CANNOT_CREATE_GROOVY_CONFIG_FILE="Cannot create Groovy configuration file";
  export CANNOT_CREATE_GRAILS_CONFIG_FILE="Cannot create Grails configuration file";
  export CANNOT_CREATE_MAVEN_CONFIG_FILE="Cannot create Maven configuration file";
  export CANNOT_CREATE_ANT_CONFIG_FILE="Cannot create Ant configuration file";

  ERROR_MESSAGES=(\
    INVALID_OPTION \
    TOOL_IS_MANDATORY \
    UNSUPPORTED_TOOL \
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
    logDebugResult FAILURE "faileda";
    exitWithErrorCode TOOL_IS_MANDATORY;
  fi
  case ${TOOL} in
    gradle | groovy | grails | maven | ant)
       ;;
    *) logDebugResult FAILURE "failed";
       exitWithErrorCode UNSUPPORTED_TOOL;
       ;;
  esac

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
  local _outputFile="${_outputFolder}/hudson.plugins.gradle.Gradle.xml";

  if [ ! -w ${_outputFile} ]; then
    exitWithErrorCode CANNOT_CREATE_GRADLE_CONFIG_FILE;
  fi
  cat <<EOF > ${_outputFile}
<?xml version='1.0' encoding='UTF-8'?>
  <hudson.plugins.gradle.Gradle_-DescriptorImpl plugin="gradle@1.24">
  <installations>
    <hudson.plugins.gradle.GradleInstallation>
      <name>gradle</name>
      <home>/home/jenkins/.sdkman/candidates/gradle/current</home>
      <properties/>
      <gradleHome>/home/jenkins/.sdkman/candidates/gradle/current</gradleHome>
    </hudson.plugins.gradle.GradleInstallation>
EOF

  for v in ${_versions}; do
    cat <<EOF >> ${_outputFile}
    <hudson.plugins.gradle.GradleInstallation>
      <name>gradle-${v}</name>
      <home>/home/jenkins/.sdkman/candidates/gradle/${v}</home>
      <properties/>
      <gradleHome>/home/jenkins/.sdkman/candidates/gradle/${v}</gradleHome>
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
  local _outputFile="${_outputFolder}/hudson.plugins.groovy.Groovy.xml";

  if [ ! -w ${_outputFile} ]; then
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
      <home>/home/jenkins/.sdkman/candidates/groovy/current</home>
      <properties/>
    </hudson.plugins.groovy.GroovyInstallation>
EOF

  for v in ${_versions}; do
    cat <<EOF >> ${_outputFile}
    <hudson.plugins.groovy.GroovyInstallation>
      <name>groovy-${v}</name>
      <home>/home/jenkins/.sdkman/candidates/groovy/${v}</home>
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
  local _outputFile="${_outputFolder}/hudson.plugins.grails.Grails.xml";

  if [ ! -w ${_outputFile} ]; then
    exitWithErrorCode CANNOT_CREATE_GRAILS_CONFIG_FILE;
  fi
  cat <<EOF > ${_outputFile}
<?xml version='1.0' encoding='UTF-8'?>
<com.g2one.hudson.grails.GrailsInstallation_-DescriptorImpl plugin="grails@1.7">
  <installations>
    <com.g2one.hudson.grails.GrailsInstallation>
      <name>grails-current</name>
      <home>/home/jenkins/.sdkman/candidates/grails/current</home>
      <properties/>
    </com.g2one.hudson.grails.GrailsInstallation>
EOF

  for v in ${_versions}; do
    cat <<EOF >> ${_outputFile}
    <com.g2one.hudson.grails.GrailsInstallation>
      <name>grails-${v}</name>
      <home>/home/jenkins/.sdkman/candidates/grails/${v}</home>
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
  local _outputFile="${_outputFolder}/hudson.tasks.Maven.xml";

  if [ ! -w ${_outputFile} ]; then
    exitWithErrorCode CANNOT_CREATE_MAVEN_CONFIG_FILE;
  fi
  cat <<EOF > ${_outputFile}
<?xml version='1.0' encoding='UTF-8'?>
<hudson.tasks.Maven_-DescriptorImpl>
  <installations>
    <hudson.tasks.Maven_-MavenInstallation>
      <name>maven</name>
      <home>/home/jenkins/.sdkman/candidates/maven/current</home>
      <properties/>
    </hudson.tasks.Maven_-MavenInstallation>
EOF

  for v in ${_versions}; do
    cat <<EOF >> ${_outputFile}
    <hudson.tasks.Maven_-MavenInstallation>
      <name>maven-${v}</name>
      <home>/home/jenkins/.sdkman/candidates/maven/${v}</home>
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
  local _outputFile="${_outputFolder}/hudson.tasks.Ant.xml";

  if [ ! -w ${_outputFile} ]; then
    exitWithErrorCode CANNOT_CREATE_ANT_CONFIG_FILE;
  fi
  cat <<EOF > ${_outputFile}
<?xml version='1.0' encoding='UTF-8'?>
<hudson.tasks.Ant_-DescriptorImpl plugin="ant@1.2">
  <installations>
    <hudson.tasks.Ant_-AntInstallation>
      <name>ant</name>
      <home>/home/jenkins/.sdkman/candidates/ant/current</home>
      <properties/>
    </hudson.tasks.Ant_-AntInstallation>
EOF

  for v in ${_versions}; do
    cat <<EOF >> ${_outputFile}
    <hudson.tasks.Ant_-AntInstallation>
      <name>ant-${v}</name>
      <home>/home/jenkins/.sdkman/candidates/ant/${v}</home>
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
  for v in ${VERSIONS:- }; do
    yes no | sdk i ${TOOL} ${v}
  done

  case ${TOOL} in
    gradle)
      generate_gradle_config ${VERSIONS};
      ;;
    groovy)
      generate_groovy_config ${VERSIONS};
      ;;
    grails)
      generate_grails_config ${VERSIONS};
      ;;
    maven)
      generate_maven_config ${VERSIONS};
      ;;
    ant)
      generate_ant_config ${VERSIONS};
      ;;
  esac
}
