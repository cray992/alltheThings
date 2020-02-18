USE [Superbill_Shared]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Drop [HL7Partner]
IF EXISTS ( SELECT  1
            FROM    sysobjects
            WHERE   xtype = 'u'
                    AND name = 'HL7Partner' ) 
    BEGIN 
        DROP TABLE [dbo].[HL7Partner]
    END


--Create [HL7Partner] Table
CREATE TABLE [dbo].[HL7Partner]
    (
      [HL7PartnerID] [int] IDENTITY(1, 1) NOT NULL,
      [Name] nvarchar(100) NOT NULL,
      [Active] BIT NOT NULL DEFAULT 0 ,
      [SortOrder] int NOT NULL DEFAULT 0 ,
      CONSTRAINT [PK_HL7Partner] PRIMARY KEY CLUSTERED ( [HL7PartnerID] ASC )
        WITH ( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,
               IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
               ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY]
    )
ON  [PRIMARY]

GO

--SET IDENTITY_INSERT dbo.[HL7Partner] ON
--GO


INSERT INTO dbo.[HL7Partner]
        ( Name, Active,SortOrder )
VALUES  ( 
		  N'None', -- Name - nvarchar(100)
          1,  -- Active - bit,
          10 --SortOrder
          )

INSERT INTO dbo.HL7Partner
        ( Name, Active,SortOrder )
VALUES  ( N'Quest', -- Name - nvarchar(100)
          1,  -- Active - bit,
          20 --SortOrder
          )
          
--SET IDENTITY_INSERT dbo.[HL7Partner] OFF