-- Script for cleaning Contract Fee File

USE ImportSpec -- %%%%%%%%%%%%%%%%%   CHANGE DATABASE   %%%%%%%%%%%%%%%%%

SET NOCOUNT OFF

IF OBJECT_ID('tempdb..#Vars') IS NOT NULL
	DROP TABLE [#Vars]

CREATE TABLE #Vars(VarName varchar(50), VarValue varchar(200))

-- %%%%%%%%%%%  SET VARIABLES    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
INSERT INTO #Vars (VarName, VarValue) VALUES ('ContractFeeFile', 'dbo.xx_HCPproc_CSV')
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'xContractFeeSchedule')
	DROP SYNONYM [dbo].[xContractFeeSchedule]
GO
-- =================================================================
DECLARE @ContractFeeFile varchar(50)
SELECT @ContractFeeFile = VarValue FROM #Vars WHERE VarName = 'ContractFeeFile'
--==================================================================
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@ContractFeeFile) and name='OfficialName')
	EXEC ('ALTER TABLE ' + @ContractFeeFile + ' ADD OfficialName varchar(50)')
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@ContractFeeFile) and name='STANDARDFEE')
	EXEC ('ALTER TABLE ' + @ContractFeeFile + ' ADD STANDARDFEE varchar(50)')
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@ContractFeeFile) and name='OfficialDescription')
	EXEC ('ALTER TABLE ' + @ContractFeeFile + ' ADD OfficialDescription varchar(50)')
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@ContractFeeFile) and name='Modifier')
	EXEC ('ALTER TABLE ' + @ContractFeeFile + ' ADD Modifier varchar(50)')
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@ContractFeeFile) and name='Gender')
	EXEC ('ALTER TABLE ' + @ContractFeeFile + ' ADD Gender varchar(50)')
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@ContractFeeFile) and name='RVU')
	EXEC ('ALTER TABLE ' + @ContractFeeFile + ' ADD RVU varchar(50)')
-- ===================
EXEC ('Create Synonym xContractFeeSchedule For ' + @ContractFeeFile)
GO
-- ==================================================================
-- Generic data cleanup

UPDATE xContractFeeSchedule SET ProcedureCode = NULL WHERE ProcedureCode = ''
UPDATE xContractFeeSchedule SET OfficialName = NULL WHERE OfficialName = ''
UPDATE xContractFeeSchedule SET STANDARDFEE = NULL WHERE STANDARDFEE = ''

UPDATE xContractFeeSchedule SET STANDARDFEE = ROUND(STANDARDFEE, 2)

UPDATE xContractFeeSchedule SET OfficialDescription = NULL WHERE OfficialDescription = ''
UPDATE xContractFeeSchedule SET Modifier = NULL WHERE Modifier = ''

UPDATE xContractFeeSchedule SET Gender = 'B' WHERE Gender = '' OR Gender IS NULL
UPDATE xContractFeeSchedule SET RVU = 0 WHERE RVU = '' OR RVU IS NULL

SET NOCOUNT OFF