use FlowMessages -- kprod-db15

SET STATISTICS IO ON
SET STATISTICS TIME ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

declare @daysToLookBack int
declare @showdetail bit
declare @showperformance bit
DECLARE @showperformancebydatabaseserverbyelapsedtime bit
declare @showperformancebydatabaseserver bit
declare @showperformancebydatabase bit
declare @MinElaspedTimeSeconds int
declare @login varchar(256)
declare @customerkey varchar(256)
declare @startdate datetime
declare @enddate datetime
declare @ignoreErrors bit
declare @showErrorsOnly BIT
DECLARE @checkAnyRecentActivity BIT -- looks for any login, any elapsed time, over the past 10 minutes
SET @checkAnyRecentActivity = 0
set @daysToLookBack = 1
set @showdetail = 1
set @showperformance = 0
set @showperformancebydatabaseserverbyelapsedtime = 1
set @showperformancebydatabaseserver = 1
set @showperformancebydatabase = 1
set @MinElaspedTimeSeconds = 3
set @ignoreErrors = 0
set @showErrorsOnly = 0
set @login = 'kareointegration@practicefusion.com'
--set @login = 'gregh@mirthcorp.com'
--set @customerkey = 'kareo:3196'
set		@startdate = dateadd(day, -1 * @daysToLookBack, getdate())
--set		@startdate = '8/27/2010'
set		@enddate = null

IF @checkAnyRecentActivity = 1
BEGIN
	SET @login = NULL
	SET @startdate = dateadd(minute, -10 * @daysToLookBack, getdate())
	SET @customerkey = NULL
	SET @MinElaspedTimeSeconds = 0
END

/*
select QueueMsgId
from queuemsg 
where createddate > dateadd(day, -1, getdate())
and MsgStatus = 'Error'
and cast(msg.query('(/Request/Name/text())') as varchar(50)) in( 'SendAllPhysiciansReportCard', 'SendAllAppointmentReminders')
*/
BEGIN TRY
	declare @minwebservicemsgid int
	set		@minwebservicemsgid = 1

	select	WebServiceMsgId,
			Received,
			Completed, 
			DateDiff(ms, Received, Completed) / 1000 as ElaspedTimeSeconds,
			cast(Request as xml) as Request,
			Error
	into	#webservicemsg
	from	WebServiceMsg
	where	WebServiceMsgId >= @minwebservicemsgid
	and		Received >= @startdate
	and		(Received <= @enddate or @enddate is null)
	and		(Error IS NULL or @ignoreErrors = 0)

	select	WebServiceMsgId,
			Received,
			Completed,
			ElaspedTimeSeconds,
			Error, 
			cast(Request.query('(/Request/Name/text())') as varchar(128)) as Name,
			cast(Request.query('(/Request/ClientVersion/text())') as varchar(128)) as ClientVersion,
			cast(Request.query('(/Request/CustomerKey/text())') as varchar(128)) as CustomerKey,
			cast(Request.query('(/Request/User/text())') as varchar(128)) as Login
	into	#webservicemsg2
	from	#webservicemsg
	where	ElaspedTimeSeconds >= @MinElaspedTimeSeconds

	if @showdetail = 1
	begin
		select	w.WebServiceMsgId,
				w.Received,
				w.Completed,
				w.ElaspedTimeSeconds,
				w.Name,
				w.ClientVersion,
				w.CustomerKey,
				w.Login, 
				c.CustomerId,
				c.CompanyName,
				c.DatabaseServerName, 
				w.Error
		from	#webservicemsg2 w
		left join
				SharedServer.Superbill_Shared.dbo.Customer c
		on		((c.CustomerKey = w.CustomerKey) or
				(cast(c.CustomerId as varchar(128)) = substring(w.CustomerKey, charindex(':', w.CustomerKey)+1, len(w.CustomerKey)-charindex(':', w.CustomerKey))))
		where (login = @login or @login is null)
		and	  (@customerkey is null or w.customerkey = @customerkey)
		and	  ((@showErrorsOnly = 1 and w.Error is not null) or @showErrorsOnly = 0)
		--and w.Name='Get Patients'
		--and w.Name='Create Encounter'
		--and login = 'kareointegration@practicefusion.com'
		--and w.ElaspedTimeSeconds > 0
		--and c.CustomerId=3265
		order by
				WebServiceMsgId desc
				--Received desc
	end

	if @showperformance = 1
	begin
		select	w.ElaspedTimeSeconds,
				count(*) as Count
		from	#webservicemsg2 w
		where (login = @login or @login is null)
		and	  ((@showErrorsOnly = 1 and w.Error is not null) or @showErrorsOnly = 0)
		group by
				w.ElaspedTimeSeconds
		order by w.ElaspedTimeSeconds
	end
	
	if @showperformancebydatabaseserverbyelapsedtime = 1
	begin
		select	w.ElaspedTimeSeconds,
				c.DatabaseServerName, 
				count(*) as Count
		from	#webservicemsg2 w
		left join
				SharedServer.Superbill_Shared.dbo.Customer c
		on		((c.CustomerKey = w.CustomerKey) or
				(cast(c.CustomerId as varchar(128)) = substring(w.CustomerKey, charindex(':', w.CustomerKey)+1, len(w.CustomerKey)-charindex(':', w.CustomerKey))))
		where (login = @login or @login is null)
		and	  (@customerkey is null or w.customerkey = @customerkey)
		and	  ((@showErrorsOnly = 1 and w.Error is not null) or @showErrorsOnly = 0)
		group by
				w.ElaspedTimeSeconds, 
				c.DatabaseServerName
		order by w.ElaspedTimeSeconds	
	end
		
	if @showperformancebydatabaseserver = 1
	begin
		select	'Count by server',
				c.DatabaseServerName, 
				count(*) as Count
		from	#webservicemsg2 w
		left join
				SharedServer.Superbill_Shared.dbo.Customer c
		on		((c.CustomerKey = w.CustomerKey) or
				(cast(c.CustomerId as varchar(128)) = substring(w.CustomerKey, charindex(':', w.CustomerKey)+1, len(w.CustomerKey)-charindex(':', w.CustomerKey))))
		where (login = @login or @login is null)
		and	  (@customerkey is null or w.customerkey = @customerkey)
		and	  ((@showErrorsOnly = 1 and w.Error is not null) or @showErrorsOnly = 0)
		group by
				c.DatabaseServerName
		order by c.DatabaseServerName
	end

	if @showperformancebydatabase = 1
	begin
		select	c.DatabaseServerName,
				c.CustomerId,  
				count(*) as Count
		from	#webservicemsg2 w
		left join
				SharedServer.Superbill_Shared.dbo.Customer c
		on		((c.CustomerKey = w.CustomerKey) or
				(cast(c.CustomerId as varchar(128)) = substring(w.CustomerKey, charindex(':', w.CustomerKey)+1, len(w.CustomerKey)-charindex(':', w.CustomerKey))))
		where (login = @login or @login is null)
		and	  (@customerkey is null or w.customerkey = @customerkey)
		and	  ((@showErrorsOnly = 1 and w.Error is not null) or @showErrorsOnly = 0)
		group by
				c.DatabaseServerName,
				c.CustomerId
		order by Count DESC
		
		select	avg(ElaspedTimeSeconds) as ElapsedTimeSecondsAverage
		from	#webservicemsg2
		where (login = @login or @login is null)
		and	  (@customerkey is null or customerkey = @customerkey)
	end

	drop table #webservicemsg
	drop table #webservicemsg2

END TRY
BEGIN CATCH
	print ERROR_MESSAGE()

	drop table #webservicemsg
	drop table #webservicemsg2
END CATCH

/*
select	WebServiceMsgId, 
		Received, 
		Completed,  
		DateDiff(ms, Received, Completed) / 1000 as ElaspedTimeSeconds,
		cast(Request as xml) Request,
		cast(Response as xml) Response, 
		Response,
		Error
from webservicemsg
where webservicemsgid in (3240700 )
order by webservicemsgid
*/