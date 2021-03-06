/* Create mapping table for practices ... */

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomerMapPractice]') AND type in (N'U'))
DROP TABLE [dbo].[CustomerMapPractice]
GO

CREATE TABLE [dbo].[CustomerMapPractice](
	[FromCustomerID] [int] NOT NULL,
	[ToCustomerID] [int] NOT NULL,
	[PracticeID] [int] NOT NULL,
CONSTRAINT [UIX_CustomerPracticeMap] UNIQUE CLUSTERED 
(
	[FromCustomerID] ASC,
	[ToCustomerID] ASC,
	[PracticeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/* Create mapping table for Bill_EDI records ... */

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomerMapBillEDI]') AND type in (N'U'))
DROP TABLE [dbo].[CustomerMapBillEDI]
GO

CREATE TABLE [dbo].[CustomerMapBillEDI](
	[FromCustomerID] [int] NOT NULL,
	[ToCustomerID] [int] NOT NULL,
	[BillBatchID] [int] NOT NULL,
	[BillID] [int] NOT NULL,
CONSTRAINT [PK_CustomerMapBillEDI] PRIMARY KEY CLUSTERED 
(
	[FromCustomerID] ASC,
	[BillBatchID] ASC,
	[BillID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/* Create mapping table for encounters and claims ... */

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomerMapEncounter]') AND type in (N'U'))
DROP TABLE [dbo].[CustomerMapEncounter]
GO

CREATE TABLE [dbo].[CustomerMapEncounter](
	[FromCustomerID] [int] NOT NULL,
	[ToCustomerID] [int] NOT NULL,
	[EncounterID] [int] NOT NULL,
	[ClaimID] [int] NOT NULL,
CONSTRAINT [PK_CustomerMapEncounter] PRIMARY KEY CLUSTERED 
(
	[FromCustomerID] ASC,
	[EncounterID] ASC,
	[ClaimID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

