defineEnvVar JAVA_VERSION "The version of the Java VM" "8";
defineEnvVar BOUNCY_CASTLE_VERSION "The version of Bouncy Castle" "154";
defineEnvVar BOUNCY_CASTLE_ARTIFACT "The Bouncy Castle artifact" 'bcprov-jdk15on-${BOUNCY_CASTLE_VERSION}.jar';
defineEnvVar BOUNCY_CASTLE_DOWNLOAD_URL "The Bouncy Castle download URL" 'http://www.bouncycastle.org/download/${BOUNCY_CASTLE_ARTIFACT}';
defineEnvVar LOGSTASH_VERSION "The Logstash version" "2.3";
overrideEnvVar ENABLE_LOGSTASH true;

