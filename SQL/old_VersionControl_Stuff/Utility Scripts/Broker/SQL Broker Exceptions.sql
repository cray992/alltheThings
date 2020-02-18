use superbill_shared -- kprod-db09
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

-- Expect: Short list with low # of Attempts
SELECT * FROM dbo.PatientStatementQueue WHERE Attempts > 5

-- Expect: Large number
SELECT COUNT(*) AS PatientStatementsSent FROM dbo.PatientStatementLog where createddate > dateadd(hour, -3, GETDATE())

-- PSC Confirmation: We want this to be postive
select count(*) as PatientStatementsConfirmationCount from patientstatementreceivelog where createddate > dateadd(hour, -3, GETDATE()) AND filename LIKE '%_Confirmation%'

-- PSC Final Confirmation: We want this to be postive
select count(*) as PatientStatementsFinalConfirmationCount from patientstatementreceivelog where createddate > dateadd(hour, -3, GETDATE()) AND filename LIKE '%_FinalConfirmation%'

-- PSC NCOA Update: We want this to be postive
select count(*) as PatientStatementsNCOACount from patientstatementreceivelog where createddate > dateadd(hour, -3, GETDATE()) AND filename LIKE '%NCOAUPDATE%'

-- PSC CASS Reject: We want this to be postive
select count(*) as PatientStatementsCASSCount from patientstatementreceivelog where createddate > dateadd(hour, -3, GETDATE()) AND filename LIKE '%CASSREJECTSFILE%'

-- Expect: Small number that fluctuates over time
select count(*) as BizClaimsReadyCount from BizClaimsEDIBill where createddate > dateadd(hour, -3, GETDATE()) and billstatecode='R'
/*
use superbill_shared -- kprod-db09

select max(createddate) from PatientStatementReceiveLog
select * from PatientStatementReceiveLog where createddate > dateadd(hour, -12, GETDATE())
select * from BizClaimsEDIBill where createddate > dateadd(hour, -3, GETDATE()) and billstatecode='R'
*/

use KareoMaintenance -- kprod-db09
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

declare @showdetail bit
declare @startdate datetime
set @showdetail = 1
set @startdate = '8/27/2011'
--set @startdate = dateadd(day, -3, GETDATE())

if @showdetail = 1
begin
	SELECT *
	FROM dbo.vwBrokerServerExceptions
	WHERE date >= @startdate
	and ExceptionReason = 'Timeout Expired'
	ORDER BY Date DESC
end

SELECT StoredProcedure, count(*) as Total
FROM dbo.vwBrokerServerExceptions
WHERE date >= @startdate
and exceptionreason='Timeout expired'
group by StoredProcedure
order by Total desc

SELECT DatabaseServerName, DatabaseName, count(*) as Total
FROM dbo.vwBrokerServerExceptions
WHERE date >= @startdate
and exceptionreason='Timeout expired'
group by DatabaseServerName, DatabaseName
order by Total desc

SELECT StoredProcedure, DatabaseServerName, DatabaseName, count(*) as Total
FROM dbo.vwBrokerServerExceptions
WHERE date >= @startdate
and exceptionreason='Timeout expired'
group by StoredProcedure, DatabaseServerName, DatabaseName
order by StoredProcedure, Total desc

/*
-- Check today vs yesterday
declare @from datetime
declare @to datetime
set @from = '7/27/2010 5:00am'
set @to = '7/27/2010 11:45am'

SELECT StoredProcedure, count(*) as Total
FROM dbo.vwBrokerServerExceptions
WHERE date >= @from
and date <= @to
and exceptionreason='Timeout expired'
group by StoredProcedure
order by Total desc

SELECT StoredProcedure, count(*) as Total
FROM dbo.vwBrokerServerExceptions
WHERE date >= dateadd(day, -1, @from)
and date <= dateadd(day, -1, @to)
and exceptionreason='Timeout expired'
group by StoredProcedure
order by Total desc
*/