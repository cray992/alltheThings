update ct set notes='Payment made with encounter '+CHAR(13)+CHAR(10)+'Payment ID# '+CAST(ReferenceID AS VARCHAR)
from claimtransaction ct inner join Payment p
on ct.referenceid=p.paymentid
where ClaimTransactionTypeCode='PAY' AND Notes like 'Payment made with encounter%'

