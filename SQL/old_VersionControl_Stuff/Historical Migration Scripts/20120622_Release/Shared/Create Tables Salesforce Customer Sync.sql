IF EXISTS ( SELECT  1
            FROM    sysobjects
            WHERE   xtype = 'u'
                    AND name = 'Salesforce_Customer' ) 
    BEGIN 
        DROP TABLE [dbo].[Salesforce_Customer]
    END
    
    IF EXISTS ( SELECT  1
            FROM    sysobjects
            WHERE   xtype = 'u'
                    AND name = 'Salesforce_CompanyType' ) 
    BEGIN 
        DROP TABLE [dbo].[Salesforce_CompanyType]
    END

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Salesforce_CompanyType](
Salesforce_CompanyTypeID INT NOT NULL IDENTITY,
Salesforce_Lead_Type VARCHAR(100) NULL
 CONSTRAINT [PK_Salesforce_CompanyType] PRIMARY KEY CLUSTERED 
(
	Salesforce_CompanyTypeID ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

INSERT INTO dbo.Salesforce_CompanyType
        ( Salesforce_Lead_Type )
SELECT 'Other'
UNION ALL
SELECT 'Billing Service'
UNION ALL
SELECT 'Physician Practice'
UNION ALL
SELECT 'RCM Practice Customer'
UNION ALL
SELECT 'VIP Billing Service'
    

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Salesforce_Customer](
CustomerID INT NOT NULL,-- CONSTRAINT [FK_Customer_Salesforce_Customer_CustomerID] FOREIGN KEY REFERENCES dbo.Customer(CustomerID),
AssistedEnrollments bit NOT NULL,
Salesforce_CompanyTypeID INT NOT NULL CONSTRAINT [DF_Customer_Salesforce_Salesforce_CompanyTypeID]  DEFAULT ((1)) CONSTRAINT [FK_Customer_Salesforce_Salesforce_CompanyType_Salesforce_CompanyTypeID] FOREIGN KEY REFERENCES dbo.Salesforce_CompanyType(Salesforce_CompanyTypeID),
[Type] VARCHAR(100) NULL,
ModifiedDate DATETIME NULL,
LastSyncedDateTime DATETIME NOT NULL CONSTRAINT [DF_Customer_Salesforce_LastSyncedDateTime]  DEFAULT ((GETDATE())),
 CONSTRAINT [PK_Customer_Salesforce] PRIMARY KEY CLUSTERED 
(
	CustomerID ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
