-- MedEClaims
-- Case : 13830
-- Import UPIN Numbers.

Use superbill_0524_dev
Go

Select * From Practice
Select * From VendorImport Order By VendorImportID Desc

-- Select * From impMWRPH Where IsNull( UPIN , '' ) <> ''
-- Select vendorimportid , doctorid , firstname , lastname from doctor
-- Select * From ProviderNumberType

Insert Into ProviderNumber
( DoctorID
  , ProviderNumberTypeID
  , ProviderNumber
)
Select A.DoctorID
       , 25
       , B.UPIN
	From Doctor A
			Inner Join impMWRPH B On A.FirstName = B.FirstName And A.LastName = B.LastName
	Where IsNull( B.UPIN , '' ) <> ''
			And A.VendorImportID = 5

-- Select Item , Code, FirstName , MiddleInitial , LastName , UPIN From impMWRPH1576 Where IsNull( UPIN , '' ) <> ''

