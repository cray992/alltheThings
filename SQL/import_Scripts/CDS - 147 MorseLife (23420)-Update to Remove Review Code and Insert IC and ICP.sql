USE superbill_23420_dev
GO

BEGIN TRANSACTION

SET NOCOUNT ON


PRINT ''
PRINT 'Removing Default Referring Physician and Rendering Provider from Patient Records in Practice 1...'
UPDATE dbo.Patient
 SET ReferringPhysicianID = NULL , 
	 PrimaryProviderID = NULL
WHERE PracticeID = 1
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + '  records updated '


PRINT ''
PRINT 'Removing ReviewCode from Insurance Company records within Practice 1 and 2...'
UPDATE dbo.InsuranceCompany
	SET ReviewCode = ''
WHERE CreatedPracticeID IN (1,2)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + '  records updated '


PRINT ''
PRINT 'Removing ReviewCode from Insurance Company Plan records within Practice 1 and 2...'
UPDATE dbo.InsuranceCompanyPlan 
	SET ReviewCode = ''
WHERE CreatedPracticeID IN (1,2)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + '  records updated '


PRINT ''
PRINT 'Inserting into InsuranceCompany for Practice 1 Where Not Exist...'
INSERT INTO dbo.InsuranceCompany 
        ( InsuranceCompanyName ,
          Notes ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Phone ,
          PhoneExt ,
          Fax ,
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
		  imp.name , -- InsuranceCompanyName - varchar(128)
          'Medigap ID/Note: ' + imp.medigapidnote , -- Notes - text
          imp.address1 , -- AddressLine1 - varchar(256)
          imp.address2 , -- AddressLine2 - varchar(256)
          imp.city , -- City - varchar(128)
          imp.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(imp.zipcode) IN (3,7) THEN '00' + imp.zipcode 
			   WHEN LEN(imp.zipcode) IN (4,8) THEN '0' + imp.zipcode
			   WHEN LEN(imp.zipcode) IN (5,9) THEN imp.zipcode ELSE '' END, -- ZipCode - varchar(9)
          imp.phone , -- Phone - varchar(10)
          imp.extension , -- PhoneExt - varchar(10)
          imp.fax , -- Fax - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          1 , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          imp.code + '1' , -- VendorID - varchar(50)
          8 , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18   -- InstitutionalBillingFormID - int
FROM dbo.[_import_7_1_Insurance] imp 
WHERE NOT EXISTS (SELECT * FROM dbo.InsuranceCompany ic WHERE imp.name = ic.InsuranceCompanyName AND --Importing insurance company records where they do not exist based on the name, address, and city 
															  imp.address1 = ic.AddressLine1 AND     -- this is because the VendorID is not unique across Practice 1 and 2
															  imp.address2 = ic.AddressLine2 AND 
															  imp.city = ic.City AND
															  ic.CreatedPracticeID = 1)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan for InsuranceCompanies Inserted into Practice 1...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Phone ,
          PhoneExt ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          Fax ,
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
          Country , -- Country - varchar(32)
          ZipCode , -- ZipCode - varchar(9)
          Phone , -- Phone - varchar(10)
          PhoneExt , -- PhoneExt - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- CreatedPracticeID - int
          Fax , -- Fax - varchar(10)
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          8  -- VendorImportID - int
FROM dbo.InsuranceCompany WHERE VendorImportID = 8
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + '   records inserted '



PRINT ''
PRINT 'Updating Insurance Policy Precedence 1 for Practice 1...'
UPDATE IP 
SET InsuranceCompanyPlanID=icp.InsuranceCompanyPlanID
from InsurancePolicy IP
Inner Join dbo.[_import_7_1_patientdemo] pd on ip.vendorid=pd.chartnumber 
Inner Join InsuranceCompanyPlan ICP on cast(pd.primarycode as varchar)+'1'=icp.vendorId
where precedence=1 and IP.PracticeId=1 and icp.createdpracticeID=1
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + '   records updated '



PRINT ''
PRINT 'Updating Insurance Policy Precedence 2 for Practice 1...'
UPDATE IP 
SET IP.InsuranceCompanyPlanId=icp.InsuranceCompanyPlanId
From InsurancePolicy IP
Inner Join dbo.[_import_7_1_patientdemo] pd on ip.vendorid=pd.chartnumber 
Inner Join InsuranceCompanyPlan ICP on cast(pd.secondarycode as varchar)+'1'=icp.vendorId
where precedence=2 and IP.PracticeId=1 and icp.createdpracticeID=1
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + '   records updated '



PRINT ' '
PRINT 'Updating Insurance Policy Precedence 3 for Practice 1...'
UPDATE IP 
SET IP.InsuranceCompanyPlanId=icp.InsuranceCompanyPlanId
from InsurancePolicy IP
Inner Join dbo.[_import_7_1_patientdemo] pd on ip.vendorid=pd.chartnumber 
Inner Join InsuranceCompanyPlan ICP on cast(pd.TertiaryCode as varchar)+'1'=icp.vendorId
where precedence=3 and IP.PracticeId=1 and icp.createdpracticeID=1
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + '   records updated '




--COMMIT
--ROLLBACK


