-- Customer : SSK, LLC Medical Billing Specialists.
-- Practice : Dancing Horizon Health.
-- Case ID  : 14142.

-- Special one-time script to delete patients having letters in medical record number field.

-- Select * From VendorImport Order By VendorImportID Desc

Use superbill_0720_prod

Declare @VendorImportID Int

Select @VendorImportID = 1

Begin Transaction
Begin

    Delete A
        From AppointmentToResource A
                Inner Join Appointment B On A.AppointmentID = B.AppointmentID
                Inner Join Patient C On B.PatientID = C.PatientID
        Where C.VendorImportID = @VendorImportID 
                And IsNumeric( C.MedicalRecordNumber ) = 0
                And IsNull( C.MedicalRecordNumber , '' ) <> ''

    Delete A
        From AppointmentToAppointmentReason A
                Inner Join Appointment B On A.AppointmentID = B.AppointmentID
                Inner Join Patient C On B.PatientID = C.PatientID
        Where C.VendorImportID = @VendorImportID 
                And IsNumeric( C.MedicalRecordNumber ) = 0
                And IsNull( C.MedicalRecordNumber , '' ) <> ''

    Delete A
        From Appointment A
                Inner Join Patient B On A.PatientID = B.PatientID
        Where B.VendorImportID = @VendorImportID 
                And IsNumeric( B.MedicalRecordNumber ) = 0
                And IsNull( B.MedicalRecordNumber , '' ) <> ''

    Delete A
        From InsurancePolicy A
                Inner Join PatientCase B on A.PatientCaseID = B.PatientCaseID
                Inner Join Patient C On B.PatientID = C.PatientID
        Where A.VendorImportID = @VendorImportID
                And C.VendorImportID = @VendorImportID
                And IsNumeric( C.MedicalRecordNumber ) = 0
                And IsNull( C.MedicalRecordNumber , '' ) <> ''

    Delete A
        From PatientCase A
                Inner Join Patient B On A.PatientID = B.PatientID
        Where A.VendorImportID = @VendorImportID
                And B.VendorImportID = @VendorImportID
                And IsNumeric( B.MedicalRecordNumber ) = 0
                And IsNull( B.MedicalRecordNumber , '' ) <> ''

    Delete A
        From Patient A
        Where A.VendorImportID = @VendorImportID
                And IsNumeric( A.MedicalRecordNumber ) = 0
                And IsNull( A.MedicalRecordNumber , '' ) <> ''

End
-- RollBack
-- Commit Transaction

