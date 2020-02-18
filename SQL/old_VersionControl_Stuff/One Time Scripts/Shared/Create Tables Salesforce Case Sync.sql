IF EXISTS ( SELECT  1
            FROM    sysobjects
            WHERE   xtype = 'u'
                    AND name = 'Salesforce_Case' ) 
    BEGIN 
        DROP TABLE [dbo].[Salesforce_Case]
    END
    
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO


CREATE TABLE [dbo].[Salesforce_Case](
CaseID VARCHAR(15) NOT NULL,
CustomerID INT NOT NULL,-- CONSTRAINT [FK_Customer_Salesforce_Customer_CustomerID] FOREIGN KEY REFERENCES dbo.Customer(CustomerID),
Webinar300Date DATETIME NULL,
ModifiedDate DATETIME NULL,
LastSyncedDateTime DATETIME NOT NULL CONSTRAINT [DF_Customer_Case_LastSyncedDateTime]  DEFAULT ((GETDATE())),
 CONSTRAINT [PK_Salesforce_Case] PRIMARY KEY CLUSTERED 
(
	CaseID ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


CREATE NONCLUSTERED INDEX [IX_Salesforce_Case_CustomerID] ON [dbo].[Salesforce_Case] ([CustomerID]) INCLUDE ([Webinar300Date]) ON [PRIMARY]
GO

INSERT INTO dbo.DataCollection_Job
        ( Name, LastSuccessfulSync )
VALUES  ( 'SF_Case', -- Name - varchar(100)
          NULL  -- LastSuccessfulSync - datetime
          )