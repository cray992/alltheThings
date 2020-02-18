update practicetoinsurancecompany
set eclaimsenrollmentstatusid=2
from insurancecompany ic
inner join clearinghousepayerslist cp
on cp.clearinghousepayerid = ic.clearinghousepayerid
inner join practicetoinsurancecompany pic
on pic.insurancecompanyid = ic.insurancecompanyid
where isenrollmentrequired=1
and eclaimsenrollmentstatusid<>2
and cp.modifieddate > '7/27/2010'