IF EXISTS(SELECT * FROM sys.objects WHERE NAME='Manage_DatabaseGrowth' AND type='p')
DROP PROCEDURE Manage_DatabaseGrowth
GO 
CREATE PROCEDURE Manage_DatabaseGrowth AS

BEGIN 
SELECT c.DatabaseServerName,mds.DatabaseName,mds.FileSizeMB*1024 AS OriginalFileSize, mds.FileSizeMB*1.20*1024 NewSize,'ALTER DATABASE ['+ mds.databasename+' ] MODIFY FILE ( NAME = ''Customer_Data'', SIZE ='+ CAST( CAST(mds.FileSizeMB*1.20*1024 AS INTEGER)AS VARCHAR(64) )+'kb) 
GO' AS AlterStatement
FROM Manage_DatabaseSpace AS mds
INNER JOIN (
SELECT mds.DatabaseName,MAX(mds.DateChecked) AS DateChecked
FROM KareoMaintenance.dbo.Manage_DatabaseSpace AS mds
GROUP BY mds.DatabaseName) sub ON mds.DatabaseName = sub.DatabaseName AND mds.DateChecked=sub.DateChecked
INNER JOIN Superbill_Shared.dbo.Customer AS c ON sub.DatabaseName = c.DatabaseName
WHERE mds.PercentUnusedSpace<=.10 AND mds.FileType='Data'
End