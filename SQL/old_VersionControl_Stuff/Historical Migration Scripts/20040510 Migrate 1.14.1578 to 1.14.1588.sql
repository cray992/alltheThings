/*

DATABASE UPDATE SCRIPT

v1.14.1578 to v.1.14.1588

*/


-- case 656 changes:

ALTER TABLE [dbo].[Users]  ADD
	[Prefix] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FirstName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MiddleName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LastName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Suffix] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AddressLine1] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AddressLine2] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[City] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Country] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ZipCode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[WorkPhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[WorkPhoneExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AlternativePhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AlternativePhoneExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EmailAddress] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Notes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO


-- case 1903 fix

ALTER TABLE
	Claim
ALTER COLUMN
	ServiceUnitCount DECIMAL(9,4)
GO



/*

At this point issue the following command:

Case 1744: This is what needs to be run once on the database to populate dates of service for procedures:

	UPDATE
		EncounterProcedure 
	SET
		ProcedureDateOfService=E.DateOfService
	FROM
		Encounter E
		INNER JOIN EncounterProcedure EP ON EP.EncounterID = E.EncounterID
	WHERE
		EP.ProcedureDateOfService IS NULL

*/
