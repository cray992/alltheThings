USE superbill_28643_dev 
--USE superbill_28643_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN

 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 2 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))
 
 --Clear out any existing records for this import, (makes the script safe to run multiple times)
--PRINT ''
--PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

--DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VEndorImportID = @VendorImportID))
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from AppointmentToAppointmentReason'
--DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted from AppointmentToResource '
--DELETE FROM dbo.AppointmentReason WHERE  DefaultDurationMinutes = 15 AND practiceid = @PracticeID AND DESCRIPTION = Name
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from AppointmentReason'
--DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted from  Appointment '
--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from InsurancePolicy'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Insurance Company Plan'
--DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from Insurance'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientCase'
--DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientJournalNotes'
--DELETE FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Patient'
--DELETE FROM dbo.Doctor WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
--PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Doctor'

 


PRINT ''
PRINT'Inserting records into Primary Insurance Company'

INSERT INTO dbo.InsuranceCompany
        (
    	  InsuranceCompanyName ,
          BillSecondaryInsurance ,
          EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
          ReviewCode ,
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT 
          ip.primaryinsname , -- InsuranceCompanyName - varchar(128)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          '' , -- ReviewCode - char(1)
          @PracticeID , -- CreatedPracticeID - int *****************
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          ip.primaryinsname , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_2_1_Policy] AS ip
WHERE ip.primaryinsname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Primary Insurance Company Successfully'
--61
PRINT ''
PRINT'Inserting records into Secondary Insurance Company'
INSERT INTO dbo.InsuranceCompany
        (
    	  InsuranceCompanyName ,
          BillSecondaryInsurance ,
          EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
          ReviewCode ,
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT
          ip.secondinsname , -- InsuranceCompanyName - varchar(128)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          '' , -- ReviewCode - char(1)
          @PracticeID , -- CreatedPracticeID - int ************
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          ip.secondinsname , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_2_1_Policy] as ip
WHERE ip.secondinsname <> '' AND NOT EXISTS (SELECT * FROM dbo.InsuranceCompany WHERE VendorID = ip.Secondinsname)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Secondary Insurance Company Successfully'
--13
PRINT ''
PRINT'Inserting records into Insurance Company plan'
INSERT INTO dbo.InsuranceCompanyPlan
        ( 
		  PlanName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ReviewCode ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
          InsuranceCompanyName , -- PlanName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '' , -- ReviewCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          InsuranceCompanyID  , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany 
WHERE VendorImportID = @VendorImportID AND CreatedPracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Insurance Company Plan Successfully'
--74
PRINT ''
PRINT 'Inserting into Doctor'
INSERT INTO dbo.Doctor
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          VendorID ,
          VendorImportID ,
          [External] 
        )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pcpfirstname , -- FirstName - varchar(64)
          pcpmiddlename , -- MiddleName - varchar(64)
          pcplastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pcpdegree , -- Degree - varchar(8)
          pcpfirstname + pcplastname , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- External - bit
FROM dbo.[_import_2_1_PatDemo]
WHERE pcpfirstname <> 'Mai-Sie' AND pcpfirstname <> 'SHU WING'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
--107
PRINT ''
PRINT 'Inserting records into patient'
INSERT INTO dbo.Patient
        ( 
		  PracticeID ,
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
         -- WorkPhone ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          DefaultServiceLocationID ,
          MobilePhone ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active 
        )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.patfirstname , -- FirstName - varchar(64)
          pat.patmiddlename , -- MiddleName - varchar(64)
          pat.patlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pat.addr1 , -- AddressLine1 - varchar(256)
          pat.addr2 , -- AddressLine2 - varchar(256)
          pat.city , -- City - varchar(128)
          pat.state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE pat.zip WHEN 'V4N3L4' THEN ''
           ELSE CASE WHEN LEN(pat.zip) = 4 THEN '0' + pat.zip ELSE LEFT(pat.zip, 9) 
		   END  END , -- ZipCode - varchar(9)
          CASE pat.gen WHEN '' THEN 'U'
		    ELSE pat.gen END , -- Gender - varchar(1)
          pat.mar , -- MaritalStatus - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pat.hmphone,' ','')),10) , -- HomePhone - varchar(10)
         -- LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pat.dayphone,' ','')),10) , -- WorkPhone - varchar(10)
          CASE WHEN ISDATE(pat.birthdt) = 1 THEN pat.birthdt END , -- DOB - datetime
          RIGHT('000' + pat.ssn, 9) , -- SSN - char(9)
          pat.emailaddr , -- EmailAddress - varchar(256)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- DefaultServiceLocationID - int    
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pat.cellph,' ','')),10) , -- MobilePhone - varchar(10)
          doc.DoctorID  , -- PrimaryCarePhysicianID - int
          pat.patientfullname , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1  -- Active - bit
FROM dbo.[_import_2_1_PatDemo] pat
LEFT JOIN dbo.Doctor doc ON
	pat.pcpfirstname = doc.firstname AND
	pat.pcplastname = doc.lastname  
WHERE pat.patfirstname <> '' and pat.patlastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
--3042


PRINT' '
PRINT 'Inserting into PatientJournalNote'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientID ,
		  UserName , 
          SoftwareApplicationID ,
          Hidden ,
          NoteMessage 
        )
SELECT    GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pat.PatientID , -- PatientID - int
		  '' , -- UserName
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          CASE WHEN dayphone = '' THEN '' ELSE 'Day Phone: ' + dayphone + CHAR(13) + CHAR(10) END + 
			(CASE WHEN dayphonecomment = '' THEN '' ELSE 'Day Phone Comment: ' + dayphonecomment + CHAR(13) + CHAR(10) END) +
			(CASE WHEN altphone = '' THEN '' ELSE 'Alt Phone: ' + altphone +  CHAR(13) + CHAR(10) END) +
			(CASE WHEN altphonecomment = '' THEN '' ELSE 'Alt Phone COmment: ' + altphonecomment + CHAR(13) + CHAR(10) END)  -- NoteMessage - varchar(max)
FROM dbo._import_2_1_Patdemo
INNER JOIN dbo.Patient pat ON
	pat.VendorID = patientfullname AND
	pat.VendorImportID = @VendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted' 

PRINT ''
PRINT 'Inserting records into PatientCase'
INSERT INTO dbo.PatientCase
        ( 
		  PatientID ,
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
SELECT
          PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via data import, please review' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient
WHERE VendorImportID=@VendorImportID AND PracticeID=@PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted '
--3042
PRINT ''
PRINT 'Inserting records into Appointment'
INSERT INTO dbo.Appointment
        ( 
		  PatientID ,
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
          Notes ,
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
          EndTm 
        )
SELECT DISTINCT
          patcase.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          convert(varchar, startdate ,101) , -- StartDate - datetime
          convert(varchar, enddate ,101) , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          resourcetypeid , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          patcase.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          starttm , -- StartTm - smallint
          endtm  -- EndTm - smallint
FROM [dbo].[_import_2_1_Appointment] AS ia
INNER JOIN dbo.patientcase AS patcase ON
  patcase.vendorID = ia.patname AND
  patcase.VendorImportID = @VendorImportID
INNER JOIN dbo.DateKeyToPractice AS dk ON 
  dk.PracticeID = @PracticeID AND 
  dk.Dt = CAST(CAST(ia.startdate AS date) AS DATETIME)
WHERE ia.startdate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into Appointment Successfully'
--383
PRINT ''
PRINT 'Inserting into AppointmentReason'
INSERT INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
          Description ,
          ModifiedDate 
        )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          Reason , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
          Reason , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo._import_2_1_Appointment
WHERE reason <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
--8
PRINT ''
PRINT 'Inserting into AppointmentToAppointmentReason'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT    app.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.Appointment app
INNER JOIN dbo.Patient pat ON
	app.PatientID = pat.PatientID AND
    pat.VendorImportID = @VendorImportID  
INNER JOIN dbo.[_import_2_1_Appointment] impa ON	
	app.StartDate = impa.startdate AND
    pat.VendorID = impa.patname	  
INNER JOIN dbo.AppointmentReason ar ON
	impa.reason = ar.name
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
--384
PRINT ''
PRINT 'Inserting into AppointmentToResource'
INSERT INTO dbo.AppointmentToResource
	    (   AppointmentID ,
	        AppointmentResourceTypeID ,
	        ResourceID ,
	        ModifiedDate ,
	        PracticeID
	    )
SELECT     app.AppointmentID , -- AppointmentID - int
	        1 , -- AppointmentResourceTypeID - int
	        resourceid , -- ResourceID - int
	        GETDATE() , -- ModifiedDate - datetime
	        @PracticeID  -- PracticeID - int
FROM dbo.Appointment app
INNER JOIN dbo.Patient pat ON 
	pat.PatientID = app.PatientID AND
	pat.VendorImportID = @VendorImportID  
INNER JOIN dbo._import_2_1_Appointment impa ON
	app.StartDate = impa.startdate AND
    pat.VendorID = impa.patname  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
--384
PRINT''
PRINT 'Insert records into Insurance policy Primary'        
INSERT INTO dbo.InsurancePolicy
        ( 
		  PatientCaseID ,
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
		  GroupName
        )
SELECT DISTINCT
          patCase.PatientCaseID , -- PatientCaseID - int
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          ip.primarypol , -- PolicyNumber - varchar(32)
          ip.primaryinsgrp , -- GroupNumber - varchar(32)
          GETDATE() , -- PolicyStartDate - datetime
          CASE ip.primaryinssubscrrelationship WHEN '' THEN 'S' 
		    ELSE ip.primaryinssubscrrelationship 
		   END, -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN ip.primaryinssubscrrelationship = 'S' THEN '' 
				WHEN ip.primaryinssubscrrelationship = '' THEN ''ELSE ip.primaryinssubfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN ip.primaryinssubscrrelationship = 'S' THEN '' 
				WHEN ip.primaryinssubscrrelationship = '' THEN '' ELSE ip.primaryinssubmiddlename END ,  -- HolderMiddleName - varchar(64)
          CASE WHEN ip.primaryinssubscrrelationship = 'S' THEN '' 
				WHEN ip.primaryinssubscrrelationship = '' THEN '' ELSE ip.primaryinssublastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          ip.pernbr+'1' , -- VendorID - varchar(50)
          @VendorImportID ,  -- VendorImportID - int
		  ip.primaryinsgrpname  -- GROUPName
FROM [dbo].[_import_2_1_Policy] AS ip 
INNER JOIN dbo.PatientCase AS patCase ON 
    patCase.VendorID = ip.name AND
	patCase.PracticeID = @PracticeID
INNER JOIN dbo.InsuranceCompanyPlan AS inscoplan ON
    inscoplan.VendorID = ip.primaryinsname AND
	inscoplan.VendorImportID = @VendorImportID 
WHERE ip.primaryinsname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted Successfully'
--1883
PRINT''
PRINT 'Insert records into Insurance policy Secondary'        
INSERT INTO dbo.InsurancePolicy
        ( 
		  PatientCaseID ,
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
		  GroupName
        )
SELECT DISTINCT
          patCase.PatientCaseID , -- PatientCaseID - int
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          ip.secondpol , -- PolicyNumber - varchar(32)
          ip.secondinsgrp , -- GroupNumber - varchar(32)
          GETDATE() , -- PolicyStartDate - datetime
          CASE ip.secondinssubscrrelationship WHEN '' THEN 'S' 
		    ELSE ip.secondinssubscrrelationship 
		   END, -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN ip.secondinssubscrrelationship <> 'S' THEN '' 
				WHEN ip.secondinssubscrrelationship <> '' THEN '' ELSE ip.secondinssubfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN ip.secondinssubscrrelationship <> 'S' THEN '' 
				WHEN ip.secondinssubscrrelationship <> '' THEN '' ELSE ip.secondinssubmiddlename END ,  -- HolderMiddleName - varchar(64)
          CASE WHEN ip.secondinssubscrrelationship <> 'S' THEN '' 
				WHEN ip.secondinssubscrrelationship <> '' THEN '' ELSE ip.secondinssublastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          ip.pernbr+'2' , -- VendorID - varchar(50)
          @VendorImportID ,  -- VendorImportID - int
		  ip.secondinsgrpname  -- GROUPName
FROM [dbo].[_import_2_1_Policy] AS ip 
INNER JOIN dbo.PatientCase AS patCase ON 
    patCase.VendorID = ip.name AND
	patCase.PracticeID = @PracticeID
INNER JOIN dbo.InsuranceCompanyPlan AS inscoplan ON
    inscoplan.VendorID = ip.secondinsname AND
	inscoplan.VendorImportID = @VendorImportID 
WHERE ip.secondinsname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted Successfully'
--526
PRINT ''
PRINT 'Updating Patient Cases that do not have policies...'
UPDATE dbo.PatientCase 
      SET PayerScenarioID = 11 ,
		  Name = 'Self Pay'
      FROM dbo.PatientCase pc
      LEFT JOIN dbo.InsurancePolicy ip ON
            pc.PatientCaseID = ip.PatientCaseID  
      WHERE pc.VendorImportID = @VendorImportID AND
              ip.PatientCaseID IS NULL AND
			  pc.PayerScenarioID = 5
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'
--1159

--COMMIT
--ROLLBACk