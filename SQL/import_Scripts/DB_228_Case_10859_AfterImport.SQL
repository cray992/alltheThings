-- Drop Function.
-- SQL Function for parsing lastname, firstname and middlename.
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fn_GetName]
GO

-- Select * From VendorImport

-- Select * From VendorImport
Declare @VendorImportID Int

Select @VendorImportID = 14

Select Count(*) From Patient Where VendorImportID = @VendorImportID

Select Count(*) From PatientCase Where VendorImportID = @VendorImportID

Select Count(*) From InsuranceCompany Where VendorImportID = @VendorImportID

Select Count(*) From InsuranceCompanyPlan Where VendorImportID = @VendorImportID

Select Count(*) From InsurancePolicy Where VendorImportID = @VendorImportID

Select Count( * ) 
		From PatientJournalNote A 
			Inner Join Patient P On A.PatientID = P.PatientID
		Where P.VendorImportID = @VendorImportID


-- Get the vendorimport id after the import.
-- Check the imported data.
Select * From Patient Where VendorImportID = @VendorImportID

Select * From PatientCase Where VendorImportID = @VendorImportID

Select * From InsuranceCompany Where VendorImportID = @VendorImportID

Select * From InsuranceCompanyPlan Where VendorImportID = @VendorImportID

Select * From InsurancePolicy Where VendorImportID = @VendorImportID

-- Drop the import table after validating the data.
-- Drop Table CustomerData
-- Go
