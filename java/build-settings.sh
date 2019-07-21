defineEnvVar PARENT_IMAGE_TAG MANDATORY "The version of the parent image" "0.11";
defineEnvVar JAVA_VERSION MANDATORY "The version of the Java VM" "8";
defineEnvVar BOUNCY_CASTLE_VERSION MANDATORY "The version of Bouncy Castle" "154";
defineEnvVar BOUNCY_CASTLE_ARTIFACT MANDATORY "The Bouncy Castle artifact" 'bcprov-jdk15on-${BOUNCY_CASTLE_VERSION}.jar';
defineEnvVar BOUNCY_CASTLE_DOWNLOAD_URL MANDATORY "The Bouncy Castle download URL" 'http://www.bouncycastle.org/download/${BOUNCY_CASTLE_ARTIFACT}';
defineEnvVar JCE_POLICY_EULA_COOKIE MANDATORY "The cookie used to accept the JCE EULA" "oraclelicense=accept-securebackup-cookie;gpw_e24=http://edelivery.oracle.com";
defineEnvVar JCE_POLICY_FOLDER MANDATORY "The JCE policy artifact basename" 'UnlimitedJCEPolicyJDK${JAVA_VERSION}';
defineEnvVar JCE_POLICY_ARTIFACT_BASENAME MANDATORY "The JCE policy artifact basename" 'jce_policy-${JAVA_VERSION}';
defineEnvVar JCE_POLICY_ARTIFACT MANDATORY "The JCE policy artifact" '${JCE_POLICY_ARTIFACT_BASENAME}.zip';
defineEnvVar JCE_POLICY_DOWNLOAD_URL MANDATORY "The URL to download JCE" 'http://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION}/${JCE_POLICY_ARTIFACT}';
defineEnvVar JAVA_HEAP_MIN MANDATORY "The minimum Java heap" "512m";
defineEnvVar JAVA_HEAP_MAX MANDATORY "The maximum Java heap" "1024m";
defineEnvVar JAVA_OPTS MANDATORY "Additional Java opts" "";
defineEnvVar LOGSTASH_VERSION MANDATORY "The Logstash version" "2.3";
overrideEnvVar ENABLE_LOGSTASH true;
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
