defineEnvVar \
    ARTIFACTORY_VERSION \
    "The version of Artifactory" \
    "4.2.1" \
    "curl -s -k http://dl.bintray.com/jfrog/artifactory/ | grep zip | grep -v asc | tail -n 1 | cut -d'\"' -f 4 | cut -d'-' -f 4 | sed 's_.zip__g'";

defineEnvVar \
    ARTIFACTORY_FILE \
    "The Artifactory zip file" \
    'jfrog-artifactory-oss-${ARTIFACTORY_VERSION}.zip';

defineEnvVar \
    ARTIFACTORY_DOWNLOAD_URL \
    "The url to download Artifactory" \
    'https://bintray.com/artifact/download/jfrog/artifactory/${ARTIFACTORY_FILE}';

defineEnvVar TOMCAT_HOME \
    "The home folder for Tomcat user" \
    "/opt/tomcat";
    
defineEnvVar LICENSE_FILE \
             "The file with the license details" \
             'LICENSE.gpl3';
defineEnvVar COPYRIGHT_PREAMBLE_FILE \
             "The file with the copyright preamble" \
             'copyright-preamble.default.txt';
