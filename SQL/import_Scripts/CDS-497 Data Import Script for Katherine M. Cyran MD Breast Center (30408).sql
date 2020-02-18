USE superbill_30408_dev 
--USE superbill_30408_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 2 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Inserting records into Insurance Company'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,   
          Country ,
          ZipCode ,  
          BillSecondaryInsurance ,
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
          inc.payername , -- InsuranceCompanyName - varchar(128)
          inc.addressline1 , -- AddressLine1 - varchar(256)
          inc.addressline2 , -- AddressLine2 - varchar(256)
          inc.city , -- City - varchar(128)
          CASE WHEN  inc.state = 'NULL' THEN '' 
		             ELSE inc.state END, -- State - varchar(2) 				 
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(inc.zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(inc.zip)  
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(inc.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(inc.zip)
			   ELSE '' END ,  -- ZipCode - varchar(9)  
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
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
          inc.payerid,-- VendorID - varchar(50)  
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM [dbo].[_import_2_1_Insurances] as inc 
WHERE NOT EXISTS (SELECT * FROM dbo.InsuranceCompanyPlan icp 
				  INNER JOIN dbo.[_import_2_1_Policy] ip ON
					ip.payerid = icp.VendorID
				  WHERE inc.payerid = icp.VendorID) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Insurance Company'

PRINT ''
PRINT 'Inserting records into InsuranceCompanyPlan'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
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
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT  DISTINCT
          ic.InsuranceCompanyName , -- PlanName - varchar(128)
          ic.AddressLine1 , -- AddressLine1 - varchar(256)
          ic.AddressLine2 , -- AddressLine2 - varchar(256)
          ic.City , -- City - varchar(128)
          ic.State , -- State - varchar(2)
          '' , -- Country - varchar(32)
          ic.zipcode , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          ic.vendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int6
FROM dbo.InsuranceCompany as ic
WHERE VendorImportID=@VendorImportID AND CreatedPracticeID=@PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Insurance Company plan'

PRINT ''
PRINT 'Inserting Into Referring Provider...'
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
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          VendorID ,
          VendorImportID ,
          [External] ,
          NPI 
        )
SELECT DISTINCT
		  @PracticeID ,
          '' ,
          i.FirstName ,
          i.MiddleName ,
          i.LastName ,
          '' ,
          refaddress1 ,
          refaddress2 ,
          refcity ,
          refstate ,
          '' ,
          refzip ,
          refphone ,
          1 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          i.Degree ,
          refname ,
          @VendorImportID ,
          1 ,
          refnpi 
FROM dbo.[_import_2_1_ReferringProvider] i
WHERE NOT EXISTS (SELECT * FROM dbo.Doctor d WHERE i.refname = d.VendorID AND d.[External] = 1)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient ReferringPhysicianID...'
UPDATE dbo.Patient 
SET ReferringPhysicianID = d.DoctorID 
FROM dbo.Patient p
INNER JOIN dbo.[_import_2_1_PatDemo] i ON
	p.FirstName = i.ptfirst AND
	p.LastName = i.ptlast AND
	p.DOB = DATEADD(hh,12,CAST(i.ptdob AS DATETIME))
INNER JOIN dbo.Doctor d ON
	i.refname = d.VendorID AND
	d.VendorImportID IN (1,2)
WHERE p.ReferringPhysicianID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Patient Guarantor...'
UPDATE dbo.Patient
SET ResponsibleDifferentThanPatient = 1 ,
	ResponsibleRelationshipToPatient = 'O' ,
	ResponsibleFirstName = i.guarantorfirst ,
	ResponsibleMiddleName = i.guarantormiddle ,
	ResponsibleLastName = i.guarantorlast 
FROM dbo.Patient p
INNER JOIN dbo.[_import_2_1_PatDemo] i ON
	p.FirstName = i.ptfirst AND
	p.LastName = i.ptlast AND
	p.DOB = DATEADD(hh,12,CAST(i.ptdob AS DATETIME))
WHERE i.guarantorfirst <> '' AND
	  i.guarantorfirst <> p.FirstName AND
	  p.ResponsibleDifferentThanPatient = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting into PatientCase'
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
         'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via data import, please review' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          pc.ptfirst+pc.ptlast+pc.ptdob , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM [dbo].[_import_2_1_Policy] as pc
INNER JOIN dbo.patient as pat ON 
    pat.firstname = pc.ptfirst AND
	pat.lastname = pc.ptlast AND
	pat.dob = DATEADD(hh,12,CAST(pc.ptdob AS DATETIME))
LEFT JOIN dbo.InsurancePolicy ip ON
	ip.VendorID = pc.policynbr AND
	ip.VendorImportID = 1
WHERE ip.VendorID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted into patientcase'

PRINT ''
PRINT'Inserting records into InsurancePolicy'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
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
          patcase.PatientCaseID , -- PatientCaseID - int
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          pc.precedence , -- Precedence - int
          pc.Policynbr , -- PolicyNumber - varchar(32)
          pc.Groupnbr , -- GroupNumber - varchar(32)
         'S' , -- PatientRelationshipToInsured - varchar(1) 
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.Policynbr, -- VendorID - varchar(50)  
          @VendorImportID , -- VendorImportID - int
          left(pc.groupname,14)  -- GroupName - varchar(14)
FROM dbo.[_import_2_1_Policy] as pc
INNER JOIN dbo.PatientCase AS patcase ON
        patCase.vendorID = pc.ptfirst+pc.ptlast+pc.ptdob  AND
        patcase.VendorImportID = @VendorImportID
INNER JOIN dbo.insurancecompanyplan as inscoplan ON
        inscoplan.VendorID = pc.payerID AND 
		inscoplan.VendorImportID IN (1,2)
WHERE pc.Policynbr <> '' AND NOT EXISTS (SELECT * FROM dbo.InsurancePolicy ip
										 WHERE ip.PolicyNumber = pc.policynbr AND ip.VendorImportID = 1)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted Insurance Policy'



--COMMIT
--ROLLBACK


