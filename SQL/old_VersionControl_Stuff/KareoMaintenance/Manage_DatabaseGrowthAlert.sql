IF EXISTS(SELECT * FROM sys.objects WHERE NAME='Manage_DatabaseGrowthAlert' AND type='p')
DROP PROCEDURE Manage_DatabaseGrowthAlert
GO 

CREATE PROCEDURE  Manage_DatabaseGrowthAlert
AS 
IF NOT EXISTS(
SELECT mds.DatabaseName
FROM Manage_DatabaseSpace AS mds
INNER JOIN (
SELECT mds.DatabaseName,MAX(mds.DateChecked) AS DateChecked
FROM Manage_DatabaseSpace AS mds
GROUP BY mds.DatabaseName) sub ON mds.DatabaseName = sub.DatabaseName AND mds.DateChecked=sub.DateChecked
INNER JOIN Superbill_Shared.dbo.Customer AS c ON sub.DatabaseName = c.DatabaseName
WHERE mds.PercentUnusedSpace<=.10 AND mds.FileType='Data')
RETURN

Else
EXEC msdb.dbo.sp_send_dbmail
    @recipients = N'pam.ozer@kareo.com', 
    @query = 'EXEC KareoMaintenance.dbo.Manage_DatabaseGrowth',
    @subject = N'Databases that need to grow',
    @profile_name='default profile',
    @attach_query_result_as_file=0,
    @query_result_header=1