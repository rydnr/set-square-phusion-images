#!/usr/bin/env dry-wit
# mod: my_exec.sh
# txt: Runs SQL scripts in a given PostgreSQL server.

DW.import aws-cli;
DW.import aws-s3;

# fun: main
# api: public
# txt: Runs SQL scripts in a given PostgreSQL server.
# txt: Returns 0/TRUE unless the script fails with an error.
# use: main;
function main() {

    local _awsProfile="postgresql-s3";
    
    configureAwsProfile "${_awsProfile}" "${AWS_ACCESS_KEY_ID}" "${AWS_SECRET_ACCESS_KEY}" "${AWS_REGION}" json;

    local _s3Folder="${HOME}/s3";

    local _localFile="${_s3Folder}/${CONFIG_FILE}";
    mkdir -p "${_s3Folder}/$(dirname "${CONFIG_FILE}")" 2> /dev/null;
    cpS3Bucket "${CONFIG_FILE}" "${S3_BUCKET}" "${_localFile}" "${_awsProfile}";

    cat "${_localFile}";

    # retrieve the PostgreSQL connection settings from the config file

    # run a SQL script in the remote PostgreSQL server.
}

# Script metadata
setScriptDescription "Runs SQL scripts in a given PostgreSQL server";

# env: AWS_ACCESS_KEY_ID: The AWS access key id (required to connect to S3).
defineEnvVar AWS_ACCESS_KEY_ID MANDATORY "The AWS access key id (required to connect to S3)";
# env: AWS_SECRET_ACCESS_KEY: The AWS secret access key (required to connect to S3).
defineEnvVar  AWS_SECRET_ACCESS_KEY MANDATORY "The AWS secret access key (required to connect to S3)";
# env: AWS_REGION: The AWS region. Defaults to eu-west-1.
defineEnvVar AWS_REGION MANDATORY "The AWS region" "eu-west-1";
# env: S3_BUCKET: The name of the S3 bucket.
defineEnvVar S3_BUCKET MANDATORY "The S3 bucket";
# env: CONFIG_FILE: The config file in the S3 bucket.
defineEnvVar CONFIG_FILE MANDATORY "The config file in the S3 bucket";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet

