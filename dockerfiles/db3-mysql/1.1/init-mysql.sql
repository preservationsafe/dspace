#Have mysql run in read-only mode:
USE mysql;
DELETE FROM user WHERE user='irrapuser';
CREATE USER irrapuser IDENTIFIED BY 'RdfiaTsnk@(';
grant ALL PRIVILEGES ON *.* TO 'irrapuser';
FLUSH PRIVILEGES;
FLUSH TABLES WITH READ LOCK;
SET GLOBAL read_only = 1;
COMMIT;
SHOW VARIABLES;
#Have mysql run in read-write mode:
#SET GLOBAL read_only = 0;
#UNLOCK TABLES;
#COMMIT;
