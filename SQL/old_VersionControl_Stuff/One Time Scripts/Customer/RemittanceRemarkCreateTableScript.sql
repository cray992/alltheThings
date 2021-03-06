--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RemittanceRemark]') AND type in (N'U'))
--BEGIN
--CREATE TABLE [dbo].[RemittanceRemark](
--	[RemittanceRemarkID] [int] IDENTITY(1,1) NOT NULL,
--	[RemittanceCode] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--	[RemittanceDescription] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--	[RemittanceNotes] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_RemittanceRemarks_CreatedDate]  DEFAULT (getdate()),
--	[CreatedUserID] [int] NOT NULL CONSTRAINT [DF_RemittanceRemarks_CreatedUserID]  DEFAULT ((0)),
--	[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_RemittanceRemarks_ModifiedDate]  DEFAULT (getdate()),
--	[ModifiedUserID] [int] NOT NULL CONSTRAINT [DF_RemittanceRemarks_ModifiedUserID]  DEFAULT ((0)),
--	[KareoLastModifiedDate] [datetime] NULL
--) ON [PRIMARY]
--END


--////////////////////////////////////////////////////////
-- Loop through databases adding table

DECLARE @DatabaseServerName varchar(128)
DECLARE @DatabaseName varchar(128)
DECLARE @DatabasePath varchar(256)
DECLARE @sql varchar(8000)

DECLARE sync_proc_cursor CURSOR
READ_ONLY
FOR 	SELECT DISTINCT '['+C.DatabaseServerName+']', C.DatabaseName
		FROM dbo.Customer C
		WHERE DBActive = 1 -- AND SyncDiagnosis=1
	UNION
	SELECT '['+@@servername+']', 'CustomerModel'
	UNION
	SELECT '['+@@servername+']', 'CustomerModelPrePopulated'

OPEN sync_proc_cursor

FETCH NEXT FROM sync_proc_cursor INTO @DatabaseServerName, @DatabaseName
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		SET @DatabasePath = @DatabaseServerName + '.' + @DatabaseName

		PRINT 'Processing for database: ' + @DatabasePath
				--update the records that are common and have changed
		SET @sql = 'USE ' + @DatabaseName + '
					IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''' + @DatabaseName + '.dbo.RemittanceRemark'') AND type in (N''U''))
					BEGIN 
						CREATE TABLE '+ @DatabaseName + '.[dbo].[RemittanceRemark](
							[RemittanceRemarkID] [int] IDENTITY(1,1) NOT NULL,
							[RemittanceCode] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
							[RemittanceDescription] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
							[RemittanceNotes] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
							[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_RemittanceRemarks_CreatedDate]  DEFAULT (getdate()),
							[CreatedUserID] [int] NOT NULL CONSTRAINT [DF_RemittanceRemarks_CreatedUserID]  DEFAULT ((0)),
							[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_RemittanceRemarks_ModifiedDate]  DEFAULT (getdate()),
							[ModifiedUserID] [int] NOT NULL CONSTRAINT [DF_RemittanceRemarks_ModifiedUserID]  DEFAULT ((0)),
							[KareoLastModifiedDate] [datetime] NULL
						) ON [PRIMARY]
					END'

--		PRINT @sql
		EXEC(@sql)	


	END
	FETCH NEXT FROM sync_proc_cursor INTO @DatabaseServerName, @DatabaseName
END
CLOSE sync_proc_cursor
DEALLOCATE sync_proc_cursor

--SELECT * FROM CustomerModel.dbo.sys.objects WHERE object_id = OBJECT_ID(N'CustomerModel.dbo.RemittanceRemarks') AND type in (N'U')
