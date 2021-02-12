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

    local _error;

    logInfo -n "Configuring AWS CLI";
    local _awsProfile="postgresql-s3";

    if configureAwsProfile "${_awsProfile}" "${AWS_ACCESS_KEY_ID}" "${AWS_SECRET_ACCESS_KEY}" "${AWS_REGION}" json; then
        logInfoResult SUCCESS "done";
    else
        _error="${ERROR}";
        logInfoResult FAILURE "failed";
        if isNotEmpty "${_error}"; then
            logInfo "${_error}";
        fi
        exitWithErrorCode CANNOT_CONFIGURE_AWS_CLI "${_awsProfile}";
    fi

    local _s3Folder="${HOME}/s3";

    local _localFile="${_s3Folder}/${CONFIG_FILE}";
    mkdir -p "${_s3Folder}/$(dirname "${CONFIG_FILE}")" 2> /dev/null;

    logInfo -n "Downloading ${S3_BUCKET}/${CONFIG_FILE}";
    if downloadFromS3Bucket "${S3_BUCKET}" "${CONFIG_FILE}" "${_localFile}" "${_awsProfile}"; then
        logInfoResult SUCCESS "done";
    else
        _error="${ERROR}";
        logInfoResult FAILURE "failed";
        if isNotEmpty "${_error}"; then
            logInfo "${_error}";
        fi
        exitWithErrorCode CANNOT_DOWNLOAD_CONFIG_FILE_FROM_S3_BUCKET "${S3_BUCKET}/${CONFIG_FILE}";
    fi

    local _host;
    logDebug -n "Extracting database host";
    if extract_host "${_localFile}"; then
        _host="${RESULT}";
        logDebugResult SUCCESS "${_host}";
    else
        _error="${ERROR}";
        logInfoResult FAILURE "failed";
        if isNotEmpty "${_error}"; then
            logInfo "${_error}";
        fi
        exitWithErrorCode CANNOT_EXTRACT_HOST_FROM_CONFIG_FILE "${S3_BUCKET}/${CONFIG_FILE}";
    fi

    local _port;
    logDebug -n "Extracting database port";
    if extract_port "${_localFile}"; then
        _port="${RESULT}";
        logDebugResult SUCCESS "${_port}";
    else
        _error="${ERROR}";
        logInfoResult FAILURE "failed";
        if isNotEmpty "${_error}"; then
            logInfo "${_error}";
        fi
        exitWithErrorCode CANNOT_EXTRACT_PORT_FROM_CONFIG_FILE "${S3_BUCKET}/${CONFIG_FILE}";
    fi

    local _user;
    logDebug -n "Extracting user name";
    if extract_user "${_localFile}"; then
        _user="${RESULT}";
        logDebugResult SUCCESS "${_user}";
    else
        _error="${ERROR}";
        logInfoResult FAILURE "failed";
        if isNotEmpty "${_error}"; then
            logInfo "${_error}";
        fi
        exitWithErrorCode CANNOT_EXTRACT_USER_FROM_CONFIG_FILE "${S3_BUCKET}/${CONFIG_FILE}";
    fi

    local _password;
    logDebug -n "Extracting user password";
    if extract_password "${_localFile}"; then
        _password="${RESULT}";
        logDebugResult SUCCESS "${_password}";
    else
        _error="${ERROR}";
        logInfoResult FAILURE "failed";
        if isNotEmpty "${_error}"; then
            logInfo "${_error}";
        fi
        exitWithErrorCode CANNOT_EXTRACT_USER_PASSWORD_FROM_CONFIG_FILE "${S3_BUCKET}/${CONFIG_FILE}";
    fi

    logDebug -n "Extracting database";
    if extract_database "${_localFile}"; then
        _database="${RESULT}";
        logDebugResult SUCCESS "${_database}";
    else
        _error="${ERROR}";
        logInfoResult FAILURE "failed";
        if isNotEmpty "${_error}"; then
            logInfo "${_error}";
        fi
        exitWithErrorCode CANNOT_EXTRACT_DATABASE_FROM_CONFIG_FILE "${S3_BUCKET}/${CONFIG_FILE}";
    fi

    logDebug -n "Extracting SQL files to process";
    if extract_sqlFiles "${_localFile}"; then
        _sqlFiles="${RESULT}";
        logDebugResult SUCCESS "$(jq '.sqlFiles | length' "${_localFile}")";
    else
        _error="${ERROR}";
        logInfoResult FAILURE "failed";
        if isNotEmpty "${_error}"; then
            logInfo "${_error}";
        fi
        exitWithErrorCode CANNOT_EXTRACT_SQLFILES_FROM_CONFIG_FILE "${S3_BUCKET}/${CONFIG_FILE}";
    fi

    local _sqlFileItem;
    local _oldIFS="${IFS}";
    IFS="${DWIFS}";
    for _sqlFileItem in $(echo "${_sqlFiles}" | jq -r '.[] | @base64'); do
        IFS="${_oldIFS}";
        local _input="$(echo "${_sqlFileItem}" | base64 --decode | jq -r ".input")";
        local _output="$(echo "${_sqlFileItem}" | base64 --decode | jq -r ".output")";

        local _inputFile="${_s3Folder}/${_input}";
        local _outputFile="${_s3Folder}/${_output}";
        
        logInfo -n "Downloading ${_input} from ${S3_BUCKET} bucket";
        if downloadFromS3Bucket "${S3_BUCKET}" "${_input}" "${_inputFile}" "${_awsProfile}"; then
            logInfoResult SUCCESS "done";
        else
            _error="${ERROR}";
            logInfoResult FAILURE "failed";
            if isNotEmpty "${_error}"; then
                logInfo "${_error}";
            fi
 #           exitWithErrorCode CANNOT_DOWNLOAD_INPUT_FILE_FROM_S3_BUCKET "${S3_BUCKET}/${_input}";
        fi

        logInfo -n "Processing ${_input}";
        if process_sql "${_inputFile}" "${_outputFile}" "${_host}" ${_port} "${_user}" "${_password}" "${_database}"; then
            logInfoResult SUCCESS "done";

            logInfo -n "Uploading ${_output} to ${S3_BUCKET} bucket";
            if uploadToS3Bucket "${_outputFile}" "${S3_BUCKET}" "${_output}" "${_awsProfile}"; then
                logInfoResult SUCCESS "done";
            else
                _error="${ERROR}";
                logInfoResult FAILURE "failed";
                if isNotEmpty "${_error}"; then
                    logInfo "${_error}";
                fi
#                exitWithErrorCode CANNOT_UPLOAD_OUTPUT_FILE_TO_S3_BUCKET "${S3_BUCKET}/${_output}";
            fi
        else
            _error="${ERROR}";
            logInfoResult FAILURE "failed";
            if isNotEmpty "${_error}"; then
                logInfo "${_error}";
            fi
#            exitWithErrorCode ERROR_PROCESSING_INPUT_FILE "${S3_BUCKET}/${_input}";
        fi
    done;
    IFS="${_oldIFS}";
}

# fun: extract_host configFile
# api: public
# txt: Extracts the host from given config file.
# opt: file: The config file.
# txt: Returns 0/TRUE if the host information could be extracted; 1/FALSE otherwise.
# txt: If the function returns 0/TRUE, the variable RESULT contains the host value.
# txt: If the function returns 1/FALSE, the variable ERROR might contain additional information.
# use: if extract_host my-file.json; then
# use:   echo "Host: ${RESULT}";
# use: fi
function extract_host() {
    local _file="${1}";
    checkNotEmpty file "${_file}" 1;

    extract_field host "${_file}";
}

# fun: extract_port configFile
# api: public
# txt: Extracts the port from given config file.
# opt: file: The config file.
# txt: Returns 0/TRUE if the port information could be extracted; 1/FALSE otherwise.
# txt: If the function returns 0/TRUE, the variable RESULT contains the port value.
# txt: If the function returns 1/FALSE, the variable ERROR might contain additional information.
# use: if extract_port my-file.json; then
# use:   echo "Port: ${RESULT}";
# use: fi
function extract_port() {
    local _file="${1}";
    checkNotEmpty file "${_file}" 1;

    extract_field port "${_file}";
}

# fun: extract_user configFile
# api: public
# txt: Extracts the user from given config file.
# opt: file: The config file.
# txt: Returns 0/TRUE if the user name could be extracted; 1/FALSE otherwise.
# txt: If the function returns 0/TRUE, the variable RESULT contains the user.
# txt: If the function returns 1/FALSE, the variable ERROR might contain additional information.
# use: if extract_user my-file.json; then
# use:   echo "User: ${RESULT}";
# use: fi
function extract_user() {
    local _file="${1}";
    checkNotEmpty file "${_file}" 1;

    extract_field user "${_file}";
}

# fun: extract_password configFile
# api: public
# txt: Extracts the password from given config file.
# opt: file: The config file.
# txt: Returns 0/TRUE if the password information could be extracted; 1/FALSE otherwise.
# txt: If the function returns 0/TRUE, the variable RESULT contains the password value.
# txt: If the function returns 1/FALSE, the variable ERROR might contain additional information.
# use: if extract_password my-file.json; then
# use:   echo "Password: ${RESULT}";
# use: fi
function extract_password() {
    local _file="${1}";
    checkNotEmpty file "${_file}" 1;

    extract_field password "${_file}";
}

# fun: extract_database configFile
# api: public
# txt: Extracts the database from given config file.
# opt: file: The config file.
# txt: Returns 0/TRUE if the database information could be extracted; 1/FALSE otherwise.
# txt: If the function returns 0/TRUE, the variable RESULT contains the database value.
# txt: If the function returns 1/FALSE, the variable ERROR might contain additional information.
# use: if extract_database my-file.json; then
# use:   echo "Database: ${RESULT}";
# use: fi
function extract_database() {
    local _file="${1}";
    checkNotEmpty file "${_file}" 1;

    extract_field database "${_file}";
}

# fun: extract_sqlFiles configFile
# api: public
# txt: Extracts the sql files from given config file.
# opt: file: The config file.
# txt: Returns 0/TRUE if the sql files could be extracted; 1/FALSE otherwise.
# txt: If the function returns 0/TRUE, the variable RESULT contains the sql files.
# txt: If the function returns 1/FALSE, the variable ERROR might contain additional information.
# use: if extract_sqlFiles my-file.json; then
# use:   echo "SQL files: ${RESULT}";
# use: fi
function extract_sqlFiles() {
    local _file="${1}";
    checkNotEmpty file "${_file}" 1;

    extract_field sqlFiles "${_file}";
}

# fun: extract_field fieldName configFile
# api: public
# txt: Extracts given field from the config file.
# opt: fieldName: The name of the field.
# opt: file: The config file.
# txt: Returns 0/TRUE if the field information could be extracted; 1/FALSE otherwise.
# txt: If the function returns 0/TRUE, the variable RESULT contains the field value.
# txt: If the function returns 1/FALSE, the variable ERROR might contain additional information.
# use: if extract_field host my-file.json; then
# use:   echo "field value: ${RESULT}";
# use: fi
function extract_field() {
    local _field="${1}";
    checkNotEmpty field "${_field}" 1;
    local _file="${2}";
    checkNotEmpty file "${_file}" 2;

    local _result;
    _result="$(jq -r ".${_field}" "${_file}" 2>&1)";
    local -i _rescode=$?;

    if isTrue ${_rescode}; then
        export RESULT="${_result}";
    else
        export ERROR="${_result}";
    fi

    return ${_rescode};
}

# fun: process_sql input output host port user password database
# api: public
# txt: Processes given SQL file, writing the output in another file.
# opt: input: The input file.
# opt: output: The output file.
# opt: host: The database host.
# opt: pont: The database port.
# opt: user: The user.
# opt: password: The password.
# opt: database: The database.
# txt: Returns 0/TRUE if the SQL file was processed successfully; 1/FALSE otherwise.
# txt: If the function returns 1/FALSE, the variable ERROR might contain additional information.
# use: if process_sql input.sql output.csv db 5432 postgresq secret test; then
# use:   echo "input.sql processed successfully";
# use: fi
function process_sql() {
    local _input="${1}";
    checkNotEmpty input "${_input}" 1;
    local _output="${2}";
    checkNotEmpty output "${_output}" 2;
    local _host="${3}";
    checkNotEmpty host "${_host}" 3;
    local _port="${4}";
    checkNumber port "${_port}" 4;
    local _user="${5}";
    checkNotEmpty user "${_user}" 5;
    local _password="${6}";
    checkNotEmpty password "${_password}" 6;
    local _database="${7}";
    checkNotEmpty database "${_database}" 7;

    local _result;
    _result="$(PGPASSWORD="${_password}" psql -h "${_host}" -p ${_port} -U "${_user}" -d "${_database}" -f "${_input}"bc >> "${_output}" 2>&1)";
    local -i _rescode=$?;

    if isTrue ${_rescode}; then
        export RESULT="${_result}";
    else
        export ERROR="${_result}";
    fi
    
    return ${_rescode};
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

# errors
addError CANNOT_CONFIGURE_AWS_CLI "Error configuring AWS CLI";
addError CANNOT_DOWNLOAD_CONFIG_FILE_FROM_S3_BUCKET "Error downloading the config file from the S3 bucket";
addError CANNOT_EXTRACT_HOST_FROM_CONFIG_FILE "Error extracting 'host' value from config file";
addError CANNOT_EXTRACT_PORT_FROM_CONFIG_FILE "Error extracting 'port' value from config file";
addError CANNOT_EXTRACT_USER_FROM_CONFIG_FILE "Error extracting 'user' value from config file";
addError CANNOT_EXTRACT_PASSWORD_FROM_CONFIG_FILE "Error extracting 'password' value from config file";
addError CANNOT_EXTRACT_DATABASE_FROM_CONFIG_FILE "Error extracting 'database' value from config file";
addError CANNOT_EXTRACT_SQLFILES_FROM_CONFIG_FILE "Error extracting 'sqlFiles' value from config file";
addError CANNOT_DOWNLOAD_INPUT_FILE_FROM_S3_BUCKET "Error downloading the input file from the S3 bucket";
addError ERROR_PROCESSING_INPUT_FILE "Error processing the input file";
addError CANNOT_UPLOAD_OUTPUT_FILE_TO_S3_BUCKET "Error uploading file to the S3 bucket";
addError JQ_NOT_INSTALLED "jq is not installed";
addError BASE64_NOT_INSTALLED "base64 is not installed";

# requirements
checkReq jq JQ_NOT_INSTALLED;
checkReq base64 BASE64_NOT_INSTALLED;

# vim: syntax=sh ts=2 sw=2 sts=4 sr noet

