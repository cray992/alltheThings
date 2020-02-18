update caa set insurancecompanyplanid=ip.insurancecompanyplanid
from claimaccounting_assignments caa inner join insurancepolicy ip
on caa.insurancepolicyid=ip.insurancepolicyid
where caa.insurancecompanyplanid is null