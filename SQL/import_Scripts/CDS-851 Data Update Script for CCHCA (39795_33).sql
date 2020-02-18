USE superbill_39795_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 


UPDATE dbo.Patient
	SET Active = 0 ,
		DOB = '1901-01-01 12:00:00.000' , 
		LastName = 'z(Duplicate)' + i.lastname ,
		ModifiedDate = GETDATE() , 
		ModifiedUserID = 0
FROM dbo.Patient p WITH (NOLOCK)
INNER JOIN dbo._import_71_33_UpdatePatDemo i ON
p.PatientID = i.id 
WHERE p.PracticeID = 33
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient Records Updated...'

--ROLLBACK
--COMMIT


