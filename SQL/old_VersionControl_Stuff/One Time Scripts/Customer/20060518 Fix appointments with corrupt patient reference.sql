-- Removes broken appointments and creates a foreign key constraint against the Appointment
-- and Patient tables.

declare @BrokenAppointments table( RID int identity(1,1), AppointmentID int )

insert into @BrokenAppointments
select AppointmentID 
from appointment 
where patientid not in (select patientid from patient)
and appointmenttype = 'p'

-- Remove appointments that have the patient linked improperly
DELETE FROM AppointmentRecurrence
WHERE AppointmentID IN (SELECT AppointmentID FROM @BrokenAppointments)

DELETE FROM AppointmentToAppointmentReason
WHERE AppointmentID IN (SELECT AppointmentID FROM @BrokenAppointments)

DELETE FROM AppointmentToResource
WHERE AppointmentID IN (SELECT AppointmentID FROM @BrokenAppointments)

DELETE FROM Appointment
WHERE AppointmentID IN (SELECT AppointmentID FROM @BrokenAppointments)

-- Update any 'other' appointments where PatientID is -1
UPDATE Appointment
SET PatientID = null
WHERE AppointmentType = 'O'
AND PatientID is not null

-- Add FK to Appointment for Patients
IF exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Appointment_Patient]') 
          AND OBJECTPROPERTY(id, N'IsForeignKey') = 1) 
	ALTER TABLE [dbo].[Appointment]  
		DROP  CONSTRAINT [FK_Appointment_Patient] 

ALTER TABLE [dbo].[Appointment]  WITH CHECK 
	ADD  CONSTRAINT [FK_Appointment_Patient] 
	FOREIGN KEY([PatientID])
	REFERENCES [dbo].[Patient] ([PatientID])

GO
