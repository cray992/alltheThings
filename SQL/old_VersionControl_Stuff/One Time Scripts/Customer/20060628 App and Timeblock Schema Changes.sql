--Denormalize some Recurrence Info into

ALTER TABLE Appointment ADD Recurrence BIT CONSTRAINT DF_Appointment_Recurrence DEFAULT (0), RecurrenceStartDate DATETIME, RangeEndDate DATETIME, RangeType CHAR(1),
StartDKPracticeID INT, EndDKPracticeID INT				

GO

UPDATE  A SET Recurrence=1, RecurrenceStartDate=AR.StartDate, RangeEndDate=AR.RangeEndDate, RangeType=AR.RangeType
FROM Appointment A INNER JOIN AppointmentRecurrence AR
ON A.AppointmentID=AR.AppointmentID

UPDATE Appointment SET Recurrence=0
WHERE Recurrence IS NULL

GO

--Denormalize some Recurrence Info for Timeblocks
ALTER TABLE Timeblock ADD RecurrenceStartDate DATETIME, RangeEndDate DATETIME, RangeType CHAR(1),
StartDKPracticeID INT, EndDKPracticeID INT
GO

UPDATE TB SET RecurrenceStartDate=ISNULL(TBR.StartDate,TB.StartDate), RangeEndDate=TBR.RangeEndDate, RangeType=TBR.RangeType
FROM Timeblock TB INNER JOIN TimeblockRecurrence TBR
ON TB.TimeblockID=TBR.TimeblockID
GO

--Create DateKeyToPractice TABLE

IF EXISTS(SELECT * FROM sys.objects WHERE name='DateKeyToPractice' AND TYPE='U')
	DROP TABLE DateKeyToPractice
GO

CREATE TABLE [dbo].[DateKeyToPractice](
	[DKPracticeID] [int] IDENTITY(1,1) NOT NULL,
	[Dt] [datetime] NULL,
	[PracticeID] [int] NULL,
	[MinDKPracticeID] [int] NULL,
	[MaxDKPracticeID] [int] NULL
)

GO

--Initially Populate DateKeyToPractice TABLE

INSERT INTO DateKeyToPractice(Dt, PracticeID)
SELECT Dt, PracticeID
FROM DateKey, Practice

DECLARE @MinIDs TABLE(PracticeID INT, MinDKPracticeID INT)
INSERT @MinIDs(PracticeID, MinDKPracticeID)
SELECT PracticeID, MIN(DKPracticeID)
FROM DateKeyToPractice 
GROUP BY PracticeID

UPDATE DKP SET MinDKPracticeID=MI.MinDKPracticeID
FROM @MinIDs MI INNER JOIN DateKeyToPractice DKP
ON MI.PracticeID=DKP.PracticeID

DECLARE @MaxIDs TABLE(PracticeID INT, MaxDKPracticeID INT)
INSERT @MaxIDs(PracticeID, MaxDKPracticeID)
SELECT PracticeID, MAX(DKPracticeID)
FROM DateKeyToPractice 
GROUP BY PracticeID

UPDATE DKP SET MaxDKPracticeID=MI.MaxDKPracticeID
FROM @MaxIDs MI INNER JOIN DateKeyToPractice DKP
ON MI.PracticeID=DKP.PracticeID

GO

CREATE UNIQUE CLUSTERED INDEX CI_DateKeyToPractice
ON DateKeyToPractice (PracticeID, Dt)

GO

UPDATE STATISTICS DateKeyToPractice

GO

--Update Appointments
UPDATE A SET StartDKPracticeID=DKP.DKPracticeID, EndDKPracticeID=DKPII.DKPracticeID
FROM Appointment A INNER JOIN DateKeyToPractice DKP
ON A.PracticeID=DKP.PracticeID AND CAST(CONVERT(CHAR(10),StartDate,110) AS DATETIME)=DKP.Dt
INNER JOIN DateKeyToPractice DKPII
ON A.PracticeID=DKPII.PracticeID AND CAST(CONVERT(CHAR(10),EndDate,110) AS DATETIME)=DKPII.Dt

GO

--Update Timeblocks
UPDATE TB SET StartDKPracticeID=DKP.DKPracticeID, EndDKPracticeID=DKPII.DKPracticeID
FROM Timeblock TB INNER JOIN DateKeyToPractice DKP
ON TB.PracticeID=DKP.PracticeID AND CAST(CONVERT(CHAR(10),StartDate,110) AS DATETIME)=DKP.Dt
INNER JOIN DateKeyToPractice DKPII
ON TB.PracticeID=DKPII.PracticeID AND CAST(CONVERT(CHAR(10),EndDate,110) AS DATETIME)=DKPII.Dt

GO

IF EXISTS(SELECT * FROM sys.indexes WHERE name='CI_Appointment')
	DROP INDEX Appointment.CI_Appointment
GO

CREATE CLUSTERED INDEX CI_Appointment 
ON Appointment (PracticeID ASC, StartDKPracticeID ASC, EndDKPracticeID ASC, AppointmentConfirmationStatusCode ASC,
				ServiceLocationID ASC, PatientID ASC, AppointmentID ASC)

GO

CREATE INDEX IX_Appointment_RecurrenceInfo
ON Appointment (Recurrence, RecurrenceStartDate, RangeEndDate, RangeType)

GO


IF EXISTS(SELECT * FROM sys.indexes WHERE name='CI_Timeblock')
	DROP INDEX Timeblock.CI_Timeblock
GO

CREATE CLUSTERED INDEX CI_Timeblock
ON Timeblock (PracticeID ASC, StartDKPracticeID ASC, EndDKPracticeID ASC, AppointmentResourceTypeID ASC,
     		  ResourceID ASC, TimeblockID ASC)

GO

CREATE INDEX IX_Timeblock_RecurrenceInfo
ON Timeblock (IsRecurring, RecurrenceStartDate, RangeEndDate, RangeType)
GO

UPDATE STATISTICS Appointment
GO
DBCC DBREINDEX(Appointment)
GO
UPDATE STATISTICS Appointment
GO

UPDATE STATISTICS Timeblock
GO
DBCC DBREINDEX(Timeblock)
GO
UPDATE STATISTICS Timeblock
GO