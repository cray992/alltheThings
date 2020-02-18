

SELECT * FROM superbill_0122_prod.dbo.AppointmentToResource
where resourceID = 8
and appointmentResourceTypeID = 2 


update superbill_0122_prod.dbo.AppointmentToResource
SET resourceID = 7863, appointmentResourceTypeID = 1
where resourceID = 8
and appointmentResourceTypeID = 2 


UPDATE superbill_0122_prod.dbo.AppointmentReasonDefaultResource
SET resourceID = 7863, appointmentResourceTypeID = 1
where resourceID = 8
and appointmentResourceTypeID = 2 

