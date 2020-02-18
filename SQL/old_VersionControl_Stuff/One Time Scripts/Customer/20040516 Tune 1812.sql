exec PaymentDataProvider_GetPaymentsCount @query_domain = N'ClaimPayerID', @applied_status = N'Unapplied', @practice_id = 34, @query = N'3955'
/*
Reads 16613
Writes 4
Duration 1770
*/

exec PaymentDataProvider_GetPayments @query_domain = N'ClaimPayerID', @applied_status = N'Unapplied', @practice_id = 34, @query = N'3955'

/*
Reads 16609
Writes 4
Duration 1746
*/

