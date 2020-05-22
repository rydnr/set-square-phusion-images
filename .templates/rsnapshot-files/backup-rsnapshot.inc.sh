# env: BACKUP_FOLDER_SCRIPT: The backup-folder.sh location. Defaults to /usr/local/bin/backup-folder.sh.
defineEnvVar BACKUP_FOLDER_SCRIPT OPTIONAL "The backup-folder.sh location" "/usr/local/bin/backup-folder.sh";
# env: RSNAPSHOT_SOURCE_FOLDER: The rsnapshot source folder. Defaults to /backup/rsnapshot.
defineEnvVar RSNAPSHOT_SOURCE_FOLDER OPTIONAL "The rsnapshot source folder" "/backup/rsnapshot";
# env: RSNAPSHOT_DESTINATION_FOLDER: The rsnapshot destination folder. Defaults to /backup/rsnapshot.
defineEnvVar RSNAPSHOT_DESTINATION_FOLDER OPTIONAL "The rsnapshot destination folder" "/backup/rsnapshot";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
