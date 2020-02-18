--drop table ServerWideDDLTracking

CREATE TABLE ServerWideDDLTracking
    (
      ID int IDENTITY(1, 1)
    , CreatedDate datetime DEFAULT ( GETDATE() )
	, ServerName nvarchar(100)
    , DbUser nvarchar(100)
	, SystemLogin nvarchar(100)
    , Event nvarchar(100)
    , DatabaseName sysname
    , TSQL nvarchar(2000)
    , FullEventData xml
    ) ;
	
GO

DROP TRIGGER tr_ddl_DbStatusChange ON ALL SERVER
go
CREATE  TRIGGER tr_ddl_DbStatusChange ON ALL SERVER
    FOR CREATE_DATABASE,
 ALTER_DATABASE,
 DROP_DATABASE
 
AS
BEGIN
    DECLARE @data xml
    SET @data = EVENTDATA()
	
	
    INSERT  KareoMaintenance.dbo.ServerWideDDLTracking
            ( ServerName
			, DbUser
            , SystemLogin
            , EVENT
            , DatabaseName
            , TSQL
            , FullEventData )
    VALUES  ( @data.value('(/EVENT_INSTANCE/ServerName)[1]', 'nvarchar(100)')
			, CONVERT(nvarchar(100), CURRENT_USER)
			, CONVERT(nvarchar(100), SYSTEM_USER)
            , @data.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(100)')
            , @data.value('(/EVENT_INSTANCE/DatabaseName)[1]', 'sysname')
            , @data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(2000)')
            , @data ) ;

	
END


