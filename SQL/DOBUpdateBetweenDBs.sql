-- Update DOB between DBs

BEGIN TRANSACTION
UPDATE dp
SET dp.DOB = rp.DOB
FROM superbill_62032_restore.dbo.patient rp
INNER JOIN superbill_62032_dev.dbo.Patient dp
	ON rp.PatientID = dp.PatientID
-- commit
-- rollback


select hm.sig,hm.*
from ecomment.enterprise ee
    inner join healthcare.patients hp on
        hp.enterprise_id = ee.enterprise_id
    inner join healthcare.patient_medications hm on
        hm.patient_id = hp.patients_id
    where ee.customer_id = 65162 and hm.sig is null
    order by created_at desc;



select * from MEDSOURCE.PRESCRIBER;


select * from ecomment.enterprise ee where ee.ENTERPRISE_ID = 3177900;
select * from MEDSOURCE.PRESCRIBER where PRESCRIBER_ID = 2930538;

select hm.sig,hm.*
from ecomment.enterprise ee
    inner join healthcare.patients hp on
        hp.enterprise_id = ee.enterprise_id
    inner join healthcare.patient_medications hm on
        hm.patient_id = hp.patients_id
    where ee.customer_id = 65162 --and hm.sig is null --and hm.CREATED_BY = 393606
        and hm.CREATED_BY in (127178,126095)
    order by created_at desc

    ;

select * from healthcare.patients where LAST_NAME like 'PAULO%' and FIRST_NAME = 'LOUIS';


select * from ECOMMENT.ENTERPRISE_SITE where enterprise_site_id in (2231,139)

select * from reg.users where
;

select * from reg.users where username in ('naomy.rosado@opuscare.org','jortiz@opuscare.org')
;
select * from ecomment.enterprise_site_user esu
where ENTERPRISE_SITE_USER_ID in (417669,393606)
;

select hm.sig,hm.*
from ecomment.enterprise ee
    inner join healthcare.patients hp on
        hp.enterprise_id = ee.enterprise_id
    inner join healthcare.patient_medications hm on
        hm.patient_id = hp.patients_id
    where --ee.customer_id = 65162 and
    hm.sig is null --and hm.CREATED_BY = 393606
      and  hm.CREATED_BY in (127178,126095)
    order by created_at desc
