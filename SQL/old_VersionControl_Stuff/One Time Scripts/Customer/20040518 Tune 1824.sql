exec PracticeDataProvider_GetPractice @practice_id = 34

exec PracticeDataProvider_GetPractices @userName = N'Administrator'

declare @P1 int
set @P1=NULL
exec ClaimDataProvider_GetClaims @status = N'ReadyForInsurance', @practice_id = 34, @totalRecords = @P1 output
select @P1

declare @P1 int
set @P1=3
exec ClaimDataProvider_GetClaims @status = N'ReadyForInsurance', @practice_id = 30, @startRecord = default, @maxRecords = default, @totalRecords = @P1 output
select @P1

exec ClaimDataProvider_GetClaimsAssignmentOptions @selection_xml = N'<?xml version=''1.0'' ?><selections></selections>'
declare @P1 int
exec ClaimDataProvider_GetClaims @status = N'ReadyForInsurance', @practice_id = 30, @startRecord = default, @maxRecords = default, @totalRecords = @P1 output
DBCC USEROPTIONS

/*
RPC:Completed		8	declare @P1 int
set @P1=0
exec ClaimDataProvider_GetClaims @status = N'ReadyForInsurance', @practice_id = 34, @totalRecords = @P1 output
select @P1	DEV	469	12792	.Net SqlClient Data Provider	1	1923	0	2004-05-18 20:59:48.783	2004-05-18 20:59:50.707		55	LT949		
*/


declare @P1 int
set @P1=0
exec ClaimDataProvider_GetClaims @status = N'ReadyForInsurance', @practice_id = 38, @startRecord = default, @maxRecords = default, @totalRecords = @P1 output
select @P1

/*
SQL:BatchCompleted		8	declare @P1 int
set @P1=0
exec ClaimDataProvider_GetClaims @status = N'ReadyForInsurance', @practice_id = 38, @startRecord = default, @maxRecords = default, @totalRecords = @P1 output
select @P1
	DC\rolland	437	6133		0	486	3600	2004-05-19 00:59:03.750	2004-05-19 00:59:04.237	rolland	53	LT949		
*/

declare @P1 int
set @P1=0
exec ClaimDataProvider_GetClaims @status = N'ReadyForInsurance', @practice_id = 30, @startRecord = default, @maxRecords = default, @totalRecords = @P1 output
select @P1

/*
SQL:BatchCompleted		8	declare @P1 int
set @P1=0
exec ClaimDataProvider_GetClaims @status = N'ReadyForInsurance', @practice_id = 30, @startRecord = default, @maxRecords = default, @totalRecords = @P1 output
select @P1
	DC\rolland	438	5562		0	470	3600	2004-05-19 01:00:10.457	2004-05-19 01:00:10.927	rolland	53	LT949		
*/
-- =============================================
-- Run the procedure for all of the practices
-- =============================================
declare @P1 int
DECLARE practice_cursor CURSOR
READ_ONLY
FOR SELECT PracticeID, Name FROM dbo.Practice

DECLARE @name varchar(100)
DECLARE @practiceId int
OPEN practice_cursor

FETCH NEXT FROM practice_cursor INTO @practiceid, @name
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
--		PRINT 'add user defined Code here'
--		eg.
		DECLARE @message varchar(100)
		SELECT @message = 'Practice ' + @name
		PRINT @message
PRINT		@practiceid

		set @P1=0
		exec ClaimDataProvider_GetClaims @status = N'ReadyForInsuranceElectronicOnly', @practice_id = @practiceid, @startRecord = default, @maxRecords = default, @totalRecords = @P1 output
		--PRINT @P1

	END
	FETCH NEXT FROM practice_cursor INTO @practiceid, @name
END

CLOSE practice_cursor
DEALLOCATE practice_cursor
GO


