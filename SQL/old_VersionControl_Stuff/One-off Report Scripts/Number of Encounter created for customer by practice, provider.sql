declare @date as Datetime
set @Date = '11/30/06'


select p.Name PracticeName, 
	d.doctorID,
	ISNULL(d.FirstName, '') + ' ' + ISNULL(d.LastName, '') + ', ' + ISNULL(d.Degree, '') as ProviderName,
	count(Distinct case when datediff(m, e.CreatedDate, @date) =7 THEN e.EncounterID ELSE NULL END ) as '-7',
	count(Distinct case when datediff(m, e.CreatedDate, @date) =6 THEN e.EncounterID ELSE NULL END ) as '-6',
	count(Distinct case when datediff(m, e.CreatedDate, @date) =5 THEN e.EncounterID ELSE NULL END ) as '-5',
	count(Distinct case when datediff(m, e.CreatedDate, @date) =4 THEN e.EncounterID ELSE NULL END ) as '-4',
	count(Distinct case when datediff(m, e.CreatedDate, @date) =3 THEN e.EncounterID ELSE NULL END ) as '-3',
	count(Distinct case when datediff(m, e.CreatedDate, @date) =2 THEN e.EncounterID ELSE NULL END ) as '-2',
	count(Distinct case when datediff(m, e.CreatedDate, @date) =1 THEN e.EncounterID ELSE NULL END ) as '-1',
	count(Distinct case when datediff(m, e.CreatedDate, @date) =0 THEN e.EncounterID ELSE NULL END ) as 'Current'
FROM dbo.Doctor D
	INNER JOIN Practice P on D.PracticeID = P.PracticeID
	LEFT OUTER JOIN dbo.Encounter E on E.DoctorID = D.DoctorID
	LEFT OUTER JOIN EncounterProcedure EP on EP.EncounterID = E.EncounterID
	LEFT OUTER JOIN dbo.Claim C on C.EncounterProcedureID = EP.EncounterProcedureID
WHERE D.[External] = 0 AND P.Active = 1 AND P.Name <> 'American Medicine Associates'
					AND P.Name NOT LIKE '%Test%' AND P.NAME NOT LIKE '%Training%'
					AND (C.ClaimID IS NULL OR C.ClaimStatusCode <> 'R')
GROUP BY 
	p.Name, 
	ISNULL(d.FirstName, '') + ' ' + ISNULL(d.LastName, '') + ', ' + ISNULL(d.Degree, ''),
	d.doctorID
ORDER BY PracticeName, ProviderName


