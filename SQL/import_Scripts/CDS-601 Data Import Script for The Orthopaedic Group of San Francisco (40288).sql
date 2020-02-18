USE superbill_40288_dev
--USE superbill_40288_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR) 
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR)

PRINT ''
PRINT 'Inserting Insurance Company Plan - Existing Company...'
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
          ReviewCode ,
          CreatedPracticeID ,
          Fax ,
          InsuranceCompanyID ,
          Copay ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  i.carriername , -- PlanName - varchar(128)
          i.address1 , -- AddressLine1 - varchar(256)
          i.address2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(i.zipcode,'-',''),9) , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          LEFT(i.contactname,64) , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16) 
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          CASE WHEN i.eligibilityphonenumber = '' THEN '' ELSE 'Eligibility Phone: ' + i.providerrelationsphonenumber + i.eligibilityphoneextension + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.preauthphonenumber = '' THEN '' ELSE 'PreAuth Phone: ' + i.preauthphonenumber + i.preauthphoneextension + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.providerrelationsphonenumber = '' THEN '' ELSE 'Provider Relations Phone: ' + i.providerrelationsphonenumber + i.providerrelationsphoneextension + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.emailaddress = '' THEN '' ELSE 'Email: ' + i.emailaddress END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '' , -- ReviewCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          dbo.fn_RemoveNonNumericCharacters(i.faxnumber) , -- Fax - varchar(10)
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          i.standardcopaydollaramt , -- Copay - money
          i.carriercode , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_Carriers] i
INNER JOIN dbo.InsuranceCompany ic ON
	ic.InsuranceCompanyID = (SELECT MIN(InsuranceCompanyID) FROM dbo.InsuranceCompany
								WHERE i.carriername = InsuranceCompanyName AND
									(ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurane Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          Notes ,
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
		  i.carriername , -- InsuranceCompanyName - varchar(128)
		  CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' ,
          1 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          i.carriername , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_Carriers] i
WHERE EXISTS (SELECT * FROM dbo.[_import_1_1_Coverages] ic WHERE i.carrieruid = ic.carrierfid)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurane Company Plan...'
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
		  i.carriername , -- PlanName - varchar(128)
          i.address1 , -- AddressLine1 - varchar(256)
          i.address2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(i.zipcode,'-',''),9)  , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          LEFT(i.contactname,64) , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16) 
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          CASE WHEN i.eligibilityphonenumber = '' THEN '' ELSE 'Eligibility Phone: ' + i.providerrelationsphonenumber + i.eligibilityphoneextension + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.preauthphonenumber = '' THEN '' ELSE 'PreAuth Phone: ' + i.preauthphonenumber + i.preauthphoneextension + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.providerrelationsphonenumber = '' THEN '' ELSE 'Provider Relations Phone: ' + i.providerrelationsphonenumber + i.providerrelationsphoneextension + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.emailaddress = '' THEN '' ELSE 'Email: ' + i.emailaddress END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          LEFT(dbo.fn_RemoveNonNumericCharacters(i.faxnumber),10) , -- Fax - varchar(10)
		  LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.faxnumber),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.faxnumber))),10), 
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          i.standardcopaydollaramt , -- Copay - money , -- Copay - money
          i.carrieruid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_Carriers] i
INNER JOIN dbo.InsuranceCompany ic ON
	ic.VendorID = i.carriername AND
	ic.VendorImportID = @VendorImportID
LEFT JOIN dbo.InsuranceCompanyPlan icp ON 
	i.carrieruid = icp.VendorID AND 
	icp.CreatedPracticeID = @PracticeID
WHERE icp.InsuranceCompanyPlanID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

UPDATE dbo.ServiceLocation 
	SET VendorID = 304 
WHERE ServiceLocationID = 1

PRINT ''
PRINT 'Inserting Into Service Location...'
INSERT INTO dbo.ServiceLocation
        ( PracticeID ,
          Name ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          BillingName ,
          Phone ,
          PhoneExt ,
          VendorImportID ,
          VendorID ,
          TimeZoneID 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          i.facilityname , -- Name - varchar(128)
          i.address2 , -- AddressLine1 - varchar(256)
          i.address1 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          REPLACE(i.zipcode,'-','') , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.facilityname , -- BillingName - varchar(128)
          i.officephone , -- Phone - varchar(10)
          i.officeextension , -- PhoneExt - varchar(10)
          @VendorImportID , -- VendorImportID - int
          i.facilityuid , -- VendorID - int
          11  -- TimeZoneID - int
FROM dbo.[_import_1_1_Facilities] i
WHERE i.display = 1 AND NOT EXISTS (SELECT * FROM dbo.ServiceLocation sl WHERE i.facilityuid = sl.VendorID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Doctor...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
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
          HomePhone ,
          WorkPhone ,
          WorkPhoneExt ,
          PagerPhone ,
          MobilePhone ,
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          [External] ,
          NPI 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          i.firstname , -- FirstName - varchar(64)
          '' , -- MiddleName - varchar(64)
          i.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.address2 , -- AddressLine1 - varchar(256)
          i.address1 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          REPLACE(i.zipcode,'-','') , -- ZipCode - varchar(9)
          i.homephone , -- HomePhone - varchar(10)
          LEFT(i.officephone ,10) , -- WorkPhone - varchar(10)
          i.officeextension , -- WorkPhoneExt - varchar(10)
          i.pager , -- PagerPhone - varchar(10)
          i.cell , -- MobilePhone - varchar(10)
          CASE WHEN i.speciality = '' THEN '' ELSE 'Specialty: ' + i.speciality + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.licensenumber = '' THEN '' ELSE 'License Number: ' + i.licensenumber END , -- Notes - text
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.title , -- Degree - varchar(8)
          i.referringprovideruid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(i.fax,10) , -- FaxNumber - varchar(10)
          1 , -- External - bit
          i.npinumber  -- NPI - varchar(10)
FROM dbo.[_import_1_1_ReferringProviders] i
WHERE i.display = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Employers...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
		  i.employer , -- EmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_1_PatientInfo] i 
WHERE i.employer <> '' AND NOT EXISTS (SELECT * FROM dbo.Employers e WHERE e.EmployerName = i.employer)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
        ( PracticeID ,
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
          EmployerID ,
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
          EmergencyName ,
          EmergencyPhone 
           
        )
SELECT DISTINCT
		  @PracticeID ,
          '' ,
          i.FirstName ,
          i.MiddleName ,
          i.LastName ,
          '' ,
          i.address2 ,
          i.address1 ,
          i.City ,
          i.[State] ,
          '' ,
          LEFT(REPLACE(i.ZipCode,'-',''),9) ,
          CASE WHEN i.gender = '' THEN 'U' ELSE i.gender END ,
          CASE i.maritalstatus
			WHEN 2 THEN 'M'
			WHEN 3 THEN 'D'
			WHEN 4 THEN 'L'
			WHEN 5 THEN 'W'
			WHEN 1 THEN 'S'
		  ELSE '' END ,
          LEFT(i.homephone,10) ,
          LEFT(i.officephone,10) ,
		  LEFT(i.officeextension,10) ,
          CASE WHEN ISDATE(i.dob) = 1 THEN i.dob ELSE NULL END ,
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.ssn)) >= 6 THEN RIGHT('000' + i.ssn, 9) ELSE '' END ,
          i.email ,
          CASE WHEN i.firstname <> rp.firstname AND i.lastname <> rp.lastname THEN 1 ELSE 0 END ,
          CASE WHEN i.firstname <> rp.firstname AND i.lastname <> rp.lastname  THEN '' END ,
          CASE WHEN i.firstname <> rp.firstname AND i.lastname <> rp.lastname  THEN rp.firstname END ,
          CASE WHEN i.firstname <> rp.firstname AND i.lastname <> rp.lastname  THEN rp.middlename END ,
          CASE WHEN i.firstname <> rp.firstname AND i.lastname <> rp.lastname  THEN rp.lastname END ,
          CASE WHEN i.firstname <> rp.firstname AND i.lastname <> rp.lastname  THEN '' END ,
          CASE WHEN i.firstname <> rp.firstname AND i.lastname <> rp.lastname  THEN CASE i.relationship 
																	WHEN 1 THEN 'S' 
																	WHEN 2 THEN 'U' 
																	WHEN 3 THEN 'C'
																	WHEN 4 THEN 'O'
																ELSE 'O' END ELSE 'O' END ,
          CASE WHEN i.firstname <> rp.firstname AND i.lastname <> rp.lastname  THEN rp.address2 END ,
          CASE WHEN i.firstname <> rp.firstname AND i.lastname <> rp.lastname  THEN rp.address1 END ,
          CASE WHEN i.firstname <> rp.firstname AND i.lastname <> rp.lastname  THEN rp.city END ,
          CASE WHEN i.firstname <> rp.firstname AND i.lastname <> rp.lastname  THEN rp.[state] END ,
          CASE WHEN i.firstname <> rp.firstname AND i.lastname <> rp.lastname  THEN '' END ,
          CASE WHEN i.firstname <> rp.firstname AND i.lastname <> rp.lastname  THEN LEFT(REPLACE(rp.zipcode,'-',''),9) END ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          CASE WHEN i.employer <> '' THEN 'E' ELSE 'U' END ,
          2 ,
          1 ,
          e.EmployerID ,
          i.chartnumber ,
          LEFT(i.cell,10) ,
          i.patientuid ,
          @VendorImportID ,
          1 ,
          i.display ,
          0 ,
          0 ,
          CASE WHEN i.other <> '' THEN 'Other Phone Type: ' + i.phonetype ELSE '' END ,
          CASE WHEN i.other <> '' THEN LEFT(i.other,10) ELSE '' END 
FROM dbo.[_import_1_1_PatientInfo] i
LEFT JOIN dbo.Employers e ON
e.EmployerName = i.employer
LEFT JOIN dbo.[_import_1_1_ResponsibleParties] rp ON
i.responsiblepartyfid = rp.responsiblepartyuid
WHERE i.display = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          EmploymentRelatedFlag ,
          AutoAccidentRelatedFlag ,
          OtherAccidentRelatedFlag ,
          AbuseRelatedFlag ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          PregnancyRelatedFlag ,
          StatementActive ,
          EPSDT ,
          FamilyPlanning ,
          EPSDTCodeID ,
          EmergencyRelated ,
          HomeboundRelatedFlag
        )
SELECT DISTINCT
		  PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          0 , -- EmploymentRelatedFlag - bit
          0 , -- AutoAccidentRelatedFlag - bit
          0 , -- OtherAccidentRelatedFlag - bit
          0 , -- AbuseRelatedFlag - bit
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          0 , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
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
SELECT DISTINCT
		  i.createdate , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          p.PatientID , -- PatientID - int
          i.createuser , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          'Note Type: ' + n.[description] + CHAR(13) + CHAR(10) + i.note , -- NoteMessage - varchar(max)
          0 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_1_1_Note] i
INNER JOIN dbo.Patient p ON
	i.patientfid = p.VendorID AND 
	p.VendorImportID = @VendorImportID
INNER JOIN dbo.[_import_1_1_NoteTypes] n ON 
	i.notetypefid = n.notetypeuid
WHERE i.note <> '' AND i.display = 1
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
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          i.sequencenumber , -- Precedence - int
          i.subscriberidnumber , -- PolicyNumber - varchar(32)
          i.groupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.effectivestartdate) = 1 THEN i.effectivestartdate ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(i.effectiveenddate) = 1 THEN i.effectiveenddate ELSE NULL END , -- PolicyEndDate - datetime
          1 , -- CardOnFile - bit
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN CASE i.relationshippatienttosubscriber 
																						WHEN 1 THEN 'S' 
																						WHEN 2 THEN 'U' 
																						WHEN 3 THEN 'C'
																						WHEN 4 THEN 'O'
																				    ELSE 'S' END ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN rp.firstname END , -- HolderFirstName - varchar(64)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN rp.middlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN rp.lastname END , -- HolderLastName - varchar(64)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN CASE WHEN ISDATE(rp.dob) = 1 THEN rp.dob ELSE NULL END END , -- HolderDOB - datetime
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(rp.ssn)) >= 6 THEN RIGHT('000' + rp.ssn,9) ELSE '' END END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN rp.gender END , -- HolderGender - char(1)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN rp.address2 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN rp.address1 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN rp.city END , -- HolderCity - varchar(128)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN rp.[state] END , -- HolderState - varchar(2)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN LEFT(REPLACE(rp.zipcode,'-',''),9) END , -- HolderZipCode - varchar(9)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN LEFT(rp.homephone,10) END , -- HolderPhone - varchar(10)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN i.subscriberidnumber END , -- DependentPolicyNumber - varchar(32)
          '' , -- Notes - text
          i.copaydollaramount , -- Copay - money
          i.active , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID + i.subscriberidnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(i.groupname,14) , -- GroupName - varchar(14)
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_1_Coverages] i
INNER JOIN dbo.PatientCase pc ON 
	i.patientfid = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	i.carrierfid = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
LEFT JOIN dbo.[_import_1_1_ResponsibleParties] rp ON
	i.responsiblepartysubscriberfid = rp.responsiblepartyuid
LEFT JOIN dbo.Patient p ON
	pc.PatientID = p.PatientID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--PRINT ''
--PRINT 'Inserting Into Appointment...'
--INSERT INTO dbo.Appointment
--        ( PatientID ,
--          PracticeID ,
--          ServiceLocationID ,
--          StartDate ,
--          EndDate ,
--          AppointmentType ,
--          Subject ,
--          Notes ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          AppointmentResourceTypeID ,
--          AppointmentConfirmationStatusCode ,
--          PatientCaseID ,
--          StartDKPracticeID ,
--          EndDKPracticeID ,
--          StartTm ,
--          EndTm 
--        )
--SELECT DISTINCT
--		  p.PatientID , -- PatientID - int
--          @PracticeID , -- PracticeID - int
--          1 , -- ServiceLocationID - int
--          CAST(i.startdatetime AS DATETIME) , -- StartDate - datetime
--          DATEADD(mi,CAST(i.duration AS INT),i.startdatetime) , -- EndDate - datetime
--          'P' , -- AppointmentType - varchar(1)
--          i.appointmentuid , -- Subject - varchar(64)
--          i.comments , -- Notes - text
--          GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0 , -- ModifiedUserID - int
--          1 , -- AppointmentResourceTypeID - int
--          'S' , -- AppointmentConfirmationStatusCode - char(1)
--          pc.PatientCaseID , -- PatientCaseID - int
--          dk.DKPracticeID , -- StartDKPracticeID - int
--          dk.DKPracticeID , -- EndDKPracticeID - int
--          REPLACE(LTRIM(REPLACE(LEFT(REPLACE(REPLACE(CAST(i.startdatetime AS TIME),':',''),'.',''), 4),'0', ' ')),' ','0') , -- StartTm - smallint
--          REPLACE(LTRIM(REPLACE(LEFT(REPLACE(REPLACE(CAST(DATEADD(n, CAST(i.duration AS INT), i.startdatetime) AS TIME),':',''),'.',''), 4),'0', ' ')),' ','0')  -- EndTm - smallint
--FROM dbo.[_import_5_1_Appointments] i
--INNER JOIN dbo.Patient p ON
--	p.VendorID = i.patientfid AND
--	p.VendorImportID = @VendorImportID
--LEFT JOIN dbo.PatientCase pc ON 
--	p.PatientID = pc.PatientID AND
--	pc.VendorImportID = @VendorImportID
--INNER JOIN dbo.DateKeyToPractice dk ON
--    dk.[PracticeID] = @PracticeID AND
--    dk.Dt = CAST(CAST(i.startdatetime AS DATE) AS DATETIME)
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--PRINT ''
--PRINT 'Inserting Into Appointment to Resource...'
--INSERT INTO dbo.AppointmentToResource
--        ( AppointmentID ,
--          AppointmentResourceTypeID ,
--          ResourceID ,
--          ModifiedDate ,
--          PracticeID
--        )
--SELECT DISTINCT
--		  a.AppointmentID , -- AppointmentID - int
--          1 , -- AppointmentResourceTypeID - int
--          CASE WHEN d.DoctorID IS NULL THEN (SELECT MIN(doctorID) FROM dbo.Doctor WHERE [External] = 0 AND ActiveDoctor = 1 AND PracticeID = @PracticeID) ELSE d.DoctorID END , -- ResourceID - int
--          GETDATE() , -- ModifiedDate - datetime
--          @PracticeID  -- PracticeID - int
--FROM dbo.Appointment a
--INNER JOIN dbo.[_import_5_1_Appointments] i ON 
--	a.[Subject] = i.appointmentuid AND
--	a.PracticeID = @PracticeID
--INNER JOIN dbo.[_import_5_1_ColumnHeadings] ch ON 
--	i.columnheadingfid = ch.columnheadinguid
--INNER JOIN dbo.[_import_1_1_Providers] ip ON 
--	ch.providerfid = ip.pgprovideruid
--LEFT JOIN dbo.Doctor d ON 
--	ip.firstname = d.FirstName AND 
--	ip.lastname = d.LastName AND 
--	d.[External] = 0 AND
--	d.ActiveDoctor = 1 AND
--    d.PracticeID = @PracticeID
--INNER JOIN dbo.Patient p ON
--	a.PatientID = p.PatientID AND
--	p.VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--PRINT ''
--PRINT 'Inserting Into Appointment Reason...'
--INSERT INTO dbo.AppointmentReason
--        ( PracticeID ,
--          Name ,
--          DefaultDurationMinutes ,
--          DefaultColorCode ,
--          Description ,
--          ModifiedDate 
--        )
--SELECT DISTINCT
--	      @PracticeID , -- PracticeID - int
--          i.name , -- Name - varchar(128)
--          15 , -- DefaultDurationMinutes - int
--          0 , -- DefaultColorCode - int
--          i.name , -- Description - varchar(256)
--          GETDATE()  -- ModifiedDate - datetime
--FROM dbo.[_import_5_1_AppointmentTypes] i WHERE NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE ar.name = i.name AND ar.PracticeID = @PracticeID) AND i.name <> ''
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--CREATE TABLE #apptreason
--(
--	appointmentuid INT , 
--	reasonname VARCHAR(50)
--)

--INSERT INTO #apptreason
--	(appointmentuid, reasonname)
--SELECT DISTINCT
--	i.appointmentfid ,
--	at.name
--FROM dbo.[_import_5_1_LnkAppointmentsTypes] i
--INNER JOIN dbo.[_import_5_1_AppointmentTypes] at ON
--	i.appttypefid = at.appttypeuid

--PRINT ''
--PRINT 'Inserting Into Appointment to Appointment Reason...'
--INSERT INTO dbo.AppointmentToAppointmentReason
--        ( AppointmentID ,
--          AppointmentReasonID ,
--          PrimaryAppointment ,
--          ModifiedDate ,
--          PracticeID
--        )
--SELECT DISTINCT
--		  a.AppointmentID , -- AppointmentID - int
--          ar.AppointmentReasonID , -- AppointmentReasonID - int
--          1 , -- PrimaryAppointment - bit
--          GETDATE() , -- ModifiedDate - datetime
--          @PracticeID  -- PracticeID - int
--FROM #apptreason i
--INNER JOIN dbo.Appointment a ON 
--	i.appointmentuid = a.[Subject] AND 
--	a.PracticeID = @PracticeID
--INNER JOIN dbo.AppointmentReason ar ON 
--	i.reasonname = ar.Name AND 
--	ar.PracticeID = @PracticeID
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase 
SET Name = 'Self Pay' , PayerScenarioID = 11
FROM dbo.PatientCase pc 
LEFT JOIN dbo.InsurancePolicy ip ON 
pc.PatientCaseID = ip.PatientCaseID  
WHERE ip.PatientCaseID IS NULL AND pc.PayerScenarioID = 5 AND pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


PRINT ''
PRINT 'Insert Into Patient Case...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          Notes ,
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
          'Balance Forward' , -- Name - varchar(128)
          1 , -- Active - bit
          11 , -- PayerScenarioID - int
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          Pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient as pat 
INNER JOIN dbo.[_import_1_1_PatBal] AS m ON
   pat.VendorID = m.patientchartnumber AND 
   pat.VendorImportID = @VendorImportID 
WHERE m.balance <> '' AND m.balance > '0'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

IF NOT EXISTS (SELECT * FROM dbo.DiagnosisCodeDictionary WHERE DiagnosisCode='000.00')
BEGIN

INSERT INTO dbo.DiagnosisCodeDictionary 
        ( 
		  DiagnosisCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          OfficialName ,
          LocalName ,
          OfficialDescription    
        )
VALUES  
       ( 
          '000.00' , -- DiagnosisCode - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          1 , -- Active - bit
         'Miscellaneous' ,  -- OfficialName - varchar(300)
         'Miscellaneous' ,  -- LocalName - varchar(100)
          NULL  -- OfficialDescription - varchar(500) 
        )
END

PRINT ''
PRINT 'Inserting Into Encounter...'
INSERT INTO dbo.Encounter
        ( PracticeID ,
          PatientID ,
          DoctorID ,
          LocationID ,
          DateOfService ,
          DateCreated ,
          Notes ,
          EncounterStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ReleaseSignatureSourceCode ,
          PlaceOfServiceCode ,
          PatientCaseID ,
          PostingDate ,
          DateOfServiceTo ,
          PaymentMethod ,
          AddOns ,
          DoNotSendElectronic ,
          SubmittedDate ,
          PaymentTypeID ,
          VendorID ,
          VendorImportID ,
          DoNotSendElectronicSecondary ,
          overrideClosingDate ,
          ClaimTypeID ,
          SecondaryClaimTypeID ,
          SubmitReasonIDCMS1500 ,
          SubmitReasonIDUB04 ,
          PatientCheckedIn 
        )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          pc.PatientID , -- PatientID - int
          CASE WHEN PAT.PrimaryProviderID IS NULL THEN Doc.DoctorID ELSE PAT.PrimaryProviderID END , -- DoctorID - int
          CASE WHEN PAT.DefaultServiceLocationID IS NULL THEN SL.ServiceLocationID ELSE PAT.DefaultServiceLocationID END , -- LocationID - int
          GETDATE() , -- DateOfService - datetime
          GETDATE() , -- DateCreated - datetime
          Convert(Varchar(10), GETDATE(),101) + ' : Balance Forward Created, please verify before use.' , -- Notes - text
          2 , -- EncounterStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'B' , -- ReleaseSignatureSourceCode - char(1)
          11 , -- PlaceOfServiceCode - char(2)
          pc.PatientCaseID , -- PatientCaseID - int       
          GETDATE() , -- PostingDate - datetime
          GETDATE() , -- DateOfServiceTo - datetime
          'U' , -- PaymentMethod - char(1)
          0 , -- AddOns - bigint
          0 , -- DoNotSendElectronic - bit
          GETDATE() , -- SubmittedDate - datetime
          0 , -- PaymentTypeID - int
          pc.VendorID , -- VendorID - varchar(50)                
          @VendorImportID , -- VendorImportID - int
          0 , -- DoNotSendElectronicSecondary - bit
          0 , -- overrideClosingDate - bit
          0 , -- ClaimTypeID - int
          0 , -- SecondaryClaimTypeID - int
          2 , -- SubmitReasonIDCMS1500 - int
          2 , -- SubmitReasonIDUB04 - int
          0  -- PatientCheckedIn - bit
FROM dbo.PatientCase AS PC  
INNER JOIN dbo.Patient PAT ON
	PC.PatientID = PAT.PatientID AND
	PC.VendorID = PAT.VendorID  
LEFT JOIN dbo.Doctor Doc ON
	Doc.DoctorID = (SELECT MIN(DoctorID) FROM dbo.Doctor AS D WHERE d.ActiveDoctor =1 AND d.[External] = 0 AND d.PracticeID = @PracticeID AND d.ActiveDoctor = 1)
LEFT JOIN dbo.ServiceLocation SL ON
	SL.ServicelocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation S WHERE s.PracticeID = @PracticeID)
WHERE pc.Name = 'Balance Forward' AND pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Encounter Diagnosis...'
INSERT INTO dbo.EncounterDiagnosis
        ( 
		  EncounterID ,
          DiagnosisCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          RecordTimeStamp ,
          ListSequence ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT DISTINCT
          enc.EncounterID , -- EncounterID - int
          dcd.DiagnosisCodeDictionaryID , -- DiagnosisCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL , -- RecordTimeStamp - timestamp
          1 , -- ListSequence - int
          @PracticeID  , -- PracticeID - int
          enc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Encounter as enc 
INNER JOIN dbo.DiagnosisCodeDictionary AS dcd ON
    dcd.DiagnosisCode = '000.00' AND 
    enc.PracticeID = @PracticeID        
WHERE enc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Insert Into Encounter Procedure...'
INSERT INTO dbo.EncounterProcedure
        ( 
		  EncounterID ,
          ProcedureCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ServiceChargeAmount ,   
          ServiceUnitCount ,
          ProcedureDateOfService ,
          PracticeID ,
          EncounterDiagnosisID1 ,
          ServiceEndDate ,
          VendorID ,
          VendorImportID ,
          TypeOfServiceCode ,
          AnesthesiaTime ,
          AssessmentDate ,
          DoctorID ,
          ConcurrentProcedures 
        )
SELECT DISTINCT
          enc.EncounterID  , -- EncounterID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pd.balance , -- ServiceChargeAmount - money   
          '1.000' , -- ServiceUnitCount - decimal
          GETDATE() , -- ProcedureDateOfService - datetime
          @PracticeID , -- PracticeID - int
          ed.EncounterDiagnosisID , -- EncounterDiagnosisID1 - int
          GETDATE() , -- ServiceEndDate - datetime
          enc.VendorID , -- VendorID - varchar(50)              
          @VendorImportID , -- VendorImportID - int
          '1' , -- TypeOfServiceCode - char(1)
          0 , -- AnesthesiaTime - int
          GETDATE() , -- AssessmentDate - datetime
          enc.DoctorID , -- DoctorID - int
          1  -- ConcurrentProcedures - int
FROM dbo.Encounter AS enc
INNER JOIN dbo.ProcedureCodeDictionary AS pcd ON
   pcd.OfficialName = 'Balance Forward' AND 
   enc.PracticeID = @PracticeID
INNER JOIN dbo.EncounterDiagnosis AS ed ON
   ed.vendorID = enc.VendorID AND 
   enc.VendorImportID = @VendorImportID   
LEFT JOIN dbo.[_import_1_1_PatBal] as pd ON 
    pd.patientchartnumber = enc.vendorID AND 
	enc.PracticeID = @PracticeID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'  


--DROP TABLE #apptreason

--ROLLBACK
--COMMIT
