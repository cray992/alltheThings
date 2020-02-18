/*

	The purpose of this script is to non-destructively pivot some badly shaped import tables for contracts and fee schedules
	
	This script created temp tables that are normalized and pivoted in the correct direction so you can join them together and use them during an import
	
	You'll still have to use good where clauses since for many practices not all A-Z insurances will have fees

*/


USE superbill_11729_dev
--USE superbill_11729_prod
GO

DECLARE @Debug BIT
SET @Debug = 1

--  +------------------------------------------------------------------------+
--  |    CREATE SOME TEMP TABLES FOR HOLDING CONTRACTS AND FEE SCHEDULES     |
--  |             WILL USE THESE AS SOURCE DATA DURING IMPORT                |
--  +------------------------------------------------------------------------+

-- TEMP CONTRACT TABLE
IF OBJECT_ID('tempdb..#TempInsuranceContracts') IS NOT NULL DROP TABLE #TempInsuranceContracts
CREATE TABLE #TempInsuranceContracts
(
	InsuranceCode CHAR(1), 
	ContractName VARCHAR(100)
)

-- TEMP STANDARD FEE SCHEDULE TABLE
IF OBJECT_ID('tempdb..#TempStandardFeeSchedules') IS NOT NULL DROP TABLE #TempStandardFeeSchedules
CREATE TABLE #TempStandardFeeSchedules
(
	ProcedureCode VARCHAR(20),
	StandardAmount MONEY,
)

-- TEMP INSURANCE SPECIFIC FEE SHCEDULE TABLE
IF OBJECT_ID('tempdb..#TempInsuranceFeeSchedules') IS NOT NULL DROP TABLE #TempInsuranceFeeSchedules
CREATE TABLE #TempInsuranceFeeSchedules
(
	InsuranceCode CHAR(1), 
	ProcedureCode VARCHAR(20),
	InsuranceAmount MONEY
)

--  +------------------------------------------------------------------------+
--  |                        POPULATE TEMP CONTRACTS                         |
--  +------------------------------------------------------------------------+

DECLARE @InsuranceCode VARCHAR(10)
DECLARE @ContractName VARCHAR(100)
DECLARE @SQLString NVARCHAR(1000)

DECLARE db_cursor CURSOR FOR  
SELECT column_name FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '_import_2_18_FeeScheduleNames' AND column_name <> 'ID'

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @InsuranceCode  

WHILE @@FETCH_STATUS = 0  
BEGIN  
		SET @SQLString = N'SET @ContractName = (SELECT ' + @InsuranceCode + ' FROM _import_2_18_FeeScheduleNames)'

		EXECUTE sp_executesql @SQLString, 
			N'@InsuranceCode VARCHAR(10), @ContractName VARCHAR(100) OUTPUT',
			@InsuranceCode,
			@ContractName OUTPUT

		INSERT INTO #TempInsuranceContracts VALUES(UPPER(RIGHT(@InsuranceCode, 1)), @ContractName)

		FETCH NEXT FROM db_cursor INTO @InsuranceCode  
END  
CLOSE db_cursor  
DEALLOCATE db_cursor 


--  +------------------------------------------------------------------------+
--  |      POPULATE STANDARD (NON-INSURANCE SPECIFIC), FEE SCHEDULES         |
--  +------------------------------------------------------------------------+

INSERT INTO #TempStandardFeeSchedules SELECT feescheduleid, [standard] FROM dbo.[_import_2_18_FeeSchedule]


--  +------------------------------------------------------------------------+
--  |             POPULATE INSURANCE SPECIFIC FEE SCHEDULES                  |
--  +------------------------------------------------------------------------+

DECLARE @intCharCode INT
SET @intCharCode = ASCII('A')
WHILE @intCharCode <= Ascii('Z')
BEGIN
	DECLARE @sql VARCHAR(255)
	
	SET @sql = 'INSERT INTO #TempInsuranceFeeSchedules SELECT ''' + CHAR(@intCharCode) +''', feescheduleid, amount' + CHAR(@intCharCode) + ' FROM dbo.[_import_2_18_FeeSchedule]'
	EXEC(@sql)

	SET @intCharCode = @intCharCode + 1
END



-- DEBUG OUTPUT (SET @Debug to 0 when happy)
IF (@Debug = 1)
BEGIN
	SELECT * FROM #TempInsuranceContracts
	SELECT * FROM #TempStandardFeeSchedules
	SELECT * FROM #TempInsuranceFeeSchedules
END


/*
	+--------------------------------------------------+
	|                                                  |
	|         DO THE FEE SCHEDULE IMPORT HERE          |
	|           JOINING THE NEW TEMP TABLES            |
	|                                                  |
	|                                                  |
	|          or integrate all the code               |
	|          here into the import script             |
	|                                                  |
	|                                                  |
	|                                                  |
	+--------------------------------------------------+
*/


--
-- ...
--




-- Cleanup / DROP temp tables
IF OBJECT_ID('tempdb..#TempInsuranceContracts') IS NOT NULL DROP TABLE #TempInsuranceContracts
IF OBJECT_ID('tempdb..#TempStandardFeeSchedules') IS NOT NULL DROP TABLE #TempStandardFeeSchedules
IF OBJECT_ID('tempdb..#TempInsuranceFeeSchedules') IS NOT NULL DROP TABLE #TempInsuranceFeeSchedules
