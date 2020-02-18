USE superbill_28012_dev
-- USE superbill_28012_prod
GO

SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT

SET @PracticeID = 1


PRINT ''
PRINT 'Inserting Into Appointment...'
INSERT INTO dbo.Appointment
        ( --PatientID ,
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
          Subject ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
		  AppointmentResourceTypeID ,
          AppointmentConfirmationStatusCode ,
    --      PatientCaseID ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT DISTINCT
		 -- p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          CASE i.locname		WHEN 'Harris Hospital Out Patient' THEN 
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Harris Methodist Hospital Fort W')
								 WHEN 'Harris Hospital In Patient' THEN 
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Harris Methodist Hospital Fort W')
								 WHEN 'Baylor All Saints Hospital OutPatient' THEN 
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Baylor All Saints Hospital')
								 WHEN 'Baylor All Saints Hospital In Patient' THEN 
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Baylor All Saints Hospital')
								 WHEN 'BSHFt Worth Out Patient' THEN 
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Baylor Surgical Hospital of Fort')
								 WHEN 'BSHFt Worth In Patient' THEN 
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Baylor Surgical Hospital of Fort')
								 WHEN 'FP Southlake Out Patient' THEN 
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Forest Park Southlake')
								 WHEN 'FP Southlake In Patient' THEN
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Forest Park Southlake')
								 WHEN 'Fort Worth Brain And Spine Institute' THEN
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Fort Worth Brain & Spine Institute')
								 WHEN 'Granbury Clinic' THEN
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Granbury Clinic')
								 WHEN 'Keller North Fort Worth Clinic' THEN
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Keller North Fort Worth Clinic')
								 ELSE 1 END , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'O' , -- AppointmentType - varchar(1)
          i.[desc] , -- Subject - varchar(64)
          i.details , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
		  1 , --AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
       --   pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttm , -- StartTm - smallint
          i.endtm  -- EndTm - smallint
FROM dbo.[_import_10_1_Sheet1] i
	INNER JOIN dbo.DateKeyToPractice dk ON	
		dk.PracticeID = @PracticeID AND
		dk.dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '




PRINT ''	
PRINT 'Inserting Into Appointment to Appointment Reason...'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT	
		  a.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_10_1_Sheet1] i
	INNER JOIN dbo.Appointment a ON
		a.StartDate = CAST(i.startdate AS DATETIME) AND
		a.EndDate = CAST(i.enddate AS DATETIME) AND
		a.[Subject] = i.[desc]
	INNER JOIN dbo.AppointmentReason ar ON
		ar.Name = i.[event] AND
		ar.PracticeID = @PracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Appointment to Resource Type 1...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          CASE i.rendering
						   WHEN 'Alford MD, Brent' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'ALFORD' AND FirstName = 'BRENT' and [External] = 0)
						   WHEN 'CHAUDHARI MD, ALOK' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'CHAUDHARI' AND FirstName = 'ALOK' and [External] = 0)
						   WHEN 'ELLIS MD, THOMAS' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'ELLIS' AND FirstName = 'THOMAS' and [External] = 0)
						   WHEN 'EVANS ACNP, AMANDA' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'EVANS' AND FirstName = 'AMANDA' and [External] = 0)
						   WHEN 'HAQUE MD, ATIF' THEN	
								(SELECT doctorid from dbo.doctor WHERE LastName = 'HAQUE' AND FirstName = 'ATIF' and [External] = 0)	
						   WHEN 'LAPSIWALA MD, SAMIR' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'LAPSIWALA' AND FirstName = 'SAMIR' and [External] = 0)
						   WHEN 'LEE MD, ANTHONY' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'LEE' AND FirstName = 'ANTHONY' and [External] = 0)
						   WHEN 'SIADATI MD. AB' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'SIADATI' AND FirstName = 'ABDOLREZA' and [External] = 0)
						   WHEN 'Corder , Kelly' THEN
								(SELECT doctorid from dbo.doctor WHERE LastName = 'CORDER' AND FirstName = 'KELLEY' and [External] = 0)
						   WHEN 'VITOVSKY PA, RODNEY' THEN
								(SELECT doctorid from dbo.doctor WHERE LastName = 'VITOVSKY' AND FirstName = 'RODNEY' and [External] = 0)
						   WHEN 'MASCIO PA, CHRISTOPHER' THEN
								(SELECT doctorid FROM dbo.doctor WHERE LastName = 'MASCIO' AND FirstName = 'CHRISTOPHER' AND [External] = 0)
							WHEN 'LUTRICK PA C, T MARK' THEN
								(SELECT doctorid FROM dbo.doctor WHERE LastName = 'LUTRICK' AND FirstName = 'T.' AND [External] = 0)
						   ELSE 2 END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.Appointment a
	INNER JOIN dbo.[_import_10_1_Sheet1] i ON
		a.StartDate = CAST(i.startdate AS DATETIME) AND
		a.EndDate = CAST(i.enddate AS DATETIME) AND
		a.[Subject] = i.[desc]
WHERE i.rendering <> 'HUBBARD MD, RICHARD' AND i.rendering <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



--COMMIT
--ROLLBACK