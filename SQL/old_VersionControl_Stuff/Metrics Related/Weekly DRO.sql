declare @endDate datetime
SELECT @endDate = '12/8/07'



declare @startDate datetime
SET @startDate = dateadd(day, -60, @endDate)



select p.PracticeID, p.Name, DaysRevenueOutStanding,
	DaysRevenueOutStanding_Bucket = round( DaysRevenueOutStanding, -1),
	PercentSelfPay
        , c.CompanyName
from DashboardKeyIndicatorDisplay d
	inner join practice p on p.practiceID = d.practiceID
	inner join sharedserver.superbill_shared.dbo.customer c on c.DatabaseName= db_Name()
	LEFT JOIN (
					select practiceID, 
						PercentSelfPay = case when sum( case when PayerTypeCode = 'I' THEN PaymentAmount ELSE 0 END ) <> 0 -- check for divide by zero
										THEN sum( case when PayerTypeCode = 'P' THEN PaymentAmount ELSE 0 END ) /
													sum( case when PayerTypeCode = 'I' THEN PaymentAmount ELSE 0 END )
										ELSE 0.00
										END
					FROM Payment
					WHERE PostingDate between @startDate and @endDate
					group by practiceID
					having 0 <> sum( case when PayerTypeCode = 'I' THEN PaymentAmount ELSE 0 END )

				) as pay on pay.PracticeID = p.PracticeID
WHERE d.ComparePeriodType = 'V' --Reviewed data over the 60 day period prior to 11/17/2007
	and c.DatabaseSErverName IN ( SELECT Name from sys.servers where server_id = 0)
	and p.active = 1
	and 100 <= (select count(*) from encounter e where e.practiceID = p.practiceID and EncounterStatusID = 3 and e.postingDate between dateadd(month, -1, @endDate) and @endDate) --Must have at least 100 encounters per month
	and p.createdDate <= dateadd(month, -6, @endDate) --Must be on Kareo for more than 6 months
	and 0.30 >= PercentSelfPay --The percentage of self-pay payments is under 30%
