select 
	pr.name, 
	pr.practiceid, 
	p.patientid, 
	COALESCE(ltrim(p.firstname+' '),'') + coalesce(ltrim(p.middlename+' '),'')+coalesce(p.lastname,''),
	pcd.procedurecode, 
	pcd.procedurename,
	(ep.serviceunitcount * ep.servicechargeamount) as charges,
	COALESCE((
		select 
			sum(amount) 
		from 
			claimtransaction ct 
		where 
			ct.claimid = c.claimid and ct.claimtransactiontypecode = 'PAY'
	),0) as payments,
	COALESCE((
		select 
			sum(amount) 
		from 
			claimtransaction ct 
		where 
			ct.claimid = c.claimid and ct.claimtransactiontypecode = 'ADJ'
	),0) as adjustments,
	(ep.serviceunitcount * ep.servicechargeamount) -
	COALESCE((
		select 
			sum(amount) 
		from 
			claimtransaction ct 
		where 
			ct.claimid = c.claimid and ct.claimtransactiontypecode = 'PAY'
	),0) - 
	COALESCE((
		select 
			sum(amount) 
		from 
			claimtransaction ct 
		where 
			ct.claimid = c.claimid and ct.claimtransactiontypecode = 'ADJ'
	),0) as balance
from 
	practice pr
	inner join encounter e on e.practiceid = pr.practiceid
	inner join encounterprocedure ep on ep.encounterid = e.encounterid
	inner join procedurecodedictionary pcd 
		on pcd.procedurecodedictionaryid = ep.procedurecodedictionaryid
	inner join patient p on e.patientid = p.patientid
	inner join claim c on c.encounterprocedureid = ep.encounterprocedureid
where 
	pcd.procedurecode in ('64612','64613','64614','A4215','J0585','95870')
	and pr.practiceid in (77,88)
order by
	pr.practiceid, p.patientid