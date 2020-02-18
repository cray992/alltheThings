-- Symco : Fix Precedence Problem.

-- Processing for ordering duplicate precedence for a patientcaseid.

-- I am re-ordering the precedence irrespective whether it is right or wrong
-- if the count of patientcaseid is more than 1.

Set NoCount On

Declare @RowNumber              Int
        , @PatientCaseID        Int
        , @Count                Int
        , @VendorImportID       Int
        , @Rows                 Int

Select @VendorImportID = 12

Create Table #tmp1
( RowNumber         Int Identity(1,1)
  , PatientCaseID   Int
  , Rows            Int
)

Create Table #tmp2
( OrderNumber           Int Identity(1,1)
  , InsurancePolicyID   Int
)

Insert Into #tmp1
( PatientCaseID
  , Rows
)
Select
    A.PatientCaseID
    , Count(*) As Rows
From InsurancePolicy A
Where A.VendorImportID = @VendorImportID
Group By A.PatientCaseID Having Count(*) > 1
Order by A.PatientCaseID

Select @RowNumber = 0
        , @PatientCaseID = 0

While ( 1 = 1 )
Begin

    Select @RowNumber = @RowNumber + 1

    Select @PatientCaseID = PatientCaseID
            , @Count = Rows
        From #tmp1
        Where RowNumber = @RowNumber

    If @@RowCount = 0 Or IsNull( @PatientCaseID , 0 ) = 0
        Break

    Print 'PatientCaseID : ' + Convert( Varchar(10) , @PatientCaseID ) + ' Count : ' + Convert( Varchar(10) , @Count )

    Insert Into #tmp2
    ( InsurancePolicyID )
    Select A.InsurancePolicyID
        From InsurancePolicy A
        Where A.PatientCaseID = @PatientCaseID
        Order By A.InsurancePolicyID

    -- Debugging.
    -- Select * From #tmp2

    Update A
        Set Precedence = B.OrderNumber
        From InsurancePolicy A
                Inner Join #tmp2 B On B.InsurancePolicyID = A.InsurancePolicyID
        Where A.VendorImportID = @VendorImportID

    Select @PatientCaseID = 0

    Truncate Table #tmp2

End

Drop Table #tmp1
Drop Table #tmp2

Set NoCount Off
