INSERT INTO dbo.Patient
( 
	PracticeID , ReferringPhysicianID , Prefix, Suffix, FirstName , MiddleName , LastName , AddressLine1 , AddressLine2 , City , State , ZipCode , Gender , 
	MaritalStatus , HomePhone , HomePhoneExt , WorkPhone , WorkPhoneExt , DOB , SSN , EmailAddress , ResponsibleDifferentThanPatient , CreatedDate , 
	CreatedUserID , ModifiedDate , ModifiedUserID , EmploymentStatus , PrimaryProviderID , DefaultServiceLocationID , EmployerID , MedicalRecordNumber , 
	MobilePhone , MobilePhoneExt , PrimaryCarePhysicianID , VendorID , VendorImportID , CollectionCategoryID , Active , SendEmailCorrespondence , 
	PhonecallRemindersEnabled, EmergencyName, EmergencyPhone, EmergencyPhoneExt
)
SELECT DISTINCT
	1 , -- PracticeID - int
	NULL, -- ReferringPhysicianID - int
	'' , -- Prefix 
	'' , -- Suffix
	LEFT(IPD.firstname,64) AS firstname , -- FirstName - varchar(64)
	LEFT(IPD.mi,64) , -- MiddleName - varchar(64)
	LEFT(IPD.lastname,64) AS lastname , -- LastName - varchar(64)
	LEFT(IPD.address,256) , -- AddressLine1 - varchar(256)
	'' , -- AddressLine2 - varchar(256)
	LEFT(IPD.city,128) , -- City - varchar(128)
	UPPER(LEFT(IPD.state,2)) , -- State - varchar(2)
	CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(IPD.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(IPD.zip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(IPD.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(IPD.zip)
		ELSE '' END , -- ZipCode - varchar(9)
	CASE
		WHEN IPD.sex IN ('M','Male') THEN 'M'
		WHEN IPD.sex IN ('F','Female') THEN 'F'
		ELSE 'U' END , -- Gender - varchar(1)
	CASE 
		WHEN IPD.marital IN ('D','Divorced') THEN 'D'
		WHEN IPD.marital IN ('M','Married') THEN 'M'
		WHEN IPD.marital IN ('W','Widowed') THEN 'W'
		ELSE 'S' END , -- MaritalStatus - varchar(1)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(IPD.phone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(IPD.phone),10)
		ELSE '' END, -- HomePhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(IPD.phone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(IPD.phone),11,LEN(dbo.fn_RemoveNonNumericCharacters(IPD.phone))),10)
		ELSE NULL END , -- HomePhoneExt - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(IPD.workphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(IPD.workphone),10)
		ELSE '' END , -- WorkPhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(IPD.workphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(IPD.workphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(IPD.workphone))),10)
		ELSE NULL END , -- WorkPhoneExt - varchar(10)
	CASE
		WHEN ISDATE(IPD.birthdate) = 1 THEN IPD.birthdate
		ELSE NULL END , -- DOB - datetime
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(IPD.patssn)) = 9 THEN dbo.fn_RemoveNonNumericCharacters(IPD.patssn)
		ELSE NULL END , -- SSN - char(9)
	LEFT(IPD.email,256) , -- EmailAddress - varchar(256)
	0, -- ResponsibleDifferentThanPatient - bit
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	'U', -- EmploymentStatus - char(1)
	NULL , -- PrimaryProviderID - int 
	NULl , -- DefaultServiceLocationID - int 
	NULL, -- EmployerID - int 
	LEFT(IPD.account,128) , -- MedicalRecordNumber - varchar(128)
	CASE
		WHEN LEN(IPD.cellphone) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(IPD.cellphone),10)
		ELSE '' END , -- MobilePhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(IPD.cellphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(IPD.cellphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(IPD.cellphone))),10)
		ELSE NULL END , -- MobilePhoneExt - varchar(10)
	NULL , -- PrimaryCarePhysicianID - int 
	AutoTempID, -- VendorID - varchar(50)
	1 , -- VendorImportID - int
	1 , -- CollectionCategoryID - int
	1, -- Active - bit
	1, -- SendEmailCorrespondence - bit
	0,  -- PhonecallRemindersEnabled - bit
	'' , -- EmergencyName - varchar(128)
	'' , -- EmergencyPhone - varchar(10)
	'' -- EmergencyPhoneExt - varchar(10)
FROM dbo.[_import_1_1_Patientdemos] AS IPD
WHERE firstname <> '' AND lastname <> ''
ORDER BY firstname, lastname

INSERT INTO dbo.InsuranceCompany
(
	InsuranceCompanyName , Notes , AddressLine1 , AddressLine2 , City , State , ZipCode , ContactFirstName , ContactLastName , Phone , 
	PhoneExt , Fax , FaxExt , EClaimsAccepts , BillingFormID , InsuranceProgramCode , HCFADiagnosisReferenceFormatCode , HCFASameAsInsuredFormatCode , 
	ReviewCode , CreatedPracticeID , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , SecondaryPrecedenceBillingFormID , VendorID , 
	VendorImportID , NDCFormat , UseFacilityID , AnesthesiaType , InstitutionalBillingFormID
)         
SELECT DISTINCT 
	LEFT(CASE 
		WHEN LEN(carriername) > 1 THEN carriername
		ELSE carriercode END,128) AS Name , -- InsuranceCompanyName - varchar(128)
	CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' AS Notes , -- Notes - text
	LEFT(carrieraddress,256) AS addressline1 , -- AddressLine1 - varchar(256)
	'', -- AddressLine2 - varchar(256)
	COALESCE(PARSENAME(carriercsz,2),'') AS InsuranceCity, -- City - varchar(128)
	SUBSTRING(PARSENAME(carriercsz,1),2,2) AS InsuranceState , -- State - varchar(2)
	dbo.fn_RemoveNonNumericCharacters(carriercsz) AS InsuranceZip, -- ZipCode - varchar(9)
	'' , -- ContactFirstName - varchar(64)
	'', -- ContactLastName - varchar(64)
	LEFT(dbo.fn_RemoveNonNumericCharacters(carrierphone),10) AS InsurancePhone, -- Phone - varchar(10)
		CASE
	WHEN LEN(dbo.fn_RemoveNonNumericCharacters(carrierphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(carrierphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(carrierphone))),10)
	ELSE NULL END AS InsurancePhoneExt , -- PhoneExt - varchar(10)
	dbo.fn_RemoveNonNumericCharacters(carrierfax) , -- Fax - varchar(10)
	NULL, -- FaxExt - varchar(10)
	0 AS eclaimsaccept, -- EClaimsAccepts - bit
	13 AS billingformid , -- BillingFormID - int
	'CI' InsuranceProgramCode, -- InsuranceProgramCode - char(2)
	'C' HCFADiagnosisReferenceFormatCode, -- HCFADiagnosisReferenceFormatCode - char(1)
	'D' HCFASameAsInsuredFormatCode, -- HCFASameAsInsuredFormatCode - char(1)
	'R' ReviewCode, -- ReviewCode - char(1)
	1 CreatedPracticeID, -- CreatedPracticeID - int
	GETDATE() CreatedDate, -- CreatedDate - datetime
	0 CreatedUserID, -- CreatedUserID - int
	GETDATE() ModifiedDate, -- ModifiedDate - datetime
	0 ModifiedUserID, -- ModifiedUserID - int
	13 SecondaryPrecedenceBillingFormID, -- SecondaryPrecedenceBillingFormID - int
	NULL VendorID, -- VendorID - varchar(50)
	1 VendorImportID, -- VendorImportID - int
	1 NDCFormat, -- NDCFormat - int
	1 UseFacilityID, -- UseFacilityID - bit
	'U' AnesthesiaType, -- AnesthesiaType - varchar(1)
	18 InstitutionalBillingFormID -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_Insurance] AS II
WHERE carriercode <> '' AND carriername <> ''

INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode , ContactPrefix , ContactFirstName , ContactMiddleName , ContactLastName , 
	ContactSuffix , Phone , PhoneExt , Notes , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , 
	Fax , FaxExt , InsuranceCompanyID , Copay , Deductible , VendorID , VendorImportID
)
SELECT 
	InsuranceCompanyName , -- PlanName - varchar(128)
	AddressLine1 , -- AddressLine1 - varchar(256)
	AddressLine2 , -- AddressLine2 - varchar(256)
	City , -- City - varchar(128)
	[State] , -- State - varchar(2)
	Country , -- Country - varchar(32)
	ZipCode , -- ZipCode - varchar(9)
	ContactPrefix , -- ContactPrefix - varchar(16)
	ContactFirstName , -- ContactFirstName - varchar(64)
	ContactMiddleName , -- ContactMiddleName - varchar(64)
	ContactLastName , -- ContactLastName - varchar(64)
	ContactSuffix , -- ContactSuffix - varchar(16)
	Phone , -- Phone - varchar(10)
	PhoneExt , -- PhoneExt - varchar(10)
	Notes , -- Notes - text
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	'R' , -- ReviewCode - char(1)
	1 , -- CreatedPracticeID - int
	Fax , -- Fax - varchar(10)
	FaxExt , -- FaxExt - varchar(10)
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	VendorID, --.ID , -- VendorID - varchar(50) --FIX
	1  -- VendorImportID - int
FROM dbo.InsuranceCompany AS IC
WHERE VendorImportID = 1

INSERT INTO dbo.PatientCase
( 
	PatientID , Name , Active , PayerScenarioID , ReferringPhysicianID , EmploymentRelatedFlag , AutoAccidentRelatedFlag , OtherAccidentRelatedFlag , 
	AbuseRelatedFlag , AutoAccidentRelatedState , Notes , ShowExpiredInsurancePolicies , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , PracticeID , CaseNumber , WorkersCompContactInfoID , VendorID , VendorImportID , PregnancyRelatedFlag , StatementActive , 
	EPSDT , FamilyPlanning , EPSDTCodeID , EmergencyRelated , HomeboundRelatedFlag
)
SELECT DISTINCT 
	PAT.PatientID , -- PatientID - int
	'Default Case'	, -- Name - varchar(128)
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
	1 , -- PracticeID - int
	NULL , -- CaseNumber - varchar(128)
	NULL , -- WorkersCompContactInfoID - int
	PAT.VendorID , -- VendorID - varchar(50)
	1 , -- VendorImportID - int
	0, -- PregnncyRelatedFlag - bit
	1, -- StatementActive - bit
	0, -- EPSDT - bit
	0, -- FamilyPlanning - bitf
	1 , -- EPSDTCodeID - int
	0 , -- EmergencyRelated - bit
	0 -- HomeboundRelatedFlag
FROM dbo.Patient AS PAT
WHERE VendorImportID = 1

INSERT INTO dbo.InsurancePolicy
( 
	PatientCaseID , InsuranceCompanyPlanID , Precedence , PolicyNumber , GroupNumber , PolicyStartDate , PolicyEndDate , CardOnFile , PatientRelationshipToInsured , 
	HolderPrefix , HolderFirstName , HolderMiddleName , HolderLastName , HolderSuffix , HolderDOB , HolderSSN , HolderThroughEmployer , HolderEmployerName , 
	PatientInsuranceStatusID , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , HolderGender , HolderAddressLine1 , HolderAddressLine2 , HolderCity , 
	HolderState , HolderZipCode , HolderPhone , HolderPhoneExt , DependentPolicyNumber , Notes , Copay , Deductible , Active , PracticeID , VendorID , 
	VendorImportID , GroupName , ReleaseOfInformation
)
SELECT DISTINCT
	PatientCaseID , -- PatientCaseID - int
	InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
	ROW_NUMBER() OVER(PARTITION BY account ORDER BY AutoTempID), -- precedence - int
	LEFT(insuranceid,32), -- PolicyNumber - varchar(32)
	LEFT(GroupNo,32), -- GroupNumber - varchar(
	CASE WHEN ISDATE(coverageeffective) = 1 AND coverageeffective<> '1900-01-01' THEN coverageeffective ELSE NULL END,
	CASE WHEN ISDATE(terminationdate) = 1 AND terminationdate <> '1900-01-01' THEN terminationdate ELSE NULL END,
	0, -- CardOnFile - bit
	CASE
		WHEN relationship IN ('C','Child') THEN 'C'
		WHEN relationship IN ('O','Other') THEN 'O'
		WHEN relationship IN ('h','w') THEN 'U'
		ELSE 'S' END, -- PatientRelationshipToInsured - varchar(1) 
	'', -- HolderPrefix - varchar(16)
	CASE WHEN relationship IN ('c','o','u') THEN LEFT(insuredfirst,64) ELSE '' END, -- HolderFirstName - varchar(64)
	'', -- HolderMiddleName - varchar(64)
	CASE WHEN relationship IN ('c','o','u') THEN LEFT(insuredlast,64) ELSE ''  END, -- HolderLastName - varchar(64)
	'', -- HolderSuffix - varchar(16)
	CASE WHEN relationship IN ('c','o','u') AND ISDATE(insureddob) = 1 THEN insureddob ELSE NULL END, -- HolderDOB - datetime
	CASE WHEN relationship IN ('c','o','u') AND LEN(dbo.fn_RemoveNonNumericCharacters(insuredssn)) = 9 THEN dbo.fn_RemoveNonNumericCharacters(insuredssn) ELSE NULL END, -- HolderSSN
	0 , -- HolderThroughEmployer - bit
	NULL , -- HolderEmployerName - varchar(128)
	0 , -- PatientInsuranceStatusID - int
	GETDATE(),
	0 , -- CreatedUserID - int
	GETDATE(),
	0 , -- ModifiedUserID - int
	CASE WHEN relationship IN ('c','o','u') THEN CASE WHEN insuredsex IN ('M','Male') THEN 'M' WHEN insuredsex IN ('F','Female') THEN 'F' ELSE 'U' END END, -- HolderGender - char(1)
	CASE WHEN relationship IN ('c','o','u') THEN LEFT(insuredaddr,256) ELSE '' END, -- HolderAddressLine1 - varchar(256)
	'' , -- HolderAddressLine2 - varchar(256)
	CASE WHEN relationship IN ('c','o','u') THEN LEFT(insuredcity,128) ELSE '' END, -- HolderCity - varchar(128)
	CASE WHEN relationship IN ('c','o','u') THEN UPPER(LEFT(insuredstate,2)) ELSE '' END, -- HolderState
	CASE WHEN relationship IN ('c','o','u') THEN CASE 
		WHEN LEN(insuredzip) IN (5,9) THEN insuredzip
		WHEN LEN(insuredzip) = 4 THEN '0' + insuredzip
		ELSE '' END END, -- HolderZipCode - varchar(9)
	CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(insuredphone)) = 10 THEN dbo.fn_RemoveNonNumericCharacters(insuredphone) ELSE '' END, -- HolderPhone - varchar(10)
	'' , -- HolderPhoneExt - varchar(10)
	'' , -- DependentPolicyNumber - varchar(32)
	CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.', -- Notes - text
	0, -- Copay - money
	0, -- Deductible - money
	1, -- Active - bit
	1 , -- PracticeID - int
	VendorID , -- VendorID - varchar(50)
	1 , -- VendorImportID - int
	'' , -- GroupName - varchar(14)
	'Y'  -- ReleaseOfInformation - varchar(1)
FROM
(
	SELECT DISTINCT pc.PatientCaseID, icp.InsuranceCompanyPlanID, AutoTempID, account, insuranceid, groupno, coverageeffective, relationship, insuredfirst, insuredlast, insureddob, insuredssn, insuredsex, insuredaddr, insuredcity,
	insuredstate, insuredzip, insuredphone, ICP.VendorID, terminationdate, p.firstname, p.lastname
	FROM dbo.[_import_1_1_Insurance] AS II
JOIN dbo.Patient AS P ON p.MedicalRecordNumber = ii.account AND p.VendorImportID = 1
	JOIN dbo.PatientCase AS PC ON P.PatientID = PC.PatientID
	JOIN dbo.InsuranceCompanyPlan AS ICP ON icp.AddressLine1 = ii.carrieraddress AND icp.PlanName = CASE WHEN LEN(carriername) > 1 THEN carriername ELSE carriercode END 
		AND icp.VendorImportID = 1 AND icp.ZipCode = dbo.fn_RemoveNonNumericCharacters(ICP.ZipCode) AND icp.Phone = LEFT(dbo.fn_RemoveNonNumericCharacters(ii.carrierphone),10) AND icp.City = COALESCE(PARSENAME(carriercsz,2),'')
		AND icp.ZipCode = dbo.fn_RemoveNonNumericCharacters(carriercsz)
	WHERE ii.carriercode <> '' AND ii.carriername <> '' 
) AS y


INSERT INTO dbo.Appointment
        ( PatientID ,
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
          Subject ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          AppointmentResourceTypeID ,
          AppointmentConfirmationStatusCode ,
          InsurancePolicyAuthorizationID ,
          PatientCaseID ,
          Recurrence ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT	  
		  pat.PatientID , -- PatientID - int
          1 , -- PracticeID - int
          1 , -- ServiceLocationID - int
          --DATEADD(hh,2,
		  CAST(apptdate + ' ' + appttime + 'm' AS DATETIME),
		  --)  , -- StartDate - datetime
          DATEADD(mi,CAST(apptmin AS INT),
		  --DATEADD(hh,2,
		  CAST(apptdate + ' ' + appttime + 'm' AS DATETIME)),
		  --) , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          AutoTempID , -- Subject - varchar(64)
          app.apptmessage , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          NULL , -- InsurancePolicyAuthorizationID - int
          pc.PatientCaseID , -- PatientCaseID - int
          0 , -- Recurrence - bit
          dk.dkPracticeID , -- StartDKPracticeID - int
          dk.dkPracticeID , -- EndDKPracticeID - int,
			CAST(DATEPART(hh,(CAST(apptdate + ' ' + appttime + 'm' AS DATETIME))) AS varchar(2)) + LEFT(CAST(DATEPART(mi,(CAST(apptdate + ' ' + appttime + 'm' AS DATETIME))) AS varchar(2)) + '00',2),
			CAST(DATEPART(hh,DATEADD(mi,CAST(apptmin AS INT),CAST((apptdate + ' ' + appttime + 'm') AS DATETIME))) AS VARCHAR(2)) + LEFT(CAST(DATEPART(mi,CAST(DATEADD(mi,CAST(apptmin AS INT),CAST((apptdate + ' ' + appttime + 'm') AS DATETIME)) AS DATETIME) )AS varchar(2)) + '00',2)
FROM dbo.[_import_1_1_AppointmentData] AS app
INNER JOIN dbo.Patient pat ON 
	app.account = pat.MedicalRecordNumber AND
	pat.VendorImportID = 1
LEFT JOIN dbo.DateKeyToPractice dk ON 
	apptdate = dk.Dt AND
	dk.PracticeID = 1
LEFT JOIN dbo.PatientCase pc ON 
	pat.PatientID = pc.PatientID AND
	pc.VendorImportID = 1
WHERE ISDATE(app.apptdate) = 1 AND app.apptdate > GETDATE()

INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          TIMESTAMP ,
          PracticeID
        )
SELECT DISTINCT
		  AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          1 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          NULL , -- TIMESTAMP - timestamp
          1  -- PracticeID - int
FROM dbo.Appointment AS A 
WHERE CreatedUserID = 0

INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          ModifiedDate ,
          TIMESTAMP ,
          PracticeID
        )
select a.appointmentid , -- AppointmentID - int
          81 , -- AppointmentReasonID - int
          '2013-01-31 19:50:11' , -- ModifiedDate - datetime
          NULL , -- TIMESTAMP - timestamp
          1  -- PracticeID - int
FROM dbo.Appointment AS A
JOIN dbo.[_import_1_1_AppointmentData] AS IAD ON a.Subject = iad.AutoTempID
WHERE iad.appttype = 'rub club'
AND a.CreatedUserID = 0

UPDATE dbo.Appointment
SET Subject = ''
WHERE CreatedUserID = 0


INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientID ,
          UserName ,
          SoftwareApplicationID ,
          Hidden ,
          NoteMessage ,
          AccountStatus ,
          NoteTypeCode ,
          LastNote
        )
SELECT '2013-01-31 23:22:12' , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          '2013-01-31 23:22:12' , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          PATientid , -- PatientID - int
          'Kareo' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          remarks1 + ' ' + remarks2 , -- NoteMessage - varchar(max)
          0, -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0-- LastNote - bit
FROM dbo.Patient AS P
JOIN dbo.[_import_1_1_Patientdemos] AS IP ON ip.account = p.MedicalRecordNumber AND p.VendorImportID = 1
WHERE remarks1 <> '' OR remarks2 <> ''


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
SELECT patientid , -- PatientID - int
          popupmessage , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          1, -- ShowInAppointmentFlag - bit
          1, -- ShowInEncounterFlag - bit
          '2013-01-31 23:26:26' , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          '2013-01-31 23:26:26' , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1, -- ShowInClaimFlag - bit
          1, -- ShowInPaymentFlag - bit
          0-- ShowInPatientStatementFlag - bit
FROM dbo.Patient AS P
JOIN dbo.[_import_1_1_Patientdemos] AS IP ON ip.account = p.MedicalRecordNumber AND p.VendorImportID = 1
WHERE ip.popupmessage <> ''