defineEnvVar CALIBRE2OPDS_MAJOR_VERSION "The major version of Calibre2Opds" "3.6";
defineEnvVar CALIBRE2OPDS_VERSION "The version of Calibre2Opds" '${CALIBRE2OPDS_MAJOR_VERSION}-384a';
overrideEnvVar TAG '${CALIBRE2OPDS_VERSION}';
defineEnvVar CALIBRE2OPDS_ARTIFACT \
             "The Calibre2Opds artifact" \
             'calibre2opds-${CALIBRE2OPDS_VERSION}.zip';
defineEnvVar CALIBRE2OPDS_JAR_FILE \
             "The Calibre2Opds jar file" \
             'OpdsOutput-${CALIBRE2OPDS_MAJOR_VERSION}-SNAPSHOT.jar';
defineEnvVar CALIBRE2OPDS_DOWNLOAD_URL \
             "The url to download Calibre2Opds from" \
             'https://drive.google.com/file/d/0B_jO8sZO1jnSM3FBbG93clVlMms';
defineEnvVar CALIBRE2OPDS_HTTP_PORT \
             "The internal HTTP port used in Calibre2Opds" \
             "80";
defineEnvVar SERVICE_USER "The service user" "calibre2opds";
defineEnvVar SERVICE_GROUP "The service group" "calibre2opds";
defineEnvVar CALIBRE2OPDS_LANGUAGE "The language of the Calibre2Opds UI" "en";
defineEnvVar CALIBLE2OPDS_WIKIPEDIA_LANGUAGE "The language of the Wikipedia" "en";
defineEnvVar CALIBRE2OPDS_CATALOG_TITLE \
             "The catalog title (used in the web page and in RSS feeds)" \
             "Calibre library";
defineEnvVar CALIBRE2OPDS_SPLIT_TAGS_ON \
             "Specifies a character that will be use to split individual tags into a tag list in a tree (e.g. Use : if your tags are named like Action:ToRead:Asap)" \
             ".";
defineEnvVar CALIBRE2OPDS_DONT_SPLIT_TAGS_ON \
             "Disable splitting tags even if you have set the CALIBRE2OPDS_SPLIT_TAGS_ON option. Provides an easy way to toggle the split ON/OFF without having to clear the split character" \
             "true";
defineEnvVar CALIBRE2OPDS_CATALOG_FILTER "If set, the main catalog will only contain books corresponding to this Calibre search (use Saved:xxx to specify a Calibre search xxx)" "";
defineEnvVar CALIBRE2OPDS_ENCRYPT_FILENAMES \
             "If set, the files will be encrypted in such a way that it's impossible to guess them, yet from one run to the next they stay constant. It's recommended that you set this option if your catalog is going to be made visible on the public Internet and you have no explicit security mechanisms in place to protect it from access by unauthorized users." \
             "true";
defineEnvVar CALIBRE2OPDS_DISABLE_RUNTIME_OPTIMIZER \
             "Calibre2Opds tries to save information from a previous catalog to speed up the generation of the next one. Normally this works well, but sometimes if significant changes are made to the settings between runs some inappropiate optimizations are done. Disabling the optimizer means a generate run takes longer but ensures that the expected results are obtained. It is recommended that the optimizer is left enabled unless you find that some changes to the settings do not seem to be reflected in the catalog that is being generated. In such a case disabling the optimizer for one run should correct things. You can then normally enable it again for subsequent runs to reduce the time taken to generate the catalog." \
             "false";
