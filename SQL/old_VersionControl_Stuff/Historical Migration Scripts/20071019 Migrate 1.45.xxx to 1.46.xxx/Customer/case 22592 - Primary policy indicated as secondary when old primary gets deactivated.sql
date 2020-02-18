	


-- Create precedence
if NOT exists( select * 
			from sys.columns c 
				inner join sys.objects o 
				on o.object_id = c.object_id 
			where c.Name = 'RelativePrecedence' 
				and o.Name = 'claimAccounting_Assignments'
				and o.Type_desc = 'USER_TABLE'
		)
BEGIN


	alter table claimAccounting_Assignments add RelativePrecedence INT



END

GO

------ Migration for the current information
update caa
SET RelativePrecedence = ip.Precedence
from claimAccounting_Assignments caa
	inner join InsurancePolicy ip 
	on ip.InsurancePolicyID = caa.InsurancePolicyID


GO