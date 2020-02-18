USE superbill_38843_dev
--USE superbill_38843_prod
GO


SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @OldVendorImportID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @OldVendorImportID = 1
SET @VendorImportID = 2

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Updating Appointment to Resource...'
UPDATE dbo.AppointmentToResource 
	SET ResourceID =  CASE i.drorroomorequip 
						WHEN '10' THEN 2
						WHEN '50' THEN 3
					  END  ,
		AppointmentResourceTypeID = 2
FROM dbo.AppointmentToResource atr
INNER JOIN dbo.Appointment a ON 
atr.AppointmentID = a.AppointmentID 
INNER JOIN dbo.[_import_1_1_appt] i ON 
a.[Subject] = i.legacyappointmentid
WHERE i.drorroomorequip IN ('10','50')
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Appointment...'
UPDATE dbo.Appointment 
	SET ServiceLocationID = CASE i.drorroomorequip 
								WHEN 'RMS' THEN 1 
								WHEN '10' THEN 2
								WHEN '50' THEN 3
							END
FROM dbo.Appointment a
INNER JOIN dbo.[_import_1_1_appt] i ON 
a.[Subject] = i.legacyappointmentid
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

CREATE TABLE #temppolid (ID VARCHAR(50))

INSERT INTO #temppolid  ( ID )

SELECT DISTINCT insplan  
FROM dbo.[_import_2_1_patplan] i
INNER JOIN dbo.[_import_2_1_patient] p ON	
i.patientlegacyaccountnumber = p.patientlegacyaccountnumber
INNER JOIN dbo.[_import_2_1_insplan] ip ON
i.insplan = ip.insuranceplanidentifier
WHERE CONVERT(DATETIME,p.ptlastdateofservice) > '2004-01-01 00:00:000' AND 
CONVERT(DATETIME,p.ptlastdateofservice) < '2014-01-01 00:00:000' AND 
p.deceased = 'N' AND
NOT EXISTS (SELECT * FROM dbo.InsuranceCompanyPlan icp WHERE ip.insuranceplanidentifier = icp.VendorID)


PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID 
        )
SELECT DISTINCT
		  i.insuranceplanname ,
          1 ,
          13 ,
          'CI' ,
          'C' ,
          'D' ,
          @PracticeID ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          13 ,
          i.insuranceplanname ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18 
FROM dbo.[_import_2_1_insplan] i
INNER JOIN #temppolid temp ON 
i.insuranceplanidentifier = temp.ID
WHERE i.insuranceplanname <> '' 
AND NOT EXISTS (SELECT * FROM dbo.InsuranceCompany ic WHERE i.insuranceplanname = ic.InsuranceCompanyName)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          ContactPrefix ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,
          ContactSuffix ,
          Phone ,
          PhoneExt ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          Fax ,
          FaxExt ,
          InsuranceCompanyID ,
          Copay ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  i.insuranceplanname , -- PlanName - varchar(128)
          i.insuranceplanaddress , -- AddressLine1 - varchar(256)
          i.insuranceplanaddress2 , -- AddressLine2 - varchar(256)
          i.insuranceplancity , -- City - varchar(128)
          i.insuranceplanstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.insuranceplanzipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.insuranceplanzipcode)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.insuranceplanzipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.insuranceplanzipcode)
		  ELSE '' END   , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16)
		  CASE
			WHEN LEN(i.insplanbusinessphone) >= 10 THEN LEFT(i.insplanbusinessphone,10)
		  ELSE '' END  , -- Phone - varchar(10)
		  CASE
			WHEN LEN(i.insplanbusinessphone) > 10 THEN LEFT(SUBSTRING(i.insplanbusinessphone,11,LEN(i.insplanbusinessphone)),10)
		  ELSE NULL END , -- PhoneExt - varchar(10)
          CASE WHEN i.insplanauthorizationphone = '' THEN '' ELSE 'Authorization Phone: ' + i.insplanauthorizationphone + CHAR(13) + CHAR(10) END + 
		  CASE WHEN i.insplaneligibilityphone = '' THEN '' ELSE 'Eligibility Phone: ' + i.insplaneligibilityphone + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.insplancontactphone = '' THEN '' ELSE 'Contact Phone: ' + i.insplancontactphone + CHAR(13) + CHAR(10) END +
		  CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
		  CASE
			WHEN LEN(i.insplanfax) >= 10 THEN LEFT(i.insplanfax,10)
		  ELSE '' END , -- Fax - varchar(10)
		  CASE
			WHEN LEN(i.insplanfax) > 10 THEN LEFT(SUBSTRING(i.insplanfax,11,LEN(i.insplanfax)),10)
		  ELSE NULL END  , -- FaxExt - varchar(10)
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          i.copayamount , -- Copay - money
          i.insuranceplanidentifier , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_insplan] i
INNER JOIN dbo.InsuranceCompany ic ON i.insuranceplanname = ic.VendorID AND ic.VendorImportID = @VendorImportID
INNER JOIN #temppolid temp ON i.insuranceplanidentifier = temp.ID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Updating Patient...'
UPDATE dbo.Patient 
	SET FirstName = UPPER(SUBSTRING(FirstName, 1, 1)) + LOWER(SUBSTRING(FirstName, 2, (LEN(FirstName) - 1) )),
		MiddleName = CASE WHEN MiddleName <> '' OR LEN(MiddleName) > 1 THEN UPPER(SUBSTRING(MiddleName, 1, 1)) + LOWER(SUBSTRING(MiddleName, 2, (LEN(MiddleName) - 1) )) ELSE '' END,
		LastName = UPPER(SUBSTRING(LastName, 1, 1)) + LOWER(SUBSTRING(LastName, 2, (LEN(LastName) - 1) ))
WHERE VendorImportID = @OldVendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
        ( PracticeID ,
          ReferringPhysicianID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Gender ,
          MaritalStatus ,
          HomePhone ,
          HomePhoneExt ,
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          ResponsiblePrefix ,
          ResponsibleFirstName ,
          ResponsibleMiddleName ,
          ResponsibleLastName ,
          ResponsibleSuffix ,
          ResponsibleRelationshipToPatient ,
          ResponsibleAddressLine1 ,
          ResponsibleAddressLine2 ,
          ResponsibleCity ,
          ResponsibleState ,
          ResponsibleCountry ,
          ResponsibleZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          --EmployerID ,
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          d.doctorid , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          i.ptfirstname , -- FirstName - varchar(64)
          i.ptmiddlename , -- MiddleName - varchar(64)
          i.ptlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.ptaddress , -- AddressLine1 - varchar(256)
          i.ptaddress2 , -- AddressLine2 - varchar(256)
          i.ptcity , -- City - varchar(128)
          i.ptstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.ptzipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.ptzipcode)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.ptzipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.ptzipcode)
		  ELSE '' END   , -- ZipCode - varchar(9)
          i.ptsex , -- Gender - varchar(1)
          CASE i.ptmaritalstatus WHEN 'U' THEN ''
								 WHEN 'X' THEN ''
								 WHEN 'O' THEN ''
		  ELSE i.ptmaritalstatus END , -- MaritalStatus - varchar(1)
		  CASE
			WHEN LEN(i.ptphone) >= 10 THEN LEFT(i.ptphone,10)
		  ELSE '' END , -- HomePhone - varchar(10)
		  CASE
			WHEN LEN(i.ptphone) > 10 THEN LEFT(SUBSTRING(i.ptphone,11,LEN(i.ptphone)),10)
		  ELSE NULL END  , -- HomePhoneExt - varchar(10)
          		  CASE
			WHEN LEN(i.ptworkphone) >= 10 THEN LEFT(i.ptworkphone,10)
		  ELSE '' END  , -- WorkPhone - varchar(10)
		  CASE
			WHEN LEN(i.ptworkphone) > 10 THEN LEFT(SUBSTRING(i.ptworkphone,11,LEN(i.ptworkphone)),10)
		  ELSE NULL END  , -- WorkPhoneExt - varchar(10)
          DATEADD(hh,12,CONVERT(DATETIME,i.ptdob))  , -- DOB - datetime
          CASE WHEN LEN(i.ptssn) >= 6 THEN RIGHT('000' + i.ptssn, 9) ELSE NULL END , -- SSN - char(9)
          i.ptemail , -- EmailAddress - varchar(256)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN '' END , -- ResponsiblePrefix - varchar(16)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN i.guarantorfirstname END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN i.guarantormiddlename END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN i.guarantorlastcompanyname END , -- ResponsibleLastName - varchar(64)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN '' END , -- ResponsibleSuffix - varchar(16)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN 'O' END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN i.guarantoraddress END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN i.guarantoraddress2 END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN i.guarantorcity END , -- ResponsibleCity - varchar(128)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN i.guarantorstate END , -- ResponsibleState - varchar(2)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN '' END , -- ResponsibleCountry - varchar(32)
          CASE WHEN i.patientuniqueid <> i.guarantoruniqueid THEN CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.guarantorzip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.guarantorzip)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.guarantorzip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.guarantorzip)
		  ELSE '' END END  , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.ptemploymentstatus <> '' THEN i.ptemploymentstatus ELSE 'U' END , -- EmploymentStatus - char(1)
          NULL , -- PrimaryProviderID - int
          NULL , -- DefaultServiceLocationID - int
          --e.EmployerID , -- EmployerID - int
          i.patientlegacyaccountnumber , -- MedicalRecordNumber - varchar(128)
		  CASE
			WHEN LEN(i.patientcellphonenumber) >= 10 THEN LEFT(i.patientcellphonenumber,10)
		  ELSE '' END  , -- MobilePhone - varchar(10)
		  CASE
			WHEN LEN(i.patientcellphonenumber) > 10 THEN LEFT(SUBSTRING(i.patientcellphonenumber,11,LEN(i.patientcellphonenumber)),10)
		  ELSE NULL END  , -- MobilePhoneExt - varchar(10)
          NULL , -- PrimaryCarePhysicianID - int
          i.patientlegacyaccountnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_2_1_Patient] i
--LEFT JOIN dbo.Employers e ON LEFT(e.EmployerName, CHARINDEX(' ', e.EmployerName) - 1) = i.ptemployer 
LEFT JOIN dbo.Doctor d ON 
	i.ptreferringprovider = d.VendorID AND 
	d.PracticeID = @PracticeID AND
	d.[External] = 1
WHERE CONVERT(DATETIME,i.ptlastdateofservice) > '2004-01-01 00:00:000' AND 
CONVERT(DATETIME,i.ptlastdateofservice) < '2014-01-01 00:00:000' AND 
i.deceased = 'N' AND NOT EXISTS
(SELECT * FROM dbo.Patient p WHERE i.patientlegacyaccountnumber = p.VendorID AND p.VendorImportID = @OldVendorImportID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Patient Case...'
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
FROM dbo.Patient WHERE  VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Patient Case Date...'
INSERT INTO dbo.PatientCaseDate
        ( PracticeID ,
          PatientCaseID ,
          PatientCaseDateTypeID ,
          StartDate ,
          EndDate ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID
        )
SELECT DISTINCT		
          @PracticeID , -- PracticeID - int
          pc.PatientCaseID , -- PatientCaseID - int
          8 , -- PatientCaseDateTypeID - int
          CONVERT(DATETIME,i.ptlastdateofservice) , -- StartDate - datetime
          NULL , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_2_1_patient] i
INNER JOIN dbo.PatientCase pc ON
	i.patientlegacyaccountnumber = pc.VendorID AND
    pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient Journal Note...'
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
SELECT    
			  CASE WHEN PJN.dateadded = '' THEN GETDATE() ELSE DATEADD(hh,12,CONVERT(DATETIME,pjn.dateadded))  END , -- CreatedDate - datetime
	          0 , -- CreatedUserID - int
	          GETDATE() , -- ModifiedDate - datetime
	          0 , -- ModifiedUserID - int
	          PAT.PatientID , -- PatientID - int
	          'Kareo' , -- UserName - varchar(128)
	          'K' , -- SoftwareApplicationID - char(1)
	          0 , -- Hidden - bit
	          'Note Class: ' + nc.[description] + CHAR(13) + CHAR(10) + PJN.note , -- NoteMessage - varchar(max)
	          0 , -- AccountStatus - bit
	          1 , -- NoteTypeCode - int
	          0  -- LastNote - bit
FROM dbo.[_import_2_1_patnotes] PJN
INNER JOIN dbo.Patient PAT ON PJN.legacypatientaccount = PAT.VendorID AND PAT.PracticeID = @PracticeID
INNER JOIN dbo.[_import_1_1_noteclas] nc ON PJN.noteclass = nc.noteclass
WHERE pjn.note <> ''	
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	


PRINT ''
PRINT 'Inserting Into Insurance Policy...'
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
          HolderPhoneExt ,
          DependentPolicyNumber ,
          Notes ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt ,
          Copay ,
          Deductible ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          AdjusterPrefix ,
          AdjusterFirstName ,
          AdjusterMiddleName ,
          AdjusterLastName ,
          AdjusterSuffix ,
          VendorID ,
          VendorImportID ,
          GroupName ,
          ReleaseOfInformation ,
          SyncWithEHR 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          i.coverageorder , -- Precedence - int
          i.memberidforclaims , -- PolicyNumber - varchar(32)
          i.[group] , -- GroupNumber - varchar(32)
          CASE WHEN i.startdate <> '' THEN CONVERT(DATETIME,i.startdate) ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN i.enddate <> '' THEN CONVERT(DATETIME,i.enddate) ELSE NULL END , -- PolicyEndDate - datetime
          0 , -- CardOnFile - bit
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN 'O' ELSE 'S' END  , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscriberfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscribermiddlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscriberlastname END , -- HolderLastName - varchar(64)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN 
			CASE WHEN i.subscriberdob <> '' THEN DATEADD(hh,12,CONVERT(DATETIME,i.subscriberdob)) ELSE NULL END END , -- HolderDOB - datetime
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN
			CASE WHEN LEN(i.subscriberssn) >= 6 THEN RIGHT('000' + i.subscriberssn, 9) ELSE NULL END END  , -- HolderSSN - char(11)
          CASE WHEN i.subscriberemployer <> '' THEN 1 ELSE 0 END  , -- HolderThroughEmployer - bit
          CASE WHEN i.subscriberemployer <> '' THEN e.EmployerName END , -- HolderEmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscribersex END , -- HolderGender - char(1)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscriberaddress END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscriberaddress2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscribercity END , -- HolderCity - varchar(128)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.subscriberstate END , -- HolderState - varchar(2)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.subscriberzip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.subscriberzip)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.subscriberzip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.subscriberzip)
		  ELSE '' END END  , -- HolderZipCode - varchar(9)
		  CASE
			WHEN LEN(i.subscriberhomephone) >= 10 THEN LEFT(i.subscriberhomephone,10)
		  ELSE '' END            , -- HolderPhone - varchar(10)
		  CASE
			WHEN LEN(i.subscriberhomephone) > 10 THEN LEFT(SUBSTRING(i.subscriberhomephone,11,LEN(i.subscriberhomephone)),10)
		  ELSE NULL END , -- HolderPhoneExt - varchar(10)
          CASE WHEN p.FirstName <> i.subscriberfirstname AND p.LastName <> i.subscriberlastname THEN i.memberidforclaims END , -- DependentPolicyNumber - varchar(32)
          '' , -- Notes - text
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)
          0 , -- Copay - money
          0 , -- Deductible - money
          '' , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16)
          i.subscriberuniqueid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          '' , -- GroupName - varchar(14)
          'Y' , -- ReleaseOfInformation - varchar(1)
          1  -- SyncWithEHR - bit
FROM dbo.[_import_2_1_patplan] i
INNER JOIN dbo.PatientCase pc ON i.patientlegacyaccountnumber = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.Patient p ON pc.PatientID = p.PatientID AND p.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON i.insplan = icp.VendorID AND icp.VendorImportID = @OldVendorImportID
LEFT JOIN dbo.Employers e ON LEFT(e.EmployerName, CHARINDEX(' ', e.EmployerName) - 1) = i.subscriberemployer
WHERE i.recordstatus = 'A' and i.coverageorder <> '99'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	


PRINT ''
PRINT 'Inserting Into Appointment...'
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
          AllDay ,
          InsurancePolicyAuthorizationID ,
          PatientCaseID ,
          Recurrence ,
          RecurrenceStartDate ,
          RangeEndDate ,
          RangeType ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
		  CASE i.drorroomorequip 
			WHEN 'RMS' THEN 1 
			WHEN '10' THEN 2
			WHEN '50' THEN 3
		  END , -- ServiceLocationID - int
          CONVERT(DATETIME,appointmentdate) + DATEADD(hh,-3,STUFF(REPLACE(STR(appointmenttime, 4), ' ', '0'), 3, 0, ':')) , -- StartDate - datetime
          CONVERT(DATETIME,appointmentdate) + DATEADD(n,CAST(appointmentlength AS INT) ,DATEADD(hh,-3,STUFF(REPLACE(STR(appointmenttime, 4), ' ', '0'), 3, 0, ':')))  , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.legacyappointmentid , -- Subject - varchar(64)
          i.appointmentnotes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          0 , -- AllDay - bit
          NULL , -- InsurancePolicyAuthorizationID - int
          pc.PatientCaseID , -- PatientCaseID - int
          0 , -- Recurrence - bit
          NULL , -- RecurrenceStartDate - datetime
          NULL , -- RangeEndDate - datetime
          '' , -- RangeType - char(1)
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.appointmenttime - 300 , -- StartTm - smallint
          REPLACE(LTRIM(REPLACE(LEFT(REPLACE(REPLACE(DATEADD(hh,-3,DATEADD(n,CAST(appointmentlength AS INT),CAST(STUFF(REPLACE(STR(appointmenttime, 4), ' ', '0'), 3, 0, ':') AS TIME))),':',''),'.',''), 4),'0', ' ')),' ','0')   -- EndTm - smallint
FROM dbo.[_import_2_1_appt] i
INNER JOIN dbo.Patient p ON i.patientnumber = p.VendorID AND p.VendorImportID = @VendorImportID
INNER JOIN dbo.PatientCase pc ON p.PatientID = pc.PatientID AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.DateKeyToPractice dk ON CONVERT(DATETIME,i.appointmentdate) = dk.Dt AND dk.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
											
PRINT ''
PRINT 'Inserting Into Appointment to Appointment Reason...'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_1_appt] i
INNER JOIN dbo.Appointment a ON i.legacyappointmentid = a.[Subject] AND a.PracticeID = @PracticeID
INNER JOIN dbo.AppointmentReason ar ON i.appointmentreasoncode = ar.Name AND ar.PracticeID = @PracticeID
WHERE a.CreatedDate > DATEADD(mi,-2,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Appointment to Resource - Doctor...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          CASE i.drorroomorequip 
			WHEN '10' THEN 2
			WHEN '50' THEN 2
			ELSE 1 
		  END , -- AppointmentResourceTypeID - int
          CASE i.drorroomorequip 
			WHEN '10' THEN 2
			WHEN '50' THEN 3
			ELSE 2 
		  END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_1_appt] i 
INNER JOIN dbo.Appointment a ON i.legacyappointmentid = a.[Subject]
WHERE i.appttypedrroomequipmentorcancellation = 'D' AND
a.CreatedDate > DATEADD(mi,-2,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

DROP TABLE #temppolid


--ROLLBACK
--COMMIT
