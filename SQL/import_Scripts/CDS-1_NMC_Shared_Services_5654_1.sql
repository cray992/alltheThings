USE superbill_5654_dev
--USE superbill_5654_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 2 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))



DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Patient records deleted '




PRINT''
PRINT'Inserting into Patient ...'
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
          ZipCode ,
          Gender ,
          MaritalStatus ,
          HomePhone ,
          MobilePhone ,
          DOB ,
          SSN ,
          ResponsibleDifferentThanPatient ,
          ResponsibleFirstName , 
          ResponsibleLastName ,
          ResponsibleAddressLine1 ,
          ResponsibleAddressLine2 ,
          ResponsibleCity ,
          ResponsibleState ,
          ResponsibleZipCode ,
          ResponsibleRelationshipToPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          SendEmailCorrespondence ,
          VendorID ,
          VendorImportID ,
          Active ,
          PhonecallRemindersEnabled 
        )  
SELECT    @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.ptfirstnm , -- FirstName - varchar(64)
          pat.ptmi , -- MiddleName - varchar(64)
          pat.ptlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pat.pataddress1 , -- AddressLine1 - varchar(256)
          pat.pataddress2 , -- AddressLine2 - varchar(256)
          pat.patcity , -- City - varchar(128)
          pat.ptst , -- State - varchar(2)
          CASE WHEN LEN(pat.ptzip) < 5 THEN  '0' + CAST(pat.ptzip AS VARCHAR)
                ELSE LEFT(replace(pat.ptzip, '-', ''), 9) END , -- ZipCode - varchar(9)
          pat.ptsex , -- Gender - varchar(1)
          CASE WHEN  pat.ptmarital = 'Single' THEN 'S'
			   WHEN  pat.ptmarital = 'Married' THEN 'M'
			   WHEN  pat.ptmarital = 'Divorced' THEN 'D'
			   WHEN  pat.ptmarital = 'Widowed' THEN 'W'
			   WHEN  pat.ptmarital = 'Separated' THEN 'L'
			   WHEN  pat.ptmarital = 'Cohabitate' THEN 'S'
			   WHEN  pat.ptmarital = 'Other' THEN '' END ,
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.patphone, ' ', ''), '(', ''), '(', ''), '-', ''), 10), -- HomePhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.ptcellphone, ' ', ''), '(', ''), '(', ''), '-', ''), 10) , -- cellPhone - varchar(10)
          CASE WHEN ISDATE(pat.ptdob) > 0 THEN pat.ptdob END , -- DOB - datetime
          LEFT(REPLACE(pat.ptssn, '-', ''), 9) , -- SSN - char(9)
          CASE WHEN pat.ptreltogr = 'self' THEN 0
				ELSE 1 END ,
          CASE WHEN pat.ptreltogr = 'self' THEN ''
				ELSE pat.grfirstnm END  ,
          CASE WHEN pat.ptreltogr = 'self' THEN ''
				ELSE pat.grlastname END  ,
          CASE WHEN pat.ptreltogr = 'self' THEN ''
				ELSE pat.guaraddress1 END  ,
          CASE WHEN pat.ptreltogr = 'self' THEN ''
				ELSE pat.guaraddress2 END  ,
          CASE WHEN pat.ptreltogr = 'self' THEN ''
				ELSE pat.guarcity END  ,
          CASE WHEN pat.ptreltogr = 'self' THEN ''
				ELSE pat.grst END  ,
          CASE WHEN pat.ptreltogr = 'self' THEN ''
				ELSE pat.grzip END  ,
          CASE WHEN pat.ptreltogr = 'self' THEN 'S' 
			   WHEN pat.ptreltogr = 'Child' THEN 'C'
			   WHEN pat.ptreltogr = 'Spouse' THEN 'U'
			   WHEN pat.ptreltogr = 'Other' THEN 'O'
			   WHEN pat.ptreltogr = 'Employee' THEN 'O' END  ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          0 ,
          AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          1  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_2_1_Patient] pat

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



COMMIT TRAN