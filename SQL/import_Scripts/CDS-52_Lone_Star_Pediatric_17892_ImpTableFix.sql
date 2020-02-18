






/****** Object:  Table [dbo].[_import_1_1_paaPatientIns2]    Script Date: 02/11/2013 10:48:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[[_import_2_1_PolicyInformation2]]') AND type in (N'U'))
DROP TABLE [dbo]._import_2_1_PolicyInformation2
GO

USE [superbill_17892_prod]
GO

/****** Object:  Table [dbo].[_import_2_1_PolicyInformation2]    Script Date: 02/11/2013 10:48:36 ******/
SET ANSI_NULLS ON
GO

CREATE TABLE [dbo].[_import_2_1_PolicyInformation2](
	[AutoTempID] [int] NOT NULL,
	[patientnumber] [varchar](max) NULL,
	[insurancecompanynumber] [varchar](max) NULL,
	[precedence] [varchar](MAX) NULL,
	[groupnumber] [varchar](max) NULL,
	[policynumber] [varchar](max) NULL
) ON [PRIMARY]

GO


SET ANSI_PADDING OFF
GO


INSERT INTO dbo.[_import_2_1_PolicyInformation2]
        ( AutoTempID ,
          patientnumber ,
          insurancecompanynumber ,
          precedence ,
          groupnumber ,
          policynumber
        )
SELECT    AutoTempID ,
          patientnumber ,
          insurancecompanynumber ,
          ROW_NUMBER() OVER (PARTITION BY patientnumber ORDER BY patientnumber,insurancecompanynumber)  ,
          groupnumber ,
          policynumber
FROM dbo.[_import_2_1_PolicyInformation] 

SELECT * FROM dbo.[_import_2_1_PolicyInformation2]
WHERE precedence = 2