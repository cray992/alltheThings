USE superbill_28908_dev
--USE superbill_XXX_prod
GO

SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 4 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


PRINT ''
PRINT 'Inserting Into Patient Journal Note...'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientID ,
          SoftwareApplicationID ,
          Hidden ,
          NoteMessage ,
          AccountStatus ,
          LastNote ,
		  UserName
        )
SELECT DISTINCT
	      GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          p.PatientID , -- PatientID - int
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          'LegacyID: '  + i.legacyid , -- NoteMessage - varchar(max)
          1 , -- AccountStatus - bit
          NULL , -- LastNote - bit
		  ''
FROM dbo.[_import_4_1_WiseCountyPatientID] i
INNER JOIN dbo.Patient p ON
p.FirstName = i.firstname AND 
p.LastName = i.lastname AND
DATEPART(MONTH,p.DOB) =  DATEPART(MONTH,CAST(i.birthdate AS DATETIME)) AND
DATEPART(DAY,p.DOB) = DATEPART(DAY,CAST(i.birthdate AS DATETIME))  AND
p.VendorImportID = 3 
WHERE p.MedicalRecordNumber <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted'
--16597


PRINT ''
PRINT 'Updating Patient MRN...'
UPDATE dbo.Patient 
SET MedicalRecordNumber = i.legacyid
FROM dbo.Patient p
INNER JOIN dbo.[_import_4_1_WiseCountyPatientID] i ON
p.FirstName = i.firstname AND 
p.LastName = i.lastname AND
p.VendorImportID = 3 AND
DATEPART(MONTH,p.DOB) =  DATEPART(MONTH,CAST(i.birthdate AS DATETIME)) AND
DATEPART(DAY,p.DOB) = DATEPART(DAY,CAST(i.birthdate AS DATETIME)) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records updated'
--16589


--ROLLBACK
--COMMIT


SELECT firstname , lastname , dob , medicalrecordnumber FROM dbo.Patient WHERE VendorImportID = 3
ORDER BY LastName
