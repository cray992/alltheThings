
/*
select * from insurancecompany where vendorID = '710' 
and insurancecompanyname = 'AMERICAN LIFE PIONEER INS' 
and (zipcode <> '32591' or zipcode is null)  --'8009992224' 1 row

select * from insurancecompanyplan where vendorID = '710' 
and planname = 'AMERICAN LIFE PIONEER INS' 
and (zipcode is null or zipcode <> '32591') -- 21 rows

*/
--BEGIN TRANSACTION

UPDATE InsuranceCompany
SET ZipCode = '32591'
WHERE vendorID = '710' 
and insurancecompanyname = 'AMERICAN LIFE PIONEER INS' 
and (zipcode <> '32591' or zipcode is null)


UPDATE InsuranceCompanyPlan
SET ZipCode = '32591' 
WHERE vendorID = '710' 
AND PlanName = 'AMERICAN LIFE PIONEER INS' 
and (zipcode is null or zipcode <> '32591')

-- COMMIT
-- ROLLBACK

/*
select * from aemstar_mwins where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'  --ZipCode = '8009992224'
--select * from champion_mwins where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'
select * from cityofliberty_mwins where code = '710'  and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'
select * from coastal_mwins where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'
select * from firstmedical_mwins where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'
select * from harriscounty_mwins where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'
select * from hilltoplakes_mwins where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'
--select * from lakejackson_mwins where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'
select * from manvel_mwins where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'
select * from paducah_mwins where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'
select * from starplus_mwins where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'
select * from tac_mwins where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'
select * from texasamuniversity_mwins where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'
select * from texaswest_mwins where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'
select * from transpro_mwins where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'
select * from wayside_mwins where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'
select * from westuniversity_mwins where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'
select * from willowbrook_mwins where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'
select * from winniestowell_mwins where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'
select * from yorktown_mwins where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'
*/
-- 18 rows
--BEGIN TRANSACTION

UPDATE aemstar_mwins 
SET ZipCode = '32591' 
where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'  --ZipCode = '8009992224'
--select * from champion_mwins where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'

UPDATE cityofliberty_mwins 
SET ZipCode = '32591' 
where code = '710'  and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'

UPDATE coastal_mwins 
SET ZipCode = '32591' 
where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'

UPDATE  firstmedical_mwins 
SET ZipCode = '32591' 
where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'

UPDATE harriscounty_mwins 
SET ZipCode = '32591' 
where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'

UPDATE hilltoplakes_mwins 
SET ZipCode = '32591' 
where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'
--select * from lakejackson_mwins where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'

UPDATE manvel_mwins 
SET ZipCode = '32591' 
where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'

UPDATE paducah_mwins 
SET ZipCode = '32591' 
where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'

UPDATE starplus_mwins 
SET ZipCode = '32591' 
where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'

UPDATE tac_mwins 
SET ZipCode = '32591' 
where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'

UPDATE texasamuniversity_mwins 
SET ZipCode = '32591' 
where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'

UPDATE texaswest_mwins 
SET ZipCode = '32591' 
where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'

UPDATE transpro_mwins 
SET ZipCode = '32591' 
where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'

UPDATE wayside_mwins 
SET ZipCode = '32591' 
where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'

UPDATE westuniversity_mwins 
SET ZipCode = '32591' 
where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'

UPDATE willowbrook_mwins 
SET ZipCode = '32591' 
where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'

UPDATE winniestowell_mwins 
SET ZipCode = '32591' 
where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'

UPDATE yorktown_mwins 
SET ZipCode = '32591' 
where code = '710' and name = 'AMERICAN LIFE PIONEER INS' and zipcode =  '8009992224'

-- COMMIT
-- ROLLBACK