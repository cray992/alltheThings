USE superbill_61761_prod;
GO
SET TRAN ISOLATION LEVEL READ UNCOMMITTED;
SELECT a.AppointmentID AS [KareoApptID],
       a.PatientID AS [KareoPatientID],
       p.LastName,
       p.FirstName,
       a.StartDate,
       a.EndDate,
       ar.Description,
       ar.AppointmentReasonID
FROM dbo.Appointment a
    INNER JOIN dbo.AppointmentToAppointmentReason atar
        ON atar.AppointmentID = a.AppointmentID
    INNER JOIN dbo.AppointmentReason ar
        ON ar.AppointmentReasonID = atar.AppointmentReasonID
    INNER JOIN dbo.Patient p
        ON a.PatientID = p.PatientID
WHERE a.PracticeID = 1;

