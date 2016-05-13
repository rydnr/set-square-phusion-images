#!/bin/bash

rsync -az --exclude '.sdkman/*' /backup/jenkins-home/ /var/jenkins_home/
rsync -az --exclude '.sdkman/*' /var/jenkins_home/ /backup/jenkins-home/
