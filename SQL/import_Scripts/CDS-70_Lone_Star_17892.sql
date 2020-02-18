USE superbill_17892_prod
GO
SET XACT_ABORT ON

BEGIN TRAN 

SET NOCOUNT ON

DECLARE @PracticeID INT 
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 107

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


PRINT ''
PRINT 'Updating Patient records...'
UPDATE dbo.Patient
	SET ResponsibleRelationshipToPatient = 'O',
		ResponsibleFirstName = (SELECT top 1 guarantorpartyfirstname FROM dbo.[_import_107_1_Guarantor] WHERE pat.firstname = patientfirst AND pat.lastname = patientlast AND pat.middlename = patientmiddle AND pat.vendorID = pat),
		ResponsibleLastName = (SELECT TOP 1 guarantorpartylastname FROM dbo.[_import_107_1_Guarantor] WHERE pat.firstname = patientfirst AND pat.lastname = patientlast AND pat.middlename = patientmiddle AND pat.vendorID = pat),
		ResponsibleAddressLine1 = (SELECT TOP 1 guarantorpartyaddress1 FROM dbo.[_import_107_1_Guarantor] WHERE pat.firstname = patientfirst AND pat.lastname = patientlast AND pat.middlename = patientmiddle AND pat.vendorID = pat),
		ResponsibleAddressLine2 = (SELECT TOP 1 guarantorpartyaddress2 FROM dbo.[_import_107_1_Guarantor] WHERE pat.firstname = patientfirst AND pat.lastname = patientlast AND pat.middlename = patientmiddle AND pat.vendorID = pat),
		ResponsibleCity = (SELECT TOP 1 guarantorpartycity FROM dbo.[_import_107_1_Guarantor] WHERE pat.firstname = patientfirst AND pat.lastname = patientlast AND pat.middlename = patientmiddle AND pat.vendorID = pat),
		ResponsibleZipCode = (SELECT TOP 1 guarantorpartyzip5 FROM dbo.[_import_107_1_Guarantor] WHERE pat.firstname = patientfirst AND pat.lastname = patientlast AND pat.middlename = patientmiddle AND pat.vendorID = pat),
		ResponsibleState = (SELECT TOP 1 guarantorpartystate FROM dbo.[_import_107_1_Guarantor] WHERE pat.firstname = patientfirst AND pat.lastname = patientlast AND pat.middlename = patientmiddle AND pat.vendorID = pat)
	FROM dbo.Patient pat 
		WHERE pat.PracticeID = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting into PatientCase ...'
INSERT INTO dbo.PatientCase 
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT 
	      pat.PatientID , -- PatientID - int
          'Default Case #2' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via update to data import.' , -- Notes - text
          1 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- PracticeID - int
          imp.pat , -- VendorID - varchar(50)
          3  -- VendorImportID - int
FROM dbo.[_import_107_1_SubscriberInfo] imp 
INNER JOIN dbo.Patient pat ON
	pat.vendorID = imp.pat AND
	pat.VendorImportID = 2
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserting'







CREATE TABLE [dbo].[_import_107_1_SubscriberInfo2](
	[AutoTempID] [int] NOT NULL,
	[pat] [varchar](max) NULL,
	[coveragenotes] [varchar](max) NULL,
	[sublname] [varchar](max) NULL,
	[subfname] [varchar](max) NULL,
	[subminit] [varchar](max) NULL,
	[subssn] [varchar](max) NULL,
	[subdob] [varchar](max) NULL,
	[subsex] [varchar](max) NULL,
	[patsubrel] [varchar](max) NULL,
	[precedence] [varchar](max) NULL,
	[policy] [varchar](max) NULL,
	[group] [varchar](max) NULL,
	[effectivestart] [varchar](max) NULL,
	[effectiveend] [varchar](max) NULL,
	[subemployer] [varchar](max) NULL
) ON [PRIMARY]

GO

INSERT INTO dbo.[_import_107_1_SubscriberInfo2]
        ( AutoTempID ,
          pat ,
          coveragenotes ,
          sublname ,
          subfname ,
          subminit ,
          subssn ,
          subdob ,
          subsex ,
          patsubrel ,
          precedence , 
          policy ,
          [group] ,
          effectivestart ,
          effectiveend ,
          subemployer
        )
SELECT    AutoTempID ,
          pat ,
          coveragenotes ,
          sublname ,
          subfname ,
          subminit ,
          subssn ,
          subdob ,
          subsex ,
          patsubrel ,
          ROW_NUMBER() OVER (PARTITION BY pat ORDER BY pat,AutoTempID)  ,
          policy ,
          [group] ,
          effectivestart ,
          effectiveend ,
          subemployer
FROM dbo.[_import_107_1_SubscriberInfo] 



PRINT''
PRINT'Inserting into Insurance Policy ...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderSSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderGender ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          imp.precedence , -- Precedence - int
          imp.policy , -- PolicyNumber - varchar(32)
          imp.[group] , -- GroupNumber - varchar(32)
          imp.effectivestart , -- PolicyStartDate - datetime
          CASE imp.patsubrel WHEN 1 THEN 'S'
							 WHEN 5 THEN 'O' 
							 WHEN 6 THEN 'U'
							 ELSE 'O' END  , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          imp.subfname , -- HolderFirstName - varchar(64)
          imp.subminit , -- HolderMiddleName - varchar(64)
          imp.sublname , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          imp.subssn , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          imp.subsex , -- HolderGender - char(1)
          imp.policy , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          1 , -- PracticeID - int
          impPat.insco + imp.pat , -- VendorID - varchar(50)
          3  -- VendorImportID - int
FROM dbo.[_import_107_1_OriginalPatientDemos] impPat
LEFT JOIN  dbo.[_import_107_1_SubscriberInfo2] imp ON 
	impPat.chartnumber = imp.pat 
INNER JOIN dbo.PatientCase pc ON 
	pc.VendorID = imp.pat AND
	pc.VendorImportID = 3
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = impPat.insco
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserting'
	
	
	COMMIT
	