---FileGrowth

SELECT  Data.StartingDataFileSize
,       Data.EndingDataFileSize
,		Data.EndingDataFileSize-Data.StartingDataFileSize AS DataFileGrowth
,       Data.DatabaseName
,       Data.StartingDate
,       Data.EndingDate
,       Data.ServerName
,       LogSize.StartingLogFileSize
,       LogSize.EndingLogFileSize
,		LogSize.EndingLogFileSize-LogSize.StartingLogFileSize AS LogFileGrowth
,       LogSize.DatabaseName
,       LogSize.StartingDate
,       LogSize.EndingDate
,       LogSize.ServerName
,       LogSize.DBActive
FROM (

SELECT  MIN(mds.FileSizeMB)StartingDataFileSize
,MAX(mds.FileSizeMB)EndingDataFileSize
,       mds.DatabaseName,       
MIN(mds.DateChecked)AS StartingDate,
MAX(mds.DateChecked)AS EndingDate

,       mds.ServerName
,       c.DBActive
--,       c.CreatedDate
--,       c.Cancelled
--,       c.CancellationDate
FROM Manage_DatabaseSpace AS mds
INNER JOIN superbill_shared.dbo.Customer AS c ON mds.DatabaseName = c.DatabaseName
WHERE mds.FileType='Data' AND mds.ServerName<>'KPROD-DB07' 
GROUP BY mds.DatabaseName, mds.ServerName, c.DBActive
HAVING  MIN(mds.FileSizeMB)<Max(mds.FileSizeMB)
--ORDER BY mds.DatabaseName--, mds.DateChecked
)Data
Full JOIN (
SELECT  MIN(mds.FileSizeMB)StartingLogFileSize
,MAX(mds.FileSizeMB)EndingLogFileSize
,       mds.DatabaseName,       
MIN(mds.DateChecked)AS StartingDate,
MAX(mds.DateChecked)AS EndingDate

,       mds.ServerName
,       c.DBActive
FROM Manage_DatabaseSpace AS mds
INNER JOIN superbill_shared.dbo.Customer AS c ON mds.DatabaseName = c.DatabaseName
WHERE mds.FileType='Log' AND mds.ServerName<>'KPROD-DB07' 
GROUP BY mds.DatabaseName, mds.ServerName, c.DBActive
HAVING  MIN(mds.FileSizeMB)<Max(mds.FileSizeMB))LogSize ON Data.DatabaseName = LogSize.DatabaseName
ORDER BY Data.StartingDataFileSize desc


----Databases To Shrink?
SELECT  Data.DatabaseName
,       Data.FileSize
,       Data.UsedSpace
,       DLog.LogFileSize
,       DLog.LogUsedSpace
FROM (

SELECT DISTINCT mds.DatabaseName, MAX(mds.FileSizeMB)FileSize, MAX(mds.UsedSpaceMB)UsedSpace
FROM Manage_DatabaseSpace AS mds
WHERE mds.PercentUnusedSpace>.7 AND FileType='Data' AND mds.FileSizeMB>=1000
GROUP BY Mds.DatabaseName
)Data--ORDER BY FileSize DESC ,mds.DatabaseName
INNER JOIN (

SELECT DISTINCT mds.DatabaseName, MAX(mds.FileSizeMB)LogFileSize, MAX(mds.UsedSpaceMB)LogUsedSpace
FROM Manage_DatabaseSpace AS mds
INNER JOIN (SELECT DISTINCT mds.DatabaseName, MAX(mds.FileSizeMB)FileSize, MAX(mds.UsedSpaceMB)UsedSpace
FROM Manage_DatabaseSpace AS mds
WHERE mds.PercentUnusedSpace>.7 AND FileType='Data' AND mds.FileSizeMB>=1000
GROUP BY Mds.DatabaseName)dbs ON mds.DatabaseName=dbs.DatabaseName

WHERE  FileType='LOG' 
GROUP BY Mds.DatabaseName
)DLog ON Data.DatabaseName = DLog.DatabaseName
ORDER BY FileSize DESC ,Data.DatabaseName