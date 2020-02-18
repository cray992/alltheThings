Set NoCount On

Declare @PracticeID			Int
		, @VendorImportID	Int
		, @RowsCreated		Int

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

Select @VendorImportID = @@Identity

Print 'Vendor Import ID : ' + Convert( Varchar(20) , @VendorImportID )

Select @PracticeID = 1

/*
Drop Table #tmpPatient
Drop Table #tmp1
Drop Table #tmp2
Drop Table #tmp3
*/

Create Table #tmpPatient
( LastName								Varchar(64)
  , FirstName							Varchar(64)
  , MiddleName							Varchar(64)
  , Suffix								Varchar(16)
  , Guarantor							Varchar(50)
  , ResponsibleLastName					Varchar(64)
  , ResponsibleFirstName				Varchar(64)
  , ResponsibleMiddleName				Varchar(64)
  , ResponsibleSuffix					Varchar(16)
  , DOB									DateTime
  , AddressLine1						Varchar(256)
  , AddressLine2						Varchar(256)
  , City								Varchar(128)
  , State								Varchar(2)
  , ZipCode								Varchar(9)
  , HomePhone							Varchar(10)
  , SSN									Char(9)
  , WorkPhone							Varchar(10)
  , WorkPhoneExt						Varchar(10)
  , Gender								Varchar(1)
  , ReferredBy							Varchar(30)
  , ReferringPhysicianID				Int Null
  , VendorID							Varchar(50)
  , Notes								Varchar(255)
  , ResponsibleDifferentThanPatient		Bit Default 1
  , ResponsibleRelationshipToPatient	Char(1) Null
)

-- If there is no SSN, set the column to NULL instead of blank or empty string.

Insert Into #tmpPatient
( LastName
  , FirstName
  , MiddleName
  , Suffix
  , Guarantor
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
  , ReferredBy
  , VendorID
  , Notes
)
Select
  LTrim( RTrim( Left( IsNull( Lastname , '' ) , Len( IsNull( Lastname , '' ) ) - 1 ) ) ) As LastName
  , LTrim( RTrim( FirstName ) )
  , LTrim( RTrim( IsNull( MI , '' ) ) )
  , IsNull( Suffix , '' )
  , LTrim( RTrim( Guarantor ) )
  , BirthDate
  , IsNull( Street1 , '' )
  , IsNull( Street2 , '' )
  , IsNull( City , '' )
  , IsNull( ST , '' )
  , left( replace( IsNull( zip , '' ) , '-' , '' ) , 9 ) As Zip
  , ( substring( IsNull( homephone , '' ) , 2 , 3 ) + substring( IsNull( homephone , '' ) , 7 , 3 ) + substring( IsNull( homephone , '' ) , 11 , 4 ) ) As HomePhone
  , ( substring( IsNull( workphone , '' ) , 2 , 3 ) + substring( IsNull( workphone , '' ) , 7 , 3 ) + substring( IsNull( workphone , '' ) , 11 , 4 ) ) As WorkPhone
  , left( IsNull( workphoneext , '' ) , 10 ) As WorkPhoneExt
  , Case 
	When RTrim( LTrim( IsNull( ssn , '' ) ) ) = '' Then Null
	Else Left( IsNull( ssn , '' ) , 3 ) + SubString( IsNull( ssn , '' ) , 5 , 2 ) + SubString( IsNull( ssn , '' ) , 8 , 4 )
	End As SSN
  -- , ( left( IsNull( ssn , '' ) , 3 ) + substring( IsNull( ssn , '' ) , 5 , 2 ) + substring( IsNull( ssn , '' ) , 8 , 4 ) ) As SSN
  , IsNull( Sex , '' )
  , ReferredBy
  , IsNull( AccountNo , '' )
  , IsNull( Notes , '' )
From CustomerData

Update T
	Set ReferringPhysicianID = D.DoctorID
	From #tmpPatient T
			Inner Join Doctor D On T.ReferredBy = D.LastName
	Where IsNull( T.ReferredBy , '' ) <> ''
			And D.PracticeID = @PracticeID

Update T
	Set ResponsibleDifferentThanPatient = 0
	From #tmpPatient T
	Where LastName = dbo.fn_GetName( guarantor , 'L' )
			And FirstName = dbo.fn_GetName( guarantor , 'F' )

Update #tmpPatient
	Set ResponsibleLastName = dbo.fn_GetName( guarantor , 'L' )
WHERE ResponsibleDifferentThanPatient<>0

Update #tmpPatient
	Set ResponsibleFirstName = dbo.fn_GetName( guarantor , 'F' )
WHERE ResponsibleDifferentThanPatient<>0

Update #tmpPatient
	Set ResponsibleMiddleName = dbo.fn_GetName( guarantor , 'M' )
WHERE ResponsibleDifferentThanPatient<>0

Select @RowsCreated = @@RowCount
Print Convert( Varchar(20) , @RowsCreated ) + ' row(s) updated for ResponsibleDifferentThanPatient.'

-- O : Other.
Update T
	Set ResponsibleRelationshipToPatient = 'O'
	From #tmpPatient T
	Where ResponsibleDifferentThanPatient = 1
			And IsNull( ResponsibleLastName , '' ) <> ''

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
  , PracticeID
  , Prefix
  , MedicalRecordNumber
  , ReferringPhysicianID
  , ResponsibleDifferentThanPatient
  , ResponsibleRelationshipToPatient
  , VendorImportID
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
  , @PracticeID
  , ''
  , VendorID
  , ReferringPhysicianID
  , ResponsibleDifferentThanPatient
  , ResponsibleRelationshipToPatient
  , @VendorImportID
From #tmpPatient

Select @RowsCreated = @@RowCount
Print Convert( Varchar(20) , @RowsCreated ) + ' row(s) created in Patient table.'

-- Create records in PatientJournalNote for referring physicians not found in the doctor table.
Insert Into PatientJournalNote
	( PatientID
	  , UserName
	  , SoftwareApplicationID
	  , Hidden
	  , NoteMessage
	 )
Select P.PatientID
	   , 'Data Import'
	   , 'B'
	   , 0
       , 'Referred By Dr. ' + TP.ReferredBy
	From Patient P
			Inner Join #tmpPatient TP On P.VendorID = TP.VendorID
	Where P.VendorImportID = @VendorImportID
			And IsNull( TP.ReferringPhysicianID , 0 ) = 0
			And IsNull( TP.ReferredBy , '' ) <> ''

Select @RowsCreated = @@RowCount
Print Convert( Varchar(20) , @RowsCreated ) + ' row(s) created in PatientJournalNote table for Physician Referrals.'

-- Create Patient Notes.
Insert Into PatientJournalNote
	( PatientID
	  , UserName
	  , SoftwareApplicationID
	  , Hidden
	  , NoteMessage
	 )
Select P.PatientID
	   , 'Data Import'
	   , 'B'
	   , 0
       , TP.Notes
	From Patient P
			Inner Join #tmpPatient TP On P.VendorID = TP.VendorID
	Where P.VendorImportID = @VendorImportID
			And RTrim( LTrim( IsNull( TP.Notes , '' ) ) ) <> ''

Select @RowsCreated = @@RowCount
Print Convert( Varchar(20) , @RowsCreated ) + ' row(s) created in PatientJournalNote table for Notes.'

-- Create PatientCase records.
Insert Into PatientCase
( PatientID
  , Name
  , PayerScenarioID
  , PracticeID
  , VendorImportID
)
Select
  P.PatientID
  -- , IsNull( P.LastName , '' ) + ' ' + IsNull( P.FirstName , '' ) + ' ' + IsNull( P.MiddleName , '' )
  , 'Default Case'
  , 5 As PayerScenarioID
  , P.PracticeID
  , P.VendorImportID
From Patient P
Where P.VendorImportID = @VendorImportID

Select @RowsCreated = @@RowCount
Print Convert( Varchar(20) , @RowsCreated ) + ' row(s) created in PatientCase table.'

Insert Into InsuranceCompany
	( InsuranceCompanyName 
	  , VendorImportID )
Select Distinct upper( ltrim( rtrim( primaryinsurance ) ) )
				, @VendorImportID
	From customerdata
	Where isnull( primaryinsurance , '' ) <> ''
			And upper( ltrim( rtrim( primaryinsurance ) ) ) Not In ( Select insurancecompanyname From insurancecompany )
	Order by upper( ltrim( rtrim( primaryinsurance ) ) )

Select @RowsCreated = @@RowCount
Print Convert( Varchar(20) , @RowsCreated ) + ' row(s) created in InsuranceCompany table for Primary Insurance.'

Insert Into InsuranceCompany
	( InsuranceCompanyName 
	  , VendorImportID )
Select Distinct upper( ltrim( rtrim( secondaryinsurance ) ) )
				, @VendorImportID
	from customerdata
	where isnull( secondaryinsurance , '' ) <> ''
			And upper( ltrim( rtrim( secondaryinsurance ) ) ) not in
				( Select Distinct upper( ltrim( rtrim( primaryinsurance ) ) ) from customerdata where isnull( primaryinsurance , '' ) <> '' )
			And upper( ltrim( rtrim( secondaryinsurance ) ) ) Not In ( Select insurancecompanyname From insurancecompany )
	order by upper( ltrim( rtrim( secondaryinsurance ) ) )

Select @RowsCreated = @@RowCount
Print Convert( Varchar(20) , @RowsCreated ) + ' row(s) created in InsuranceCompany table for Secondary Insurance.'

Insert Into InsuranceCompany
	( InsuranceCompanyName 
	  , VendorImportID )
Select Distinct upper( ltrim( rtrim( col02 ) ) )
				, @VendorImportID
	from customerdata
	where isnull( col02 , '' ) <> ''
			And upper( ltrim( rtrim( col02 ) ) )
				Not In ( Select insurancecompanyname From insurancecompany )
	order by upper( ltrim( rtrim( col02 ) ) )

Select @RowsCreated = @@RowCount
Print Convert( Varchar(20) , @RowsCreated ) + ' row(s) created in InsuranceCompany table for Tertiary Insurance.'

Insert Into InsuranceCompanyPlan
	( PlanName
	  , InsuranceCompanyID
	  , VendorImportID
	)
Select IC.InsuranceCompanyName
	   , IC.InsuranceCompanyID
	   , IC.VendorImportID
	From InsuranceCompany IC
	Where IC.VendorImportID = @VendorImportID

Select @RowsCreated = @@RowCount
Print Convert( Varchar(20) , @RowsCreated ) + ' row(s) created in InsuranceCompanyPlan table.'

-- Select Distinct InsuranceCompanyName Into #tmp1 From InsuranceCompany

Select IC.InsuranceCompanyName , IC.InsuranceCompanyID Into #tmp1 
	From InsuranceCompany IC 
			Inner Join ( Select Min( InsuranceCompanyID ) As Min_InsuranceCompanyID From InsuranceCompany Group By InsuranceCompanyName ) IC2 
		On IC.InsuranceCompanyID = IC2.Min_InsuranceCompanyID

Select ICP.InsuranceCompanyPlanID , ICP.InsuranceCompanyID Into #tmp2
	From InsuranceCompanyPlan ICP
			Inner Join ( Select Max( A.InsuranceCompanyPlanID ) As Max_InsuranceCompanyPlanID 
							From InsuranceCompanyPlan A 
									Inner Join #tmp1 B On A.InsuranceCompanyID = B.InsuranceCompanyID
							Group By A.InsuranceCompanyID ) ICP2 
		On ICP.InsuranceCompanyPlanID = ICP2.Max_InsuranceCompanyPlanID

Create Table #tmp3
( AccountNo					Varchar(50) Null
  , PatientID				Int Null Default 0
  , PatientCaseID			Int Null Default 0
  , InsuranceCompanyName	Varchar(35)	Null
  , PolicyNumber			Varchar(35) Null
  , InsuranceCompanyID		Int Null Default 0
  , InsuranceCompanyPlanID	Int Null Default 0
  , Precedence				Int Null Default 0
)

Insert Into #tmp3
	( AccountNo
	  , InsuranceCompanyName
	  , PolicyNumber
	  , Precedence
	)
Select Left( AccountNo , 50 )
		, Left( IsNull( PrimaryInsurance , '' ) , 35 ) As InsuranceCompanyName
		, Left( IsNull( PrimaryPolicy , '' ) , 35 ) As PolicyNumber
		, 1
	From CustomerData CD
	Where IsNull( PrimaryPolicy , '' ) <> ''

Insert Into #tmp3
	( AccountNo
	  , InsuranceCompanyName
	  , PolicyNumber
	  , Precedence
	)
Select Left( AccountNo , 50 )
		, Left( IsNull( SecondaryInsurance , '' ) , 35 ) As InsuranceCompanyName
		, Left( IsNull( SecondaryPolicy , '' ) , 35 ) As PolicyNumber
		, 2
	From CustomerData CD
	Where IsNull( SecondaryPolicy , '' ) <> ''

Insert Into #tmp3
	( AccountNo
	  , InsuranceCompanyName
	  , PolicyNumber
	  , Precedence
	)
Select Left( AccountNo , 50 )
		, Left( IsNull( Col02 , '' ) , 35 ) As InsuranceCompanyName
		, Left( IsNull( Col03 , '' ) , 35 ) As PolicyNumber
		, 3
	From CustomerData CD
	Where IsNull( Col03 , '' ) <> ''

Update T3
	Set InsuranceCompanyID = T1.InsuranceCompanyID
		, InsuranceCompanyPlanID = T2.InsuranceCompanyPlanID
	From #tmp3 T3
		Inner Join #tmp1 T1 On T3.InsuranceCompanyName = T1.InsuranceCompanyName
		Inner Join #tmp2 T2 On T2.InsuranceCompanyID = T1.InsuranceCompanyID

Select @RowsCreated = @@RowCount
Print Convert( Varchar(20) , @RowsCreated ) + ' row(s) updated in #tmp3 Table.'

Update T3
	Set PatientID = P.PatientID
	From #tmp3 T3
		  Inner Join Patient P On T3.AccountNo = P.VendorID
	Where P.VendorImportID = @VendorImportID

Update T3
	Set PatientCaseID = PC.PatientCaseID
	From #tmp3 T3
		  Inner Join PatientCase PC On T3.PatientID = PC.PatientID
	Where PC.VendorImportID = @VendorImportID

Select * From #tmp3 Where IsNull( InsuranceCompanyID , 0 ) = 0 Or IsNull( InsuranceCompanyPlanID , 0 ) = 0

-- Insert Policy Numbers.
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
  , Precedence
  -- , Copay
  -- , Deductible
  , VendorID
  , VendorImportID
)
Select
	T3.patientcaseid
	, T3.PolicyNumber
	, T3.InsuranceCompanyPlanID
	, 'S'
	, P.PracticeID
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
	, T3.Precedence
	, P.VendorID
	, P.VendorImportID
	From #tmp3 T3
			Inner Join Patient P On T3.PatientID = P.PatientID
	Where P.VendorImportID = @VendorImportID
		  And IsNull( T3.InsuranceCompanyPlanID , 0 ) <> 0

Select @RowsCreated = @@RowCount
Print Convert( Varchar(20) , @RowsCreated ) + ' row(s) created in InsurancePolicy table.'

-- Update as 'Self-Pay' if there is no insurance policy.
Update PC
	Set PayerScenarioID = 11
	From PatientCase PC
	Where PatientCaseID Not In ( Select PatientCaseID From InsurancePolicy Where VendorImportID = @VendorImportID )
			And VendorImportID = @VendorImportID

Drop Table #tmpPatient
Drop Table #tmp1
Drop Table #tmp2
Drop Table #tmp3

Set NoCount Off
