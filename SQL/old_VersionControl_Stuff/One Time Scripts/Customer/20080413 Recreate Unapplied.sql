
delete UnappliedPayments

		
insert into UnappliedPayments( practiceID, paymentID)
select v.practiceID, v.paymentID
from (
select PracticeID, paymentID, sum( paymentAmount ) as paymentAmount
from
(

	select PracticeID, paymentID, paymentAmount
	from Payment (NOLOCK)

	union all

	select PracticeID, PaymentID, -1 * Amount as paymentAmount
	from ClaimAccounting (NOLOCK)
	where ClaimTransactionTypeCode = 'PAY'

	union all
	select practiceID, paymentID, -1 * Amount
	from RefundToPayments rtp (NOLOCK)
	inner join Refund r (NOLOCK)
	on r.RefundID = rtp.RefundID

	union all

	select practiceID, paymentID, -1 * rtp.Amount
	from CapitatedAccountToPayment rtp (NOLOCK)
	inner join CapitatedAccount r (NOLOCK)
	on r.CapitatedAccountID = rtp.CapitatedAccountID


) as s
group by PracticeID, paymentID
) as v
inner join Payment p on p.PracticeID = v.PracticeID and p.PaymentID = v.paymentID
left join UnappliedPayments up on up.paymentID=p.paymentID
where v.paymentAmount > 1
and up.paymentID is null

