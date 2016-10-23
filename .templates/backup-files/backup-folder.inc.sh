defineEnvVar SOURCE "The source folder" "/backup/rsnapshot/";
defineEnvVar DESTINATION "The destination folder" "~/rsnapshot/";
defineEnvVar SSH_OPTIONS "The SSH options used to connect to the remote host" "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /etc/ssh/ssh_host_dsa_key -q";
defineEnvVar RSYNC_OPTIONS "The rsync options used to connect to the remote host" '-az -H --numeric-ids';
defineEnvVar BACKUP_ROOT_FOLDER "The root folder to backup" "/backup/rsnapshot";
