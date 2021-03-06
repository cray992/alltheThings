/*=============================================================================
Case 21712: PSC - Eliminate patient statement enrollment process with PSC Info 
Group 
=============================================================================*/

/* Add practice address types ... */

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PracticeAddressType]') AND type in (N'U'))
DROP TABLE [dbo].[PracticeAddressType]
GO

CREATE TABLE [dbo].[PracticeAddressType](
	[PracticeAddressTypeID] [int] NOT NULL,
	[AddressTypeName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SortOrder] [smallint] NULL,
 CONSTRAINT [PK_PracticeAddressType] PRIMARY KEY CLUSTERED 
(
	[PracticeAddressTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

INSERT INTO [dbo].[PracticeAddressType] (
	[PracticeAddressTypeID]
	,[AddressTypeName]
	,[SortOrder] )
VALUES( 
	1,
	'Contact Information Address',
	1 )

INSERT INTO [dbo].[PracticeAddressType] (
	[PracticeAddressTypeID]
	,[AddressTypeName]
	,[SortOrder] )
VALUES( 
	2,
	'Billing Contact Address',
	2 )

INSERT INTO [dbo].[PracticeAddressType] (
	[PracticeAddressTypeID]
	,[AddressTypeName]
	,[SortOrder] )
VALUES( 
	3,
	'Administrator Address',
	3 )

GO


/* Add new patient statements option fields ... */

ALTER TABLE dbo.Practice ADD
	PracticeAddressTypeID int NULL,
	RemitAddressTypeID int NULL,
	VisaAccepted bit NULL,
	MastercardAccepted bit NULL,
	AmexAccepted bit NULL,
	DiscoverAccepted bit NULL,
	OfficeHours varchar(50) NULL
GO

ALTER TABLE dbo.Practice ADD CONSTRAINT
	DF_Practice_PracticeAddressTypeID DEFAULT 1 FOR PracticeAddressTypeID
GO

ALTER TABLE dbo.Practice ADD CONSTRAINT
	DF_Practice_RemitAddressTypeID DEFAULT 1 FOR RemitAddressTypeID
GO

ALTER TABLE dbo.Practice ADD CONSTRAINT
	DF_Practice_VisaAccepted DEFAULT 0 FOR VisaAccepted
GO

ALTER TABLE dbo.Practice ADD CONSTRAINT
	DF_Practice_MastercardAccepted DEFAULT 0 FOR MastercardAccepted
GO

ALTER TABLE dbo.Practice ADD CONSTRAINT
	DF_Practice_AmexAccepted DEFAULT 0 FOR AmexAccepted
GO

ALTER TABLE dbo.Practice ADD CONSTRAINT
	DF_Practice_DiscoverAccepted DEFAULT 0 FOR DiscoverAccepted
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Practice_PracticeAddressTypeID]') AND parent_object_id = OBJECT_ID(N'[dbo].[Practice]'))
ALTER TABLE [dbo].[Practice] DROP CONSTRAINT [FK_Practice_PracticeAddressTypeID]
GO

ALTER TABLE dbo.Practice ADD CONSTRAINT
	FK_Practice_PracticeAddressTypeID FOREIGN KEY
	(
	PracticeAddressTypeID
	) REFERENCES dbo.PracticeAddressType
	(
	PracticeAddressTypeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Practice_RemitAddressTypeID]') AND parent_object_id = OBJECT_ID(N'[dbo].[Practice]'))
ALTER TABLE [dbo].[Practice] DROP CONSTRAINT [FK_Practice_RemitAddressTypeID]
GO

ALTER TABLE dbo.Practice ADD CONSTRAINT
	FK_Practice_RemitAddressTypeID FOREIGN KEY
	(
	RemitAddressTypeID
	) REFERENCES dbo.PracticeAddressType
	(
	PracticeAddressTypeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO

/* Set default values for existing practices ... */

UPDATE dbo.Practice SET
	PracticeAddressTypeID = 1,
	RemitAddressTypeID = 1,
	VisaAccepted = 0,
	MastercardAccepted = 0,
	AmexAccepted = 0,
	DiscoverAccepted = 0

GO

/* Enable patient statement sending for all ... */

DECLARE @EFormatId INT

SELECT TOP 1 
	@EFormatId = PatientStatementsFormatId 
FROM 
	SharedServer.[superbill_shared].dbo.PatientStatementsFormat 
WHERE 
	PatientStatementsVendorId = 3 
	AND GoodForElectronic = 1

UPDATE dbo.Practice SET
	EnrolledForEStatements = 1,
	EStatementsSendEnabled = 1,
	EStatementsSendInTestMode = 0,
	EStatementsVendorID = 3,
	EStatementsPreferredPrintFormatID = 3,
	EStatementsPreferredElectronicFormatID = @EFormatId
WHERE
	(EStatementsVendorID IS NULL) OR (EStatementsVendorID <> 4)
GO

/* 

Import PSC-supplied customer enrollment data ... 

NOTE: This assumes that a table named "PSCKareoClientInfo" exists on superbill_shared.

*/

update p set  
	p.VisaAccepted = psc.Visa,
	p.MastercardAccepted = psc.MasterCard,
	p.AmexAccepted = psc.Amex,
	p.DiscoverAccepted = psc.Discover,
	p.OfficeHours = psc.OfficeHours
from 
	Practice p
	join SharedServer.superbill_shared.dbo.PSCKareoClientInfo psc on replace(p.EStatementsLogin, 'PINC', '') = cast(psc.PINC as varchar(10))
where
	p.EStatementsLogin like 'PINC%' 