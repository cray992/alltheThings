USE superbill_1614_dev
GO

SET TRAN ISOLATION LEVEL READ UNCOMMITTED
SET XACT_ABORT ON

BEGIN TRANSACTION
--rollback
--commit

SET NOCOUNT ON

--DELETE FROM dbo.AppointmentToAppointmentReason WHERE vendorimportid = 9
--DELETE FROM dbo.AppointmentReason WHERE vendorimportid = 9
--DELETE FROM appointmenttoresource WHERE vendorimportid = 9
--DELETE FROM dbo.Appointment WHERE vendorimportid = 9

--ALTER TABLE dbo.Appointment ADD vendorimportid INT 
--ALTER TABLE dbo.Appointmenttoresource ADD vendorimportid INT 
--ALTER TABLE dbo.Appointmentreason ADD vendorimportid INT 
--ALTER TABLE dbo.Appointmenttoappointmentreason ADD vendorimportid INT 

DECLARE @sourcepracticeID INT 
DECLARE @targetPracticeID INT
DECLARE @VendorImportID INT

SET @sourcepracticeID = 1
SET @targetPracticeID = 9
SET @VendorImportID = 21

PRINT 'PracticeID = ' + CAST(@targetPracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

--SELECT * FROM dbo.Doctor WHERE PracticeID = 9

PRINT ''
PRINT 'Inserting Into Doctor...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          SSN ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          HomePhone ,
          HomePhoneExt ,
          WorkPhone ,
          WorkPhoneExt ,
          PagerPhone ,
          PagerPhoneExt ,
          MobilePhone ,
          MobilePhoneExt ,
          DOB ,
          EmailAddress ,
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          TaxonomyCode ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          FaxNumberExt ,
          [External] ,
          NPI ,
          ProviderTypeID ,
          ProviderPerformanceReportActive ,
          ProviderPerformanceScope ,
          ProviderPerformanceFrequency ,
          ProviderPerformanceDelay ,
          ProviderPerformanceCarbonCopyEmailRecipients ,
          ExternalBillingID ,
          GlobalPayToAddressFlag ,
          GlobalPayToName ,
          GlobalPayToAddressLine1 ,
          GlobalPayToAddressLine2 ,
          GlobalPayToCity ,
          GlobalPayToState ,
          GlobalPayToZipCode ,
          GlobalPayToCountry ,
          KareoSpecialtyId
        )
SELECT DISTINCT
		  @TargetPracticeID , -- PracticeID - int
          '', --i.prefix , -- Prefix - varchar(16)
          i.firstname , -- FirstName - varchar(64)
          i.middlename , -- MiddleName - varchar(64)
          i.lastname , -- LastName - varchar(64)
          '', --i.Suffix , -- Suffix - varchar(16)
          NULL, --i.SSN , -- SSN - varchar(9)
          i.Address1 , -- AddressLine1 - varchar(256)
          i.Address2 , -- AddressLine2 - varchar(256)
          i.City , -- City - varchar(128)
          i.State , -- State - varchar(2)
          NULL, --i.Country  -- Country - varchar(32)
          i.zipcode , -- ZipCode - varchar(9)
          i.HomePhone , -- HomePhone - varchar(10)
          NULL, --i.HomePhoneExt  -- HomePhoneExt - varchar(10)
          i.WorkPhone , -- WorkPhone - varchar(10)
          i.workphoneext, --i.WorkPhoneExt  -- WorkPhoneExt - varchar(10)
          NULL, --i.PagerPhone  -- PagerPhone - varchar(10)
          NULL, --i.PagerPhoneExt  -- PagerPhoneExt - varchar(10)
          i.mobilephone , -- MobilePhone - varchar(10)
          NULL, --i.MobilePhoneExt  -- MobilePhoneExt - varchar(10)
          i.dateofbirth , -- DOB - datetime
          NULL, --i.Email , -- EmailAddress - varchar(256)
          i.notes, --i.Notes , -- Notes - text
          1, -- i.ActiveDoctor  -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL, --i.Degree  -- Degree - varchar(8)
          NULL, --i.TaxonomyCode  -- TaxonomyCode - char(10)
          i.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          i.faxnumber , -- FaxNumber - varchar(10)
          NULL, --i.FaxExt , -- FaxNumberExt - varchar(10)
          1, --i.[External]  -- External - bit
          i.NPI , -- NPI - varchar(10)
          NULL, --i.ProviderTypeID  -- ProviderTypeID - int
          NULL, --i.ProviderPerformanceReportActive  -- ProviderPerformanceReportActive - bit
          NULL, --i.ProviderPerformanceScope  -- ProviderPerformanceScope - int
          NULL, --i.ProviderPerformanceFrequency  -- ProviderPerformanceFrequency - char(1)
          NULL, --i.ProviderPerformanceDelay  -- ProviderPerformanceDelay - int
          NULL, --i.ProviderPerformanceCarbonCopyEmailRecipients , -- ProviderPerformanceCarbonCopyEmailRecipients - varchar(max)
          NULL, --i.ExternalBillingID , -- ExternalBillingID - varchar(50)
          NULL, --i.GlobalPayToAddressFlag , -- GlobalPayToAddressFlag - bit
          NULL, --i.GlobalPayToName , -- GlobalPayToName - varchar(128)
          NULL, --i.GlobalPayToAddressLine1 , -- GlobalPayToAddressLine1 - varchar(256)
          NULL, --i.GlobalPayToAddressLine2 , -- GlobalPayToAddressLine2 - varchar(256)
          NULL, --i.GlobalPayToCity , -- GlobalPayToCity - varchar(128)
          NULL, --i.GlobalPayToState , -- GlobalPayToState - varchar(2)
          NULL, --i.GlobalPayToZipCode , -- GlobalPayToZipCode - varchar(9)
          NULL, --i.GlobalPayToCountry , -- GlobalPayToCountry - varchar(32)
          NULL --i.KareoSpecialtyId  -- KareoSpecialtyId - int
--FROM dbo._import_10_1_ReferringDoctors i WHERE i.npi NOT IN(SELECT npi FROM dbo.Doctor) 
--select * 
FROM dbo._import_12_9_doctors i 
WHERE 
NOT EXISTS (SELECT * FROM dbo.Doctor d WHERE d.LastName = i.lastname AND d.FirstName = i.firstname AND d.PracticeID = @TargetPracticeID)
AND i.lastname<>''


PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--SELECT * FROM dbo.Doctor WHERE PracticeID = 9

INSERT INTO dbo.ServiceLocation
( PracticeID,Name,AddressLine1,AddressLine2,City,State,Country,ZipCode,CreatedDate,CreatedUserID,ModifiedUserID,
PlaceOfServiceCode,BillingName,Phone,PhoneExt,FaxPhone,FaxPhoneExt)
		SELECT  9,Name,AddressLine1,AddressLine2,City,State,Country,ZipCode,CreatedDate,CreatedUserID,ModifiedUserID,
PlaceOfServiceCode,BillingName,Phone,PhoneExt,FaxPhone,FaxPhoneExt FROM dbo.ServiceLocation sl WHERE sl.PracticeID =1 and sl.name IN (
			'XXXXXXXXXXXXXXXXXX817 Avenue C B','2520 Kennedy Boulevard','1160 Kennedy Blvd, Suite A','700 Ave C')

--SELECT * FROM dbo.ServiceLocation sl WHERE sl.PracticeID =9

PRINT ''
PRINT 'Inserting Into Appointments...'
INSERT INTO dbo.Appointment
        ( PatientID,
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
		  Recurrence,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm,
		  vendorimportid
        )
		--SELECT * FROM dbo.Appointment WHERE PracticeID =8

SELECT DISTINCT
		  p.PatientID,
          @targetPracticeID , -- PracticeID - int
		  
		  CASE 
		  WHEN i.servicelocationname = '1160 Kennedy Blvd, Suite A' THEN 46
		  WHEN i.servicelocationname = '2520 Kennedy Boulevard' THEN 45
		  WHEN i.servicelocationname = '700 Ave C' THEN 47
	      WHEN i.servicelocationname = 'XXXXXXXXXXXXXXXXXX817 Avenue C B' THEN 44
		  ELSE '47' END ,
		  --40, --i.servicelocationid,  -- ServiceLocationID - int
          i.startdate, --CAST(i.appointmentdate AS DATETIME)+i.appointmentstarttime , -- StartDate - datetime
          i.enddate, --CAST(i.appointmentdate AS DATETIME)+i.appointmentendtime,  -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          i.note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
		  --i.status,
          CASE i.status
			WHEN 'cancelled' THEN 'X'
			WHEN 'check-In' THEN 'I'
			WHEN 'confirmed' THEN 'C'
			WHEN 'no-show' THEN 'N'
			WHEN 'rescheduled' THEN 'R'
			WHEN 'scheduled' THEN 'S'
			ELSE'S' END , -- AppointmentConfirmationStatusCode - char(1)
		  0,
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(LEFT(REPLACE(CAST(i.startdate AS TIME),':',''),4) AS SMALLINT), -- StartTm - smallint
          CAST(LEFT(REPLACE(CAST(i.enddate AS TIME),':',''),4) AS SMALLINT),  -- EndTm - smallint
		  @VendorImportID
		  --SELECT distinct i.*
FROM dbo._import_12_9_PatientAppointments i 
	--INNER JOIN dbo._import_44_61_PatientDemographics d ON 
	--	d.chartnumber = i.mrn
	INNER JOIN dbo.Patient p ON 
		i.patientlast = p.LastName AND 
		i.patientfirst = p.FirstName AND 
		p.PracticeID = @targetPracticeID 
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @targetPracticeID AND
		DK.dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
WHERE p.PracticeID = @targetPracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID,
		  vendorimportid
        )
		--SELECT * FROM dbo.PracticeResource WHERE PracticeID = 61
SELECT DISTINCT	
		  a.AppointmentID , -- AppointmentID - int
		  1, -- AppointmentResourceTypeID - int
			CASE 
				WHEN i.doctor = 'McGee' THEN 78
				WHEN i.doctor = 'Kawecki' THEN 90
				WHEN i.doctor = 'Shakarjian' THEN 77
			ELSE '' END ,
          GETDATE(),  -- ModifiedDate - datetime
          @targetPracticeID,  -- PracticeID - int
		  @VendorImportID
		
	--SELECT i.*
FROM dbo._import_12_9_PatientAppointments i 
	--INNER JOIN dbo._import_44_61_PatientDemographics d ON 
	--	d.chartnumber = i.chartnumber
	INNER JOIN dbo.Patient p ON 
		i.mrnchartnumber = p.VendorID AND 
		i.patientlast = p.LastName AND 
		i.patientfirst = p.FirstName AND 
		--CAST(d.dateofbirth AS DATE) = CAST(p.DOB AS DATE) AND 
		p.PracticeID = @targetPracticeID 		
	INNER JOIN dbo.Appointment a ON 
		a.PatientID = p.PatientID AND 
		a.StartDate = i.startdate AND 
		a.EndDate = i.enddate AND 
		a.PracticeID = @targetPracticeID
WHERE a.CreatedDate > DATEADD(mi,-3,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Appointment Reasons...'


INSERT INTO dbo.AppointmentReason
(
    PracticeID,
    Name,
    DefaultDurationMinutes,
    DefaultColorCode,
    Description,
    ModifiedDate,
	vendorimportid

)
SELECT DISTINCT	
    @targetPracticeID,         -- PracticeID - int
    ip.reasons,        -- Name - varchar(128)
    DATEDIFF(MINUTE,ip.startdate,ip.enddate),         -- DefaultDurationMinutes - int
    null,      -- DefaultColorCode - int
    ip.reasons,        -- Description - varchar(256)
    GETDATE(), -- ModifiedDate - datetime
	@VendorImportID
	
	--SELECT ip.*
FROM dbo._import_12_9_PatientAppointments IP
LEFT JOIN dbo.AppointmentReason ar ON ar.name = ip.reasons 
WHERE ip.reasons <>''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT''
PRINT'Inserting into Appointment to Appointment Reasons...'

INSERT INTO dbo.AppointmentToAppointmentReason
(
    AppointmentID,
    AppointmentReasonID,
    PrimaryAppointment,
    ModifiedDate,
    PracticeID,
	vendorimportid
)
SELECT DISTINCT a.AppointmentID, 
MIN(ar.AppointmentReasonID) AS AppointmentReasonID, 
1 ,
GETDATE() ,
@targetPracticeID,
@VendorImportID
--select * 
FROM _import_12_9_PatientAppointments iapt
	INNER JOIN dbo.AppointmentReason ar ON 
		ar.Name = iapt.reasons
	INNER JOIN dbo.Patient p ON 
		p.LastName = iapt.patientlast AND 
        p.FirstName = iapt.patientfirst
	INNER JOIN dbo.Appointment a ON 
		a.PatientID = p.PatientID AND 
		CAST(a.StartDate AS DATETIME) = CAST(iapt.startdate AS DATETIME) AND 
		CAST(a.EndDate AS DATETIME) = CAST(iapt.enddate AS DATETIME) --AND 
WHERE a.CreatedDate > DATEADD(mi,-3,GETDATE()) AND a.PracticeID = @targetPracticeID AND ar.PracticeID = @targetPracticeID
GROUP BY a.AppointmentID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
