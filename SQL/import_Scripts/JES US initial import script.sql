--this script is not high-quality and should NEVER be run straight-through. it is case-specific.

--select * from customer where companyname like 'Jes Us%'
--228

--select * from practice
--2


--JR, I, III, SR

DECLARE @rexGuarantor varchar(max)
SET @rexGuarantor = '(?<last>[^\s]+)(?:\s+(?<suffix>(?:JR|SR|I|III)))?(?:\s+(?<first>[^\s]+))(?:\s+(?<middle>.*))?'

/*
select [Last Name], [Gen], [First Name],[M],
	dbo.RegexReplace(guarantor,@rexGuarantor,'${last}') as GuarantorLast, 
	dbo.RegexReplace(guarantor,@rexGuarantor,'${suffix}') as GuarantorSuffix, 
	dbo.RegexReplace(guarantor,@rexGuarantor,'${first}') as GuarantorFirst, 
	dbo.RegexReplace(guarantor,@rexGuarantor,'${middle}') as GuarantorMiddle 
from import10178
where
	[Last Name] <> dbo.RegexReplace(guarantor,@rexGuarantor,'${last}')
	OR [First Name] <> dbo.RegexReplace(guarantor,@rexGuarantor,'${first}')
*/

select distinct [Referred By] from import10178 where [Referred By] is not null

select top 100 * from doctor where practiceid=2

insert into doctor 
	(
	practiceid,
	prefix,firstname,middlename,lastname,suffix,ssn,addressline1,addressline2,city,state,zipcode,
	homephone,homephoneext,workphone,workphoneext,pagerphone,pagerphoneext,mobilephone,mobilephoneext,dob,emailaddress,
	notes,activedoctor,createddate,createduserid,modifieddate,modifieduserid,userid,degree,taxonomycode,vendorid,vendorimportid,faxnumber,faxnumberext,[external]
	)
select 
	2,prefix,firstname,middlename,d.lastname,suffix,ssn,addressline1,addressline2,city,state,zipcode,
	homephone,homephoneext,workphone,workphoneext,pagerphone,pagerphoneext,mobilephone,mobilephoneext,dob,emailaddress,
	notes,activedoctor,getdate(),0,getdate(),0,userid,degree,taxonomycode,doctorid,1,faxnumber,faxnumberext,[external] from doctor d inner join (select distinct [referred by] as lastname from import10178 where [referred by] is not null) i on d.lastname = i.lastname where d.[external]=1 and d.practiceid<>2

insert into providernumber(doctorid,providernumbertypeid,providernumber,attachconditionstypeid)
select
	d.doctorid, 25, pn.ProviderNumber,1
FROM
	doctor d inner join providernumber pn on pn.doctorid=d.vendorid
where
	d.vendorimportid=1

select * from providernumber where doctorid in (select vendorid from doctor where vendorimportid=1)
	
insert into doctor (practiceid,lastname,
	prefix,firstname,middlename,suffix,activedoctor,[external])
select distinct 2,[Referred By],'','','','',1,1 from import10178 where [Referred By] is not null and [referred by] not in (
select i.lastname from doctor d inner join (select distinct [referred by] as lastname from import10178 where [referred by] is not null) i on d.lastname = i.lastname where d.[external]=1 and d.practiceid=2
)

update doctor set vendorimportid=1 where practiceid=2 and doctorid>10

--select * from import10178
--select * from patient where practiceid = 2

/*
INSERT INTO
	Patient
	(PracticeID, 
	Prefix, Firstname, MiddleName, LastName, Suffix, 
	AddressLine1, AddressLine2, City, State, ZipCode, HomePhone, WorkPhone,
	DOB, SSN, Gender, 
	ResponsibleDifferentThanPatient, 
	ResponsiblePrefix, ResponsibleFirstName, ResponsibleMiddleName, ResponsibleLastName, ResponsibleSuffix,
	ResponsibleRelationshipToPatient, 
	CreatedDate,ModifiedDate,CreatedUserID,ModifiedUserID, VendorID, VendorImportID)
SELECT
	2,
	'', COALESCE([First Name],''),COALESCE([M],''),COALESCE([Last Name],''), COALESCE(Gen,''),
	[Street 1], [Street 2], City, ST, dbo.RegexReplace(COALESCE(Zip,''), '[^0-9]',''), dbo.RegexReplace(COALESCE([Home Phone],''),'[^0-9]',''), dbo.RegexReplace(COALESCE([Work Phone],''),'[^0-9]',''),
	[Birth Date], dbo.RegexReplace(COALESCE([Soc Sec No],''),'[^0-9]',''), [S],
	CASE WHEN 	[Last Name] <> dbo.RegexReplace(COALESCE(guarantor,''),@rexGuarantor,'${last}') OR [First Name] <> dbo.RegexReplace(COALESCE(guarantor,''),@rexGuarantor,'${first}') THEN 1 ELSE 0 END,
	'',
	CASE WHEN 	[Last Name] <> dbo.RegexReplace(COALESCE(guarantor,''),@rexGuarantor,'${last}') OR [First Name] <> dbo.RegexReplace(COALESCE(guarantor,''),@rexGuarantor,'${first}') THEN dbo.RegexReplace(COALESCE(guarantor,''),@rexGuarantor,'${first}') ELSE NULL END, 
	CASE WHEN 	[Last Name] <> dbo.RegexReplace(COALESCE(guarantor,''),@rexGuarantor,'${last}') OR [First Name] <> dbo.RegexReplace(COALESCE(guarantor,''),@rexGuarantor,'${first}') THEN dbo.RegexReplace(COALESCE(guarantor,''),@rexGuarantor,'${middle}') ELSE NULL END,
	CASE WHEN 	[Last Name] <> dbo.RegexReplace(COALESCE(guarantor,''),@rexGuarantor,'${last}') OR [First Name] <> dbo.RegexReplace(COALESCE(guarantor,''),@rexGuarantor,'${first}') THEN dbo.RegexReplace(COALESCE(guarantor,''),@rexGuarantor,'${last}') ELSE NULL END, 
	CASE WHEN 	[Last Name] <> dbo.RegexReplace(COALESCE(guarantor,''),@rexGuarantor,'${last}') OR [First Name] <> dbo.RegexReplace(COALESCE(guarantor,''),@rexGuarantor,'${first}') THEN dbo.RegexReplace(COALESCE(guarantor,''),@rexGuarantor,'${suffix}') ELSE NULL END, 
	CASE WHEN 	[Last Name] <> dbo.RegexReplace(COALESCE(guarantor,''),@rexGuarantor,'${last}') OR [First Name] <> dbo.RegexReplace(COALESCE(guarantor,''),@rexGuarantor,'${first}') THEN 'O' ELSE NULL END,
	getdate(),getdate(),0,0, [Account No],1
FROM
	import10178
*/


update patient
set referringphysicianid=d.doctorid
from patient p inner join import10178 i on i.[account no] = p.vendorid and p.vendorimportid=1
inner join doctor d on d.lastname = i.[Referred By] and d.practiceid=2 and d.vendorimportid = 1
where p.practiceid=2

select i.lastname from doctor d inner join (select distinct [referred by] as lastname from import10178 where [referred by] is not null) i on d.lastname = i.lastname where d.[external]=1 and d.practiceid=2

insert into patientcase (patientid,practiceid,name,active,payerscenarioid, referringphysicianid,vendorimportid)
select patientid, 2, 'Default Case',1,5,ReferringPhysicianID, 1 from patient where practiceid=2

select * from import10178



BEGIN TRAN

DECLARE @t table (Ins varchar(max), ICID int, ICPID int)

INSERT INTO @t (Ins)
SELECT DISTINCT
	[primary insurance] as ins
FROM
	import10178
WHERE
	[primary insurance] is not null
UNION
SELECT
	[secondary insurance] as ins
FROM 
	import10178
WHERE
	[secondary insurance] is not null
ORDER BY
	ins

INSERT INTO insurancecompany (Insurancecompanyname, vendorimportid)
SELECT Ins, 1 FROM @t

UPDATE @t SET ICID = InsuranceCompanyID FROM InsuranceCompany IC INNER JOIN @t t ON IC.InsuranceCompanyName = t.Ins WHERE IC.VendorImportID = 1

INSERT INTO InsuranceCompanyPlan (PlanName, InsuranceCompanyID, VendorImportID)
SELECT Ins, ICID, 1 FROM @t 

UPDATE @t SET ICPID = InsuranceCompanyPlanID FROM InsuranceCompanyPlan ICP INNER JOIN @t t ON ICP.PlanName = t.Ins WHERE ICP.VendorImportID = 1

DECLARE @pi table (PatientCaseID int, ICPID int, Precedence int, PolicyNumber varchar(255))

INSERT INTO @pi
SELECT
	PC.PatientCaseID,
	t.ICPID,
	1,
	i.[Primary Policy]
FROM
	Patient P
	INNER JOIN PatientCase PC ON PC.PatientID = P.PatientID
	INNER JOIN import10178 i ON i.[Account No] = P.VendorID AND P.VendorImportID = 1
	INNER JOIN @t t ON t.Ins = i.[Primary Insurance]
WHERE
	i.[Primary Insurance] IS NOT NULL
	AND i.[Primary Policy] IS NOT NULL

INSERT INTO @pi
SELECT
	PC.PatientCaseID,
	t.ICPID,
	2,
	i.[Secondary Policy]
FROM
	Patient P
	INNER JOIN PatientCase PC ON PC.PatientID = P.PatientID
	INNER JOIN import10178 i ON i.[Account No] = P.VendorID AND P.VendorImportID = 1
	INNER JOIN @t t ON t.Ins = i.[Secondary Insurance]
WHERE
	i.[Secondary Insurance] IS NOT NULL
	AND i.[Secondary Policy] IS NOT NULL

INSERT INTO InsurancePolicy
	(PatientCaseID, InsuranceCompanyPlanID, Precedence,PolicyNumber, VendorImportID, Active, Practiceid, PatientRelationshipToInsured)
SELECT
	PatientCaseID, ICPID, Precedence, PolicyNumber, 1,1,2, 'S'
FROM
	@pi

--COMMIT
--ROLLBACK

INSERT INTO PatientJournalNote
(PatientID, UserName, SoftwareApplicationID, Hidden, NoteMessage, CreatedDate)
SELECT P.PatientID, 'Data Conversion','B',0,i.Note, i.[Date Entered]
FROM Patient P INNER JOIN import10178 i ON P.VendorImportID = 1 AND P.VendorID = i.[Account No]
WHERE i.Note IS NOT NULL AND LEN(i.Note) > 0

