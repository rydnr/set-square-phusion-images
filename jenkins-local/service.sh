#!/bin/sh

_sleep="3s";
_aux=1;
_jobName=$(cat /workspace/.prjname);
_jenkinsCliJar=/opt/tomcat/.jenkins/WEB-INF/jenkins-cli.jar

while [ ${_aux} -ne 0 ]; do
  echo "Waiting until Jenkins becomes ready";
  sleep ${_sleep};
  echo "Triggering a new build of ${_jobName}";
  java -jar ${_jenkinsCliJar} -s http://localhost:${VIRTUAL_PORT}/ build ${_jobName} -w
  _aux=$?;
done

while [ 0 -ne 1 ]; do
  sleep ${_sleep};
done
