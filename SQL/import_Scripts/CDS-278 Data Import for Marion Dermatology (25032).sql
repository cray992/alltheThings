USE superbill_25032_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1


--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
--DELETE from dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
--DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
--DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
--DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'

PRINT ''
PRINT 'Inserting Into Referring Providers...'
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
          WorkPhone ,
          WorkPhoneExt ,
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
          firstname , -- FirstName - varchar(64)
          '' , -- MiddleName - varchar(64)
          lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          address1 , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          [state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          REPLACE(zipcode,'-','') , -- ZipCode - varchar(9)
          officephone , -- WorkPhone - varchar(10)
          officeextension , -- WorkPhoneExt - varchar(10)
          CASE WHEN practicename = '' THEN '' ELSE 'Practice Name: ' + practicename + CHAR(13)+CHAR(10) END + 
		 (CASE WHEN licensenumber = '' THEN '' ELSE 'License Number: ' + licensenumber  END) , -- Notes - text
          active , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          title , -- Degree - varchar(8)
          referringprovideruid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          fax , -- FaxNumber - varchar(10)
          1 , -- External - bit
          npinumber  -- NPI - varchar(10)
FROM dbo.[_import_2_1_ReferringProviders]
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          ContactPrefix ,
          ContactFirstName ,
          ContactSuffix ,
          Phone ,
          PhoneExt ,
          Fax ,
		  FaxExt ,
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
		  carriername , -- InsuranceCompanyName - varchar(128)
          address1 , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          LEFT([state],2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          zipcode , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          contactname , -- ContactFirstName - varchar(64)
          '' , -- ContactSuffix - varchar(16)
          eligibilityphonenumber , -- Phone - varchar(10)
          eligibilityphoneextension , -- PhoneExt - varchar(10)
          LEFT(faxnumber, 10) , -- Fax - varchar(10)
		  CASE WHEN LEN(faxnumber) > 10 THEN LEFT(SUBSTRING(faxnumber,11,LEN(faxnumber)),10) ELSE NULL END , -- FaxExt
          13 , -- BillingFormID - int
          'CI', -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          carrieruid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_2_1_Carriers] 
WHERE carriername <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



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
          ContactSuffix ,
          Phone ,
          PhoneExt ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          Fax ,
          FaxExt ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  InsuranceCompanyName , -- PlanName - varchar(128)
          AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          [State] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          ZipCode , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          ContactFirstName , -- ContactFirstName - varchar(64)
          '' , -- ContactSuffix - varchar(16)
          Phone , -- Phone - varchar(10)
          PhoneExt , -- PhoneExt - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          Fax , -- Fax - varchar(10)
          FaxExt, -- FaxExt - varchar(10)
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany 
WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


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
          MedicalRecordNumber ,
          MobilePhone ,
		  MobilePhoneExt ,
          VendorID ,
          VendorImportID ,
          Active ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
		    @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          imp.firstname , -- FirstName - varchar(64)
          imp.middlename , -- MiddleName - varchar(64)
          imp.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          imp.address1, -- AddressLine1 - varchar(256)
          imp.address2 , -- AddressLine2 - varchar(256)
          imp.city , -- City - varchar(128)
          imp.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(imp.zipcode) IN (4,8) THEN '0' + imp.zipcode
			   WHEN LEN(imp.zipcode) IN (5,9) THEN imp.zipcode ELSE NULL END  , -- ZipCode - varchar(9)
          imp.gender , -- Gender - varchar(1)
          CASE maritalstatus WHEN 1 THEN 'S'
							 WHEN 2 THEN 'M'
							 WHEN 3 THEN 'D'
							 WHEN 4 THEN 'L'
							 WHEN 5 THEN 'W'
							 ELSE '' END
							  , -- MaritalStatus - varchar(1)
          imp.homephone , -- HomePhone - varchar(10)
          imp.officephone, -- WorkPhone - varchar(10)
          imp.officeextension , -- WorkPhoneExt - varchar(10)
          imp.dob , -- DOB - datetime
          CASE WHEN LEN(imp.SSN) >= 6 then RIGHT('000' + imp.ssn,9) ELSE NULL END , -- SSN - char(9)
          imp.email , -- EmailAddress - varchar(256)
          CASE WHEN imp.relationship <> 1 THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          CASE WHEN imp.relationship <> 1 THEN '' END , -- ResponsiblePrefix - varchar(16)
          CASE WHEN imp.relationship <> 1 THEN r.firstname END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN imp.relationship <> 1 THEN r.middlename END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN imp.relationship <> 1 THEN r.lastname END , -- ResponsibleLastName - varchar(64)
          CASE WHEN imp.relationship <> 1 THEN '' END, -- ResponsibleSuffix - varchar(16)
          CASE imp.relationship WHEN 2 THEN 'U'
								WHEN 3 THEN 'C'
								WHEN 4 THEN 'O'
								ELSE 'O' END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN imp.relationship <> 1 THEN r.address1 END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN imp.relationship <> 1 THEN r.address2 END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN imp.relationship <> 1 THEN r.city END , -- ResponsibleCity - varchar(128)
          CASE WHEN imp.relationship <> 1 THEN r.[state] END , -- ResponsibleState - varchar(2)
          CASE WHEN imp.relationship <> 1 THEN '' END , -- ResponsibleCountry - varchar(32)
          CASE WHEN imp.relationship <> 1 THEN 
		  CASE WHEN LEN(imp.zipcode) IN (4,8) THEN '0' + r.zipcode
			   WHEN LEN(imp.zipcode) IN (5,9) THEN r.zipcode ELSE NULL END END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          2 , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int
          imp.chartnumber , -- MedicalRecordNumber - varchar(128)
          LEFT(imp.mobile, 10) , -- MobilePhone - varchar(10)
		  CASE WHEN LEN(imp.mobile) > 10 THEN LEFT(SUBSTRING(imp.mobile,11,LEN(imp.mobile)),10) ELSE NULL END , --MobilePhoneExt
          imp.patientuid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          imp.active , -- Active - bit
          0  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_2_1_PatientInfo] imp
	LEFT JOIN dbo.[_import_2_1_ResponsibleParties] r ON
	r.responsiblepartyuid = imp.responsiblepartyfid
WHERE imp.firstname <> '' AND imp.lastname <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


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
FROM dbo.Patient 
WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


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
		  GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          p.PatientID , -- PatientID - int
          'Kareo' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          i.note , -- NoteMessage - varchar(max)
          0 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_2_1_Note] i
INNER JOIN dbo.Patient p ON 
	p.VendorID =  i.patientfid AND
	p.VendorImportID = @VendorImportID
WHERE i.note <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



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
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
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
          DependentPolicyNumber ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          sequencenumber , -- Precedence - int
          i.subscriberidnumber , -- PolicyNumber - varchar(32)
          i.groupnumber , -- GroupNumber - varchar(32)
          CASE WHEN i.effectivestartdate <> '' THEN i.effectivestartdate ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN i.effectiveenddate <> '' THEN i.effectiveenddate ELSE NULL END , -- PolicyEndDate - datetime
          CASE i.relationshippatienttosubscriber WHEN 1 THEN 'S'
												 WHEN 2 THEN 'U'
												 WHEN 3 THEN 'C'
												 WHEN 4 THEN 'O'
											     ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.relationshippatienttosubscriber <> 1 THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.relationshippatienttosubscriber <> 1 THEN r.firstname END , -- HolderFirstName - varchar(64)
          CASE WHEN i.relationshippatienttosubscriber <> 1 THEN r.middlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.relationshippatienttosubscriber <> 1 THEN r.lastname END , -- HolderLastName - varchar(64)
          CASE WHEN i.relationshippatienttosubscriber <> 1 THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN i.relationshippatienttosubscriber <> 1 THEN r.dob END , -- HolderDOB - datetime
          CASE WHEN i.relationshippatienttosubscriber <> 1 THEN 
		  CASE WHEN LEN(r.ssn) >= 6 then RIGHT('000' + r.ssn,9) ELSE NULL END END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.relationshippatienttosubscriber <> 1 THEN r.gender END , -- HolderGender - char(1)
          CASE WHEN i.relationshippatienttosubscriber <> 1 THEN r.address1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.relationshippatienttosubscriber <> 1 THEN r.address2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.relationshippatienttosubscriber <> 1 THEN r.city END , -- HolderCity - varchar(128)
          CASE WHEN i.relationshippatienttosubscriber <> 1 THEN r.[state] END , -- HolderState - varchar(2)
          CASE WHEN i.relationshippatienttosubscriber <> 1 THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN i.relationshippatienttosubscriber <> 1 THEN 
		  CASE WHEN LEN(r.zipcode) IN (5,9) THEN r.zipcode 
			   WHEN LEN(r.zipcode) IN (4,8) THEN '0' + r.zipcode END END , -- HolderZipCode - varchar(9)
          CASE WHEN i.relationshippatienttosubscriber <> 1 THEN i.subscriberidnumber END , -- DependentPolicyNumber - varchar(32)
          i.copaydollaramount , -- Copay - money
          i.active , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(i.groupname, 14)  -- GroupName - varchar(14)
FROM dbo.[_import_2_1_Coverages] i
	INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = i.patientfid AND 
	pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorID = i.carrierfid AND
	icp.VendorImportID = @VendorImportID
	LEFT JOIN dbo.[_import_2_1_ResponsibleParties] r ON
	r.responsiblepartyuid = i.responsiblepartysubscriberfid
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
		  AppointmentResourceTypeID ,
          AppointmentConfirmationStatusCode ,
          PatientCaseID ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm ,
		  Notes
        )
SELECT DISTINCT
		  pat.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          imp.startdateest , -- StartDate - datetime
          imp.enddateest , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          imp.starttmest , -- StartTm - smallint
          imp.endtmest , -- EndTm - smallint
		  comments  --Notes - text
FROM dbo.[_import_2_1_Appointments] imp
INNER JOIN dbo.Patient pat ON 
	pat.VendorID = imp.patientfid AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = pat.VendorID AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice dk ON
	dk.PracticeID = @PracticeID AND
	dk.Dt = CAST(CAST(imp.startdateest AS DATE) AS DATETIME)   
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Appointment to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  app.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          2 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_1_appointments] AS imp
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = imp.patientfid AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment AS app ON
	app.PatientID = pat.PatientID AND
	app.StartDate = imp.startdateest
WHERE app.CreatedDate > DATEADD(mi,-2,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Updating Patient Cases to Self Pay Not Linked to Policies...'
UPDATE dbo.PatientCase 
      SET PayerScenarioID = 11 ,
		  Name = 'Self Pay' 
      FROM dbo.PatientCase pc
      LEFT JOIN dbo.InsurancePolicy ip ON
            pc.PatientCaseID = ip.PatientCaseID  
      WHERE pc.VendorImportID = @VendorImportID AND
              PayerScenarioID = 5 AND 
              ip.PatientCaseID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--ROLLBACK
--COMMIT


