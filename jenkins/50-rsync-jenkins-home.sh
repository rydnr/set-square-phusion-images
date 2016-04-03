#!/bin/bash

rsync -avz /backup/jenkins-home /var/jenkins_home
rsync -avz /var/jenkins_home /backup/jenkins-home
