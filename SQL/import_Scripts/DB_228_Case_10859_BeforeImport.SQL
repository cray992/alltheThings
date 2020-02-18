-- Delete records for a particular vendor import id.

Set NoCount On

Declare @VendorImportID Int
		, @RowsDeleted	Int

-- Select * From VendorImport
-- Substitute for actual vendor import id.

Select @VendorImportID = 8

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

-- Delete From VendorImport
--	Where VendorImportID = @VendorImportID

-- Print 'Deleted Record from VendorImport Table.'

Go

-- Manually Update Work Phone Ext since SQL Object Explorer is giving problem importing them.
Update customerdata Set workphoneext = '234'  Where accountno = '7'
Update customerdata Set workphoneext = '6280' Where accountno = '6667347'
Update customerdata Set workphoneext = '294'  Where accountno = '33466'
Update customerdata Set workphoneext = '3063' Where accountno = '1019'
Update customerdata Set workphoneext = '135'  Where accountno = '6667607'
Update customerdata Set workphoneext = '2246' Where accountno = '22336'
Update customerdata Set workphoneext = '1537' Where accountno = '6667362'
Update customerdata Set workphoneext = '138'  Where accountno = '6667211'

-- SQL Function for parsing lastname, firstname and middlename.
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
	DROP FUNCTION [dbo].[fn_GetName]
	PRINT 'FUNCTION fn_GetName DROPPED...'
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fn_GetName( @full_name Varchar(255) , @name_type Char(1) )
RETURNS Varchar(30)
AS
Begin
	Declare @patient_name	Varchar(50)
			, @start_pos	Int
			, @end_pos		Int

	Select @full_name = IsNull( @full_name , '' )

	-- Extract last name.
	If @name_type = 'L'	
	Begin
		Select @patient_name = Left( @full_name , CharIndex( ' ' , @full_name ) )
	End

	-- Extract first name.	
	If @name_type = 'F'
	Begin
		Select @start_pos = CharIndex( ' ' , @full_name )
		       , @end_pos = CharIndex( ' ' , @full_name , @start_pos + 1 )
		
		If IsNull( @end_pos , 0 ) = 0
			Select @end_pos = Len( @full_name )

		-- Extract first name.
		Select @patient_name = SubString( @full_name , @start_pos + 1 , @end_pos )

		Select @start_pos = CharIndex( ' ' , @patient_name )

		-- Get rid of middle initial from the first name.
		If IsNull( @start_pos , 0 ) > 0
			Select @patient_name = Left( @patient_name , @start_pos )
	End

	-- Extract middle name.
	If @name_type = 'M'
	Begin
		-- BRYANT TILLMAN LAWRENCE J      BRYANT                         TILLMAN                         LAWRENC
		Select @start_pos = CharIndex( ' ' , @full_name )
		       -- , @end_pos = CharIndex( ' ' , @full_name , @start_pos + 1 )
		
		-- If IsNull( @end_pos , 0 ) = 0
			Select @end_pos = Len( @full_name )

		-- Extract first name.
		Select @patient_name = SubString( @full_name , @start_pos + 1 , @end_pos )

		Select @start_pos = CharIndex( ' ' , @patient_name )

		-- Extract middle initial or name from the first name.
		If IsNull( @start_pos , 0 ) > 0
			Select @patient_name = SubString( @patient_name , @start_pos + 1 , 255 )
		Else
			Select @patient_name = ''
	End

	Select @patient_name = LTrim( RTrim( @patient_name ) )

	Return @patient_name
End
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	PRINT 'FUNCTION fn_GetName CREATED...'
GO

Set NoCount Off
