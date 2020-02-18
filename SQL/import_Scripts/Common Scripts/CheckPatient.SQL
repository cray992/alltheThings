Select  LastName
        , MiddleName
        , FirstName
        , SSN
        , Convert( Char(10) , DOB , 101 ) As DOB
        , Case When Gender = 'M' Then 'Male' When Gender = 'F' Then 'Female' Else Gender End As Gender
        , MedicalRecordNumber
        , MaritalStatus
        , EmploymentStatus
        , AddressLine1
        , AddressLine2
        , City
        , State
        , ZipCode
        , HomePhone
        , WorkPhone
        , WorkPhoneExt
    From Patient
    Where VendorImportID = 8
    Order By LastName, FirstName
