-- add new field to the procedure macro
alter table ProcedureMacro add DoctorID int null
GO

-- add foreign key on ProcedureMacro to Doctor
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProcedureMacro_Doctor]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProcedureMacro]'))
ALTER TABLE [dbo].[ProcedureMacro]  WITH CHECK ADD  CONSTRAINT [FK_ProcedureMacro_Doctor] FOREIGN KEY([DoctorID])
REFERENCES [dbo].[Doctor] ([DoctorID])
GO


---------------------------
-- UPDATE STORED PROCEDURES
---------------------------

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Handheld_ProcedureDataProvider_GetProcedureMacros'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.Handheld_ProcedureDataProvider_GetProcedureMacros
GO


CREATE PROCEDURE dbo.Handheld_ProcedureDataProvider_GetProcedureMacros
	@doctorId INT
AS
BEGIN
	DECLARE @practiceId int
	SELECT @practiceId=PracticeID from Doctor where DoctorID=@doctorId

	SELECT	
		ProcedureMacroID,
		[Name], 
		[Description]
	FROM ProcedureMacro
	WHERE (DoctorID=@doctorID or DoctorID is null) and Active=1 and PracticeId=@practiceId
	ORDER BY [Name]
END
GO


IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Handheld_ProcedureDataProvider_GetProcedureMacroDetails'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.Handheld_ProcedureDataProvider_GetProcedureMacroDetails
GO


CREATE PROCEDURE dbo.Handheld_ProcedureDataProvider_GetProcedureMacroDetails
	@doctorID INT
AS
BEGIN
	DECLARE @practiceId int
	SELECT @practiceId=PracticeID from Doctor where DoctorID=@doctorId

	SELECT
		ProcedureMacroDetailID,	
		ProcedureMacroID,
		PMD.ProcedureCodeDictionaryID,
		ProcedureModifier1,
		ProcedureModifier2,
		ProcedureModifier3,
		ProcedureModifier4,
		Units, 
		Charge,
		DiagnosisCodeDictionaryID1,
		DiagnosisCodeDictionaryID2,
		DiagnosisCodeDictionaryID3,
		DiagnosisCodeDictionaryID4,

		EDIServiceNoteReferenceCode,
		EDIServiceNote,
		PMD.TypeOfServiceCode,

		PCD.ProcedureCode,
		ISNULL(PCD.LocalName, PCD.OfficialName) as ProcedureName,
		DCD1.DiagnosisCode as DiagnosisCode1,
		DCD2.DiagnosisCode as DiagnosisCode2,
		DCD3.DiagnosisCode as DiagnosisCode3,
		DCD4.DiagnosisCode as DiagnosisCode4,
		ISNULL(DCD1.LocalName, DCD1.OfficialName) as DiagnosisName1,
		ISNULL(DCD2.LocalName, DCD2.OfficialName) as DiagnosisName2,
		ISNULL(DCD3.LocalName, DCD3.OfficialName) as DiagnosisName3,
		ISNULL(DCD4.LocalName, DCD4.OfficialName) as DiagnosisName4

	FROM	ProcedureMacroDetail PMD 
	inner join ProcedureCodeDictionary PCD on PCD.ProcedureCodeDictionaryID=PMD.ProcedureCodeDictionaryID
	left join DiagnosisCodeDictionary DCD1 on DCD1.DiagnosisCodeDictionaryID=PMD.DiagnosisCodeDictionaryID1
	left join DiagnosisCodeDictionary DCD2 on DCD2.DiagnosisCodeDictionaryID=DiagnosisCodeDictionaryID2
	left join DiagnosisCodeDictionary DCD3 on DCD3.DiagnosisCodeDictionaryID=DiagnosisCodeDictionaryID3
	left join DiagnosisCodeDictionary DCD4 on DCD4.DiagnosisCodeDictionaryID=DiagnosisCodeDictionaryID4
	WHERE	PCD.ProcedureCodeDictionaryID=PMD.ProcedureCodeDictionaryID and
			ProcedureMacroID in (select ProcedureMacroID from ProcedureMacro where (DoctorID=@doctorID or DoctorID is null) and Active=1 and PracticeId=@practiceId)
END
GO
