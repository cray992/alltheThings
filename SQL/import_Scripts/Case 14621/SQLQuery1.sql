
use superbill_0670_prod
go

select * from practice

select * from patient

select * from practice

select * from superbill_shared.dbo.customer

use superbill_0613_dev

Insert Into Practice
( [Name] )
Values
( 'Facial Plastic Reconstructive & Laser Surgery, LLC' )

Insert Into Practice
( [Name] )
Values
( 'Blumenthal' )

select * from impPatients14621
select * from impCarrier14621
select * from impInsPlan14621
select * from impPatIns14621
select * from impPatIpr14621
select * from impRefFile14621

select * from practice

use superbill_0613_prod

select * from practice

select * from patient

usp_columns impRefFile14621

select * from impReffile14621

usp_columns vendorimport

select * from iRefPhy

select * from vendorimport

select * from doctor where vendorimportid = 10

select * from iRefPhy order by convert( int , mm_ref_dr_no )

usp_deleteimport 11

delete A from doctor A where vendorimportid = 0
delete from vendorimport where vendorimportid = 9

create clustered index dx on impReffile14621 ( mm_ref_dr_no )
drop index impReffile14621.dx

select * from impReffile14621

alter table impReffile14621
    add RowNumber int identity(1,1)

select *
    from impReffile14621 A
    where rownumber >
               ( select min( rownumber ) from impReffile14621 B where B.mm_ref_dr_no = A.mm_ref_dr_no )

delete A
    from impReffile14621 A
    where rownumber >
               ( select min( rownumber ) from impReffile14621 B where B.mm_ref_dr_no = A.mm_ref_dr_no )

select * from doctor

select * from iPatient

select distinct state from iPatient

select distinct zipcode from iPatient where isnumeric( zipcode ) = 0

select distinct zipcode from iPatient where len( zipcode ) > 5

select distinct gender from iPatient

select distinct maritalstatus from iPatient

select distinct homephone from iPatient where len( homephone ) > 10

select distinct workphone from iPatient where len( workphone ) > 10

usp_columns impPatients14621

select distinct convert( datetime , dob ) from iPatient

select distinct ssn from iPatient where len( ssn ) < 9 order by ssn

select patientaccountid , notes from iPatient where isnull( notes , '' ) <> ''

select * from patient where practiceid = 2

select * from practice

select * from vendorimport

usp_deleteimport 4

select max( patientid ) from patient
dbcc checkident( 'patient' , 'RESEED' , 110 )
dbcc checkident( 'vendorimport' , 'RESEED' , 0 )

select * from iPatient

select * from patient where vendorimportid = 3

select * from iRefPhy

select * from impInsPlan14621

select * from impPatIns14621

select * from impPatIpr14621

select * from iDoctor

select * from doctor

-- Facial Practice

    Drop Synonym iDoctor
    Go
    Drop Synonym iRefPhy
    Go
    Drop Synonym iPatient
    Go
    Drop Synonym iInsCompany
    Go
    Drop Synonym iInsPlan
    Go
    Drop Synonym iInsPolicy
    Go
    Drop Synonym iInsParty
    Go

    Create Synonym iDoctor For impDoctors14621
    Go
    Create Synonym iRefPhy For impReffile14621
    Go
    Create Synonym iPatient For impPatients14621
    Go
    Create Synonym iInsCompany For impCarrier14621
    Go
    Create Synonym iInsPlan For impInsPlan14621
    Go
    Create Synonym iInsPolicy For impPatIns14621
    Go
    Create Synonym iInsParty For impPatIpr14621
    Go

usp_columns impInsPlan14621

usp_columns impCarrier14621

-- drop table impDoctors14621
-- drop table impPatIns14621
-- drop table impPatIpr14621
-- drop table impCarrier14621

select * from iInsPlan order by convert( int , InsurancePlanNo )
select * From iInsCompany order by insurancecompanycode
select * from iInsPolicy order by InsurancePolicyID

select * from iInsPolicy where isnull( insuredpartyno , '' ) <> ''

select count(*) from iPatient
select count(*) from iPatient where isnull( insuranceplan1 , '' ) <> ''
select count(*) from iPatient where isnull( insuranceplan2 , '' ) <> ''
select count(*) from iPatient where isnull( insuranceplan3 , '' ) <> ''

Select A.PatientAccountID As VendorID
        , A.FirstName As PatientFirstName
        , A.LastName As PatientLastName
        -- , E.InsuredPartyFirstName
        -- , E.InsuredPartyLastName
        , C.InsuranceCompanyName
        , A.InsurancePlan1
        -- , A.InsurancePlan2
        -- , A.InsurancePlan3
        , B.PlanName
        , D.InsurancePolicyNumber
        , D.InsurancePolicyGroupNumber
        , D.PolicyStartDate
        , D.PolicyEndDate
        , D.InsuredPartyNo
    From iPatient A
            Inner Join iInsPlan B On A.InsurancePlan2 = B.InsurancePlanNo
            Inner Join iInsCompany C On C.InsuranceCompanyCode = B.MM_CompanyID
            Inner Join iInsPolicy D On D.InsurancePolicyID = A.PatientAccountID
            -- Inner Join iInsParty E On D.InsuredPartyNo = E.InsuredPartyNo
    Order By VendorID

Select Distinct A.PatientAccountID As VendorID
    From iPatient A
            Inner Join iInsPlan B On A.InsurancePlan1 = B.InsurancePlanNo
            Inner Join iInsCompany C On C.InsuranceCompanyCode = B.MM_CompanyID
            Inner Join iInsPolicy D On D.InsurancePolicyID = A.PatientAccountID
    Order By VendorID

select count(*) from iPatient
select count(*) from iPatient where isnull( insuranceplan1 , '' ) <> ''

-- Bluementhal Practice
select * from impDoctors14621B
select * from impPatients14621B order by convert( int , patientaccountid )

select * from impPatIns14621B order by convert( int , insurancepolicyid )

select * from impPatIpr14621B

select * from impReffile14621B

select * from impProcedureCodes14621B

select * from impProcedureCodes14621


    Drop Synonym iDoctorB
    Go
    Drop Synonym iRefPhyB
    Go
    Drop Synonym iPatientB
    Go
    Drop Synonym iInsPolicyB
    Go
    Drop Synonym iInsPartyB
    Go

    Create Synonym iDoctorB For impDoctors14621B
    Go
    Create Synonym iRefPhyB For impReffile14621B
    Go
    Create Synonym iPatientB For impPatients14621B
    Go
    Create Synonym iInsPolicyB For impPatIns14621B
    Go
    Create Synonym iInsPartyB For impPatIpr14621B
    Go

select * from iDoctorB
select * from iRefPhyB
select * from iPatientB
select * from iInsPolicyB
select * from iInsPartyB

select * from iInsPlan order by convert( int , InsurancePlanNo )
select * From iInsCompany order by insurancecompanycode
select * from iInsPolicyB order by InsurancePolicyID
select * from iInsPartyB order by Convert( Int , InsuredPartyNo )

select count(*) from iPatientB
select count(*) from iPatientB where isnull( insuranceplan1 , '' ) <> ''
select count(*) from iPatientB where isnull( insuranceplan2 , '' ) <> ''
select count(*) from iPatientB where isnull( insuranceplan3 , '' ) <> ''

-- Insurance Policy.
Select A.PatientAccountID As VendorID
        , A.FirstName As PatientFirstName
        , A.LastName As PatientLastName
        -- , E.InsuredPartyFirstName
        -- , E.InsuredPartyLastName
        , C.InsuranceCompanyName
        , A.InsurancePlan1
        -- , A.InsurancePlan2
        -- , A.InsurancePlan3
        , B.PlanName
        , D.InsurancePolicyNumber
        , D.InsurancePolicyGroupNumber
        , D.PolicyStartDate
        , D.PolicyEndDate
        , D.InsuredPartyNo
    From iPatientB A
            Inner Join iInsPlan B On A.InsurancePlan3 = B.InsurancePlanNo
            Inner Join iInsCompany C On C.InsuranceCompanyCode = B.MM_CompanyID
            Inner Join iInsPolicyB D On D.InsurancePolicyID = A.PatientAccountID
            -- Inner Join iInsParty E On D.InsuredPartyNo = E.InsuredPartyNo
    Order By VendorID

Select Distinct A.PatientAccountID As VendorID
    From iPatientB A
            Inner Join iInsPlan B On A.InsurancePlan1 = B.InsurancePlanNo
            Inner Join iInsCompany C On C.InsuranceCompanyCode = B.MM_CompanyID
            Inner Join iInsPolicyB D On D.InsurancePolicyID = A.PatientAccountID
    Order By VendorID

-- Insured Party.
Select A.PatientAccountID As VendorID
        , A.FirstName As PatientFirstName
        , A.LastName As PatientLastName
        , E.InsuredPartyFirstName
        , E.InsuredPartyLastName
        , C.InsuranceCompanyName
        , A.InsurancePlan1
        , A.InsurancePlan2
        , A.InsurancePlan3
        , B.PlanName
        , D.InsurancePolicyNumber
        , D.InsurancePolicyGroupNumber
        , D.PolicyStartDate
        , D.PolicyEndDate
        , D.InsuredPartyNo
    From iPatientB A
            Inner Join iInsPlan B On A.InsurancePlan3 = B.InsurancePlanNo
            Inner Join iInsCompany C On C.InsuranceCompanyCode = B.MM_CompanyID
            Inner Join iInsPolicyB D On D.InsurancePolicyID = A.PatientAccountID
            Inner Join iInsPartyB E On D.InsuredPartyNo = E.InsuredPartyNo
    Order By VendorID

Select Count(*) From iInsPolicyB Where IsNull( InsuredPartyNo , '' ) <> ''

Select * From iInsPartyB

-- ===

select * from practice

select * from iDoctorB
select * from iRefPhyB
select * from iPatientB where isnull( referringphysicianid , '' ) = ''

select * from doctor

select * from patient where vendorimportid = 7

usp_columns patient

select A.vendorid , A.primaryproviderid , A.referringphysicianid
    from patient A
    where A.vendorimportid = 9

select * from insurancecompany

select * from iInsCompany

usp_columns insurancecompany

select * from iInsPlan where len( zipcode ) > 9

usp_columns InsuranceCompanyPlan

delete from iInsPlan where insuranceplanno = '18'

select * from iInsPolicyB where InsurancePlanNumber = '18'

select * from insurancecompany where vendorimportid = 12
select * from insurancecompanyplan where vendorimportid = 12

select * from patientcase where vendorimportid = 14

select * from iPatient where isnull( guarantoraspatient , '' ) = 'N'

select * from iInsPolicyB

select A.insurancepolicyid
        , A.insurancepolicynumber
        , A.insurancepolicygroupnumber
        , A.policystartdate
        , A.policyenddate
        , A.insuredpartyno
        -- , *
    from iInsPolicyB A
    order by A.insurancepolicyid

select * from iInsPartyB

Select 
    C.VendorID
    , B.Name
	 , C.LastName
	 , C.FirstName
	 , C.MiddleName
	 , E.InsuranceCompanyName
	 , D.PlanName As PlanName
	 , A.PolicyNumber
	 , A.GroupNumber
	From InsurancePolicy A
			Inner Join PatientCase B On A.PatientCaseID = B.PatientCaseID
			Inner Join Patient C On B.PatientID = C.PatientID
			Inner Join InsuranceCompanyPlan D On A.InsuranceCompanyPlanID = D.InsuranceCompanyPlanID
			Inner Join InsuranceCompany E On D.InsuranceCompanyID = E.InsuranceCompanyID
         Inner Join iInsPolicyB F On F.InsurancePolicyID = A.VendorID And F.InsurancePolicyNumber = A.PolicyNumber And F.InsurancePlanNumber = D.VendorID
         -- Inner Join iInsPartyB F On F.InsuredPartyNo = 
	Where A.VendorImportID = 22
			-- And Precedence = 1
         -- And A.VendorID = '1173'
   Order By C.VendorID


select * from iInsPolicyB where insurancepolicyid = '1014'
select * from iInsPolicyB where isnull( insurancepolicynumber , '' ) = ''
select * from iInsPolicyB where isnull( insuranceplannumber , '' ) = ''

select insurancepolicyid , insurancepolicynumber , count(*) as count1 into #tmp1
    from iInsPolicyB
    group by insurancepolicyid , insurancepolicynumber having count(*) > 1
    order by insurancepolicyid

select * from iInsPlan

select A.InsurancePolicyID
        , A.InsurancePolicyNumber
        , A.InsurancePolicyGroupNumber
        , A.InsurancePlanNumber
        , C.PlanName
        , A.InsuredPartyNo
    from iInsPolicyB A
            inner join #tmp1 B on A.insurancepolicyid = B.insurancepolicyid and A.insurancepolicynumber = B.insurancepolicynumber
            inner join iInsPlan C On A.InsurancePlanNumber = C.InsurancePlanNo
    order by A.insurancepolicyid

select * from InsurancePolicy where vendorid = '1173'

Select A.InsurancePolicyID
        , A.InsurancePolicyNumber
        , A.InsurancePolicyGroupNumber
        , A.InsurancePlanNumber
        , A.InsuredPartyNo
        , B.InsuranceCompanyPlanID
        , B.PlanName
        , B.VendorID
    From iInsPolicyB A
            Inner Join InsuranceCompanyPlan B On A.InsurancePlanNumber = B.VendorID
            Inner Join InsurancePolicy C On C.VendorID = A.InsurancePolicyID And C.InsuranceCompanyPlanID = B.InsuranceCompanyPlanID
    Where IsNull( A.InsuredPartyNo , '' ) <> ''
    -- Where A.InsurancePolicyID = '1020'
    Order By A.InsurancePolicyID
    -- Order By Convert( Int , A.InsuredPartyNo )

Select * From iInsPartyB

-- Insured Party/Holder.
Select C.InsuredPartyNo
        , F.FirstName As PatientFirstName
        , F.LastName As PatientLastName
        , D.InsuredPartyFirstName As HolderFirstName
        , D.InsuredPartyMiddleName As HolderMiddleName
        , D.InsuredPartyLastName As HolderLastName
        , D.InsuredPartyAddressLine1 As HolderAddressLine1
        -- , D.InsuredPartyAddressLine2 As HolderAddressLine2
        , D.InsuredPartyCity As HolderCity
        , D.InsuredPartyState As HolderState
        , D.InsuredPartyZipCode As HolderZipCode
        , D.InsuredPartyPolicyNumber As HolderSSN
        , D.InsuredPartyGender As HolderGender
        , Convert( Char(10) , Convert( Datetime , D.InsuredPartyDOB ) , 101 ) As HolderDOB
        , D.InsuredPartyPhone As HolderPhone
        -- , D.*
    From InsurancePolicy A
            Inner Join InsuranceCompanyPlan B On B.InsuranceCompanyPlanID = A.InsuranceCompanyPlanID
            Inner Join iInsPolicyB C On C.InsurancePolicyID = A.VendorID And C.InsurancePlanNumber = B.VendorID
            Inner Join iInsPartyB D On D.InsuredPartyNo = C.InsuredPartyNo
            Inner Join PatientCase E On E.PatientCaseID = A.PatientCaseID
            Inner Join Patient F On F.PatientID = E.PatientID
    Where A.VendorImportID = 23
            And IsNull( C.InsuredPartyNo , '' ) <> ''
    Order By Convert( Int , C.InsuredPartyNo )

select * 
    from iInsPolicyB 
    -- where IsNull( InsuredPartyNo , '' ) <> ''
    where InsuredPartyNo In ( '3' , '12' , '19' )
    order by Convert( Int , InsuredPartyNo )

select * from insurancecompanyplan where vendorimportid = 22

select PatientAccountID , InsurancePlan1 , InsurancePlan2 , InsurancePlan3 from iPatientB where patientaccountid = '1114'
select * from iInsPolicyB where insurancepolicyid = '1020'
select * from insurancepolicy where vendorid = '1020'

select count(*) from iPatientB where isnull( insuranceplan1 , '' ) <> ''
select count(*) from iPatientB where isnull( insuranceplan2 , '' ) <> ''
select count(*) from iPatientB where isnull( insuranceplan3 , '' ) <> ''

select count(*) from insurancepolicy where vendorimportid = 23 and precedence = 1
select count(*) from insurancepolicy where vendorimportid = 23 and precedence = 2
select count(*) from insurancepolicy where vendorimportid = 23 and precedence = 3

select * from patient where vendorimportid = 25
select * from patientcase where vendorimportid = 25
select count(*) from insurancecompany where vendorimportid = 25
select count(*) from insurancecompanyplan where vendorimportid = 25
select count(*) from insurancepolicy where vendorimportid = 25

select A.* 
    from impProcedureCodes14621B A
            inner join ProcedureCodeDictionary B On A.ProcedureCode = B.ProcedureCode

select A.* 
    from impProcedureCodes14621B A
            left outer join ProcedureCodeDictionary B On A.ProcedureCode = B.ProcedureCode
    where B.procedurecode is null
            and isnumeric( A.procedurecode ) = 1
            and IsNull( convert( decimal(10,2) , A.standardfee ) , 0 ) <> 0


drop table impServiceCode14621

sp_helptext usp_deleteimport

usp_columns contractfeeschedule

alter table contractfeeschedule
    add VendorImportID Int

select * from vendorimport order by vendorimportid desc

usp_deleteimport 25

select * from iFeesB where isnumeric( procedurecode ) = 1

select * from contractfeeschedule where vendorimportid = 26


select * from 

use superbill_0670_prod

select * from vendorimport

select * from practice

alter table contractfeeschedule
    add VendorImportID int

select * from insurancepolicy where vendorimportid = 2

select * from iInsPolicyB

usp_columns impPatients14621B
usp_columns impPatIns14621B

select insurancepolicyid , insuranceplannumber
        , convert( datetime , policystartdate )
        , convert( datetime , policyenddate )
    from iInsPolicyB 
    where isnull( policystartdate , '' ) <> '' or isnull( policyenddate , '' ) <> ''

select insurancepolicyid , insuranceplannumber
        , convert( datetime , policystartdate )
        , convert( datetime , policyenddate )
    from iInsPolicyB 
    where insurancepolicyid = '1461'

select insuranceplan1 , insuranceplan2 , insuranceplan3 from ipatientb where patientaccountid = '1461'

usp_deleteimport 2


select * from insurancepolicy where vendorimportid = 2 and isnull( policystartdate , '' ) <> ''

select B.LastName
        , B.FirstName
        , A.InsurancePlanNumber
        , C.PlanName
        , A.InsurancePolicyNumber
        , A.InsurancePolicyGroupNumber
        , A.InsurancePolicyID As VendorID
    from iInsPolicyB A
            inner join iPatientB B On B.PatientAccountID = A.InsurancePolicyID And B.InsurancePlan1 = A.InsurancePlanNumber
            inner join InsuranceCompanyPlan C On C.VendorID = B.InsurancePlan1
    order by B.LastName , B.FirstName

select * from impPatients14621B

select * from iInsPolicyB where insurancepolicyid = '1300'
select patientaccountid , insuranceplan1 , insuranceplan2 , insuranceplan3 from iPatientB where patientaccountid = '1300'

select * from iInsPolicyB where insurancepolicyid = '1461'
select patientaccountid , insuranceplan1 , insuranceplan2 , insuranceplan3 from iPatientB where patientaccountid = '1461'

select * from iRefPhyB

select * from contract

select * from vendorimport

select distinct vendorimportid from contractfeeschedule

select contractid , count(*) from contractfeeschedule group by contractid

usp_deleteimport 1

select * from insurancecompanyplan where vendorimportid = 3

select distinct vendorimportid from insurancecompany
select distinct vendorimportid from insurancepolicy
select distinct vendorimportid from patient
select distinct vendorimportid from patientcase

delete from insurancecompany where vendorimportid = 3

select * from insurancecompanyplan
    where insurancecompanyid in ( select insurancecompanyid from insurancecompany where vendorimportid = 3 )

select * from practice

select * from procedurecodedictionary where createddate between convert( datetime , '11/01/2006' ) and convert( datetime , '11/30/2006' )

select * from procedurecodedictionary where isnull( localname , '' ) <> ''

select * from procedurecodedictionary where convert( char(10) , modifieddate , 101 ) = '11/20/2006'

select distinct contractid from contractfeeschedule

select * from contract

select 