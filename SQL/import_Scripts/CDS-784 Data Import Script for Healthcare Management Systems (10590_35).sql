USE superbill_10590_dev
--USE superbill_10590_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @Timezone INT

SET @PracticeID = 35
SET @VendorImportID = 22
SET @Timezone = 0 -- EST 3 , CST 2 , MST 1 , PST 0 , Hawaii -3 (Depending on DST) , Arizona - 1 (Depending on DST)

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
--DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
----DELETE FROM dbo.Employers WHERE CreatedUserID = 0 AND ModifiedUserID = 0
----PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'
--DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID

CREATE TABLE #insmap (CarrierUID VARCHAR(15) , KareoPlanID INT)
INSERT INTO #insmap  ( CarrierUID, KareoPlanID )
SELECT DISTINCT carrieruid , CASE WHEN planid = 6014 THEN 6111 ELSE planid END
FROM dbo.[_import_22_35_UpdateCarriers]

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
FROM dbo.[_import_22_35_Carriers] i
WHERE i.carrieruid = '18797'
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
FROM dbo.[_import_22_35_Carriers] i
INNER JOIN dbo.InsuranceCompany ic ON
	ic.VendorID = i.carriername AND
	ic.VendorImportID = @VendorImportID
WHERE i.carrieruid = '18797'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

UPDATE #insmap 
	SET KareoPlanID = icp.InsuranceCompanyPlanID
FROM #insmap insmap
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	insmap.CarrierUID = icp.VendorID AND 
	icp.VendorImportID = @VendorImportID

UPDATE dbo.InsuranceCompanyPlan
	SET ReviewCode = 'R'
WHERE InsuranceCompanyPlanID = 6111

PRINT ''
PRINT 'Updating Existing Service Locations with VendorID...'
UPDATE dbo.ServiceLocation 
	SET VendorID = i.facilityuid
FROM dbo.ServiceLocation sl 
INNER JOIN dbo.[_import_22_35_Facilities] i ON 
	sl.AddressLine1 = i.address2 AND 
	sl.[State] = i.[state]
WHERE sl.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

-- Service Location - OPTIONAL -- The TimezoneID is loosely selected

--PRINT ''
--PRINT 'Inserting Into Service Location...'
--INSERT INTO dbo.ServiceLocation
--        ( PracticeID ,
--          Name ,
--          AddressLine1 ,
--          AddressLine2 ,
--          City ,
--          State ,
--          Country ,
--          ZipCode ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          BillingName ,
--          Phone ,
--          PhoneExt ,
--          VendorImportID ,
--          VendorID ,
--          TimeZoneID 
--        )
--SELECT DISTINCT
--		  @PracticeID , -- PracticeID - int
--          i.facilityname , -- Name - varchar(128)
--          i.address2 , -- AddressLine1 - varchar(256)
--          i.address1 , -- AddressLine2 - varchar(256)
--          i.city , -- City - varchar(128)
--          i.[state] , -- State - varchar(2)
--          '' , -- Country - varchar(32)
--          REPLACE(i.zipcode,'-','') , -- ZipCode - varchar(9)
--          GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0 , -- ModifiedUserID - int
--          i.facilityname , -- BillingName - varchar(128)
--          i.officephone , -- Phone - varchar(10)
--          i.officeextension , -- PhoneExt - varchar(10)
--          @VendorImportID , -- VendorImportID - int
--          i.facilityuid , -- VendorID - int
--          CASE @Timezone
--			WHEN 3 THEN 15
--			WHEN 2 THEN 11
--			WHEN 1 THEN 
--					CASE (SELECT [state] FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID) 
--						WHEN 'AZ' THEN 7
--						WHEN 'CO' THEN 9
--						WHEN 'UT' THEN 9 
--						WHEN 'WY' THEN 9
--					END
--		    WHEN -3 THEN 3
--			WHEN -2 THEN 3
--		  ELSE 5 END  -- TimeZoneID - int 
--FROM dbo.[_import_22_35_Facilities] i
--LEFT JOIN dbo.ServiceLocation sl ON 
--	sl.AddressLine1 = i.address2 AND
--    sl.[State] = i.[state] AND
--    sl.PracticeID = @PracticeID
--WHERE i.display = 1 AND sl.ServiceLocationID IS NULL
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
FROM dbo.[_import_22_35_ReferringProviders] i
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
FROM dbo.[_import_22_35_PatientInfo] i 
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
FROM dbo.[_import_22_35_PatientInfo] i
LEFT JOIN dbo.Employers e ON
	e.EmployerName = i.employer
LEFT JOIN dbo.[_import_22_35_ResponsibleParties] rp ON
	i.responsiblepartyfid = rp.responsiblepartyuid
LEFT JOIN dbo.[_import_22_35_Providers] ip ON
	ip.pgprovideruid = i.providerfid
LEFT JOIN dbo.Doctor d ON 
	ip.firstname = d.FirstName AND 
	ip.lastname = d.lastname AND 
	ip.npinumber = d.NPI AND 
	d.[External] = 0 AND
    d.PracticeID = @PracticeID
LEFT JOIN dbo.ServiceLocation sl ON 
	sl.ServiceLocationID = (SELECT MIN(ServicelocationID) FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID)
WHERE i.firstname <> '' AND NOT EXISTS (SELECT * FROM dbo.Patient p WHERE p.FirstName = i.firstname AND p.LastName = i.lastname AND p.DOB = DATEADD(hh,12,CAST(i.dob AS DATETIME)) AND p.PracticeID = @PracticeID)
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
		  CAST(i.createdate AS DATE) , -- CreatedDate - datetime
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
FROM dbo.[_import_22_35_Note] i
INNER JOIN dbo.Patient p ON
	i.patientfid = p.VendorID AND 
	p.VendorImportID = @VendorImportID
INNER JOIN dbo.[_import_22_35_NoteTypes] n ON 
	i.notetypefid = n.notetypeuid
WHERE i.note <> ''
ORDER BY CAST(i.createdate AS DATE) ASC
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
          insmap.KareoPlanID , -- InsuranceCompanyPlanID - int
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
FROM dbo.[_import_22_35_Coverages] i
INNER JOIN dbo.PatientCase pc ON 
	i.patientfid = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID
INNER JOIN #insmap insmap ON 
	i.carrierfid = insmap.carrieruid 
LEFT JOIN dbo.[_import_22_35_ResponsibleParties] rp ON
	i.responsiblepartysubscriberfid = rp.responsiblepartyuid
LEFT JOIN dbo.Patient p ON
	pc.PatientID = p.PatientID
WHERE i.carrierfid <> '1'  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

UPDATE dbo.PatientCase 
SET Name = 'Self Pay' , PayerScenarioID = 11
FROM dbo.PatientCase pc LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND ip.VendorImportID = @VendorImportID
WHERE ip.PatientCaseID IS NULL AND pc.practiceid = @PracticeID and pc.VendorImportID = @VendorImportID

DROP TABLE #insmap

--ROLLBACK
--COMMIT
