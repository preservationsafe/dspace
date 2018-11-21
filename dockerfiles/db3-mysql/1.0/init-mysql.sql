#Have mysql run in read-only mode:
FLUSH TABLES WITH READ LOCK;
SET GLOBAL read_only = 1;
COMMIT;
SHOW VARIABLES;
#Have mysql run in read-write mode:
#SET GLOBAL read_only = 0;
#UNLOCK TABLES;
#COMMIT;
