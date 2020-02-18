--Add functions used for import here

--

DECLARE @VendorImportID INT

Insert Into VendorImport
( VendorName
  , VendorFormat
  , Notes
)
Values
( 'Jes Us Medical Billing'
  , 'Microsoft Excel File'
  , 'Imported and delimited data using Excel Import Wizard. Delimiter is double quotes symbol.' 
 )

SET @VendorImportID=@@IDENTITY

Declare @count			Int
		, @practiceid	Int

Create Table #tmpPatient
( LastName                      Varchar(64)
  , FirstName                   Varchar(64)
  , MiddleName                  Varchar(64)
  , Suffix                      Varchar(16)
  , Guarantor                   Varchar(50)
  , ResponsibleLastName         Varchar(64)
  , ResponsibleFirstName        Varchar(64)
  , ResponsibleMiddleName       Varchar(64)
  , ResponsibleSuffix           Varchar(16)
  , DOB                         DateTime
  , AddressLine1                Varchar(256)
  , AddressLine2                Varchar(256)
  , City                        Varchar(128)
  , State                       Varchar(2)
  , ZipCode                     Varchar(9)
  , HomePhone                   Varchar(10)
  , SSN                         Char(9)
  , WorkPhone                   Varchar(10)
  , WorkPhoneExt                Varchar(10)
  , Gender                      Varchar(1)
  , VendorID                    Varchar(50)
  , Notes						Text
)

Insert Into #tmpPatient
( LastName
  , FirstName
  , MiddleName
  , Suffix
  , Guarantor
  -- , ResponsibleLastName
  , DOB
  , AddressLine1
  , AddressLine2
  , City
  , State
  , ZipCode
  , HomePhone
  , WorkPhone
  , WorkPhoneExt
  , SSN
  , Gender
  , VendorID
  , Notes
)
Select
  Left( IsNull( Lastname , '' ) , Len( IsNull( Lastname , '' ) ) - 1 ) As LastName
  -- LastName
  , FirstName
  , IsNull( MI , '' )
  , IsNull( Suffix , '' )
  , Guarantor
  -- , IsNull( Guarantor , '' )
  , BirthDate
  , IsNull( Street1 , '' )
  , IsNull( Street2 , '' )
  , IsNull( City , '' )
  , IsNull( ST , '' )
  , ( replace( IsNull( zip , '' ) , '-' , '' ) ) As Zip
  , ( substring( IsNull( homephone , '' ) , 2 , 3 ) + substring( IsNull( homephone , '' ) , 7 , 3 ) + substring( IsNull( homephone , '' ) , 11 , 4 ) ) As HomePhone
  , ( substring( IsNull( workphone , '' ) , 2 , 3 ) + substring( IsNull( workphone , '' ) , 7 , 3 ) + substring( IsNull( workphone , '' ) , 11 , 4 ) ) As WorkPhone
  , left( IsNull( workphoneext , '' ) , 10 ) As WorkPhoneExt
  , ( left( IsNull( ssn , '' ) , 3 ) + substring( IsNull( ssn , '' ) , 5 , 2 ) + substring( IsNull( ssn , '' ) , 8 , 4 ) ) As SSN
  , IsNull( Sex , '' )
  , IsNull( AccountNo , '' )
  , IsNull( Notes , '' )
From CustomerData

/*
Update #tmpPatient
	Set ResponsibleLastName = substring( guarantor , 1 , charindex( ' ' , guarantor ) )
		, Guarantor = substring( guarantor , charindex( ' ' , guarantor ) + 1 , len( ltrim( rtrim( isnull( guarantor , '' ) ) ) ) )

Update #tmpPatient
	Set ResponsibleFirstName = substring( guarantor , 1 , charindex( ' ' , guarantor ) )
		, Guarantor = substring( guarantor , charindex( ' ' , guarantor ) + 1 , len( ltrim( rtrim( isnull( guarantor , '' ) ) ) ) )

Update #tmpPatient
	Set ResponsibleMiddleName = left( isnull( guarantor , '' ) , 30 )
*/

Update #tmpPatient
	Set ResponsibleLastName = dbo.fn_GetName( guarantor , 'L' )

Update #tmpPatient
	Set ResponsibleFirstName = dbo.fn_GetName( guarantor , 'F' )

Update #tmpPatient
	Set ResponsibleMiddleName = dbo.fn_GetName( guarantor , 'M' )

--Never perform these unqualified statements unless your sure no other data exists
--prior to your import
--Delete From InsurancePolicy

--instead use
Delete From InsurancePolicy
WHERE VendorImportID=@VendorImportID

Delete PatientCase
WHERE VendorImportID=@VendorImportID

Delete Patient
WHERE VendorImportID=@VendorImportID

--Select @count = Count(*)
--	From Practice PR
--	Where PR.name = 'Convington'
--
--Select @count = IsNull( @count , 0 )
--
--If @count = 0
--Begin
--	Insert Into Practice
--		( Name )
--		Values
--		( 'Convington' )
--End
--
--Select @practiceid = PR.PracticeID
--	From Practice PR
--	Where PR.Name = 'Convington'
--
--If IsNull( @practiceid , 0 ) = 0
--Begin
--	RaisError( 'Practice ID Not Found.' , 11 , -1 )
--	Return -1
--End

--Do the lookup to see there is already a practice populated
--SELECT * FROM Practice

SET @practiceid=1

Insert Into Patient
( LastName
  , FirstName
  , MiddleName
  , Suffix
  , ResponsibleLastName
  , ResponsibleFirstName
  , ResponsibleMiddleName
  , DOB
  , AddressLine1
  , AddressLine2
  , City
  , State
  , ZipCode
  , HomePhone
  , WorkPhone
  , WorkPhoneExt
  , SSN
  , Gender
  -- , Notes
  , VendorID
  , VendorImportID
  , PracticeID
  , Prefix
)
Select
  LastName
  , FirstName
  , MiddleName
  , Suffix
  , ResponsibleLastName
  , ResponsibleFirstName
  , ResponsibleMiddleName
  , DOB
  , AddressLine1
  , AddressLine2
  , City
  , State
  , ZipCode
  , HomePhone
  , WorkPhone
  , WorkPhoneExt
  , SSN
  , Gender
  -- , Notes
  , VendorID
  , @VendorImportID	
  , @practiceid
  , ''
From #tmpPatient

-- Create PatientCase records.
Insert Into PatientCase
( PatientID
  , Name
  , PayerScenarioID
  , PracticeID
  , VendorID
  , VendorImportID
)
Select
  P.PatientID
  , IsNull( P.LastName , '' ) + ' ' + IsNull( P.FirstName , '' ) + ' ' + IsNull( P.MiddleName , '' )
  , 5 As PayerScenarioID
  , @practiceid
  , VendorID
  , VendorImportID
From Patient P
WHERE VendorImportID=@VendorImportID

-- Create insurance company and insurance policy records.
Delete From InsurancePolicy

Delete From InsuranceCompanyPlan

Delete From InsuranceCompany

Insert Into InsuranceCompany
	( InsuranceCompanyName )
Select Distinct upper( ltrim( rtrim( primaryinsurance ) ) )
	From customerdata
	Where isnull( primaryinsurance , '' ) <> ''
	Order by upper( ltrim( rtrim( primaryinsurance ) ) )

Insert Into InsuranceCompany
	( InsuranceCompanyName )
Select Distinct upper( ltrim( rtrim( secondaryinsurance ) ) )
	from customerdata
	where isnull( secondaryinsurance , '' ) <> ''
			and upper( ltrim( rtrim( secondaryinsurance ) ) ) not in
				( Select Distinct upper( ltrim( rtrim( primaryinsurance ) ) ) from customerdata where isnull( primaryinsurance , '' ) <> '' )
	order by upper( ltrim( rtrim( secondaryinsurance ) ) )

Insert Into InsuranceCompanyPlan
	( PlanName
	  , InsuranceCompanyID
	)
Select IC.InsuranceCompanyName
	  , IC.InsuranceCompanyID
	From InsuranceCompany IC

-- Primary Policy.
Insert Into InsurancePolicy
( PatientCaseID
  , PolicyNumber
  , InsuranceCompanyPlanID
  , PatientRelationshipToInsured
  , PracticeID
  , HolderFirstName
  , HolderMiddleName
  , HolderLastName
  , HolderSuffix
  , HolderDOB
  , HolderSSN 
  , HolderGender
  , HolderAddressLine1
  , HolderAddressLine2
  , HolderCity
  , HolderState
  , HolderCountry
  , HolderZipCode
  , HolderPhone
  , HolderPhoneExt
  -- , Copay
  -- , Deductible
  , VendorID
)
Select
	PC.patientcaseid
	, CD.primarypolicy
	, ICP.InsuranceCompanyPlanID
	, 'S'
	, 2
	, P.FirstName
	, P.MiddleName
	, P.LastName
	, P.Suffix
	, P.DOB
	, P.SSN
	, P.Gender
	, P.AddressLine1
	, P.AddressLine2
	, P.City
	, P.State
	, P.Country
	, P.ZipCode
	, P.HomePhone
	, P.HomePhoneExt
	, P.VendorID
	From customerdata CD
			Inner Join Patient P On CD.AccountNo = P.VendorID
			Inner Join PatientCase PC On PC.PatientID = P.PatientID
			Inner Join InsuranceCompany IC On IC.InsuranceCompanyName = CD.PrimaryInsurance
			Inner Join InsuranceCompanyPlan ICP On ICP.InsuranceCompanyID = IC.InsuranceCompanyID
	Where IsNull( CD.PrimaryInsurance , '' ) <> ''

-- Secondary Policy.
Insert Into InsurancePolicy
( PatientCaseID
  , PolicyNumber
  , InsuranceCompanyPlanID
  , PatientRelationshipToInsured
  , PracticeID
  , HolderFirstName
  , HolderMiddleName
  , HolderLastName
  , HolderSuffix
  , HolderDOB
  , HolderSSN 
  , HolderGender
  , HolderAddressLine1
  , HolderAddressLine2
  , HolderCity
  , HolderState
  , HolderCountry
  , HolderZipCode
  , HolderPhone
  , HolderPhoneExt
  -- , Copay
  -- , Deductible
  , VendorID
)
Select
	PC.patientcaseid
	, CD.secondarypolicy
	, ICP.InsuranceCompanyPlanID
	, 'S'
	, 2
	, P.FirstName
	, P.MiddleName
	, P.LastName
	, P.Suffix
	, P.DOB
	, P.SSN
	, P.Gender
	, P.AddressLine1
	, P.AddressLine2
	, P.City
	, P.State
	, P.Country
	, P.ZipCode
	, P.HomePhone
	, P.HomePhoneExt
	, P.VendorID
	From customerdata CD
			Inner Join Patient P On CD.AccountNo = P.VendorID
			Inner Join PatientCase PC On PC.PatientID = P.PatientID
			Inner Join InsuranceCompany IC On IC.InsuranceCompanyName = CD.SecondaryInsurance
			Inner Join InsuranceCompanyPlan ICP On ICP.InsuranceCompanyID = IC.InsuranceCompanyID
	Where IsNull( CD.SecondaryInsurance , '' ) <> ''

-- Update as 'Self-Pay' if there is no insurance policy.
Update PC
	Set PayerScenarioID = 11
	From PatientCase PC
	Where PatientCaseID Not In ( Select PatientCaseID From InsurancePolicy )

--Drop functions used for import here
