-- Delete records for a particular VendorImportID.
-- California Medical Billing - Dr. Simpson Practice.
-- Case 10809
-- Before Import Script.

Set NoCount On

Use superbill_0327_dev
Go

Declare @VendorImportID Int
		, @RowsDeleted	Int

-- Select * From VendorImport
-- Substitute for actual vendor import id.

Select @VendorImportID = 11
-- Select @VendorImportID = Max( VendorImportID ) From VendorImport

Print 'Deleting data for Vendor Import ID : ' + Convert( Varchar(20) , @VendorImportID )

Print '  '

Delete From InsurancePolicy
	Where VendorImportID = @VendorImportID

Select @RowsDeleted = @@RowCount
Print Convert( Varchar(20) , @RowsDeleted ) + ' records deleted from InsurancePolicy Table.'

Delete PJN
	From PatientJournalNote PJN
			Inner Join Patient P On PJN.PatientID = P.PatientID
	Where P.VendorImportID = @VendorImportID

Select @RowsDeleted = @@RowCount
Print Convert( Varchar(20) , @RowsDeleted ) + ' records deleted from PatientJournalNote Table.'

Delete A
	From providernumber A
			Inner Join doctor B On A.doctorid = B.doctorid
	Where B.vendorimportid = @VendorImportID

Select @RowsDeleted = @@RowCount
Print Convert( Varchar(20) , @RowsDeleted ) + ' records deleted from ProviderNumber Table.'

Delete PC
	From PatientCase PC
	Where VendorImportID = @VendorImportID

Select @RowsDeleted = @@RowCount
Print Convert( Varchar(20) , @RowsDeleted ) + ' records deleted from PatientCase Table.'

Delete From InsuranceCompanyPlan
	Where VendorImportID = @VendorImportID

Select @RowsDeleted = @@RowCount
Print Convert( Varchar(20) , @RowsDeleted ) + ' records deleted from InsuranceCompanyPlan Table.'

Delete From InsuranceCompany
	Where VendorImportID = @VendorImportID

Select @RowsDeleted = @@RowCount
Print Convert( Varchar(20) , @RowsDeleted ) + ' records deleted from InsuranceCompany Table.'

Delete P
	From Patient P
	Where P.VendorImportID = @VendorImportID

Select @RowsDeleted = @@RowCount
Print Convert( Varchar(20) , @RowsDeleted ) + ' records deleted from Patient Table.'

Delete D
	From Doctor D
	Where D.VendorImportID = @VendorImportID

Select @RowsDeleted = @@RowCount
Print Convert( Varchar(20) , @RowsDeleted ) + ' records deleted from Doctor Table.'

-- Delete From VendorImport
--	Where VendorImportID = @VendorImportID

-- Print 'Deleted Record from VendorImport Table.'

Go

