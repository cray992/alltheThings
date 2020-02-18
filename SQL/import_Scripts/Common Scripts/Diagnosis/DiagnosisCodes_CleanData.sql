-- Script for cleaning DiagnosisCode File

USE superbill_0848_dev -- %%%%%%%%%%%%%%%%%   CHANGE DATABASE   %%%%%%%%%%%%%%%%%

SET NOCOUNT OFF

IF OBJECT_ID('tempdb..#Vars') IS NOT NULL
	DROP TABLE [#Vars]

CREATE TABLE #Vars(VarName varchar(50), VarValue varchar(200))

-- %%%%%%%%%%%  SET VARIABLES    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
INSERT INTO #Vars (VarName, VarValue) VALUES ('DiagnosisCodeFile', 'dbo.xC_diagnosis_txt')
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'xDiagnosisCodeDictionary')
	DROP SYNONYM [dbo].[xDiagnosisCodeDictionary]
GO
-- =================================================================
DECLARE @DiagnosisFile varchar(50)
SELECT @DiagnosisFile = VarValue FROM #Vars WHERE VarName = 'DiagnosisCodeFile'
--==================================================================
--IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@DiagnosisFile) and name='OfficialName')
--	EXEC ('ALTER TABLE ' + @DiagnosisFile + ' ADD OfficialName varchar(50)')

-- ===================
EXEC ('Create Synonym xDiagnosisCodeDictionary For ' + @DiagnosisFile)
GO
-- ==================================================================
-- Generic data cleanup

UPDATE xDiagnosisCodeDictionary SET DiagnosisCode = NULL WHERE DiagnosisCode = ''
UPDATE xDiagnosisCodeDictionary SET OfficialName = NULL WHERE OfficialName = ''


SET NOCOUNT OFF