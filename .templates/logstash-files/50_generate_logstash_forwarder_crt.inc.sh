defineEnvVar OPENSSL_CNF_FILE "The openssl.cnf file" "/etc/ssl/openssl.cnf";
defineEnvVar LOGSTASH_FORWARDER_CRT_FILE "The logstash-forwarder.crt file" "/etc/pki/tls/certs/logstash-forwarder.crt";
defineEnvVar LOGSTASH_FORWARDER_PRIVATE_KEY "The logstash-forwarder.crt private key" "/etc/pki/tls/private/logstash-forwarder.key";
defineEnvVar LOGSTASH_FORWARDER_VALIDITY_DAYS "The logstash-forwarder validity in days" "3650";
defineEnvVar LOGSTASH_FORWARDER_KEY_ALGORITHM "The key algorithm used to generate logstash-forwarder.crt" "rsa";
defineEnvVar LOGSTASH_FORWARDER_KEY_LENGTH "The key length used to generate logstash-forwarder.crt" "2048";
