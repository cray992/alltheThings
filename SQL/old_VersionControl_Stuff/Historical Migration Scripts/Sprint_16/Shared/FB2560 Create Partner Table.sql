USE [Superbill_Shared]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT  1
            FROM    sysobjects
            WHERE   xtype = 'u'
                    AND name = 'Partner' ) 
    BEGIN 
		ALTER TABLE Customer
		DROP CONSTRAINT FK_Customer_PartnerID
      
		DROP TABLE [dbo].[Partner]
    END
    
GO

CREATE TABLE dbo.[Partner]
	(
	PartnerID int NOT NULL IDENTITY (1, 1),
	Name varchar(100) NOT NULL,
	QuickBooksIdentifier varchar(50) NULL,
	AllowEInvoice bit NOT NULL
	)  ON [PRIMARY]
GO

ALTER TABLE dbo.[Partner] ADD CONSTRAINT
	DF_Partner_AllowEInvoice DEFAULT 1 FOR AllowEInvoice
	
GO

ALTER TABLE dbo.[Partner] ADD CONSTRAINT
	PK_Partner PRIMARY KEY CLUSTERED 
	(
	PartnerID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO


--Insert Quest Partner
INSERT INTO dbo.[Partner] ( NAME, QuickBooksIdentifier, AllowEInvoice)
SELECT 'Kareo' AS NAME, NULL AS QuickBooksIdentifier, 1 AS AllowEInvoice
UNION ALL
SELECT 'Quest' AS Name,NULL AS QuickBooksIdentifier, 0 AS AllowEInvoice
UNION ALL SELECT 'Practice Fusion', NULL, 1
UNION ALL SELECT 'WebPT', NULL, 1
UNION ALL SELECT 'Modernizing Medicine', NULL, 1
UNION ALL SELECT 'nextEMR', NULL, 1

SELECT * FROM dbo.Partner