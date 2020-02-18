-- California Medical Billing - Dr. Simpson Practice.
-- Case 10809
-- Practice ID : 1

-- Post Import Script.

use superbill_0327_dev
go

select * from vendorimport

select count(*) from cmb1_mwpat where patienttype = 'Patient'
select count(*) from patient where vendorimportid = 11

select count(*) from cmb1_mwcas
select count(*) from patientcase where vendorimportid = 11
select count( distinct chartnumber ) from cmb1_mwcas
select count( distinct patientid ) from patientcase where vendorimportid = 11

select count(*) from cmb1_mwins
select count(*) from insurancecompany where vendorimportid = 11

select count(*) from cmb1_mwphy
select count(*) from cmb1_mwrph
select count(*) from doctor where vendorimportid = 11


select firstname , lastname from cmb1_mwphy
select firstname , lastname from cmb1_mwrph
select firstname , lastname , vendorimportid from doctor where vendorimportid = 11

select chartnumber into #tmp1 from cmb1_mwpat where patienttype = 'Patient'
select distinct chartnumber from cmb1_mwpat where patienttype = 'Patient'
select distinct chartnumber from cmb1_mwpat where patienttype <> 'Patient'

select count(*) from cmb1_mwcas
select count( distinct chartnumber ) from cmb1_mwcas

select count(*) from #tmp1

select count( distinct A.chartnumber )
	from cmb1_mwcas A
		inner join #tmp1 B on A.chartnumber = B.chartnumber

select A.chartnumber , A.casenumber , B.chartnumber
	from cmb1_mwcas A
		right outer join #tmp1 B on A.chartnumber = B.chartnumber
	where isnull( A.chartnumber , '' ) = ''

select count(*) from cmb1_mwcas where chartnumber is null

select A.chartnumber
		, convert( varchar(20) , max( convert( int , A.casenumber ) ) ) as casenumber
		into #tmp2
	from cmb1_mwcas A
	group by A.chartnumber

select A.vendorid as p_vendorid
		, B.vendorid as pc_vendorid
		, C.casenumber
	from patient A
			inner join patientcase B on A.patientid = B.patientid
			left outer join
				( select A.chartnumber
					, convert( varchar(20) , max( convert( int , A.casenumber ) ) ) as casenumber
					from cmb1_mwcas A
					group by A.chartnumber
				) C on B.vendorid = C.casenumber
	where A.vendorimportid = 11
			and isnull( C.casenumber , '' ) = ''

-- Patients NOT having any case assigned to them.
select * from #tmp2 where chartnumber in ( 'BLOAM001' , 'FRECA000' , 'HALBI008' , 'HEZHE000' , 'JONBI000' , 'JONBI002' , 'RASPA000' , 'SCOMI001' )
select * from cmb1_mwcas where chartnumber in ( 'BLOAM001' , 'FRECA000' , 'HALBI008' , 'HEZHE000' , 'JONBI000' , 'JONBI002' , 'RASPA000' , 'SCOMI001' )
select A.* from patientcase A where vendorid in ( 'BLOAM001' , 'FRECA000' , 'HALBI008' , 'HEZHE000' , 'JONBI000' , 'JONBI002' , 'RASPA000' , 'SCOMI001' )

select count(*) from insurancepolicy where vendorimportid = 11
select count(*) from insurancepolicy where vendorimportid = 11 and precedence = 1
select count(*) from insurancepolicy where vendorimportid = 11 and precedence = 2
select count(*) from insurancepolicy where vendorimportid = 11 and precedence = 3

-- First Insurance Policy.
select A.chartnumber
		, A.casenumber
		, B.insurancecarrier1
		, B.insured1
		, B.policynumber1
		, B.groupnumber1
		, B.InsuredRelationship1
	from #tmp2 A
		inner join cmb1_mwcas B on A.chartnumber = B.chartnumber and A.casenumber = B.casenumber
		inner join cmb1_mwpat C on C.chartnumber = B.chartnumber and C.chartnumber = A.chartnumber
	where isnull( B.insurancecarrier1 , '' ) <> ''
	order by A.chartnumber , A.casenumber

-- Secondary Insurance Policy.
select A.chartnumber
		, A.casenumber
		, B.insurancecarrier2
		, B.insured2
		, B.policynumber2
		, B.groupnumber2
	from #tmp2 A
		inner join cmb1_mwcas B on A.chartnumber = B.chartnumber and A.casenumber = B.casenumber
		inner join cmb1_mwpat C on C.chartnumber = B.chartnumber and C.chartnumber = A.chartnumber
	where isnull( B.insurancecarrier2 , '' ) <> ''

-- Tertiary Insurance Policy.
select A.chartnumber
		, A.casenumber
		, B.insurancecarrier3
		, B.insured3
		, B.policynumber3
		, B.groupnumber3
	from #tmp2 A
		inner join cmb1_mwcas B on A.chartnumber = B.chartnumber and A.casenumber = B.casenumber
		inner join cmb1_mwpat C on C.chartnumber = B.chartnumber and C.chartnumber = A.chartnumber
	where isnull( B.insurancecarrier3 , '' ) <> ''

-- Check for missing insurancecompanyplanid
select A.InsuranceCompanyPlanID
	from InsurancePolicy A
	where not exists ( select * from insurancecompanyplan B where A.insurancecompanyplanid = B.insurancecompanyplanid )
			and vendorimportid = 11

select A.* into #tmp3
	from cmb1_mwcas	A
			inner join cmb1_mwpat B on A.chartnumber = B.chartnumber
			inner join #tmp2 C on A.chartnumber = C.chartnumber and A.casenumber = C.casenumber

select count(*) from #tmp3 where isnull( policynumber1 , '' ) <> ''
select count(*) from #tmp3 where isnull( policynumber2 , '' ) <> ''
select count(*) from #tmp3 where isnull( policynumber3 , '' ) <> ''

-- Check insurance policy numbers for first insurance carrier.
select A.chartnumber , A.casenumber , A.policynumber1 , D.policynumber
	from #tmp3 A
			inner join patient B on B.vendorid = A.chartnumber
			inner join patientcase C on C.patientid = B.patientid and C.vendorid = A.casenumber
			inner join insurancepolicy D on D.patientcaseid = C.patientcaseid
	where B.vendorimportid = 11
			and C.vendorimportid = 11
			and D.vendorimportid = 11
			and D.precedence = 1
			and A.policynumber1 <> D.policynumber

-- Check insurance policy numbers for second insurance carrier.
select A.chartnumber , A.casenumber , A.policynumber2 , D.policynumber
	from #tmp3 A
			inner join patient B on B.vendorid = A.chartnumber
			inner join patientcase C on C.patientid = B.patientid and C.vendorid = A.casenumber
			inner join insurancepolicy D on D.patientcaseid = C.patientcaseid
	where B.vendorimportid = 11
			and C.vendorimportid = 11
			and D.vendorimportid = 11
			and D.precedence = 2
			and A.policynumber2 <> D.policynumber

-- Check insurance policy numbers for third insurance carrier.
select A.chartnumber , A.casenumber , A.policynumber3 , D.policynumber
	from #tmp3 A
			inner join patient B on B.vendorid = A.chartnumber
			inner join patientcase C on C.patientid = B.patientid and C.vendorid = A.casenumber
			inner join insurancepolicy D on D.patientcaseid = C.patientcaseid
	where B.vendorimportid = 11
			and C.vendorimportid = 11
			and D.vendorimportid = 11
			and D.precedence = 3
			and A.policynumber3 <> D.policynumber
