/*  

PMR Practice

1.0 to 1.2 transition script

*/



ALTER TABLE
	Appointment
ADD
	PracticeResourceID INT 
	FOREIGN KEY REFERENCES PracticeResource(PracticeResourceID)
GO


CREATE TABLE [AppointmentResourceType] (
	[AppointmentResourceTypeID] [int] IDENTITY (1, 1) NOT NULL ,
	[TypeName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	CONSTRAINT [PK_AppointmentResourceType] PRIMARY KEY  CLUSTERED 
	(
		[AppointmentResourceTypeID]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO


INSERT INTO
	AppointmentResourceType
	(TypeName)
VALUES
	('Doctor')
GO

INSERT INTO
	AppointmentResourceType
	(TypeName)
VALUES
	('Practice Resource')
GO




ALTER TABLE
	Appointment
ADD
	AppointmentResourceTypeID INT DEFAULT 1 NOT NULL
	FOREIGN KEY REFERENCES AppointmentResourceType(AppointmentResourceTypeID)
GO


ALTER TABLE
	Appointment
ALTER COLUMN
	DoctorID INT NULL
GO
 
/* This is what needs to be run once on the database to populate dates of service for procedures:  -- sergei */
	UPDATE
		EncounterProcedure 
	SET
		ProcedureDateOfService=E.DateOfService
	FROM
		Encounter E
		INNER JOIN EncounterProcedure EP ON EP.EncounterID = E.EncounterID
	WHERE
		EP.ProcedureDateOfService IS NULL
GO
/* end of populating the procedures dates */
