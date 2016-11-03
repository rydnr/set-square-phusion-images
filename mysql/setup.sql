GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'secret' WITH GRANT OPTION;
CREATE USER 'dbadmin'@'localhost' IDENTIFIED BY 'secret';
GRANT ALL PRIVILEGES ON *.* TO 'dbadmin'@'localhost' IDENTIFIED BY 'secret' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'dbadmin'@'___LAN___' IDENTIFIED BY 'secret' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'dbadmin'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
GRANT ALL PRIVILEGES on *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY '___DEBIAN_SYS_MAINT_PASSWORD_HASH___' WITH GRANT OPTION;
