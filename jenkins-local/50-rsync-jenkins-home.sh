#!/bin/bash

rsync -az /backup/jenkins-home/ /var/jenkins_home/
rsync -az --exclude '.sdkman/*' /var/jenkins_home/ /backup/jenkins-home/
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
