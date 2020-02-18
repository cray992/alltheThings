USE superbill_64229_dev
GO

SET NOCOUNT ON 
BEGIN TRAN 

PRINT''
PRINT'Updating DoctorID in Appointment to Resource table...'
UPDATE ar SET 
ar.ResourceID= d.DoctorID
--SELECT d.doctorid,d.LastName,ar.resourceid,*
FROM dbo.Patient p 
INNER JOIN patientcase pc ON pc.PatientID=p.PatientID
INNER JOIN dbo.Appointment a ON a.PatientCaseID=pc.PatientCaseID
INNER JOIN dbo.AppointmentToResource ar ON ar.AppointmentID=a.AppointmentID
INNER JOIN dbo.[Appointments_update_64229$] ia ON ia.Chart_Number=p.VendorID
AND CONVERT(DATETIME,ia.start_date,120)=a.StartDate 
INNER JOIN dbo.Doctor d ON d.LastName=ia.Doctor_LastName AND d.FirstName=ia.Doctor_FirstName 
WHERE ia.Doctor_LastName IS NOT NULL AND d.DoctorID IN (1,2,3,4)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--rollback
--commit
