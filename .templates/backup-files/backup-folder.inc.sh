defineEnvVar SOURCE MANDATORY "The source folder" "/backup/rsnapshot/";
defineEnvVar DESTINATION MANDATORY "The destination folder" "~/rsnapshot/";
defineEnvVar SSH_OPTIONS MANDATORY "The SSH options used to connect to the remote host" "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /etc/ssh/ssh_host_dsa_key -q";
defineEnvVar RSYNC_OPTIONS MANDATORY "The rsync options used to connect to the remote host" '-az -H --numeric-ids';
defineEnvVar BACKUP_ROOT_FOLDER MANDATORY "The root folder to backup" "/backup/rsnapshot";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
