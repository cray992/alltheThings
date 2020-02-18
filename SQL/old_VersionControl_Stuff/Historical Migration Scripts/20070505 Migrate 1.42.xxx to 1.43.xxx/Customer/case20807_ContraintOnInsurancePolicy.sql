-- finds and fixes duplicate precedence.

select patientcaseid, precedence 
INTO #Dup
from insurancepolicy 
group by patientcaseid, precedence 
having count(insurancepolicyid)>1


select identity(int, 1, 1) as rowID,
	PatientCaseID,
	Precedence,
	cast(insurancePolicyID as int) as insurancePolicyID
INTO #insurancepolicy
from insurancepolicy ip
WHERE exists( select * from #Dup d where d.patientcaseid = ip.patientcaseid )
GROUP BY 
	PatientCaseID,
	Precedence,
	insurancePolicyID

Update ip
SET Precedence = (select count(*) FROM #insurancepolicy rowID where rowID.PatientCaseID = ip.PatientCaseID and rowID.rowID <= ip.RowID )
FROM #insurancepolicy ip

update ip
SET Precedence = new.Precedence
FROM insurancepolicy ip
INNER JOIN #insurancepolicy new ON ip.insurancepolicyID = new.insurancepolicyID

drop table #Dup, #insurancepolicy
GO



-- Unique constraint on the table.
ALTER TABLE [dbo].[InsurancePolicy] ADD  CONSTRAINT [UQ_InsurancePolicy_PatientCaseIDPrecedence]  UNIQUE (PatientCaseID, Precedence)
