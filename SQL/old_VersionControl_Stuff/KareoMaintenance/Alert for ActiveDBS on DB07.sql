

IF EXISTS(
SELECT c.DatabaseName
FROM Customer AS c
WHERE customertype='N' AND c.DatabaseServerName='KPROD-DB07' AND c.DBActive=1 AND c.Cancelled=0)

EXEC msdb.dbo.sp_send_dbmail
@profile_name='default profile',
@recipients='pam.ozer@kareo.com',
@subject='Reactivated Customers On DB07',
@query='SELECT c.DatabaseName
FROM superbill_shared.dbo.Customer AS c
WHERE customertype=''N'' AND c.DatabaseServerName=''KPROD-DB07'' AND c.DBActive=1 AND c.Cancelled=0',
@attach_query_result_as_file = 1 ;


