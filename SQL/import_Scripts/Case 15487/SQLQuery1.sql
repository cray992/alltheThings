
use superbill_0670_prod

select * from superbill_shared.dbo.customer

select State , count(*) as StateCount
    from superbill_shared.dbo.customer
    group by state
    order by count(*) desc

select * from superbill_shared.dbo.customer where state = 'CA'

select * from impPatients15487

select distinct responsible from impPatients15487
select distinct status from impPatients15487

select

select * from practice

use superbill_0121_prod
select * from practice
select * from patient where practiceid = 4

Insert Into Practice
( [Name] )
Values
( 'Debra Carter Miller' )

create synonym iPatient for impPatients15487

select * from iPatient

alter table impPatients15487
    add PatientName2 Varchar(100)

alter table impPatients15487
    add VendorID Varchar(25)

alter table impPatients15487
    add FirstName Varchar(35)

alter table impPatients15487
    add MiddleInitial Varchar(1)

alter table impPatients15487
    add LastName Varchar(35)

alter table impPatients15487
    add Suffix Varchar(10)

Update iPatient
    Set PatientName2 = PatientName

-- Update iPatient Set PatientName = PatientName2

Select PatientName
        , Replace( PatientName , 'Sr.,' , '' )
    From iPatient
    Where PatientName Like '%Sr.,%'

Update iPatient
    Set Suffix = 'Sr'
        , PatientName = Replace( PatientName , 'Sr.,' , '' )
    Where PatientName Like '%Sr.,%'

Select PatientName
    From iPatient
    Where Suffix Like '%Sr%'

Select PatientName
        , Replace( PatientName , 'Jr.' , '' )
    From iPatient
    Where PatientName Like '%Jr.%'

Update iPatient
    Set Suffix = 'Jr'
        , PatientName = Replace( PatientName , 'Jr.' , '' )
    Where PatientName Like '%Jr.%'

Select PatientName
    From iPatient
    Where Suffix Like '%Jr%'

select PatientName
        , Len( Ltrim( Rtrim( PatientName ) ) ) As Length
        -- , CharIndex( '(' , PatientName  ) As StartPos
        -- , CharIndex( ')' , PatientName  ) - CharIndex( '(' , PatientName  ) - 1 As Width
        , SubString( LTrim( Rtrim( PatientName ) ) , CharIndex( '(' , PatientName  ) + 1 ,  ( CharIndex( ')' , PatientName  ) - CharIndex( '(' , PatientName  ) - 1 ) ) As VendorID
        , Left( PatientName , CharIndex( '(' , PatientName  ) - 1 ) As NewPatientName
    from iPatient

-- Update VendorID.
update A
    set VendorID = SubString( LTrim( Rtrim( PatientName ) ) , CharIndex( '(' , PatientName  ) + 1 ,  ( CharIndex( ')' , PatientName  ) - CharIndex( '(' , PatientName  ) - 1 ) )
        , PatientName = Left( PatientName , CharIndex( '(' , PatientName  ) - 1 )
    from iPatient A

select PatientName
        , VendorID
        , Case When CharIndex( ',' , PatientName ) > 0 Then Left( PatientName , CharIndex( ',' , PatientName ) - 1 ) 
          Else PatientName End As LastName
    from iPatient
    where CharIndex( ',' , PatientName ) = 0

Update iPatient
    Set PatientName = 'Gilkey, Charles L'
    Where VendorID = 'GILCH000'

-- Update LastName.
Update A
    Set LastName = Left( PatientName , CharIndex( ',' , PatientName ) - 1 )
        , PatientName = SubString( PatientName , CharIndex( ',' , PatientName  ) + 1 , Len( PatientName ) )
    From iPatient A

select PatientName
        , VendorID
        , LastName
    from iPatient

Update A
    Set PatientName = LTrim( RTrim( PatientName ) )
    From iPatient A

-- FirstName
Select PatientName
        , VendorID
        , LastName
        , Suffix
        , CharIndex( ' ' , PatientName )
        , Case 
            When CharIndex( ' ' , PatientName ) = 0 Then PatientName
            When CharIndex( ' ' , PatientName ) > 0 Then Left( PatientName , CharIndex( ' ' , PatientName ) - 1 )
          End As FirstName
        , Case 
            When CharIndex( ' ' , PatientName ) = 0 Then Null
            When CharIndex( ' ' , PatientName ) > 0 Then SubString( PatientName , CharIndex( ' ' , PatientName ) + 1 , Len( PatientName ) )
          End As MiddleInitial
    From iPatient
    Where Len( Case 
            When CharIndex( ' ' , PatientName ) = 0 Then Null
            When CharIndex( ' ' , PatientName ) > 0 Then SubString( PatientName , CharIndex( ' ' , PatientName ) + 1 , Len( PatientName ) )
          End ) > 1

Update iPatient Set FirstName = 'Audrey' , MiddleInitial = 'F' Where VendorID = 'ANDAU000'
Update iPatient Set FirstName = 'Baby Boy' , MiddleInitial = '' Where VendorID = 'BOLBA000'
Update iPatient Set FirstName = 'Nathaniel' , MiddleInitial = '' , Suffix = 'Jr' Where VendorID = 'BROWNJ0000'
Update iPatient Set FirstName = 'Nathaniel' , MiddleInitial = 'F' Where VendorID = 'BROWN,0000'
Update iPatient Set FirstName = 'Daniel' , MiddleInitial = 'B' Where VendorID = 'CARDA001'
Update iPatient Set FirstName = 'La Kisha' , MiddleInitial = 'J' Where VendorID = 'COCLA000'
Update iPatient Set FirstName = 'Ke Mora' , MiddleInitial = 'S' Where VendorID = 'COLKE000'
Update iPatient Set FirstName = 'Orron' , MiddleInitial = 'L' , Suffix = 'Sr' Where VendorID = 'COLOR000'
Update iPatient Set FirstName = 'Gail' , MiddleInitial = 'M' Where VendorID = 'DAVGA000'
Update iPatient Set FirstName = 'Caroline' , MiddleInitial = '' Where VendorID = 'ECHCA000'
Update iPatient Set FirstName = 'Charles' , MiddleInitial = 'W' Where VendorID = 'ELLCH000'
Update iPatient Set FirstName = 'David' , MiddleInitial = 'L' , Suffix = 'Jr' Where VendorID = 'FLEDA000'
Update iPatient Set FirstName = 'Mary' , MiddleInitial = 'Ellen' Where VendorID = 'FLOMA000'
Update iPatient Set FirstName = 'CYNTHIA' , MiddleInitial = '' Where VendorID = 'HALL,0000'
Update iPatient Set FirstName = 'Charlie Mae' , LastName = 'Harris' , MiddleInitial = '' Where VendorID = 'HARRIS0001'
Update iPatient Set FirstName = 'Walter' , MiddleInitial = '' Where VendorID = 'HARWA001'
Update iPatient Set FirstName = 'Patricia' , MiddleInitial = '' Where VendorID = 'JACPA000'
Update iPatient Set FirstName = 'Ed Willie' , MiddleInitial = '' Where VendorID = 'JORDAN0000'


Update A
    Set FirstName = Case 
            When CharIndex( ' ' , PatientName ) = 0 Then PatientName
            When CharIndex( ' ' , PatientName ) > 0 Then Left( PatientName , CharIndex( ' ' , PatientName ) - 1 )
          End
        , PatientName = Case 
            When CharIndex( ' ' , PatientName ) = 0 Then Null
            When CharIndex( ' ' , PatientName ) > 0 Then SubString( PatientName , CharIndex( ' ' , PatientName ) + 1 , Len( PatientName ) )
          End
    From iPatient A
    Where IsNull( FirstName , '' ) = ''

Select PatientName
        , VendorID
        , LastName
        , FirstName
        , MiddleInitial
        , Suffix
    From iPatient
    -- Where Rtrim( LTrim( FirstName ) ) = ','
    -- Where Len( IsNull( PatientName , '' ) ) = 1
    Where IsNull( PatientName , '' ) <> ''

Update A
    Set MiddleInitial = PatientName
        , PatientName = ''
    From iPatient A
    Where Len( IsNull( PatientName , '' ) ) = 1

Update A
    Set LastName = 'Brown'
    From iPatient A
    Where VendorID = 'BROWNJ0000'

-- drop table impPatients15487

Select PatientName
        , VendorID
        , LastName
        , FirstName
        , MiddleInitial
        , Suffix
        , *
        , Case
            When Sex = 'Male' Then 'M'
            When Sex = 'Female' Then 'F'
            Else 'U'
          End
    From iPatient

select * from practice

usp_columns impPatients15487

select firstname , lastname , maritalstatus , dob from iPatient

select distinct maritalstatus from iPatient

select * from maritalstatus

select firstname , lastname , employmentstatus from iPatient

select distinct employmentstatus from iPatient

select * from employmentstatus

usp_columns Patient

select patientcode from iPatient

select firstname
        , lastname
        , ( Select dbo.fn_GetNumber( A.HomePhone ) ) As HomePhone
        , ( Select dbo.fn_GetNumber( A.WorkPhone ) ) As WorkPhone
        , ZipCode
    from iPatient A
    where len( dbo.fn_GetNumber( A.HomePhone ) ) > 10
            or len( dbo.fn_GetNumber( A.HomePhone ) ) > 10
            or len( dbo.fn_GetNumber( A.zipcode ) ) > 9

    Select
      4 As PracticeID
      , '' As Prefix
      , A.FirstName
      , A.MiddleInitial
      , A.LastName
      , A.Suffix
      , A.Address1
      , A.Address2
      , A.City
      , A.State
      , A.ZipCode
      , ( Select dbo.fn_GetNumber( A.HomePhone ) ) As HomePhone
      , ( Select dbo.fn_GetNumber( A.WorkPhone ) ) As WorkPhone
      , ( Select dbo.fn_GetNumber( A.MobilePhone ) ) As MobilePhone
      , Case
            When Sex = 'Male' Then 'M'
            When Sex = 'Female' Then 'F'
            Else 'U'
        End As Gender
      , Case
            When MaritalStatus = 'Single' Then 'S'
            When MaritalStatus = 'Married' Then 'M'
            When MaritalStatus = 'Divorced' Then 'D'
            When MaritalStatus = 'Widowed' Then 'W'
            When IsNull( MaritalStatus , '' ) = '' Then Null
            Else 'U'
        End As MaritalStatus
      , Convert( Datetime , DOB ) As DOB
      , ( Select dbo.fn_GetNumber( A.SSN ) ) As SSN
      , HomeEmail As EmailAddress
      , Case When EmploymentStatus = 'Employment' Then 'E'
             When EmploymentStatus = 'Employment Full time' Then 'E'
             When EmploymentStatus = 'Employment Retired' Then 'R'
             When EmploymentStatus = 'Employment Not employed' Then Null
        Else 'U'
        End As EmploymentStatus
      , A.VendorID As MedicalRecordNumber
      , A.VendorID
      , 0 As VendorImportID
    From iPatient A
    Where Len( State ) > 2


Select * From iPatient 
    -- where len( select dbo.fn_getnumber( workphone ) from iPatient ) > 10
    where len( dbo.fn_getnumber( workphone ) ) > 10

select * from patient where workphoneext = '321'

drop table #tmp1

select distinct primaryinsurance as insurancecompany into #tmp1 from impPatients15487 where isnull( primaryinsurance , '' ) <> ''
union
select distinct secondaryinsurance from impPatients15487 where isnull( secondaryinsurance , '' ) <> ''
union
select distinct tertiaryinsurance from impPatients15487 where isnull( tertiaryinsurance , '' ) <> ''

select A.* 
    from #tmp1 A
            inner join insurancecompany B on A.insurancecompany = B.insurancecompanyname

    

select dateadd( ww , 8 , '10/24/2006' )

usp_columns impPatients15487

select A.firstname
        , A.lastname
        , A.referringphysician
    from iPatient A
    where isnull( A.referringphysician , '' ) <> ''

select distinct referringphysician from iPatient where isnull( referringphysician , '' ) <> ''

usp_columns doctor

select count(*) from iPatient where isnull( vendorid , '' ) <> ''

select * from vendorimport

usp_deleteimport 30

select * from doctor where practiceid = 4

select * from vendorimport

select referringphysicianid from patient where vendorimportid = 20

select * from doctor where vendorimportid = 23

select * from doctor where vendorimportid = 23

select * from patient where isnull( referringphysicianid , 0 ) <> 0 and practiceid = 4

usp_columns insurancecompany

select * from insurancecompany where vendorimportid = 28

select * from patient where practiceid = 4

select * from iPatient

select * from patientcase where vendorimportid = 29

select * from relationship

select firstname
        , lastname
        , DOB
        , copayamt
        , primaryinsurance
        , primarytype
        , primarygroupnumber
        , primaryid
        , primaryauthorization
        , primaryacceptassign
        , primaryinsured
        , primaryinsuredrelation
        , vendorid
    from iPatient
    where isnull( primaryinsurance , '' ) <> ''
            and ( isnull( primarygroupnumber , '' ) <> '' or isnull( primaryid , '' ) <> '' )
            and primaryinsured <> 'Self'

Select firstname
        , lastname
        , DOB
        , primarytype
        , primaryinsured
        , ( select dbo.fn_GetName2( PrimaryInsured , 'F' , 'FML' ) ) as FirstName
        , ( select dbo.fn_GetName2( PrimaryInsured , 'M' , 'FML' ) ) as MiddleName
        , ( select dbo.fn_GetName2( PrimaryInsured , 'L' , 'FML' ) ) as LastName
        , primaryinsuredrelation
        , vendorid
    from iPatient
    where isnull( primaryinsurance , '' ) <> ''
            and ( isnull( primarygroupnumber , '' ) <> '' or isnull( primaryid , '' ) <> '' )
            and primaryinsured <> 'Self'

select * from relationship

select firstname
        , lastname
        , DOB
        , copayamt
        , secondaryinsurance
        , secondarytype
        , secondarygroupnumber
        , secondaryid
        , secondaryauthorization
        , secondaryacceptassign
        , secondaryinsured
        , secondaryinsuredrelation
        , vendorid
    from iPatient
    -- where primaryinsured <> 'Self'
    where isnull( secondaryinsurance , '' ) <> ''
            and ( isnull( secondarygroupnumber , '' ) <> '' or isnull( secondaryid , '' ) <> '' )

select firstname
        , lastname
        , DOB
        , secondarytype
        , secondaryinsured
        , ( select dbo.fn_GetName2( secondaryInsured , 'F' , 'FML' ) ) as FirstName
        , ( select dbo.fn_GetName2( secondaryInsured , 'M' , 'FML' ) ) as MiddleName
        , ( select dbo.fn_GetName2( secondaryInsured , 'L' , 'FML' ) ) as LastName
        , secondaryinsuredrelation
        , vendorid
    from iPatient
    where isnull( secondaryinsurance , '' ) <> ''
            and ( isnull( secondarygroupnumber , '' ) <> '' or isnull( secondaryid , '' ) <> '' )
            and secondaryinsured <> 'Self'

select firstname
        , lastname
        , DOB
        , copayamt
        , tertiaryinsurance
        , tertiarytype
        , tertiarygroupnumber
        , tertiaryid
        , tertiaryauthorization
        , tertiaryacceptassign
        , tertiaryinsured
        , tertiaryinsuredrelation
        , vendorid
    from iPatient
    -- where primaryinsured <> 'Self'
    where isnull( tertiaryinsurance , '' ) <> ''
            and ( isnull( tertiarygroupnumber , '' ) <> '' or isnull( tertiaryid , '' ) <> '' )

Select firstname
        , lastname
        , DOB
        , tertiaryinsured
        , ( select dbo.fn_GetName2( TertiaryInsured , 'F' , 'FML' ) ) as FirstName
        , ( select dbo.fn_GetName2( TertiaryInsured , 'M' , 'FML' ) ) as MiddleName
        , ( select dbo.fn_GetName2( TertiaryInsured , 'L' , 'FML' ) ) as LastName
        , TertiaryInsuredRelation
        , vendorid
    from iPatient
    where isnull( TertiaryInsurance , '' ) <> ''
            and ( isnull( Tertiarygroupnumber , '' ) <> '' or isnull( TertiaryID , '' ) <> '' )
            and TertiaryInsured <> 'Self'

usp_columns impPatients15487

usp_columns InsuranceCompanyPlan

select * from vendorimport

usp_deleteimport 58

select * from insurancepolicy where vendorimportid = 45

select * from insurancecompany order by insurancecompanyname

select lastname
        , firstname
    into #d1
    from iPatient
    group by lastname , firstname having count(*) > 1

select A.lastname
        , A.firstname
        , A.vendorid
        , A.*
    from iPatient A
            inner join #d1 B on B.lastname = A.lastname and B.firstname = A.firstname
    order by A.lastname , A.firstname

usp_columns insurancepolicy

select HolderFirstName
        , HolderMiddleName
        , HolderLastName
        , PatientRelationshipToInsured
        , HolderThroughEmployer
    from InsurancePolicy
    where vendorimportid = 58
            and precedence = 2
            and isnull( HolderFirstName , '' ) <> ''
    order by HolderFirstName , HolderLastName

usp_columns insurancepolicy

select * from practice

select * from userpractices where userid = 1268

insert into userpractices
( userid , practiceid )
values
( 1268 , 4 )

select * from vendorimport order by vendorimportid desc

select * from patient where vendorimportid = 59

select * from insurancepolicy where vendorimportid = 59

select * from insurancepolicy where vendorimportid = 59 and isnull( holderfirstname , '' ) <> ''

select * from practice

select A.LastName
        , A.FirstName
        , PrimaryInsurance
        , PrimaryType
        , PrimaryID As PolicyNumber
        , A.PrimaryGroupNumber As GroupNumber
        , SecondaryInsurance
        , SecondaryType
        , SecondaryID As PolicyNumber2
        , A.SecondaryGroupNumber As GroupNumber2
        , TertiaryInsurance
        , TertiaryType
        , TertiaryID As PolicyNumber3
        , A.TertiaryGroupNumber As GroupNumber3
    from iPatient A
    where isnull( tertiaryinsurance , '' ) <> ''
    order by A.lastname , A.firstname

select distinct employeraddress1 from impPatients15487 where isnull( employeraddress1 , '' ) <> ''

select * from impPatients15487 where isnull( employeraddress1 , '' ) <> ''

usp_columns employers

select * from vendorimport order by vendorimportid desc

usp_deleteimport 6

select lastname , firstname , employeraddress1
    from iPatient 
    where isnull( employeraddress1 , '' ) <> ''

select * from impFeeSchedule15487

update impFeeSchedule15487
    set [column 42] = replace( [column 42] , '"' , '' )
        , [column 43] = replace( [column 43] , '"' , '' )
        , [column 50] = replace( [column 50] , '"' , '' )
        , [column 51] = replace( [column 51] , '"' , '' )
        , [column 52] = replace( [column 52] , '"' , '' )
        , [column 53] = replace( [column 53] , '"' , '' )
        , [column 55] = replace( [column 55] , '"' , '' )
        , [column 52] = replace( [column 52] , '$' , '' )

update impFeeSchedule15487
    set [column 52] = replace( [column 52] , '$' , '' )

select [column 42]
        , [column 43]
        , [column 50]
        , [column 51]
        , [column 52]
        , [column 53]
        , [column 55]
    from impFeeSchedule15487

select ProcedureCode
        , ProcedureCode2
        , StandardFee
    from impFeeSchedule15487

select A.ProcedureCode
        , A.StandardFee
    from impFeeSchedule15487 A
            inner join ProcedureCodeDictionary B On B.ProcedureCode = A.ProcedureCode
    where A.StandardFee <> '0.00'
    order by A.ProcedureCode
    
select Distinct A.ProcedureCode
        , A.StandardFee
    from impFeeSchedule15487 A
            left outer join ProcedureCodeDictionary B On B.ProcedureCode = A.ProcedureCode
    where A.StandardFee <> '0.00'
            and B.ProcedureCode Is Null
    order by A.ProcedureCode

select * from vendorimport order by vendorimportid desc

usp_deleteimport 10

select * from vendorimport order by vendorimportid desc
select distinct vendorimportid from employers
delete from employers where vendorimportid in ( 8 , 9 , 10 )


use superbill_0121_prod

select * from practice

select * from patient where practiceid = 4

select * from vendorimport order by vendorimportid desc

select min( createddate ) from patient
select max( createddate ) from patient

select * from doctor where practiceid = 4

select distinct referringphysician from iPatient where isnull( referringphysician , '' ) <> ''

select A.lastname
        , A.firstname
        , A.primaryid
        , A.secondaryid
        , A.tertiaryid
    from iPatient A
    where isnull( A.primaryid , '' ) like '%E+%'
            or isnull( A.secondaryid , '' ) like '%E+%'
            or isnull( A.tertiaryid , '' ) like '%E+%'
    order by A.lastname , A.firstname

usp_deleteimport 101

alter table contractfeeschedule
    add VendorImportID Int

select lastname , firstname
    from patient 
    where vendorimportid = 1
            and isnull( employerid , 0 ) <> 0
            and practiceid = 4

select * from vendorimport

update vendorimport set vendorformat = 'CSV'

select A.LastName
        , A.FirstName
        , case when C.precedence = 1 then 'Primary'
                when C.precedence = 2 then 'Secondary'
                when C.precedence = 3 then 'Tertiary'
          end as InsuranceType
        , C.PolicyNumber
    from patient A
            inner join patientcase B on B.patientid = A.patientid
            inner join insurancepolicy C on C.patientcaseid = B.patientcaseid
    where A.vendorimportid = 1
            and C.policynumber like '%E+%'
    order by A.lastname , A.firstname , C.precedence

