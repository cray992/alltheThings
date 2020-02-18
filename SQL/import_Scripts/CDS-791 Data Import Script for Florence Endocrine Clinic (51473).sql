USE superbill_51473_dev
--USE superbill_51473_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

CREATE TABLE #ins (InsName VARCHAR(128))
INSERT INTO #ins
        ( InsName )
SELECT DISTINCT
		  patientprimaryinspkgname  -- InsName - varchar(128)
FROM dbo.[_import_1_1_fulldemoexport3]         
WHERE  patientprimaryinspkgname <> '' AND patientprimaryinspkgname <> 'Self Pay'


INSERT INTO #ins
        ( InsName )
SELECT DISTINCT
		  patientsecondaryinspkgname  -- InsName - varchar(128)
FROM dbo.[_import_1_1_fulldemoexport3] i        
WHERE NOT EXISTS (SELECT * FROM #ins ins WHERE i.patientsecondaryinspkgname = ins.InsName) AND
	  patientsecondaryinspkgname <> '' AND patientsecondaryinspkgname <> 'Self Pay'

INSERT INTO #ins
        ( InsName )
SELECT DISTINCT
		  i.patienttertiaryinspkgname  -- InsName - varchar(128)
FROM dbo.[_import_1_1_fulldemoexport3] i        
WHERE NOT EXISTS (SELECT * FROM #ins ins WHERE i.patienttertiaryinspkgname = ins.InsName) AND
	  patienttertiaryinspkgname <> '' AND patienttertiaryinspkgname <> 'Self Pay'

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
		  InsName ,
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
          LEFT(InsName, 50) ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18 
FROM #ins
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  InsuranceCompanyName,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
FROM dbo.InsuranceCompany 
WHERE Vendorimportid = @VendorImportID AND CreatedPracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT ''


SELECT patientfirstname , patientlastname , patientdob
FROM dbo.[_import_1_1_fulldemoexport3]
GROUP BY patientfirstname , patientlastname , patientdob
HAVING COUNT(*) > 1

DROP TABLE #ins

ROLLBACK