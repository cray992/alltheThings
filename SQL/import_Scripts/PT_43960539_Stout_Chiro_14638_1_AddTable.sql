
USE [superbill_14638_prod]
GO

/****** Object:  Table [dbo].[_import_1_1_paaPatientIns2]    Script Date: 02/11/2013 10:48:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_import_1_1_paaPatientIns2]') AND type in (N'U'))
DROP TABLE [dbo].[_import_1_1_paaPatientIns2]
GO

USE [superbill_14638_prod]
GO

/****** Object:  Table [dbo].[_import_1_1_paaPatientIns2]    Script Date: 02/11/2013 10:48:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[_import_1_1_paaPatientIns2](
	[id] [varchar](max) NULL,
	[patientid] [varchar](max) NULL,
	[carrierid] [varchar](max) NULL,
	[idnum] [varchar](max) NULL,
	[groupno] [varchar](max) NULL,
	[groupname] [varchar](max) NULL,
	[copayamt] [varchar](max) NULL,
	[precedence] [varchar](max) NULL,
	[hold_firstname] [varchar](max) NULL,
	[hold_lastname] [varchar](max) NULL,
	[hold_mi] [varchar](max) NULL, 
	[hold_add1] [varchar](max) NULL,
	[hold_add2] [varchar](max) NULL,
	[hold_city] [varchar](max) NULL,
	[hold_st] [varchar](max) NULL,
	[hold_zip] [varchar](max) NULL,
	[hold_phone] [varchar](max) NULL,
	[hold_rel] [varchar](MAX) NULL,
	[hold_dob] [varchar](MAX) NULL,
	[hold_sex] [varchar](MAX) NULL, 
) ON [PRIMARY]


GO

SET ANSI_PADDING OFF
GO



INSERT INTO dbo.[_import_1_1_paaPatientIns2]
        ( id ,
		  idnum ,
          groupno ,
          groupname,
          precedence ,
          patientid ,
          carrierid ,
          copayamt ,
          hold_firstname ,
          hold_lastname ,
          hold_mi ,
          hold_add1 ,
          hold_add2 ,
          hold_city ,
          hold_st ,
          hold_zip ,
          hold_phone,
          hold_rel ,
          hold_dob ,
          hold_sex
        )
SELECT	  ins.id,
		  ins.idnum ,
          ins.groupno ,
          ins.groupname,
          ROW_NUMBER() OVER (PARTITION BY ins.patientid ORDER BY ins.patientid, ins.id),
          ins.patientid ,
          ins.carrierid ,
          ins.copayamt ,
          ins.firstname ,
          ins.lastname ,
          ins.mi ,
          ins.address ,
          ins.address2 ,
          ins.city ,
          ins.state ,
          ins.zip ,
          ins.phone ,
          ins.relid ,
          ins.dob ,
          ins.sex 
FROM dbo.[_import_1_1_paaPatientIns] ins





/*

USE [superbill_14638_prod]
GO

UPDATE dbo.InsurancePolicy 
	SET HolderFirstName = impip.hold_firstname , 
		HolderLastName = impip.hold_lastname ,
		HolderMiddleName = impip.hold_mi ,
		HolderAddressLine1 = impip.hold_add1 ,
		HolderAddressLine2 = impip.hold_add2 , 
		HolderCity = impip.hold_city ,
		HolderState = impip.hold_st ,
		HolderZipCode = LEFT(REPLACE(impip.hold_zip, '-', ''), 9) ,
		HolderPhone = LEFT(REPLACE(REPLACE(REPLACE(impip.hold_phone, '(', ''), ')', ''), '-', ''), 10) , 
		PatientRelationshipToInsured = CASE WHEN impip.hold_rel = 1 THEN 'S'
											WHEN impip.hold_rel = 2 THEN 'U'
											WHEN impip.hold_rel = 3 THEN 'C'
											WHEN impip.hold_rel = 4 THEN 'O' END,
		HolderDOB = CASE WHEN impip.hold_dob > GETDATE() THEN DATEADD(yy, -100, impip.hold_dob)
								ELSE impip.hold_dob END ,
		HolderGender = impip.hold_sex
	FROM dbo.InsurancePolicy ip
	INNER JOIN dbo.[_import_1_1_paaPatientIns2] impip ON 
		impip.id = ip.VendorID
	

*/	