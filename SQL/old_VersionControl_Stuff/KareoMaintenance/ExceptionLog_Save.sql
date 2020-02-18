--===========================================================================
--
-- EXCEPTION LOG TEST
--
--===========================================================================

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'ExceptionLog_Save'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.ExceptionLog_Save
GO

CREATE PROCEDURE dbo.ExceptionLog_Save
	@Date datetime,
    @AppServerName varchar(300),
    @DatabaseServerName varchar(128) = null,
    @DatabaseName varchar(128) = null,
    @StoredProcedure varchar(200) = null,
    @Exception varchar(MAX),
    @StackTrace varchar(MAX) = null,
    @LogFileName varchar(1000) = null,
    @ExceptionType varchar(100),
    @SourceFile varchar(200)
AS

BEGIN
IF NOT EXISTS
(
	SELECT * FROM dbo.SqlExceptionLog
	WHERE Date = @Date 
	AND DatabaseName = @DatabaseName 
	AND StoredProcedure = @StoredProcedure 
	AND EXCEPTION = @Exception
 ) 
	 BEGIN 

		 INSERT INTO dbo.SqlExceptionLog
				( [Date] ,
				  AppServerName ,
				  DatabaseServerName ,
				  DatabaseName ,
				  StoredProcedure ,
				  Exception ,
				  StackTrace ,
				  LogFileName,
				  ExceptionType,
				  SourceFile
				)
		 VALUES ( @Date , -- Date - datetime
				  @AppServerName , -- AppServerName - sysname
				  @DatabaseServerName , -- DatabaseServerName - sysname
				  @DatabaseName , -- DatabaseName - varchar(50)
				  @StoredProcedure , -- StoredProcedure - varchar(200)
				  @Exception , -- Exception - varchar(max)
				  @StackTrace , -- StackTrace - varchar(max)
				  @LogFileName , -- LogFileName - varchar(1000)
				  @ExceptionType,
				  @SourceFile
				) 
	END
END
GO