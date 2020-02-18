GO

--Drop SyncJobErrors
IF EXISTS ( SELECT  1
            FROM    sysobjects
            WHERE   xtype = 'u'
                    AND name = 'ReportConfig' ) 
    BEGIN 
        DROP TABLE [dbo].[ReportConfig]
    END

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ReportConfig](
	[ReportConfigID] [int] NOT NULL,
	[ReportPartitionID] [int] NOT NULL,
	[AuthenticationType] varchar(50) NOT NULL CHECK ([AuthenticationType] IN ( 'Basic' ) ),
	[Url] VARCHAR(100) NOT NULL,
	[UserName] VARCHAR(100) NOT NULL,
	[Password] VARCHAR(100) NOT NULL,
	[Timeout] [int] NOT NULL,
 CONSTRAINT [PK_ReportConfig_1] PRIMARY KEY CLUSTERED 
(
	[ReportConfigID] ASC, [ReportPartitionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

INSERT INTO dbo.ReportConfig
        ( 
        ReportConfigID,
        ReportPartitionID,
        AuthenticationType ,
          Url ,
          UserName ,
          Password ,
          Timeout
        )
VALUES  (
1,
1,
 'Basic' , -- AuthenticationType - varchar(50)
          'http://kdev-db03.kareo.ent/ReportServer/ReportService.asmx' , -- Url - varchar(100)
          'KAREO0\reportuser' , -- UserName - varchar(100)
          '$report$' , -- Password - varchar(100)
          1800000  -- Timeout - int
        )