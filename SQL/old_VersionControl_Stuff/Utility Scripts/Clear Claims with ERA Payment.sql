
-- Purpose ******* For Development testing ONLY. Not for production **********
----	The script is used to wipe out all claim transaction that were paid with an ERA so that the
----	the claim is in a fresh, newly approved state for the entire practice. 
----	Used to Payment testing, sprint 15 12/27/06

declare @PracticeID INT

select @PracticeID = 1

---------------------------------------------------
-------- Start of Sproc ---------------------------
if @PracticeID IS NULL
	RETURN


select ClearingHouseResponseID, PaymentID
INTO #ClearinghouseResponse
from ClearinghouseResponse
where ResponseType = 33
	AND ClearinghouseResponseReportTypeID = 2
	AND PaymentID IS NOT NULL
	AND PracticeID = @PracticeID


select cr.ClearingHouseResponseID, cr.PaymentID, ca.ClaimID, ca.ClaimTransactionID, lastPayment = cast(null as int)
INTO #ClaimPayment
FROM #ClearinghouseResponse cr
	INNER JOIN (SELECT PaymentID, ClaimID, ClaimTransactionID = max(ClaimTransactionID) FROM ClaimAccounting ca GROUP BY PaymentID, ClaimID ) as ca 
		ON ca.PaymentID = cr.PaymentID



Update cp
SET lastPayment = case when cp.ClaimTransactionID = ca.ClaimTransactionID THEN 0 ELSE 1 END
FROM #ClaimPayment cp 
	INNER JOIN (select ClaimID, ClaimTransactionID = max(ClaimTransactionID) FROM ClaimTransaction ca WHERE ClaimTransactionTypeCode IN ('PAY', 'ADJ') group by claimID) ca
	ON ca.ClaimID = cp.ClaimID






select cr.ClaimID, ClaimTransactionID = ca.ClaimTransactionID
INTO #firstASN
FROM #ClaimPayment cr
	INNER JOIN (Select ClaimID, min(ClaimTransactionID) ClaimTransactionID FROM ClaimTransaction WHERE ClaimTransactionTypeCode IN ('ASN', 'PRC')  GROUP BY ClaimID) as ca
		ON cr.ClaimID = ca.ClaimID


	select ClearingHouseResponseID, paymentID 
	INTO #PaymentsToProcess
	from #ClaimPayment 
	GRoup by ClearingHouseResponseID, paymentID 
	having sum(lastPayment) = 0


declare @ClaimID INT, @PaymentID INT
select @PaymentID = 0


		-- delete each payment in the list
		while 1=1
		BEGIN
			
			select @PaymentID = min(c.paymentID)
			FROM #ClaimPayment p
				INNER JOIN ClaimTransaction c ON c.ClaimID = p.ClaimID
			WHERE c.paymentID > @PaymentID


			IF @@rowcount = 0 OR @PaymentID IS NULL
				BREAK

			-- delete the actual payment
			exec PaymentDataProvider_DeletePayment @PaymentID
			PRINT 'Deleting PaymentID - '+CAST(@PaymentID AS VARCHAR)

		END

	delete ct
	FRom ClaimTransaction ct 
		INNER JOIN #firstASN asn ON asn.ClaimID = ct.ClaimID AND ct.ClaimTransactionID > asn.ClaimTransactionID 
		INNER JOIN  #ClaimPayment cp ON cp.ClaimID = ct.ClaimID


drop table #ClearinghouseResponse, #ClaimPayment
drop table #firstASN, #PaymentsToProcess



/*
select *
from practice
order by Name



select *
from #ClaimPayment

select *
from #firstASN
where ClaimID = 340150

select *
from ClaimTransaction ca
	INNER JOIN #ClaimPayment cp on cp.ClaimID = ca.ClaimID
where ca.ClaimID = 340150
-- payment = 73862


select *
from #PaymentsToProcess



	select *
	FROM #PaymentsToProcess p
		INNER JOIN 	#ClaimPayment cp ON cp.PaymentID = p.PaymentID

235622

select *
from ClaimTransaction
where ClaimID  = 222684
order by claimTransactionID


select *
from ClaimTransaction
where ClaimID  = 222685
order by claimTransactionID





select *
from ClaimTransaction
where PaymentID   = 53949
order by claimTransactionID


select *
from #ClaimPayment
where paymentID = 53946



*/