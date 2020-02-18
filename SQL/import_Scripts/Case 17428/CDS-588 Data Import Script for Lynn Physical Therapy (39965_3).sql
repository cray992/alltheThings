USE superbill_39965_dev
--USE superbill_39965_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 3
SET @VendorImportID = 3

SET NOCOUNT ON 


PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


-- Patient
PRINT ''
PRINT 'Inserting records into Patient ...'
INSERT INTO dbo.Patient (
	PracticeID ,
	Prefix ,
	LastName ,
	FirstName ,
	MiddleName ,
	Suffix ,
	AddressLine1 ,
	AddressLine2 ,
	City ,
	[State] ,
	Country ,
	ZipCode ,
	Gender ,
	MaritalStatus ,
	HomePhone ,
	WorkPhone,
	WorkPhoneExt,
	DOB ,
	SSN ,
	EmailAddress,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	EmploymentStatus ,
	MedicalRecordNumber,
	ReferringPhysicianID,
	--PrimaryProviderID,
	--EmployerID , 
	VendorID ,
	VendorImportID ,
	CollectionCategoryID ,
	Active ,
	SendEmailCorrespondence ,
	PhonecallRemindersEnabled ,
	MobilePhone
	)
SELECT DISTINCT
	@PracticeID
	,''
	,pat.lastname
	,pat.firstname
	,pat.middle
	,''
	,pat.AddressOne 
	,pat.AddressTwo
	,pat.City
	,LEFT(pat.[State], 2)
	,''
	,LEFT(REPLACE(pat.ZipCode, '-', ''), 9)
	,pat.Gender 
	,CASE pat.MaritalStatus 
		WHEN 'D' THEN 'D'
		WHEN 'M' THEN 'M'
		WHEN 'S' THEN 'S'
		WHEN 'W' THEN 'W'
		ELSE 'U'
	END
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.HomePhone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.WorkPhone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE WHEN ISNUMERIC(pat.workext) = 1 THEN pat.workext ELSE '' END 
	,CASE ISDATE(pat.BirthDate) WHEN 1 
		THEN CASE WHEN pat.birthdate > GETDATE() THEN DATEADD(yy, -100, pat.birthdate) 
			ELSE pat.birthdate END 
		ELSE NULL END 
	,LEFT(REPLACE(pat.SSN, '-', ''), 9)
	,pat.emailAddress
	,GETDATE()
	,0
	,GETDATE()
	,0
	,CASE pat.StudentStatus
		WHEN 'F' THEN 'S'
		WHEN 'P' THEN 'T'
		ELSE 'U' -- Employment Status
	END
	,pat.id -- MedicalRecordNumber
	,CASE WHEN pat.[referralid] <> '' THEN (SELECT DoctorID FROM dbo.Doctor WHERE VendorID = referralid AND PracticeID = @PracticeID) ELSE NULL END 
	--,(Select DoctorID FROM dbo.Doctor WHERE PracticeID = @PracticeID AND [External] = 0) -- PrimaryCarePhysicianID
	--,CASE WHEN pat.employerid <> '' THEN emp.EmployerID ELSE NULL END 
	,pat.[ID] -- VendorID 
	,@VendorImportID
	,1
	,1
	,CASE WHEN emailAddress <> '' THEN 1 ELSE 0 END
	,0
	,pat.cellphone
FROM dbo.[_import_3_3_Patient] pat
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

-- Patient Case 
PRINT ''
PRINT 'Inserting records into PatientCase ...'
INSERT INTO dbo.PatientCase
( 
	PatientID , Name , Active , PayerScenarioID , ReferringPhysicianID , EmploymentRelatedFlag , AutoAccidentRelatedFlag , OtherAccidentRelatedFlag , 
	AbuseRelatedFlag , AutoAccidentRelatedState , Notes , ShowExpiredInsurancePolicies , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , PracticeID , CaseNumber , WorkersCompContactInfoID , VendorID , VendorImportID , PregnancyRelatedFlag , StatementActive , 
	EPSDT , FamilyPlanning , EPSDTCodeID , EmergencyRelated , HomeboundRelatedFlag
)
SELECT DISTINCT 
	PatientID , -- PatientID - int
	'Default Case' , -- Name - varchar(128)
	1 , -- Active - bit
	5 , -- PayerScenarioID - int
	NULL , -- ReferringPhysicianID - int
	0 , -- EmploymentRelatedFlag - bit
	0, -- AutoAccidentRelatedFlag - bit
	0, -- OtherAccidentRelatedFlag - bit
	0, -- AbuseRelatedFlag - bit
	NULL , -- AutoAccidentRelatedState - char(2)
	CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
	0, -- ShowExpiredInsurancePolicies - bit
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	@PracticeID , -- PracticeID - int
	NULL , -- CaseNumber - varchar(128)
	NULL , -- WorkersCompContactInfoID - int
	VendorID , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	0, -- PregnncyRelatedFlag - bit
	1, -- StatementActive - bit
	0, -- EPSDT - bit
	0, -- FamilyPlanning - bit
	1 , -- EPSDTCodeID - int
	0 , -- EmergencyRelated - bit
	0 -- HomeboundRelatedFlag
FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

-- Patient Journal Note
PRINT ''
PRINT 'Inserting records into PatientJournalNote ...'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientID ,
          UserName , 
          SoftwareApplicationID ,
          NoteMessage 
        )
SELECT    GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          realP.PatientID , -- PatientID - int
          'Import ',
          'K' , -- SoftwareApplicationID - char(1)
          pjn.text  -- NoteMessage - varchar(max)
FROM dbo._import_3_3_PatientNotes pjn
INNER JOIN dbo.Patient realP ON
	pjn.[id] = realP.VendorID AND
	realP.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy - Primary...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
          CardOnFile ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          HolderThroughEmployer ,
          HolderEmployerName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          DependentPolicyNumber ,
          Notes ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.insurancecompanyplanid , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          i.idnumber , -- PolicyNumber - varchar(32)
          '' , -- GroupNumber - varchar(32)
		  CASE ISDATE(i.effectivedate) WHEN 1 
			THEN CASE WHEN i.effectivedate > GETDATE() THEN DATEADD(yy, -100, i.effectivedate) 
			ELSE i.effectivedate END 
		  ELSE NULL END  , -- PolicyStartDate - datetime
		  CASE ISDATE(i.terminationdate) WHEN 1 
			THEN CASE WHEN i.terminationdate > GETDATE() THEN DATEADD(yy, -100, i.terminationdate) 
			ELSE i.terminationdate END 
		  ELSE NULL END  , -- PolicyEndDate - datetime
          0 , -- CardOnFile - bit
          CASE WHEN i.holderid <> p.id THEN 'O' ELSE 'S' END  , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.holderid <> p.id THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.holderid <> p.id THEN h.firstname END , -- HolderFirstName - varchar(64)
          CASE WHEN i.holderid <> p.id THEN h.middle END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.holderid <> p.id THEN h.lastname END , -- HolderLastName - varchar(64)
          CASE WHEN i.holderid <> p.id THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN i.holderid <> p.id THEN 
											CASE ISDATE(h.birthdate) WHEN 1 
												THEN CASE WHEN h.birthdate > GETDATE() THEN DATEADD(yy, -100, h.birthdate) 
											ELSE h.birthdate END END END , -- HolderDOB - datetime
          CASE WHEN i.holderid <> p.id THEN h.ssn END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          '' , -- HolderEmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.holderid <> p.id THEN h.gender END , -- HolderGender - char(1)
          CASE WHEN i.holderid <> p.id THEN h.addressone END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.holderid <> p.id THEN h.addresstwo END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.holderid <> p.id THEN h.city END , -- HolderCity - varchar(128)
          CASE WHEN i.holderid <> p.id THEN h.[state] END , -- HolderState - varchar(2)
          CASE WHEN i.holderid <> p.id THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN i.holderid <> p.id THEN REPLACE(REPLACE(h.zipcode,'-',''),' ','') END , -- HolderZipCode - varchar(9)
          CASE WHEN i.holderid <> p.id THEN h.homephone END , -- HolderPhone - varchar(10)
          CASE WHEN i.holderid <> p.id THEN i.idnumber END , -- DependentPolicyNumber - varchar(32)
          '' , -- Notes - text
          i.copayamount , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          i.id , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(i.groupname, 14) , -- GroupName - varchar(14)
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_3_3_Patient] p 
INNER JOIN dbo.[_import_3_3_Policy] i ON 
	p.primarypolicyid = i.id 
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.carrierid = icp.VendorID 
INNER JOIN dbo.PatientCase pc ON 
	p.id = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID
LEFT JOIN dbo.[_import_3_3_Patient] h ON
	p.id = h.id
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy - Secondary...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
          CardOnFile ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          HolderThroughEmployer ,
          HolderEmployerName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          DependentPolicyNumber ,
          Notes ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.insurancecompanyplanid , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          i.idnumber , -- PolicyNumber - varchar(32)
          '' , -- GroupNumber - varchar(32)
		  CASE ISDATE(i.effectivedate) WHEN 1 
			THEN CASE WHEN i.effectivedate > GETDATE() THEN DATEADD(yy, -100, i.effectivedate) 
			ELSE i.effectivedate END 
		  ELSE NULL END  , -- PolicyStartDate - datetime
		  CASE ISDATE(i.terminationdate) WHEN 1 
			THEN CASE WHEN i.terminationdate > GETDATE() THEN DATEADD(yy, -100, i.terminationdate) 
			ELSE i.terminationdate END 
		  ELSE NULL END  , -- PolicyEndDate - datetime
          0 , -- CardOnFile - bit
          CASE WHEN i.holderid <> p.id THEN 'O' ELSE 'S' END  , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.holderid <> p.id THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.holderid <> p.id THEN h.firstname END , -- HolderFirstName - varchar(64)
          CASE WHEN i.holderid <> p.id THEN h.middle END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.holderid <> p.id THEN h.lastname END , -- HolderLastName - varchar(64)
          CASE WHEN i.holderid <> p.id THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN i.holderid <> p.id THEN 
											CASE ISDATE(h.birthdate) WHEN 1 
												THEN CASE WHEN h.birthdate > GETDATE() THEN DATEADD(yy, -100, h.birthdate) 
											ELSE h.birthdate END END END , -- HolderDOB - datetime
          CASE WHEN i.holderid <> p.id THEN h.ssn END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          '' , -- HolderEmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.holderid <> p.id THEN h.gender END , -- HolderGender - char(1)
          CASE WHEN i.holderid <> p.id THEN h.addressone END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.holderid <> p.id THEN h.addresstwo END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.holderid <> p.id THEN h.city END , -- HolderCity - varchar(128)
          CASE WHEN i.holderid <> p.id THEN h.[state] END , -- HolderState - varchar(2)
          CASE WHEN i.holderid <> p.id THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN i.holderid <> p.id THEN REPLACE(REPLACE(h.zipcode,'-',''),' ','') END , -- HolderZipCode - varchar(9)
          CASE WHEN i.holderid <> p.id THEN h.homephone END , -- HolderPhone - varchar(10)
          CASE WHEN i.holderid <> p.id THEN i.idnumber END , -- DependentPolicyNumber - varchar(32)
          '' , -- Notes - text
          i.copayamount , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          i.id , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(i.groupname, 14) , -- GroupName - varchar(14)
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_3_3_Patient] p 
INNER JOIN dbo.[_import_3_3_Policy] i ON 
	p.secondarypolicyid = i.id 
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.carrierid = icp.VendorID 
INNER JOIN dbo.PatientCase pc ON 
	p.id = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID
LEFT JOIN dbo.[_import_3_3_Patient] h ON
	p.id = h.id
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'






-- Contract for fee schedule
PRINT ''
PRINT 'Inserting records into Contract (Standard)...'
INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
        ( PracticeID ,
          Name ,
          Notes ,
          EffectiveStartDate ,
          SourceType ,
          SourceFileName ,
          EClaimsNoResponseTrigger ,
          PaperClaimsNoResponseTrigger ,
          MedicareFeeScheduleGPCICarrier ,
          MedicareFeeScheduleGPCILocality ,
          MedicareFeeScheduleGPCIBatchID ,
          MedicareFeeScheduleRVUBatchID ,
          AddPercent ,
          AnesthesiaTimeIncrement
        )
	VALUES  ( 
		  @PracticeID , -- PracticeID - int
          'Default contract' , -- Name - varchar(128)
          'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
          GETDATE() , -- EffectiveStartDate - datetime
          'F' , -- SourceType - char(1)
          'Import file' , -- SourceFileName - varchar(256)
          45 , -- EClaimsNoResponseTrigger - int
          45 , -- PaperClaimsNoResponseTrigger - int
          NULL , -- MedicareFeeScheduleGPCICarrier - int
          NULL , -- MedicareFeeScheduleGPCILocality - int
          NULL , -- MedicareFeeScheduleGPCIBatchID - int
          NULL , -- MedicareFeeScheduleRVUBatchID - int
          0 , -- AddPercent - decimal
          15  -- AnesthesiaTimeIncrement - int
        )
	

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

-- Contract Fee Schedule
PRINT ''
PRINT 'Inserting records into ContractFeeSchedule (Standard)...'
INSERT INTO dbo.ContractsAndFees_StandardFee
        ( StandardFeeScheduleID ,
          ProcedureCodeID ,
          ModifierID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
	SELECT
	      c.StandardFeeScheduleID , -- StandardFeeScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          NULL , -- ModifierID - int
          impSFS.[standard] , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
	FROM dbo.[_import_3_3_FeeSchedule] impSFS
	INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule c ON
		CAST(c.Notes AS VARCHAR) = 'Vendor Import ' +  CAST(@VendorImportID AS VARCHAR) AND
		c.practiceID = @PracticeID
	INNER JOIN dbo.ProcedureCodeDictionary pcd ON
		impSFS.id = pcd.ProcedureCode
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Standard Fee Schedule Link...'
	INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
        ( ProviderID ,
          LocationID ,
          StandardFeeScheduleID
        )
	SELECT
	      doc.DoctorID , -- ProviderID - int
          sl.ServiceLocationID , -- LocationID - int
          sfs.StandardFeeScheduleID  -- StandardFeeScheduleID - int
	FROM dbo.Doctor doc, dbo.ServiceLocation sl, dbo.ContractsAndFees_StandardFeeSchedule sfs 
	WHERE doc.PracticeID = @PracticeID AND
		doc.[External] = 0 AND 
		sl.PracticeID = @PracticeID AND
		CAST(sfs.Notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
		sfs.PracticeID = @PracticeID 
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


--Patient Alerts
PRINT ''
PRINT 'Inserting records into Patient Alerts ...'
INSERT INTO dbo.PatientAlert
        ( PatientID ,
          AlertMessage ,
          ShowInPatientFlag ,
          ShowInAppointmentFlag ,
          ShowInEncounterFlag ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ShowInClaimFlag ,
          ShowInPaymentFlag ,
          ShowInPatientStatementFlag
        )
SELECT    realP.patientID , -- PatientID - int
          pa.AlertNote , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          0 , -- ShowInAppointmentFlag - bit
          0 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          0 , -- ShowInClaimFlag - bit
          0 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_3_3_Patient] pa
LEFT JOIN dbo.Patient realP ON	
	pa.[id] = realP.VendorID AND
	realP.VendorImportID = @VendorImportID
WHERE pa.alertnote <> ''
PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase SET Name = 'Self Pay' , PayerScenarioID = 11 
FROM dbo.PatientCase pc LEFT JOIN dbo.InsurancePolicy ip ON ip.PatientCaseID = pc.PatientCaseID
WHERE pc.VendorImportID = 1 AND ip.PatientCaseID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT 


