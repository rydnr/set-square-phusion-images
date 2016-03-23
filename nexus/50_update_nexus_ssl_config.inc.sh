defineEnvVar PASSWORD_CLASS "The Password class" "org.eclipse.jetty.util.security.Password";
defineEnvVar PASSWORD_JAR_FILE 'The location of the Jetty jar with the ${PASSWORD_CLASS} class' '/opt/sonatype/nexus/system/org/eclipse/jetty/jetty-util/*/jetty-util-*.jar';
defineEnvVar SSL_KEYSTORE_PATH "The keystore path" "${SSL_KEY_FOLDER}/${SSL_KEYSTORE_NAME}.jks";
defineEnvVar NEXUS_CONFIG_FILE "The Nexus config file" "/opt/sonatype/nexus/etc/org.sonatype.nexus.cfg";
defineEnvVar NEXUS_PROPERTIES_FILE "The Nexus properties file" "/opt/sonatype/nexus/etc/custom.properties";
