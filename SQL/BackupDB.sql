--Backup script:

BACKUP DATABASE [KMB_26499_v4]
TO DISK = N'\\las-prod-sqlbackups\SQL_BACKUPS\D043\DATA\KMB_26499_v4.bak'
WITH NAME = N'KMB_26499_v4.bak-Full Database Backup',
FORMAT, COMPRESSION, COPY_ONLY, STATS = 10;
GO



BACKUP DATABASE [KMB_54551]
TO DISK = N'\\prod-sqlbackups\stage_data_copies\[KMB_54551].bak'
WITH FORMAT, NAME = N'[KMB_54551]-Full Database Backup',
COMPRESSION, STATS = 10;
GO




————

BACKUP DATABASE [KMB_DAG_552]
TO DISK = N'R:\MSSQL11.SHR01\MSSQL\Backup\KMB_DAG_552_v2.bak'
WITH FORMAT, NAME = N'KMB_DAG_552-Full Database Backup',
COMPRESSION, STATS = 10;
GO


USE [master]
RESTORE DATABASE [KMB_DAG_552_v2] FROM  DISK = N'R:\MSSQL11.SHR01\MSSQL\Backup\KMB_DAG_552_v2.bak' WITH  FILE = 1,
MOVE N'KMB_DAG_552'
TO N'R:\shr01_data01\sqldata\KMB_DAG_552_v4.mdf',
MOVE N'KMB_DAG_552_log'
TO N'R:\shr01_log01\sqllog\KMB_DAG_552_log_v4.ldf',
NOUNLOAD,  STATS = 5

GO