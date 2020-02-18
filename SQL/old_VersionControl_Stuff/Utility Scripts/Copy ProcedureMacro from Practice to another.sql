
----------------------------------
-- Addes the VendorID column if it doesn't already exist ----
IF not exists( select Object_Name(id), * from sys.syscolumns where id = Object_ID('ProcedureMacro') and name = 'VendorID' )
	ALTER TABLE ProcedureMacro ADD VendorID varchar(50)

IF not exists( select Object_Name(id), * from sys.syscolumns where id = Object_ID('ProcedureMacro') and name = 'VendorImportID' )
	ALTER TABLE ProcedureMacro ADD VendorImportID INT
GO
----------------------------------



DECLARE 
	@SourcePractice INT,
	@TargetPractice INT,
	@ImportSessionNotes VARCHAR(128)

-- MUST FILL IN THE PARAMETERS USE "NULL" WHEN YOU WANT TO USE THE DEFAULT VALUES -----


SET	@SourcePractice = 28						-- Practice ID of Source	(Mandatory)

SET	@TargetPractice = 49					-- Practice ID of Destination	(Optional)

-- Notes tobe written to the VendorImport table to describe this session.
SET @ImportSessionNotes = 'Case 11537' + 'date: ' + convert( varchar, getdate() ) 


DECLARE 
	@VendorImportID INT


SELECT ProcedureMacroID,
		PracticeID,
		Name,
		Description,
		Active,
		CreatedUserID,
		ModifiedUserID
INTO #InsProcedureMacro
FROM ProcedureMacro
WHERE PracticeID = @SourcePractice

IF @@rowcount = 0
	BEGIN
		RETURN
	END



Begin tran MyTran

Begin Try






	INSERT INTO VendorImport(VendorName, DateCreated, Notes, VendorFormat)
	VALUES('Duplicate Procedure Macro',GETDATE(),@ImportSessionNotes,'KAREO')
	SET @VendorImportID=@@IDENTITY	


	INSERT ProcedureMacro (
		VendorID,
		PracticeID,
		Name,
		Description,
		Active,
		CreatedUserID,
		ModifiedUserID,
		CreatedDate,
		ModifiedDate,
		VendorImportID
		)
	SELECT 
		ProcedureMacroID,
		@TargetPractice,
		Name,
		Description,
		Active,
		CreatedUserID,
		ModifiedUserID,
		getdate(),
		getdate(),
		@VendorImportID		
	FROM #InsProcedureMacro insC




INSERT INTO [ProcedureMacroDetail]
           ([CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID]
           ,[ProcedureCodeDictionaryID]
           ,[ProcedureModifier1]
           ,[ProcedureModifier2]
           ,[ProcedureModifier3]
           ,[ProcedureModifier4]
           ,[Units]
           ,[Charge]
           ,[DiagnosisCodeDictionaryID1]
           ,[DiagnosisCodeDictionaryID2]
           ,[DiagnosisCodeDictionaryID3]
           ,[DiagnosisCodeDictionaryID4]
           ,[ProcedureMacroID])
	SELECT
           Getdate()
           ,pmd.[CreatedUserID]
           , Getdate()
           ,pmd.[ModifiedUserID]
           ,[ProcedureCodeDictionaryID]
           ,[ProcedureModifier1]
           ,[ProcedureModifier2]
           ,[ProcedureModifier3]
           ,[ProcedureModifier4]
           ,[Units]
           ,[Charge]
           ,[DiagnosisCodeDictionaryID1]
           ,[DiagnosisCodeDictionaryID2]
           ,[DiagnosisCodeDictionaryID3]
           ,[DiagnosisCodeDictionaryID4]
           ,pm.ProcedureMacroID
	FROM ProcedureMacroDetail pmd
		INNER JOIN ProcedureMacro pm on pmd.ProcedureMacroID = pm.VendorID
	WHERE pm.VendorImportID = @VendorImportID


	commit Tran MyTran
END TRY

BEGIN CATCH
	PRINT 'rolling back. Error log....'
    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_PROCEDURE() AS ErrorProcedure,
        ERROR_LINE() AS ErrorLine,
        ERROR_MESSAGE() AS ErrorMessage;

	Rollback Tran MyTran
END CATCH



drop table #InsProcedureMacro
go

