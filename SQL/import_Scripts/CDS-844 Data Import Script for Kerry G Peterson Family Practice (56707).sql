USE superbill_56707_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @Timezone INT

SET @PracticeID = 2
SET @VendorImportID = 1
SET @Timezone = 0 -- EST 3 , CST 2 , MST 1 , PST 0 , Hawaii -3 (Depending on DST) , Arizona - 1 (Depending on DST)

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

/*
PRINT 'Deleting From EncounterDiagnosis...'
DELETE FROM dbo.EncounterDiagnosis WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From EncounterProcedure...'
DELETE FROM dbo.EncounterProcedure WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
DELETE FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted' 
PRINT 'Deleting From InsurancePolicy...'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From InsuranceCompanyPlan...'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From InsuranceCompany...'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From PatientCase...'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From PatientAlert...'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From PatientJournalNote...'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From Patient...'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From Doctor...'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From ServiceLocation...'
DELETE FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From Employers...'
DELETE FROM dbo.Employers 
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From ProcedureCodeDicationary...'
DELETE FROM dbo.ProcedureCodeDictionary WHERE CreatedDate > DATEADD(d,-4,GETDATE())
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
*/

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
          CASE WHEN i.eligibilityphonenumber = '' THEN '' ELSE 'Eligibility Phone: ' + i.providerrelationsphonenumber + ' ' + i.eligibilityphoneextension + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.preauthphonenumber = '' THEN '' ELSE 'PreAuth Phone: ' + i.preauthphonenumber + ' ' + i.preauthphoneextension + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.providerrelationsphonenumber = '' THEN '' ELSE 'Provider Relations Phone: ' + i.providerrelationsphonenumber + ' ' + i.providerrelationsphoneextension + CHAR(13) + CHAR(10) END +
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
FROM dbo.[_import_1_2_Carriers] i
INNER JOIN dbo.InsuranceCompany ic ON
	ic.InsuranceCompanyID = (SELECT MIN(InsuranceCompanyID) FROM dbo.InsuranceCompany
								WHERE i.carriername = InsuranceCompanyName AND
									(ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
WHERE i.display = 1
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
FROM dbo.[_import_1_2_Carriers] i
WHERE i.display = 1
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
          dbo.fn_RemoveNonNumericCharacters(i.faxnumber) , -- Fax - varchar(10)
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          i.standardcopaydollaramt , -- Copay - money , -- Copay - money
          i.carrieruid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_2_Carriers] i
INNER JOIN dbo.InsuranceCompany ic ON
	ic.VendorID = i.carriername AND
	ic.VendorImportID = @VendorImportID
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
FROM dbo.[_import_1_2_PatientInfo] i 
WHERE i.employer <> '' AND NOT EXISTS (SELECT * FROM dbo.Employers e WHERE e.EmployerName = i.employer)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

DECLARE @DefaultCollectionCategory INT
SET @DefaultCollectionCategory = (SELECT CollectionCategoryID FROM dbo.CollectionCategory WHERE IsDefaultCategory = 1)

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
          CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname THEN 1 ELSE 0 END ,
          CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN '' END ,
          CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN rp.firstname END ,
          CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN rp.middlename END ,
          CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN rp.lastname END ,
          CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN '' END ,
          CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN CASE i.relationship 
																	WHEN 1 THEN 'S' 
																	WHEN 2 THEN 'U' 
																	WHEN 3 THEN 'C'
																	WHEN 4 THEN 'O'
																ELSE 'O' END ELSE 'O' END ,
          CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN rp.address2 END ,
          CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN rp.address1 END ,
          CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN rp.city END ,
          CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN rp.[state] END ,
          CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN '' END ,
          CASE WHEN i.firstname <> rp.firstname OR i.lastname <> rp.lastname  THEN LEFT(REPLACE(rp.zipcode,'-',''),9) END ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          CASE WHEN i.employer <> '' THEN 'E' ELSE 'U' END ,
          d.DoctorID ,
          sl.ServiceLocationID ,
          e.EmployerID ,
          i.chartnumber ,
          LEFT(i.cell,10) ,
          i.patientuid ,
          @VendorImportID ,
          @DefaultCollectionCategory ,
          i.display ,
          0 ,
          0 ,
          CASE WHEN i.other <> '' THEN 'Other Phone Type: ' + i.phonetype ELSE '' END ,
          CASE WHEN i.other <> '' THEN LEFT(i.other,10) ELSE '' END 
FROM dbo.[_import_1_2_PatientInfo] i
LEFT JOIN dbo.Employers e ON
	e.EmployerName = i.employer
LEFT JOIN dbo.[_import_1_2_ResponsibleParties] rp ON
	i.responsiblepartyfid = rp.responsiblepartyuid
LEFT JOIN dbo.[_import_1_2_Providers] ip ON
	ip.pgprovideruid = i.providerfid
LEFT JOIN dbo.Doctor d ON 
	ip.firstname = d.FirstName AND 
	ip.lastname = d.lastname AND 
	ip.npinumber = d.NPI AND 
	d.[External] = 0 AND
    d.PracticeID = @PracticeID
LEFT JOIN dbo.ServiceLocation sl ON 
	sl.ServiceLocationID = (SELECT MIN(ServicelocationID) FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID)
WHERE i.firstname <> '' AND NOT EXISTS (SELECT * FROM dbo.Patient p WHERE p.FirstName = i.firstname AND p.LastName = i.lastname AND p.DOB = DATEADD(hh,12,CAST(i.dob AS DATETIME)) and p.practiceid = @practiceid)
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
          1 , -- ShowExpiredInsurancePolicies - bit
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
FROM dbo.[_import_1_2_Note] i
INNER JOIN dbo.Patient p ON
	i.patientfid = p.VendorID AND 
	p.VendorImportID = @VendorImportID
INNER JOIN dbo.[_import_1_2_NoteTypes] n ON 
	i.notetypefid = n.notetypeuid
WHERE i.note <> ''
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
          pc.VendorID + i.sequencenumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(i.groupname,14) , -- GroupName - varchar(14)
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_2_Coverages] i
INNER JOIN dbo.PatientCase pc ON 
	i.patientfid = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	i.carrierfid = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
LEFT JOIN dbo.[_import_1_2_ResponsibleParties] rp ON
	i.responsiblepartysubscriberfid = rp.responsiblepartyuid
LEFT JOIN dbo.Patient p ON
	pc.PatientID = p.PatientID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating PatientCase...'
UPDATE dbo.PatientCase 
SET Name = 'Self Pay' , PayerScenarioID = 11
FROM dbo.PatientCase pc LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND pc.PayerScenarioID = 5 AND pc.VendorImportID = @VendorImportID
WHERE ip.PatientCaseID IS NULL and pc.practiceid = @PracticeID and pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting Into Patient Case - Balance Forward...'
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
          'Balance Forward' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          0 , -- EmploymentRelatedFlag - bit
          0 , -- AutoAccidentRelatedFlag - bit
          0 , -- OtherAccidentRelatedFlag - bit
          0 , -- AbuseRelatedFlag - bit
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import for the purpose of Balance Forward Encounters. Please verify before use.' , -- Notes - text
          1 , -- ShowExpiredInsurancePolicies - bit
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
FROM dbo.Patient p 
	INNER JOIN _import_1_2_ChargeDetail i ON
		p.VendorID = i.patientfid AND
		p.PracticeID = @PracticeID
WHERE i.patbalance > '0.00' OR i.insbalance > '0.00'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy - Balance Forward...'
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
          pc.VendorID + i.sequencenumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(i.groupname,14) , -- GroupName - varchar(14)
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_2_Coverages] i
INNER JOIN dbo.PatientCase pc ON 
	i.patientfid = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID AND 
	pc.Name = 'Balance Forward'
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	i.carrierfid = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
LEFT JOIN dbo.[_import_1_2_ResponsibleParties] rp ON
	i.responsiblepartysubscriberfid = rp.responsiblepartyuid
INNER JOIN dbo._import_1_2_ChargeDetail impcd ON
	i.patientfid = impcd.patientfid
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
    p.PracticeID = @PracticeID AND
    p.VendorID = impcd.patientfid
WHERE impcd.patbalance > '0.00' OR impcd.insbalance > '0.00'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Encounter...'
INSERT INTO dbo.Encounter
        ( PracticeID ,
          PatientID ,
          DoctorID ,
          AppointmentID ,
          LocationID ,
          PatientEmployerID ,
          DateOfService ,
          DateCreated ,
          Notes ,
          EncounterStatusID ,
          --AdminNotes ,
          AmountPaid ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          MedicareAssignmentCode ,
          ReleaseOfInformationCode ,
          ReleaseSignatureSourceCode ,
          PlaceOfServiceCode ,
          ConditionNotes ,
          PatientCaseID ,
          InsurancePolicyAuthorizationID ,
          PostingDate ,
          DateOfServiceTo ,
          SupervisingProviderID ,
          ReferringPhysicianID ,
          PaymentMethod ,
          Reference ,
          AddOns ,
          HospitalizationStartDT ,
          HospitalizationEndDT ,
          Box19 ,
          DoNotSendElectronic ,
          SubmittedDate ,
          PaymentTypeID ,
          PaymentDescription ,
          EDIClaimNoteReferenceCode ,
          EDIClaimNote ,
          VendorID ,
          VendorImportID ,
          AppointmentStartDate ,
          BatchID ,
          SchedulingProviderID ,
          DoNotSendElectronicSecondary ,
          PaymentCategoryID ,
          overrideClosingDate ,
          Box10d ,
          ClaimTypeID ,
          OperatingProviderID ,
          OtherProviderID ,
          PrincipalDiagnosisCodeDictionaryID ,
          AdmittingDiagnosisCodeDictionaryID ,
          PrincipalProcedureCodeDictionaryID ,
          DRGCodeID ,
          ProcedureDate ,
          AdmissionTypeID ,
          AdmissionDate ,
          PointOfOriginCodeID ,
          AdmissionHour ,
          DischargeHour ,
          DischargeStatusCodeID ,
          Remarks ,
          SubmitReasonID ,
          DocumentControlNumber ,
          PTAProviderID ,
          SecondaryClaimTypeID ,
          SubmitReasonIDCMS1500 ,
          SubmitReasonIDUB04 ,
          DocumentControlNumberCMS1500 ,
          DocumentControlNumberUB04 ,
          EDIClaimNoteReferenceCodeCMS1500 ,
          EDIClaimNoteReferenceCodeUB04 ,
          EDIClaimNoteCMS1500 ,
          EDIClaimNoteUB04 ,
          PatientCheckedIn ,
          RoomNumber ,
          DiagnosisMapSource ,
          CollectionCategoryID
        )
SELECT DISTINCT	
		  @PracticeID , -- PracticeID - int
          pc.PatientID , -- PatientID - int
          2 ,--rendprov.DoctorID , -- DoctorID - int ******** NEEDS UPDATING - mapping to provider based on date and patid is duplicated
          NULL , -- AppointmentID - int
          1 , -- LocationID - int
          NULL , -- PatientEmployerID - int
          impcd.begindateofservice , -- DateOfService - datetime
          GETDATE() , -- DateCreated - datetime
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          1 , -- EncounterStatusID - int *********		DRAFT = 1 , APPROVED = 3
    --      'From AdvancedMD - ' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) +
		  --CASE WHEN impcd.patbalance > '0.00' THEN + CHAR(13) + CHAR(10) + 'Remaining Patient Balance: ' + impcd.patbalance  
		  --     WHEN impcd.insbalance > '0.00' THEN + CHAR(13) + CHAR(10) + 'Remaining Insurance Balance: ' + impcd.insbalance
		  --ELSE '' END + CHAR(13) + CHAR(10) +
		  --'PatientFID: ' + impcd.patientfid + CHAR(13) + CHAR(10) +
		  --'ChargeDetail_UID: ' + impcd.chargedetailuid + CHAR(13) + CHAR(10) +
		  --'Created Date: ' + CONVERT(VARCHAR(10),impcd.createdat,101) + CHAR(13) + CHAR(10) , -- AdminNotes - text
          '$0.00' , -- AmountPaid - money
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL , -- MedicareAssignmentCode - char(1)
          NULL , -- ReleaseOfInformationCode - char(1)
          'B' , -- ReleaseSignatureSourceCode - char(1)
          11 , -- PlaceOfServiceCode - char(2)
          NULL , -- ConditionNotes - text
          pc.PatientCaseID , -- PatientCaseID - int
          NULL , -- InsurancePolicyAuthorizationID - int
          GETDATE() , -- PostingDate - datetime -- Source Data has two separate posting dates with save vendorid/Visitfid
          impcd.enddateofservice , -- DateOfServiceTo - datetime
          NULL , -- SupervisingProviderID - int
          NULL , -- ReferringPhysicianID - int
          'U' , -- PaymentMethod - char(1)
          NULL , -- Reference - varchar(40)
          0 , -- AddOns - bigint
          NULL , -- HospitalizationStartDT - datetime
          NULL , -- HospitalizationEndDT - datetime
          NULL , -- Box19 - varchar(51)
          1 , -- DoNotSendElectronic - bit
          NULL , -- SubmittedDate - datetime
          NULL , -- PaymentTypeID - int
          NULL , -- PaymentDescription - varchar(250)
          NULL , -- EDIClaimNoteReferenceCode - char(3)
          NULL , -- EDIClaimNote - varchar(1600)
          impcd.visitfid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          NULL , -- AppointmentStartDate - datetime
          '' , -- BatchID - varchar(50)
          NULL , -- SchedulingProviderID - int
          1 , -- DoNotSendElectronicSecondary - bit
          NULL , -- PaymentCategoryID - int
          0 , -- overrideClosingDate - bit
          '' , -- Box10d - varchar(40)
          0 , -- ClaimTypeID - int
          NULL , -- OperatingProviderID - int
          NULL , -- OtherProviderID - int
          NULL , -- PrincipalDiagnosisCodeDictionaryID - int
          NULL , -- AdmittingDiagnosisCodeDictionaryID - int
          NULL , -- PrincipalProcedureCodeDictionaryID - int
          NULL , -- DRGCodeID - int
          GETDATE() , -- ProcedureDate - datetime
          NULL , -- AdmissionTypeID - int
          GETDATE() , -- AdmissionDate - datetime
          NULL , -- PointOfOriginCodeID - int
          NULL , -- AdmissionHour - varchar(2)
          NULL , -- DischargeHour - varchar(2)
          NULL , -- DischargeStatusCodeID - int
          NULL , -- Remarks - varchar(255)
          NULL , -- SubmitReasonID - int
          NULL , -- DocumentControlNumber - varchar(26)
          NULL , -- PTAProviderID - int
          0 , -- SecondaryClaimTypeID - int
          2 , -- SubmitReasonIDCMS1500 - int
          2 , -- SubmitReasonIDUB04 - int
          NULL , -- DocumentControlNumberCMS1500 - varchar(26)
          NULL , -- DocumentControlNumberUB04 - varchar(26)
          NULL , -- EDIClaimNoteReferenceCodeCMS1500 - char(3)
          NULL , -- EDIClaimNoteReferenceCodeUB04 - char(3)
          NULL , -- EDIClaimNoteCMS1500 - varchar(1600)
          NULL , -- EDIClaimNoteUB04 - varchar(1600)
          0 , -- PatientCheckedIn - bit
          NULL , -- RoomNumber - varchar(32)
          1 , -- DiagnosisMapSource - bit
          p.CollectionCategoryID  -- CollectionCategoryID - int
FROM dbo._import_1_2_ChargeDetail impcd 
	INNER JOIN dbo.PatientCase pc ON 
		impcd.patientfid = pc.VendorID AND 
		pc.Name = 'Balance Forward' AND
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.Patient p ON 
		pc.PatientID = p.PatientID AND 
		p.PracticeID = @PracticeID
	INNER JOIN dbo._import_1_2_PatientInfo imppat ON 
		imppat.patientuid = pc.VendorID
	--INNER JOIN dbo._import_1_2_Appointments ia ON
	--	impcd.visitfid = ia.appointmentuid
	--INNER JOIN dbo._import_1_2_Providers id ON 
	--	ia.pgproviderfid = id.pgprovideruid 
	--INNER JOIN dbo.Doctor d ON 
	--	id.firstname = d.FirstName AND 
 --       id.lastname = d.LastName AND 
	--	id.npinumber = d.NPI AND 
 --       d.[External] = 0 AND 
 --       d.ActiveDoctor = 1 AND 
	--	d.PracticeID = @PracticeID
	LEFT JOIN dbo.Encounter e ON
		impcd.chargedetailuid = e.VendorID AND 
		e.VendorImportID = @VendorImportID
WHERE (impcd.patbalance > '0.00' OR impcd.insbalance > '0.00') AND e.EncounterID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

CREATE TABLE #AdminNote (VisitFID INT, ChargeDetailUID INT, ChargeCode VARCHAR(50) , InsBalance VARCHAR(15) , PatBalance VARCHAR(15))
INSERT INTO #AdminNote
        ( VisitFID ,
          ChargeDetailUID ,
          ChargeCode ,
          InsBalance ,
          PatBalance
        )
SELECT DISTINCT
		  i.visitfid , -- VisitFID - int
          i.chargedetailuid , -- ChargeDetailUID - int
          cc.chargecode , -- ChargeCode - varchar(50)
          i.insbalance , -- InsBalance - money
          i.patbalance  -- PatBalance - money
FROM dbo._import_1_2_ChargeDetail i
	INNER JOIN dbo._import_1_2_ChargeCodes cc ON 
		i.chargecodefid = cc.chargecodeuid
WHERE i.patbalance > '0.00' OR i.insbalance > '0.00'

PRINT ''
PRINT 'Updating Encounter Notes...'
UPDATE dbo.Encounter 
	SET AdminNotes =  'Remaining Balances From Advanced MD:' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) +
					  'Procedure Code: ' + Bal1.ChargeCode + 
															CASE WHEN Bal1.InsBalance = '0.00' THEN ' | Pat Balance = ' + Bal1.PatBalance 
																WHEN Bal1.PatBalance = '0.00' THEN ' | Ins Balance = ' + Bal1.InsBalance
															ELSE ' | Pat Balance = ' + Bal1.PatBalance + CHAR(13) + CHAR(10) +
																 'Ins Balance = ' + Bal1.InsBalance 
															END + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal2.ChargeCode + 
															 CASE WHEN Bal2.InsBalance = '0.00' THEN ' | Pat Balance = ' + Bal2.PatBalance 
																WHEN Bal2.PatBalance = '0.00' THEN ' | Ins Balance = ' + Bal2.InsBalance
															ELSE ' | Pat Balance = ' + Bal2.PatBalance + CHAR(13) + CHAR(10) +
																 'Ins Balance = ' + Bal2.InsBalance 
															END,'') + CHAR(13) + CHAR(10)  + 
					   ISNULL('Procedure Code: ' + Bal3.ChargeCode +
															 CASE WHEN Bal3.InsBalance = '0.00' THEN ' | Pat Balance = ' + Bal3.PatBalance 
																WHEN Bal3.PatBalance = '0.00' THEN ' | Ins Balance = ' + Bal3.InsBalance
															ELSE ' | Pat Balance = ' + Bal3.PatBalance + CHAR(13) + CHAR(10) +
																 'Ins Balance = ' + Bal3.InsBalance 
															END,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal4.ChargeCode +
															 CASE WHEN Bal4.InsBalance = '0.00' THEN ' | Pat Balance = ' + Bal4.PatBalance 
																WHEN Bal4.PatBalance = '0.00' THEN ' | Ins Balance = ' + Bal4.InsBalance
															ELSE ' | Pat Balance = ' + Bal4.PatBalance + CHAR(13) + CHAR(10) +
																 'Ins Balance = ' + Bal4.InsBalance 
															END,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal5.ChargeCode +
															 CASE WHEN Bal5.InsBalance = '0.00' THEN ' | Pat Balance = ' + Bal5.PatBalance 
																WHEN Bal5.PatBalance = '0.00' THEN ' | Ins Balance = ' + Bal5.InsBalance
															ELSE ' | Pat Balance = ' + Bal5.PatBalance + CHAR(13) + CHAR(10) +
																 'Ins Balance = ' + Bal5.InsBalance + CHAR(13) + CHAR(10)
															END,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal6.ChargeCode + 
															 CASE WHEN Bal6.InsBalance = '0.00' THEN ' | Pat Balance = ' + Bal6.PatBalance 
																WHEN Bal6.PatBalance = '0.00' THEN ' | Ins Balance = ' + Bal6.InsBalance
															ELSE ' | Pat Balance = ' + Bal6.PatBalance + CHAR(13) + CHAR(10) +
																 'Ins Balance = ' + Bal6.InsBalance + CHAR(13) + CHAR(10)
															END,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal7.ChargeCode + 
															 CASE WHEN Bal7.InsBalance = '0.00' THEN ' | Pat Balance = ' + Bal7.PatBalance 
																WHEN Bal7.PatBalance = '0.00' THEN ' | Ins Balance = ' + Bal7.InsBalance
															ELSE ' | Pat Balance = ' + Bal7.PatBalance + CHAR(13) + CHAR(10) +
																 'Ins Balance = ' + Bal7.InsBalance + CHAR(13) + CHAR(10)
															END,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal8.ChargeCode + 
															 CASE WHEN Bal8.InsBalance = '0.00' THEN ' | Pat Balance = ' + Bal8.PatBalance 
																WHEN Bal8.PatBalance = '0.00' THEN ' | Ins Balance = ' + Bal8.InsBalance
															ELSE ' | Pat Balance = ' + Bal8.PatBalance + CHAR(13) + CHAR(10) +
																 'Ins Balance = ' + Bal8.InsBalance + CHAR(13) + CHAR(10)
															END,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal9.ChargeCode +
															 CASE WHEN Bal9.InsBalance = '0.00' THEN ' | Pat Balance = ' + Bal9.PatBalance 
																WHEN Bal9.PatBalance = '0.00' THEN ' | Ins Balance = ' + Bal9.InsBalance
															ELSE ' | Pat Balance = ' + Bal9.PatBalance + CHAR(13) + CHAR(10) +
																 'Ins Balance = ' + Bal9.InsBalance + CHAR(13) + CHAR(10)
															END,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal10.ChargeCode + 
															 CASE WHEN Bal10.InsBalance = '0.00' THEN ' | Pat Balance = ' + Bal10.PatBalance 
																WHEN Bal10.PatBalance = '0.00' THEN ' | Ins Balance = ' + Bal10.InsBalance
															ELSE ' | Pat Balance = ' + Bal10.PatBalance + CHAR(13) + CHAR(10) +
																 'Ins Balance = ' + Bal10.InsBalance + CHAR(13) + CHAR(10)
															END,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal11.ChargeCode +
															 CASE WHEN Bal11.InsBalance = '0.00' THEN ' | Pat Balance = ' + Bal11.PatBalance 
																WHEN Bal11.PatBalance = '0.00' THEN ' | Ins Balance = ' + Bal11.InsBalance
															ELSE ' | Pat Balance = ' + Bal11.PatBalance + CHAR(13) + CHAR(10) +
																 'Ins Balance = ' + Bal11.InsBalance + CHAR(13) + CHAR(10)
															END,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal12.ChargeCode +
															 CASE WHEN Bal12.InsBalance = '0.00' THEN ' | Pat Balance = ' + Bal12.PatBalance 
																WHEN Bal12.PatBalance = '0.00' THEN ' | Ins Balance = ' + Bal12.InsBalance
															ELSE ' | Pat Balance = ' + Bal12.PatBalance + CHAR(13) + CHAR(10) +
																 'Ins Balance = ' + Bal12.InsBalance + CHAR(13) + CHAR(10)
															END,'') + CHAR(13) + CHAR(10) + 
					   ISNULL('Procedure Code: ' + Bal13.ChargeCode +
															 CASE WHEN Bal13.InsBalance = '0.00' THEN ' | Pat Balance = ' + Bal13.PatBalance 
																WHEN Bal13.PatBalance = '0.00' THEN ' | Ins Balance = ' + Bal13.InsBalance
															ELSE ' | Pat Balance = ' + Bal13.PatBalance + CHAR(13) + CHAR(10) +
																 'Ins Balance = ' + Bal13.InsBalance + CHAR(13) + CHAR(10)
															END,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal14.ChargeCode +
															 CASE WHEN Bal14.InsBalance = '0.00' THEN ' | Pat Balance = ' + Bal14.PatBalance 
																WHEN Bal14.PatBalance = '0.00' THEN ' | Ins Balance = ' + Bal14.InsBalance
															ELSE ' | Pat Balance = ' + Bal14.PatBalance + CHAR(13) + CHAR(10) +
																 'Ins Balance = ' + Bal14.InsBalance + CHAR(13) + CHAR(10)
															END,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal15.ChargeCode +
															 CASE WHEN Bal15.InsBalance = '0.00' THEN ' | Pat Balance = ' + Bal15.PatBalance 
																WHEN Bal15.PatBalance = '0.00' THEN ' | Ins Balance = ' + Bal15.InsBalance
															ELSE ' | Pat Balance = ' + Bal15.PatBalance + CHAR(13) + CHAR(10) +
																 'Ins Balance = ' + Bal15.InsBalance + CHAR(13) + CHAR(10)
															END,'')

FROM dbo.Encounter e
LEFT JOIN (
SELECT VisitFID, ChargeDetailUID, ChargeCode, InsBalance, PatBalance, ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY ChargeDetailUID DESC) AS BalNum FROM #AdminNote
		  ) AS Bal1 ON e.VendorID = Bal1.VisitFID AND Bal1.BalNum = 1
LEFT JOIN (
SELECT VisitFID, ChargeDetailUID, ChargeCode, InsBalance, PatBalance, ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY ChargeDetailUID DESC) AS BalNum FROM #AdminNote
		  ) AS Bal2 ON e.VendorID = Bal2.VisitFID AND Bal2.BalNum = 2
LEFT JOIN (
SELECT VisitFID, ChargeDetailUID, ChargeCode, InsBalance, PatBalance, ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY ChargeDetailUID DESC) AS BalNum FROM #AdminNote
		  ) AS Bal3 ON e.VendorID = Bal3.VisitFID AND bal3.BalNum = 3
LEFT JOIN (
SELECT VisitFID, ChargeDetailUID, ChargeCode, InsBalance, PatBalance, ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY ChargeDetailUID DESC) AS BalNum FROM #AdminNote
		  ) AS Bal4 ON e.VendorID = Bal4.VisitFID AND bal4.BalNum = 4
LEFT JOIN (
SELECT VisitFID, ChargeDetailUID, ChargeCode, InsBalance, PatBalance, ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY ChargeDetailUID DESC) AS BalNum FROM #AdminNote
		  ) AS Bal5 ON e.VendorID = Bal5.VisitFID AND bal5.BalNum = 5
LEFT JOIN (
SELECT VisitFID, ChargeDetailUID, ChargeCode, InsBalance, PatBalance, ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY ChargeDetailUID DESC) AS BalNum FROM #AdminNote
		  ) AS Bal6 ON e.VendorID = Bal6.VisitFID AND bal6.BalNum = 6
LEFT JOIN (
SELECT VisitFID, ChargeDetailUID, ChargeCode, InsBalance, PatBalance, ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY ChargeDetailUID DESC) AS BalNum FROM #AdminNote
		  ) AS Bal7 ON e.VendorID = Bal7.VisitFID AND bal7.BalNum = 7
LEFT JOIN (
SELECT VisitFID, ChargeDetailUID, ChargeCode, InsBalance, PatBalance, ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY ChargeDetailUID DESC) AS BalNum FROM #AdminNote
		  ) AS Bal8 ON e.VendorID = Bal8.VisitFID AND bal8.BalNum = 8
LEFT JOIN (
SELECT VisitFID, ChargeDetailUID, ChargeCode, InsBalance, PatBalance, ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY ChargeDetailUID DESC) AS BalNum FROM #AdminNote
		  ) AS Bal9 ON e.VendorID = Bal9.VisitFID AND bal9.BalNum = 9
LEFT JOIN (
SELECT VisitFID, ChargeDetailUID, ChargeCode, InsBalance, PatBalance, ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY ChargeDetailUID DESC) AS BalNum FROM #AdminNote
		  ) AS Bal10 ON e.VendorID = Bal10.VisitFID AND bal10.BalNum = 10
LEFT JOIN (
SELECT VisitFID, ChargeDetailUID, ChargeCode, InsBalance, PatBalance, ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY ChargeDetailUID DESC) AS BalNum FROM #AdminNote
		  ) AS Bal11 ON e.VendorID = Bal11.VisitFID AND bal11.BalNum = 11
LEFT JOIN (
SELECT VisitFID, ChargeDetailUID, ChargeCode, InsBalance, PatBalance, ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY ChargeDetailUID DESC) AS BalNum FROM #AdminNote
		  ) AS Bal12 ON e.VendorID = Bal12.VisitFID AND Bal12.BalNum = 12
LEFT JOIN (
SELECT VisitFID, ChargeDetailUID, ChargeCode, InsBalance, PatBalance, ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY ChargeDetailUID DESC) AS BalNum FROM #AdminNote
		  ) AS Bal13 ON e.VendorID = Bal13.VisitFID AND bal13.BalNum = 13
LEFT JOIN (
SELECT VisitFID, ChargeDetailUID, ChargeCode, InsBalance, PatBalance, ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY ChargeDetailUID DESC) AS BalNum FROM #AdminNote
		  ) AS Bal14 ON e.VendorID = Bal14.VisitFID AND bal14.BalNum = 14
LEFT JOIN (
SELECT VisitFID, ChargeDetailUID, ChargeCode, InsBalance, PatBalance, ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY ChargeDetailUID DESC) AS BalNum FROM #AdminNote
		  ) AS Bal15 ON e.VendorID = Bal15.VisitFID AND bal15.BalNum = 15
WHERE e.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting Into Procedure Code Dictionary...'
INSERT INTO dbo.ProcedureCodeDictionary
        ( ProcedureCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          TypeOfServiceCode ,
          Active ,
          OfficialName ,
          NOC ,
          CustomCode
        )
SELECT DISTINCT
		  cc.chargecode , -- ProcedureCode - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '1' , -- TypeOfServiceCode - char(1)
          1 , -- Active - bit
          cc.statementdescription , -- OfficialName - varchar(300)
          0 , -- NOC - int
          0  -- CustomCode - bit
FROM dbo._import_1_2_ChargeDetail cd
INNER JOIN dbo._import_1_2_ChargeCodes cc ON cd.chargecodefid = cc.chargecodeuid
LEFT JOIN dbo.ProcedureCodeDictionary pcd ON cc.chargecode = pcd.ProcedureCode
WHERE (cd.patbalance > '0.00' OR cd.insbalance > '0.00') AND PCD.ProcedureCodeDictionaryID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

CREATE TABLE #TempImpProcedureMod (ChargeDetailModifierCodeUID INT , ChargeDetailFID INT , ModifierCodeFID INT , codesequence INT , KProcedureModifer VARCHAR(10))
INSERT INTO #TempImpProcedureMod
        ( ChargeDetailModifierCodeUID ,
          ChargeDetailFID ,
          ModifierCodeFID ,
          codesequence , 
		  KProcedureModifer
        )
SELECT DISTINCT
		  i.chargedetailmodifiercodeuid , -- ChargeDetailModifierCodeUID - int
          i.chargedetailfid , -- ChargeDetailFID - int
          i.modifiercodefid , -- ModifierCodeFID - int
          i.codesequence ,  -- codesequence - int
		  pm.ProcedureModifierCode
FROM dbo._import_1_2_lnkChargeDetailModifierCodes i
	INNER JOIN dbo._import_1_2_ModifierCodes mc ON
		i.modifiercodefid = mc.modifiercodeuid
	LEFT JOIN dbo.ProcedureModifier pm ON
		mc.modifiercode = pm.ProcedureModifierCode

PRINT ''
PRINT 'Inserting Into Encounter Procedure...'
INSERT INTO dbo.EncounterProcedure
        ( EncounterID ,
          ProcedureCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ServiceChargeAmount ,
          ServiceUnitCount ,
          ProcedureModifier1 ,
          ProcedureModifier2 ,
          ProcedureModifier3 ,
          ProcedureModifier4 ,
          ProcedureDateOfService ,
          PracticeID ,
          --EncounterDiagnosisID1 ,
          --EncounterDiagnosisID2 ,
          --EncounterDiagnosisID3 ,
          --EncounterDiagnosisID4 ,
          ServiceEndDate ,
          VendorID ,
          VendorImportID ,
          ContractID ,
          [Description] ,
          EDIServiceNoteReferenceCode ,
          EDIServiceNote ,
          TypeOfServiceCode ,
          AnesthesiaTime ,
          ApplyPayment ,
          PatientResp ,
          AssessmentDate ,
          RevenueCodeID ,
          NonCoveredCharges ,
          DoctorID ,
          StartTime ,
          EndTime ,
          ConcurrentProcedures ,
          StartTimeText ,
          EndTimeText 
          --EncounterDiagnosisID5 ,
          --EncounterDiagnosisID6 ,
          --EncounterDiagnosisID7 ,
          --EncounterDiagnosisID8
        )
SELECT DISTINCT
		  e.EncounterID , -- EncounterID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          impcd.fee , -- ServiceChargeAmount - money
          impcd.units , -- ServiceUnitCount - decimal
          impprocmod1.KProcedureModifer , -- ProcedureModifier1 - varchar(16)
          impprocmod2.KProcedureModifer , -- ProcedureModifier2 - varchar(16)
          impprocmod3.KProcedureModifer , -- ProcedureModifier3 - varchar(16)
          NULL , -- ProcedureModifier4 - varchar(16)
          e.DateOfService , -- ProcedureDateOfService - datetime
          @PracticeID , -- PracticeID - int
          e.DateOfServiceTo , -- ServiceEndDate - datetime
          impcd.chargedetailuid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          NULL , -- ContractID - int
          NULL , -- Description - varchar(80)
          NULL , -- EDIServiceNoteReferenceCode - char(3)
          NULL , -- EDIServiceNote - varchar(80)
          NULL , -- TypeOfServiceCode - char(1)
          0 , -- AnesthesiaTime - int
          0.00 , -- ApplyPayment - money
          0.00 , -- PatientResp - money
          NULL , -- AssessmentDate - datetime
          NULL , -- RevenueCodeID - int
          0.00 , -- NonCoveredCharges - money
          NULL , -- DoctorID - int
          NULL , -- StartTime - datetime
          NULL , -- EndTime - datetime
          NULL , -- ConcurrentProcedures - int
          NULL , -- StartTimeText - varchar(4)
          NULL  -- EndTimeText - varchar(4)
FROM dbo.Encounter e 
	INNER JOIN dbo._import_1_2_ChargeDetail impcd ON
		e.VendorID = impcd.visitfid 
	INNER JOIN dbo._import_1_2_ChargeCodes impcc ON 
		impcd.chargecodefid = impcc.chargecodeuid 
	INNER JOIN dbo.ProcedureCodeDictionary pcd ON 
		impcc.chargecode = pcd.ProcedureCode
	LEFT JOIN #TempImpProcedureMod impprocmod1 ON
		impcd.chargedetailuid = impprocmod1.ChargeDetailFID AND
		impprocmod1.codesequence = 1
	LEFT JOIN #TempImpProcedureMod impprocmod2 ON
		impcd.chargedetailuid = impprocmod2.ChargeDetailFID AND
		impprocmod2.codesequence = 2
	LEFT JOIN #TempImpProcedureMod impprocmod3 ON
		impcd.chargedetailuid = impprocmod3.ChargeDetailFID AND
		impprocmod3.codesequence = 3
WHERE impcd.patbalance > '0.00' OR impcd.insbalance > '0.00'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

IF NOT EXISTS (SELECT * FROM dbo.DiagnosisCodeDictionary WHERE DiagnosisCode = '000.00')
BEGIN

INSERT INTO dbo.DiagnosisCodeDictionary
        ( DiagnosisCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          OfficialName 
        )
VALUES  ( '000.00' , -- DiagnosisCode - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          'PHYSICALS'  -- OfficialName - varchar(300)
        )
END

PRINT ''
PRINT 'Inserting Into Encounter Diagnosis...'
INSERT INTO dbo.EncounterDiagnosis
        ( EncounterID ,
          DiagnosisCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ListSequence ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT DISTINCT
	      e.EncounterID , -- EncounterID - int
          CASE WHEN dcd.DiagnosisCodeDictionaryID IS NULL THEN dcd10.ICD10DiagnosisCodeDictionaryId ELSE dcd.DiagnosisCodeDictionaryID END , -- DiagnosisCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          impcdd.codesequence , -- ListSequence - int
          @PracticeID , -- PracticeID - int
          impcdd.chargedetaildiagnosiscodeuid + '|' + impcdd.chargedetailfid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo._import_1_2_ChargeDetail impcd 
	INNER JOIN dbo.EncounterProcedure e ON 
		impcd.chargedetailuid = e.VendorID AND 
		e.VendorImportID = @VendorImportID
	INNER JOIN dbo._import_1_2_LnkChargeDetailDiagnosisCode impcdd ON 
		impcd.chargedetailuid = impcdd.chargedetailfid 
	INNER JOIN dbo._import_1_2_DiagnosisCodes impdc ON 
		impcdd.diagnosiscodefid = impdc.diagnosiscodeuid
	LEFT JOIN dbo.DiagnosisCodeDictionary dcd ON 
		impdc.diagnosiscode = dcd.DiagnosisCode
	LEFT JOIN dbo.ICD10DiagnosisCodeDictionary dcd10 ON 
		impdc.diagnosiscode = dcd10.DiagnosisCode
WHERE impdc.display = 1 AND (impcd.patbalance > '0.00' OR impcd.insbalance > '0.00') AND (impcdd.codesequence >= 1 AND impcdd.codesequence <=8) AND e.ModifiedUserID = 0 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Encounter Procedure...'
UPDATE dbo.EncounterProcedure
	SET  EncounterDiagnosisID1 = ed_5.EncounterDiagnosisID ,
		 EncounterDiagnosisID2 = ed_6.EncounterDiagnosisID ,
		 EncounterDiagnosisID3 = ed_7.EncounterDiagnosisID ,
		 EncounterDiagnosisID4 = ed_8.EncounterDiagnosisID ,
		 EncounterDiagnosisID5 = ed_1.EncounterDiagnosisID ,
		 EncounterDiagnosisID6 = ed_2.EncounterDiagnosisID ,
		 EncounterDiagnosisID7 = ed_3.EncounterDiagnosisID ,
		 EncounterDiagnosisID8 = ed_4.EncounterDiagnosisID 
FROM dbo.EncounterProcedure e
LEFT JOIN dbo.EncounterDiagnosis ed_5 ON 
	ed_5.EncounterID = e.EncounterID  AND
    ed_5.ListSequence = 5 AND
    ed_5.VendorImportID = @VendorImportID AND
    RIGHT(ed_5.vendorid,CHARINDEX('|',ed_5.VendorID)-1) = e.VendorID
LEFT JOIN dbo.EncounterDiagnosis ed_6 ON 
	ed_6.EncounterID = e.EncounterID AND
    ed_6.ListSequence = 6 AND
    ed_6.VendorImportID = @VendorImportID AND
    RIGHT(ed_6.vendorid,CHARINDEX('|',ed_6.VendorID)-1) = e.VendorID
LEFT JOIN dbo.EncounterDiagnosis ed_7 ON 
	ed_7.EncounterID = e.EncounterID AND
    ed_7.ListSequence = 7 AND
    ed_7.VendorImportID = @VendorImportID AND
    RIGHT(ed_7.vendorid,CHARINDEX('|',ed_7.VendorID)-1) = e.VendorID
LEFT JOIN dbo.EncounterDiagnosis ed_8 ON 
	ed_8.EncounterID = e.EncounterID AND
    ed_8.ListSequence = 8 AND
    ed_8.VendorImportID = @VendorImportID AND
    RIGHT(ed_8.vendorid,CHARINDEX('|',ed_8.VendorID)-1) = e.VendorID
LEFT JOIN dbo.EncounterDiagnosis ed_1 ON 
	ed_1.EncounterID = e.EncounterID AND
    ed_1.ListSequence = 1 AND
    ed_1.VendorImportID = @VendorImportID AND
    RIGHT(ed_1.vendorid,CHARINDEX('|',ed_1.VendorID)-1) = e.VendorID
LEFT JOIN dbo.EncounterDiagnosis ed_2 ON 
	ed_2.EncounterID = e.EncounterID AND
    ed_2.ListSequence = 2 AND
    ed_2.VendorImportID = @VendorImportID AND
    RIGHT(ed_2.vendorid,CHARINDEX('|',ed_2.VendorID)-1) = e.VendorID
LEFT JOIN dbo.EncounterDiagnosis ed_3 ON 
	ed_3.EncounterID = e.EncounterID AND
    ed_3.ListSequence = 3 AND
    ed_3.VendorImportID = @VendorImportID AND
    RIGHT(ed_3.vendorid,CHARINDEX('|',ed_3.VendorID)-1) = e.VendorID
LEFT JOIN dbo.EncounterDiagnosis ed_4 ON 
	ed_4.EncounterID = e.EncounterID AND
    ed_4.ListSequence = 4 AND
    ed_4.VendorImportID = @VendorImportID AND
    RIGHT(ed_4.vendorid,CHARINDEX('|',ed_4.VendorID)-1) = e.VendorID
WHERE e.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


DROP TABLE #TempImpProcedureMod, #AdminNote



--ROLLBACK
--COMMIT
