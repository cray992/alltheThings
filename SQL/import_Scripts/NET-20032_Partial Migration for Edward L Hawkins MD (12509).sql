--12509_partial migration


--SELECT * FROM dbo.Appointment a WHERE a.PracticeID=2
--SELECT * FROM dbo.AppointmentReason

USE superbill_12509_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION
--rollback
--commit
SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 2
SET @VendorImportID = 4

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

--ALTER TABLE dbo._import_8_1_AppointmentData1
--ADD patientcaseid VARCHAR(10)

--UPDATE im SET
--im.patientcaseid=a.PatientCaseID
----SELECT * 
--FROM dbo.Appointment a INNER JOIN dbo._import_8_1_AppointmentData1 im ON a.AppointmentID = im.id


IF (SELECT COUNT(*) FROM dbo._import_8_1_AppointmentData1 WHERE id <> '') > =1 
BEGIN

-- The Excel Add-In provides the Doctor and Practice Resource in a column not defining which is which. The Doctor full name is also 
-- in one cell. This query below will parse out the resources into into name columns - first , middle , and last
--Copied from https://stackoverflow.com/questions/159567/sql-parse-the-first-middle-and-last-name-from-a-fullname-field


CREATE TABLE #ResourceMap (ORIGINAL_INPUT_DATA VARCHAR(250) , TITLE VARCHAR(50) , FIRST_NAME VARCHAR(250) , MIDDLE_NAME VARCHAR(250) , 
						   LAST_NAME VARCHAR(250))
--DROP TABLE #ResourceMap
INSERT INTO #ResourceMap
        ( ORIGINAL_INPUT_DATA ,
          TITLE ,
          FIRST_NAME ,
          MIDDLE_NAME ,
          LAST_NAME
        )
SELECT
  FIRST_NAME.ORIGINAL_INPUT_DATA
 ,FIRST_NAME.TITLE
 ,FIRST_NAME.FIRST_NAME
 ,CASE WHEN 0 = CHARINDEX(' ',FIRST_NAME.REST_OF_NAME)
       THEN NULL  --no more spaces?  assume rest is the last name
       ELSE SUBSTRING(
                       FIRST_NAME.REST_OF_NAME
                      ,1
                      ,CHARINDEX(' ',FIRST_NAME.REST_OF_NAME)-1
                     )
       END AS MIDDLE_NAME
 ,SUBSTRING(
             FIRST_NAME.REST_OF_NAME
            ,1 + CHARINDEX(' ',FIRST_NAME.REST_OF_NAME)
            ,LEN(FIRST_NAME.REST_OF_NAME)
           ) AS LAST_NAME
FROM
  (  
  SELECT
    TITLE.TITLE
   ,CASE WHEN 0 = CHARINDEX(' ',TITLE.REST_OF_NAME)
         THEN TITLE.REST_OF_NAME --No space? return the whole thing
         ELSE SUBSTRING(
                         TITLE.REST_OF_NAME
                        ,1
                        ,CHARINDEX(' ',TITLE.REST_OF_NAME)-1
                       )
    END AS FIRST_NAME
   ,CASE WHEN 0 = CHARINDEX(' ',TITLE.REST_OF_NAME)  
         THEN NULL  --no spaces @ all?  then 1st name is all we have
         ELSE SUBSTRING(
                         TITLE.REST_OF_NAME
                        ,CHARINDEX(' ',TITLE.REST_OF_NAME)+1
                        ,LEN(TITLE.REST_OF_NAME)
                       )
    END AS REST_OF_NAME
   ,TITLE.ORIGINAL_INPUT_DATA
  FROM
    (   
    SELECT
      --if the first three characters are in this list,
      --then pull it as a "title".  otherwise return NULL for title.
      CASE WHEN SUBSTRING(TEST_DATA.FULL_NAME,1,3) IN ('MR ','MS ','DR ','MRS')
           THEN LTRIM(RTRIM(SUBSTRING(TEST_DATA.FULL_NAME,1,3)))
           ELSE NULL
           END AS TITLE
      --if you change the list, don't forget to change it here, too.
      --so much for the DRY prinicple...
     ,CASE WHEN SUBSTRING(TEST_DATA.FULL_NAME,1,3) IN ('MR ','MS ','DR ','MRS')
           THEN LTRIM(RTRIM(SUBSTRING(TEST_DATA.FULL_NAME,4,LEN(TEST_DATA.FULL_NAME))))
           ELSE LTRIM(RTRIM(TEST_DATA.FULL_NAME))
           END AS REST_OF_NAME
     ,TEST_DATA.ORIGINAL_INPUT_DATA
    FROM
      (
      SELECT
        --trim leading & trailing spaces before trying to process
        --disallow extra spaces *within* the name
        REPLACE(REPLACE(LTRIM(RTRIM(FULL_NAME)),'  ',' '),'  ',' ') AS FULL_NAME
       ,FULL_NAME AS ORIGINAL_INPUT_DATA
      FROM
        (
        --if you use this, then replace the following
        --block with your actual table
        SELECT DISTINCT resourcename1 AS FULL_NAME
		FROM dbo._import_8_1_AppointmentData1
		WHERE resourcename1 <> ''

        ) RAW_DATA
      ) TEST_DATA
    ) TITLE
  ) FIRST_NAME
  SELECT * FROM dbo.PracticeResource
-- If an import appointment resource does not match to an existing rendering provider - create a new practice resource
PRINT ''
PRINT 'Inserting Into Practice Resource...'
INSERT INTO dbo.PracticeResource
        ( PracticeResourceTypeID ,
          PracticeID ,
          ResourceName ,
          ModifiedDate ,
          CreatedDate
        )
SELECT DISTINCT
		  2 , -- PracticeResourceTypeID - int
          1 , -- PracticeID - int
          i.ORIGINAL_INPUT_DATA , -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
FROM #ResourceMap i 
LEFT JOIN dbo.PracticeResource pr ON 
	i.ORIGINAL_INPUT_DATA = pr.ResourceName AND
	pr.PracticeID = 1
--LEFT JOIN dbo.Doctor d ON 
--	d.FirstName = i.FIRST_NAME AND 
--	d.LastName = i.LAST_NAME AND 
--	d.[External] = 0 AND
--    d.PracticeID = 1 AND
--    d.ActiveDoctor = 1
--WHERE d.DoctorID IS NULL AND pr.PracticeResourceID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment...'
INSERT INTO dbo.Appointment
        ( PatientID ,
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
          InsurancePolicyAuthorizationID ,
          PatientCaseID ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          CASE WHEN sl.ServiceLocationID IS NULL THEN sl2.ServiceLocationID ELSE sl.ServiceLocationID END , -- ServiceLocationID - int
          i.startdate, -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.id , -- Subject - varchar(64)
          i.notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          CASE i.confirmationstatus 
			WHEN 'Confirmed' THEN 'C'
			WHEN 'Seen' THEN 'E'
			WHEN 'Check-in' THEN 'I'
			WHEN 'No-show' THEN 'N'
			WHEN 'Check-out' THEN 'O'
			WHEN 'Rescheduled' THEN 'R'
			WHEN 'Tentative' THEN 'T'
			WHEN 'Cancelled' THEN 'X'
		  ELSE 'S' END, -- AppointmentConfirmationStatusCode - char(1)
          NULL , -- InsurancePolicyAuthorizationID - int -- not going to happen with this data set. 
														 -- support tools Case Information export does not give AuthorizationID 
													     -- only the authorization number. not unique
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(REPLACE(RIGHT(i.StartDate,5), ':','') AS SMALLINT) , -- StartTm - smallint
          CAST(REPLACE(RIGHT(i.enddate,5), ':','') AS SMALLINT) -- EndTm - smallint
		
FROM dbo._import_8_1_AppointmentData1 i
INNER JOIN dbo.Patient p ON 
	i.patientid = p.VendorID AND 
	
	p.PracticeID = 1
LEFT JOIN dbo.PatientCase pc ON 
	i.patientcaseid = pc.VendorID AND
    pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = 1
LEFT JOIN dbo.ServiceLocation sl ON 
	i.servicelocationname = sl.Name AND 
	sl.PracticeID = 1
LEFT JOIN dbo.ServiceLocation sl2 ON
	sl2.ServiceLocationID = (SELECT MAX(s.ServiceLocationID) FROM dbo.ServiceLocation s
							 WHERE s.PracticeID = 1)
INNER JOIN dbo.DateKeyToPractice DK ON
	DK.PracticeID = 1 AND
	DK.dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)		
WHERE i.[type] = 'Patient'			  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



-- This probably could have been done in the #ResourceMap insert but I don't have the time to figure it out
-- Link new doctor and practice resource ids to import appointmentid

CREATE TABLE #ApptResourceMap (ApptID INT , ApptDocID INT , ApptPracticeResourceID INT)
INSERT INTO #ApptResourceMap  (ApptID, ApptDocID, ApptPracticeResourceID)
SELECT DISTINCT
		  i.id , -- ApptID - int
          d.DoctorID , -- ApptDocID - int
		  pr.PracticeResourceID  -- ApptPracticeResourceID - int
FROM dbo._import_8_1_AppointmentData1 i
INNER JOIN #ResourceMap rm ON
	i.resourcename1 = rm.ORIGINAL_INPUT_DATA
LEFT JOIN dbo.Doctor d ON 
	rm.FIRST_NAME = d.FirstName AND 
	rm.LAST_NAME = d.LastName AND 
	d.[External] = 0 AND 
	d.ActiveDoctor = 1 AND 
	d.PracticeID = @PracticeID
LEFT JOIN dbo.PracticeResource pr ON 
	pr.ResourceName = i.resourcename1 AND
    pr.PracticeID = @PracticeID
WHERE i.resourcename1 <> ''


PRINT ''
PRINT 'Inserting Into Appointment to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          CASE WHEN i.ApptDocID IS NULL THEN 2 ELSE 1 END , -- AppointmentResourceTypeID - int
          CASE WHEN i.ApptDocID IS NULL THEN i.ApptPracticeResourceID ELSE i.ApptDocID END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM #ApptResourceMap i 
INNER JOIN dbo.Appointment a ON 
	i.ApptID = a.[Subject] AND 
	a.PracticeID = @PracticeID
WHERE a.CreatedDate >= DATEADD(mi,-2,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

-- Group the 4 Appointment Reason columns into one temp table
CREATE TABLE #ApptReason (ApptReasonName VARCHAR(128))
INSERT INTO #ApptReason  (ApptReasonName)
SELECT DISTINCT appointmentreason1 
FROM dbo._import_8_1_AppointmentData1


-- Insert Appointment Reasons from temp table where not already exists
PRINT ''
PRINT 'Inserting Into Appointment Reason...'
INSERT INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
          DefaultColorCode ,
          Description ,
          ModifiedDate 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          i.ApptReasonName , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
          0 , -- DefaultColorCode - int
          i.ApptReasonName , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM #ApptReason i
LEFT JOIN dbo.AppointmentReason ar ON 
	i.ApptReasonName = ar.Name AND 
    ar.PracticeID = @PracticeID 
WHERE ar.AppointmentReasonID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

-- Create mapping table of the import appointmentid to the new appointment reasonid
-- AppointmentReason1 is the Primary BIT
CREATE TABLE #ApptReasonMap (ApptID INT , ApptReasonID INT , PrimaryReason BIT)
INSERT INTO #ApptReasonMap (ApptID, ApptReasonID , PrimaryReason)
SELECT DISTINCT
		  i.id, -- ApptID - int
          ar.AppointmentReasonID,  -- ApptReasonID - int
		  1
FROM dbo._import_8_1_AppointmentData1 i 
INNER JOIN dbo.AppointmentReason ar ON 
	i.appointmentreason1 = ar.Name AND
	ar.PracticeID = @PracticeID
WHERE i.appointmentreason1 <> ''

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
          i.ApptReasonID , -- AppointmentReasonID - int
          i.PrimaryReason , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM #ApptReasonMap i 
INNER JOIN dbo.Appointment a ON 
	i.ApptID = a.[Subject] AND
    a.PracticeID = @PracticeID
WHERE a.CreatedDate >= DATEADD(mi,-2,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

DROP TABLE #ApptReason , #ApptReasonMap , #ApptResourceMap , #ResourceMap

END



--ROLLBACK
--COMMIT
