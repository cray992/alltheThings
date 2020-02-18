----------------------------------------------------------
--  Case 17933:   No permission for Patient Detail report
----------------------------------------------------------
update Report
SET PermissionValue = 'ReadPatientDetailReport'
WHERE Name = 'Patient Detail'
GO




----------------------------------------------------------
-- Case 17934:   No permission for Missed Encounters report
----------------------------------------------------------
update Report
SET PermissionValue = 'ReadMissedEncountersReport'
WHERE Name = 'Missed Encounters'
GO


----------------------------------------------------------
-- No permission for Appointment report
----------------------------------------------------------
update Report
SET PermissionValue = 'ReadAppointmentsSummaryReport'
WHERE Name = 'Appointments Summary'
GO


