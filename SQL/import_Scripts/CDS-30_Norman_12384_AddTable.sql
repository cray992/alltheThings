
USE [superbill_12384_prod]
GO

/****** Object:  Table [dbo].[_import_1_1_paaPatientIns2]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_import_2_1_Policy2]') AND type in (N'U'))
DROP TABLE [dbo].[_import_2_1_Policy]
GO

USE [superbill_12384_prod]
GO

/****** Object:  Table [dbo].[_import_2_1_Policy2]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[_import_2_1_Policy2](
	AutoTempID [varchar](MAX) NULL,
    insuranceid [varchar](MAX) NULL,
    patientid [varchar](MAX) NULL,
    precedence [varchar](MAX) NULL,
    policy [varchar](MAX) NULL,
    groupnumber [varchar](MAX) NULL,
    copay [varchar](MAX) NULL,
) ON [PRIMARY]


GO

SET ANSI_PADDING OFF
GO



INSERT INTO dbo.[_import_2_1_Policy2]
        ( AutoTempID ,
          insuranceid ,
          patientid ,
          precedence ,
          policy ,
          groupnumber ,
          copay
        )
SELECT	  AutoTempID ,
          insuranceid ,
          patientid ,
          ROW_NUMBER() OVER (PARTITION BY ins.patientid ORDER BY ins.patientid, ins.AutoTempID),
          policy ,
          groupnumber ,
          copay
FROM dbo.[_import_2_1_Policy] ins


