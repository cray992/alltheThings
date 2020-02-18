--USE superbill_50760_dev
USE superbill_50760_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

SET NOCOUNT ON

/*==========================================================================*/
 --FOR DB-13 ONLY -- 
--UPDATE PATIENTS WITH CORRECT DEMOGRAPHIC INFO FROM SUPPORT TOOLS EXPORT--

--CREATE TABLE #updatepat (PatientID INT , DateofBirth DATETIME , SSN VARCHAR(9))
--INSERT INTO #updatepat (PatientID, DateofBirth, SSN) 
--SELECT DISTINCT
--		     REPLACE(REPLACE(p.PatientID,'.00',''),',','') , -- PatientID - int
--			 DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) , -- DateofBirth - 
--			 i.ssn  -- SSN - varchar(9)
--FROM dbo.Patient p 
--INNER JOIN dbo.[_import_4_1_PatientDemographics] i ON p.PatientID = REPLACE(REPLACE(i.id,'.00',''),',','')

--PRINT ''
--PRINT 'Updating Existing Patients Demographics...'
--UPDATE dbo.Patient 
--	SET DOB = i.DateofBirth  ,
--		SSN = i.ssn
--FROM #updatepat i 
--INNER JOIN dbo.Patient p ON
--	REPLACE(REPLACE(p.PatientID,'.00',''),',','') = i.patientid
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--DROP TABLE #updatepat

/*==========================================================================*/

PRINT ''
PRINT 'Inserting Into Doctor...'
INSERT INTO dbo.Doctor
( 
	PracticeID , Prefix, Suffix, FirstName , MiddleName , LastName , ActiveDoctor , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , TaxonomyCode , VendorID , VendorImportID , [External] , NPI 
)
SELECT DISTINCT 
	@PracticeID , -- PracticeID - int
	'', -- Prefix
	'', -- Suffix
	LEFT(RP.dboproviderlistingfirstname,64) , -- FirstName - varchar(64)
	'' , -- MiddleName - varchar(64)
	LEFT(RP.dboproviderlistinglastname,64) , -- LastName - varchar(64)
	1 , -- ActiveDoctor - bit
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	TC.TaxonomyCode , -- TaxonomyCode - char(10)
	RP.providerid , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	0, -- External - bit
	CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.npi)) = 10 THEN dbo.fn_RemoveNonNumericCharacters(RP.npi)
		ELSE NULL END -- NPI - varchar(10)
FROM dbo.[_import_3_1_PatientUpload] AS RP 
	LEFT JOIN dbo.TaxonomyCode AS TC ON TC.TaxonomyCode = RP.taxonomy
	LEFT JOIN dbo.Doctor AS OD ON OD.FirstName = RP.dboproviderlistingfirstname AND OD.LastName = RP.dboproviderlistinglastname AND OD.[External] = 0 AND OD.PracticeID = @PracticeID
WHERE RP.dboproviderlistingfirstname <> '' AND RP.dboproviderlistinglastname <> '' 
	AND OD.DoctorId IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Update Patient - Default Renderring...'
UPDATE dbo.Patient 
	SET PrimaryProviderID = d.DoctorID
FROM dbo.Patient p 
INNER JOIN dbo.[_import_3_1_PatientUpload] i ON 
	p.FirstName = i.dbopatientlistingfirstname AND 
	p.LastName = i.dbopatientlistinglastname AND
	p.DOB = DATEADD(hh,12,CAST(i.dob AS DATETIME))
INNER JOIN dbo.Doctor d ON
	d.VendorID = i.providerid AND
    d.PracticeID = @PracticeID AND
    d.[External] = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

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
	          PAT.PatientID , -- PatientID - int
	          'Kareo' , -- UserName - varchar(128)
	          'K' , -- SoftwareApplicationID - char(1)
	          0 , -- Hidden - bit
	          CASE WHEN PJN.diag1 = '' THEN '' ELSE 'Diag1: ' + PJN.diag1 + CHAR(13) + CHAR(10) END + 
			  CASE WHEN PJN.diag2 = '' THEN '' ELSE 'Diag2: ' + PJN.diag1 + CHAR(13) + CHAR(10) END + 
			  CASE WHEN PJN.diag3 = '' THEN '' ELSE 'Diag3: ' + PJN.diag1 + CHAR(13) + CHAR(10) END + 
			  CASE WHEN PJN.diag4 = '' THEN '' ELSE 'Diag4: ' + PJN.diag1 + CHAR(13) + CHAR(10) END  , -- NoteMessage - varchar(max)
	          0 , -- AccountStatus - bit
	          1 , -- NoteTypeCode - int
	          0  -- LastNote - bit
	FROM dbo.[_import_3_1_PatientUpload] PJN
	INNER JOIN dbo.Patient PAT ON
		PJN.dbopatientlistingfirstname = PAT.FirstName AND
		PJN.dbopatientlistinglastname = PAT.LastName AND
		DATEADD(hh,12,CAST(PJN.dob AS DATETIME)) = PAT.DOB
	WHERE pjn.diag1 <> ''	
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--ROLLBACK
--COMMIT
