/*

DATABASE UPDATE SCRIPT

v1.13.1536 to v.1.14.1xxx

*/

ALTER TABLE ReportEdition
ADD PageOrientation INT NOT NULL DEFAULT 0
GO

ALTER TABLE Practice ADD
[BillingAddressLine1] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
[BillingAddressLine2] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingCity] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingCountry] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingZipCode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingPhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingPhoneExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingEmailAddress] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdministrativeContactPhoneExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
GO

--

ALTER TABLE EncounterProcedure ADD
[ProcedureDateOfService] [datetime] NULL 
GO

--


--For case 1754
ALTER TABLE Claim
ALTER COLUMN ReferringProviderIDNumber VARCHAR(32) NULL

UPDATE
	Claim
SET
	ReferringProviderIDNumber = RP.UPIN
FROM
	Claim C
	LEFT OUTER JOIN ReferringPhysician RP 
		ON RP.ReferringPhysicianID = C.ReferringProviderID
WHERE
	C.ReferringProviderIDNumber IS NULL

--



/*

At this point issue the following command:

textcopy /S 10.0.0.10 /U dev /P /D pmr_copy /T BillingForm /C Transform /W "WHERE BillingFormID = 1" /F c:\cvsroot\PMR\Software\Billing\Libraries\PMR.Billing.ServiceImplementation\Bill_RAW-HCFA.xsl /I

--replace 10.0.0.10 with database ip, pmr_copy with database Name, and ensure path is valid

*/
