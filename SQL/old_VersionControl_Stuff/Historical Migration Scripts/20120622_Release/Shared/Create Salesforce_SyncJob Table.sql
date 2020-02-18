IF EXISTS ( SELECT  1
            FROM    sysobjects
            WHERE   xtype = 'u'
                    AND name = 'DataCollection_Job' ) 
    BEGIN 
        DROP TABLE [dbo].[DataCollection_Job]
    END
    


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DataCollection_Job](
DataCollection_JobID INT NOT NULL IDENTITY,
Name VARCHAR(100) NULL,
LastSuccessfulSync DATETIME NULL
 CONSTRAINT [PK_DataCollection_Job] PRIMARY KEY CLUSTERED 
(
	DataCollection_JobID ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

INSERT INTO dbo.DataCollection_Job
        ( Name, LastSuccessfulSync )
VALUES  ( 'SF_Account', -- Name - varchar(100)
          NULL  -- LastSuccessfulSync - datetime
          )
          