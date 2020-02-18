/*

BIZCLAIMS DATABASE UPDATE SCRIPT

v0.0.xxxx to v1.0.xxxx

Should be applied to database KareoBizclaims residing on the BizClaims machine.
*/
----------------------------------

--BEGIN TRAN 
----------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ClaimMessageTransaction_ClaimMessage]'))
ALTER TABLE [dbo].[ClaimMessageTransaction] DROP CONSTRAINT FK_ClaimMessageTransaction_ClaimMessage
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ClaimMessageTransactionTypeCode_ClaimMessageTransactionType]'))
ALTER TABLE [dbo].[ClaimMessageTransaction] DROP CONSTRAINT FK_ClaimMessageTransactionTypeCode_ClaimMessageTransactionType
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BatchTransaction_Batch]'))
ALTER TABLE [dbo].[BatchTransaction] DROP CONSTRAINT FK_BatchTransaction_Batch
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Batch_PayerGatewayId]'))
ALTER TABLE [dbo].[Batch] DROP CONSTRAINT FK_Batch_PayerGatewayId
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Batch_RoutingType]'))
ALTER TABLE [dbo].[Batch] DROP CONSTRAINT FK_Batch_RoutingType
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BatchTransactionTypeCode_BatchTransactionType]'))
ALTER TABLE [dbo].[BatchTransaction] DROP CONSTRAINT FK_BatchTransactionTypeCode_BatchTransactionType
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PayerGateway_TransportDirectionCode]'))
ALTER TABLE [dbo].[PayerGateway] DROP CONSTRAINT FK_PayerGateway_TransportDirectionCode
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PrefetcherFile_PayerGatewayId]'))
ALTER TABLE [dbo].[PrefetcherFile] DROP CONSTRAINT FK_PrefetcherFile_PayerGatewayId
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PayerGatewayResponse_PayerProcessingStatusTypeCode]'))
ALTER TABLE [dbo].[PayerGatewayResponse] DROP CONSTRAINT FK_PayerGatewayResponse_PayerProcessingStatusTypeCode
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PayerGatewayResponse_PayerGatewayResponseTypeCode]'))
ALTER TABLE [dbo].[PayerGatewayResponse] DROP CONSTRAINT FK_PayerGatewayResponse_PayerGatewayResponseTypeCode
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PayerGatewayResponse_PayerGatewayId]'))
ALTER TABLE [dbo].[PayerGatewayResponse] DROP CONSTRAINT FK_PayerGatewayResponse_PayerGatewayId
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProxymedResponse_PayerGatewayId]'))
ALTER TABLE [dbo].[ProxymedResponse] DROP CONSTRAINT FK_ProxymedResponse_PayerGatewayId
GO

---------------------------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ClearinghouseResponseType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ClearinghouseResponseType]
GO

CREATE TABLE ClearinghouseResponseType (
	ClearinghouseResponseType INT NOT NULL CONSTRAINT PK_ClearinghouseResponseType_ClearinghouseResponseTypeID
		PRIMARY KEY NONCLUSTERED,
	[Name] varchar(64) NOT NULL,
	Description varchar(512)
)
GO

-- see PayerGatewayBase.cs
INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (0, 'Unknown')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (1, 'All')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name], Description)
   VALUES (2, 'Etf', 'tilde-separated format; can be a mix')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (10, 'UnknownClaim')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (11, 'AllClaim')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (12, 'ClaimPayerResponseReport')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (13, 'ClaimDailyClaimsVerificationStatement')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (14, 'ClaimBillingInvoiceConfirmationListing')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (15, 'ClaimBillingInvoiceConfirmationStats')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name], Description)
   VALUES (16, 'ClaimFileProcessingStatement', 'like what OfficeAlly sends back in email')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name], Description)
   VALUES (17, 'ClaimGeneratedStatement', 'some report generated internally here, for example from ETF')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (18, 'ClaimEdiStatusStatement')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (20, 'UnknownPatientStatement')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (21, 'AllPatientStatement')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (22, 'PatientStatementBatchReport')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (30, 'UnknownERA')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (31, 'AllERA')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (32, 'ERAExplanationOfProviderPaymentImage')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (33, 'ERAExplanationOfProviderPaymentANSI')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (34, 'ERAExplanationOfProviderPaymentNSF')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (35, 'ERAProviderPaymentEFT')

GO

---------------------------------------------------------------------------------------
--case 7249, 7250 - Create tables for ClaimMessage

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TaxIdType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TaxIdType]
GO

CREATE TABLE TaxIdType (
	[TaxIdType] char(2) NOT NULL PRIMARY KEY NONCLUSTERED, 	-- 24=EIN or 34=SSN or XX=National Provider ID
	[TypeDescription] varchar(128) NOT NULL,
	[TIMESTAMP] timestamp NOT NULL
) ON [PRIMARY]

GO

INSERT TaxIdType (TaxIdType, TypeDescription) VALUES ('24', 'EIN')
INSERT TaxIdType (TaxIdType, TypeDescription) VALUES ('34', 'SSN')
INSERT TaxIdType (TaxIdType, TypeDescription) VALUES ('XX', 'National Provider ID')

GO



-- Keep in mind that this table is ClaimMessage.xsd related, it is a flat representation thereof

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ClaimMessage]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ClaimMessage]
GO

CREATE TABLE ClaimMessage (
	[ClaimMessageId] INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_ClaimMessage_ClaimMessageID 
		PRIMARY KEY NONCLUSTERED,
	[BiztalkMessageId] varchar(128), 

	[errors] text,
	[result] int,
	[count] int,
	[startedutc] datetime,
	[durationms] decimal,
	[data] ntext,

	[RoutingPayerConnection] int,
	[RoutingPayerNumber] varchar(30),
	[RoutingPayerType] varchar(30),
	[RoutingPayerName] varchar(128),
	[RoutingRoutingPreference] varchar(512),
	[RoutingSourceName] varchar(128),
	[RoutingPaytoName] varchar(128),
	[RoutingPaytoTaxIdType] char(2) NOT NULL, 	-- 24=EIN or 34=SSN or XX=National Provider ID
	[RoutingPaytoTaxId] varchar(20) NOT NULL,
	[RoutingBillerType] varchar(20),

	[DataDataCreatedDate] datetime, 
	[DataOriginalCustomerId] int, 
	[DataOriginalPracticeId] int, 
	[DataOriginalClaimId] int, 
	[DataOriginalBatchId] int, 

	[ClaimK9Number] varchar(128), 
	[ClaimK9Numbers] varchar(1024), 
	[ClaimTotalAmount] decimal, 
	[ClaimServiceFacilityName] varchar(128), 
	[ClaimDiagnoses] varchar(1024), 
	[ClaimProcedures] varchar(1024),
 
	[PatientOriginalId] int, 
	[PatientFirstName] varchar(64), 
	[PatientLastName] varchar(64), 
	[PatientMiddleName] varchar(64), 
	[PatientRelationToInsured] varchar(20), 

	[ProviderFirstName] varchar(64), 
	[ProviderLastName] varchar(64), 
	[ProviderMiddleName] varchar(64), 
	[ProviderUpin] varchar(20), 
	[ProviderSpecialtyCode] varchar(20), 

	[PolicyGroupNumber] varchar(64), 
	[PolicyPolicyNumber] varchar(64), 

	[PayerAddressStreet] varchar(128), 
	[PayerAddressCity] varchar(64), 
	[PayerAddressState] varchar(64), 
	[PayerAddressZipcode] varchar(64), 
	[PayerAddressCountry] varchar(64), 
	[PayerPhone] varchar(64), 

	CreatedDate DATETIME NOT NULL CONSTRAINT DF_ClaimMessage_CreatedDate DEFAULT (GETDATE()),
	CreatedUserID INT NOT NULL CONSTRAINT DF_ClaimMessage_CreatedUserID DEFAULT (0),
	ModifiedDate DATETIME NOT NULL CONSTRAINT DF_ClaimMessage_ModifiedDate DEFAULT (GETDATE()),
	ModifiedUserID INT NOT NULL CONSTRAINT DF_ClaimMessage_ModifiedUserID DEFAULT (0)
)

GO

-- Add a foreign key for the RoutingPaytoTaxIdType
ALTER TABLE [dbo].[ClaimMessage] ADD
	CONSTRAINT [FK_ClaimMessage_TaxIdType] FOREIGN KEY 
	(
		[RoutingPaytoTaxIdType]
	) REFERENCES [TaxIdType] (
		[TaxIdType]
	)
GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ClaimMessageTransaction]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ClaimMessageTransaction]
GO

CREATE TABLE ClaimMessageTransaction (
	[ClaimMessageTransactionId] INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_ClaimMessageTransaction_ClaimMessageTransactionID 
		PRIMARY KEY NONCLUSTERED,

	[ClaimMessageId] INT NOT NULL,

	[ClaimMessageTransactionTypeCode] char(3),
	[TransactionTimestamp] datetime NOT NULL CONSTRAINT DF_ClaimMessageTransaction_TransactionTimestamp DEFAULT (GETDATE()),

	[errors] text,
	[result] int,
	[count] int,
	[startedutc] datetime,
	[durationms] decimal,
	[data] ntext,

	[CreatedByEntity] varchar(64),
	[Destination] varchar(128),
	[ReferenceId] INT NULL,
	[Notes] ntext,
	[Forwarded] bit NOT NULL DEFAULT (0),

	CreatedDate DATETIME NOT NULL CONSTRAINT DF_ClaimMessageTransaction_CreatedDate DEFAULT (GETDATE()),
	CreatedUserID INT NOT NULL CONSTRAINT DF_ClaimMessageTransaction_CreatedUserID DEFAULT (0),
	ModifiedDate DATETIME NOT NULL CONSTRAINT DF_ClaimMessageTransaction_ModifiedDate DEFAULT (GETDATE()),
	ModifiedUserID INT NOT NULL CONSTRAINT DF_ClaimMessageTransaction_ModifiedUserID DEFAULT (0)
)

GO

-- Add a foreign key for the ClaimMessageId
ALTER TABLE [dbo].[ClaimMessageTransaction] ADD
	CONSTRAINT [FK_ClaimMessageTransaction_ClaimMessage] FOREIGN KEY 
	(
		[ClaimMessageId]
	) REFERENCES [ClaimMessage] (
		[ClaimMessageId]
	)
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ClaimMessageTransactionType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ClaimMessageTransactionType]
GO

CREATE TABLE ClaimMessageTransactionType (
	[ClaimMessageTransactionTypeCode] char(3) NOT NULL PRIMARY KEY NONCLUSTERED,
	[TypeName] varchar(64) NOT NULL,
	[TypeDescription] varchar(512) NOT NULL,
	[TIMESTAMP] timestamp NOT NULL
)

GO

-- Add a foreign key for the ClaimMessageTransactionTypeCode
ALTER TABLE [dbo].[ClaimMessageTransaction] ADD
	CONSTRAINT [FK_ClaimMessageTransactionTypeCode_ClaimMessageTransactionType] FOREIGN KEY 
	(
		[ClaimMessageTransactionTypeCode]
	) REFERENCES [ClaimMessageTransactionType] (
		[ClaimMessageTransactionTypeCode]
	)
GO

INSERT ClaimMessageTransactionType (ClaimMessageTransactionTypeCode, TypeName, TypeDescription) VALUES ('NEW', 'Created', '')
INSERT ClaimMessageTransactionType (ClaimMessageTransactionTypeCode, TypeName, TypeDescription) VALUES ('VLD', 'Validated', '')
INSERT ClaimMessageTransactionType (ClaimMessageTransactionTypeCode, TypeName, TypeDescription) VALUES ('BTC', 'Batched', '')
INSERT ClaimMessageTransactionType (ClaimMessageTransactionTypeCode, TypeName, TypeDescription) VALUES ('SNT', 'Sent', '')
INSERT ClaimMessageTransactionType (ClaimMessageTransactionTypeCode, TypeName, TypeDescription) VALUES ('REL', 'Relate to another Claim', 'when rebilling is detected, contains ID of the predecessor claim')
INSERT ClaimMessageTransactionType (ClaimMessageTransactionTypeCode, TypeName, TypeDescription) VALUES ('CRS', 'Clearinghouse response received', '')
INSERT ClaimMessageTransactionType (ClaimMessageTransactionTypeCode, TypeName, TypeDescription) VALUES ('CBL', 'Clearinghouse billing report received', '')
INSERT ClaimMessageTransactionType (ClaimMessageTransactionTypeCode, TypeName, TypeDescription) VALUES ('GRS', 'Gateway response received', '')
INSERT ClaimMessageTransactionType (ClaimMessageTransactionTypeCode, TypeName, TypeDescription) VALUES ('PRS', 'Payer response received', '')
INSERT ClaimMessageTransactionType (ClaimMessageTransactionTypeCode, TypeName, TypeDescription) VALUES ('ERA', 'ERA 835 received', '')
INSERT ClaimMessageTransactionType (ClaimMessageTransactionTypeCode, TypeName, TypeDescription) VALUES ('ERP', 'ERA printable report received', '')
INSERT ClaimMessageTransactionType (ClaimMessageTransactionTypeCode, TypeName, TypeDescription) VALUES ('CHK', 'Payment transaction received', '')
INSERT ClaimMessageTransactionType (ClaimMessageTransactionTypeCode, TypeName, TypeDescription) VALUES ('EDT', 'Edited for rebilling', '')

-- generic errors:
INSERT ClaimMessageTransactionType (ClaimMessageTransactionTypeCode, TypeName, TypeDescription) VALUES ('E_G', 'Error - general', 'generic errors')
-- routing table requested to reject claim:
INSERT ClaimMessageTransactionType (ClaimMessageTransactionTypeCode, TypeName, TypeDescription) VALUES ('E_R', 'Error - routing', 'routing table requested to reject claim')
-- batching problem, likely not routed correctly:
INSERT ClaimMessageTransactionType (ClaimMessageTransactionTypeCode, TypeName, TypeDescription) VALUES ('E_B', 'Error - batching', 'batching problem, likely not routed correctly')
-- data interpreted correctly but found invalid or missing:
INSERT ClaimMessageTransactionType (ClaimMessageTransactionTypeCode, TypeName, TypeDescription) VALUES ('E_V', 'Error - validation', 'data interpreted correctly but found invalid or missing')
-- could not interpret data, indicates programming error or deficiency:
INSERT ClaimMessageTransactionType (ClaimMessageTransactionTypeCode, TypeName, TypeDescription) VALUES ('E_D', 'Error - data interpretation', 'could not interpret data, indicates programming error or deficiency')
-- processing stopped or failed for system reasons, like service computer was down or other exception:
INSERT ClaimMessageTransactionType (ClaimMessageTransactionTypeCode, TypeName, TypeDescription) VALUES ('E_P', 'Error - processing failure', 'processing stopped or failed for system reasons, like service computer was down or other exception')

GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Batch]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Batch]
GO

CREATE TABLE Batch (
	[BatchId] INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_Batch_BatchID 
		PRIMARY KEY NONCLUSTERED,

	[errors] text,
	[result] int,
	[count] int,
	[startedutc] datetime,
	[durationms] decimal,
	[data] ntext,

	[PayerGatewayId] int,
	[GatewayClass] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RoutingType] varchar(20) NOT NULL,

	[RoutingPayerNumber] varchar(30),
	[RoutingPayerType] varchar(30),
	[RoutingRoutingPreference] varchar(512),

	[DataOriginalCustomerId] int, 
	[DataOriginalPracticeId] int, 

	CreatedDate DATETIME NOT NULL CONSTRAINT DF_Batch_CreatedDate DEFAULT (GETDATE()),
	CreatedUserID INT NOT NULL CONSTRAINT DF_Batch_CreatedUserID DEFAULT (0),
	ModifiedDate DATETIME NOT NULL CONSTRAINT DF_Batch_ModifiedDate DEFAULT (GETDATE()),
	ModifiedUserID INT NOT NULL CONSTRAINT DF_Batch_ModifiedUserID DEFAULT (0)
)

GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BatchTransaction]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BatchTransaction]
GO

CREATE TABLE BatchTransaction (
	[BatchTransactionId] INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_BatchTransaction_BatchTransactionID 
		PRIMARY KEY NONCLUSTERED,

	[BatchId] INT NOT NULL,

	[BatchTransactionTypeCode] char(3),
	[TransactionTimestamp] datetime NOT NULL CONSTRAINT DF_BatchTransaction_TransactionTimestamp DEFAULT (GETDATE()),

	[errors] text,
	[result] int,
	[count] int,
	[startedutc] datetime,
	[durationms] decimal,
	[data] ntext,

	[CreatedByEntity] varchar(64),
	[Destination] varchar(128),
	[ReferenceId] INT NULL,
	[Notes] ntext,

	CreatedDate DATETIME NOT NULL CONSTRAINT DF_BatchTransaction_CreatedDate DEFAULT (GETDATE()),
	CreatedUserID INT NOT NULL CONSTRAINT DF_BatchTransaction_CreatedUserID DEFAULT (0),
	ModifiedDate DATETIME NOT NULL CONSTRAINT DF_BatchTransaction_ModifiedDate DEFAULT (GETDATE()),
	ModifiedUserID INT NOT NULL CONSTRAINT DF_BatchTransaction_ModifiedUserID DEFAULT (0)
)

GO

-- Add a foreign key for the BatchId
ALTER TABLE [dbo].[BatchTransaction] ADD
	CONSTRAINT [FK_BatchTransaction_Batch] FOREIGN KEY 
	(
		[BatchId]
	) REFERENCES [Batch] (
		[BatchId]
	)
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BatchTransactionType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BatchTransactionType]
GO

CREATE TABLE BatchTransactionType (
	[BatchTransactionTypeCode] char(3) NOT NULL PRIMARY KEY NONCLUSTERED,
	[TypeName] varchar(64) NOT NULL,
	[TypeDescription] varchar(512) NOT NULL,
	[TIMESTAMP] timestamp NOT NULL
)

GO

-- Add a foreign key for the BatchTransactionTypeCode
ALTER TABLE [dbo].[BatchTransaction] ADD
	CONSTRAINT [FK_BatchTransactionTypeCode_BatchTransactionType] FOREIGN KEY 
	(
		[BatchTransactionTypeCode]
	) REFERENCES [BatchTransactionType] (
		[BatchTransactionTypeCode]
	)
GO

INSERT BatchTransactionType (BatchTransactionTypeCode, TypeName, TypeDescription) VALUES ('NEW', 'Created', '')
INSERT BatchTransactionType (BatchTransactionTypeCode, TypeName, TypeDescription) VALUES ('VLD', 'Validated', '')
INSERT BatchTransactionType (BatchTransactionTypeCode, TypeName, TypeDescription) VALUES ('SNT', 'Sent', '')
INSERT BatchTransactionType (BatchTransactionTypeCode, TypeName, TypeDescription) VALUES ('RSP', 'Response Received', '')

-- generic errors:
INSERT BatchTransactionType (BatchTransactionTypeCode, TypeName, TypeDescription) VALUES ('E_R', 'Error - general', 'generic errors')
-- data interpreted correctly but found invalid or missing:
INSERT BatchTransactionType (BatchTransactionTypeCode, TypeName, TypeDescription) VALUES ('E_V', 'Error - validation', 'data interpreted correctly but found invalid or missing')
-- could not interpret data, indicates programming error or deficiency:
INSERT BatchTransactionType (BatchTransactionTypeCode, TypeName, TypeDescription) VALUES ('E_D', 'Error - data interpretation', 'could not interpret data, indicates programming error or deficiency')
-- processing stopped or failed for system reasons, like service computer was down or other exception:
INSERT BatchTransactionType (BatchTransactionTypeCode, TypeName, TypeDescription) VALUES ('E_P', 'Error - processing failure', 'processing stopped or failed for system reasons, like service computer was down or other exception')

GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TransportDirection]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TransportDirection]
GO

CREATE TABLE TransportDirection (
	[TransportDirectionCode] varchar(10) NOT NULL PRIMARY KEY NONCLUSTERED,
	[TransportDirection] varchar(16) NOT NULL,
	[TIMESTAMP] timestamp NOT NULL
) ON [PRIMARY]

GO

INSERT TransportDirection (TransportDirectionCode, TransportDirection) VALUES ('NONE', 'no transmission')
INSERT TransportDirection (TransportDirectionCode, TransportDirection) VALUES ('IN', 'inbound')
INSERT TransportDirection (TransportDirectionCode, TransportDirection) VALUES ('OUT', 'outbound')
INSERT TransportDirection (TransportDirectionCode, TransportDirection) VALUES ('BOTH', 'bidirectional')
INSERT TransportDirection (TransportDirectionCode, TransportDirection) VALUES ('NA', 'not applicable')

GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PayerGateway]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PayerGateway]
GO

CREATE TABLE [dbo].[PayerGateway] (

	[PayerGatewayId] [int] IDENTITY (1, 1) NOT NULL,

	[ClearinghouseConnectionID] [int] NULL,

	[Active] [bit] NOT NULL ,
	[GatewayName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[GatewayClass] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[GatewayScope] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TransportTypeCode] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TransportDirectionCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EncryptionOriginatorEmail] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EncryptionRecepientEmail] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EncryptionPassphrase] ntext,
	[data] ntext NULL,

	CreatedDate DATETIME NOT NULL CONSTRAINT DF_PayerGateway_CreatedDate DEFAULT (GETDATE()),
	CreatedUserID INT NOT NULL CONSTRAINT DF_PayerGateway_CreatedUserID DEFAULT (0),
	ModifiedDate DATETIME NOT NULL CONSTRAINT DF_PayerGateway_ModifiedDate DEFAULT (GETDATE()),
	ModifiedUserID INT NOT NULL CONSTRAINT DF_PayerGateway_ModifiedUserID DEFAULT (0),
	[TIMESTAMP] [timestamp] NULL

) ON [PRIMARY]

GO

ALTER TABLE [dbo].[PayerGateway] ADD 
	CONSTRAINT [PK_PayerGateway] PRIMARY KEY  CLUSTERED 
	(
		[PayerGatewayId]
	),
	CONSTRAINT [UK_PayerGateway_GatewayName] UNIQUE NONCLUSTERED 
	(
		[GatewayName]
	) ON [PRIMARY]

GO

-- Add a foreign key for the TransportDirectionCode
ALTER TABLE [dbo].[PayerGateway] ADD
	CONSTRAINT [FK_PayerGateway_TransportDirectionCode] FOREIGN KEY 
	(
		[TransportDirectionCode]
	) REFERENCES [TransportDirection] (
		[TransportDirectionCode]
	)
GO

INSERT [dbo].[PayerGateway] (ClearinghouseConnectionID, Active, GatewayName, GatewayClass, GatewayScope, TransportTypeCode, TransportDirectionCode, EncryptionOriginatorEmail, EncryptionRecepientEmail, EncryptionPassphrase)
    VALUES (1, 1, 'Kareo-00739220-ProxyMed-Claims-OUT', 'PROXYMED', 'CLAIMS', 'FTP', 'OUT', 'sergei@kareo.com', 'claims@imsedi.com', 'the kareo software is best' )
INSERT [dbo].[PayerGateway] (ClearinghouseConnectionID, Active, GatewayName, GatewayClass, GatewayScope, TransportTypeCode, TransportDirectionCode, EncryptionOriginatorEmail, EncryptionRecepientEmail, EncryptionPassphrase)
    VALUES (1, 1, 'Kareo-00739220-ProxyMed-Claims-IN', 'PROXYMED', 'CLAIMS', 'FTP', 'IN', 'claims@imsedi.com', 'sergei@kareo.com', 'the kareo software is best' )

INSERT [dbo].[PayerGateway] (ClearinghouseConnectionID, Active, GatewayName, GatewayClass, GatewayScope, TransportTypeCode, TransportDirectionCode, EncryptionOriginatorEmail, EncryptionRecepientEmail, EncryptionPassphrase)
    VALUES (3, 1, 'Kareo-0073922a-ProxyMed-Claims-OUT', 'PROXYMED', 'CLAIMS', 'FTP', 'OUT', 'sergei@kareo.com', 'claims@imsedi.com', 'the kareo software is best' )
INSERT [dbo].[PayerGateway] (ClearinghouseConnectionID, Active, GatewayName, GatewayClass, GatewayScope, TransportTypeCode, TransportDirectionCode, EncryptionOriginatorEmail, EncryptionRecepientEmail, EncryptionPassphrase)
    VALUES (3, 1, 'Kareo-0073922a-ProxyMed-Claims-IN', 'PROXYMED', 'CLAIMS', 'FTP', 'IN', 'claims@imsedi.com', 'sergei@kareo.com', 'the kareo software is best' )

INSERT [dbo].[PayerGateway] (ClearinghouseConnectionID, Active, GatewayName, GatewayClass, GatewayScope, TransportTypeCode, TransportDirectionCode, EncryptionOriginatorEmail, EncryptionRecepientEmail, EncryptionPassphrase)
    VALUES (4, 1, 'Kareo-0073922b-ProxyMed-Claims-OUT', 'PROXYMED', 'CLAIMS', 'FTP', 'OUT', 'sergei@kareo.com', 'claims@imsedi.com', 'the kareo software is best' )
INSERT [dbo].[PayerGateway] (ClearinghouseConnectionID, Active, GatewayName, GatewayClass, GatewayScope, TransportTypeCode, TransportDirectionCode, EncryptionOriginatorEmail, EncryptionRecepientEmail, EncryptionPassphrase)
    VALUES (4, 1, 'Kareo-0073922b-ProxyMed-Claims-IN', 'PROXYMED', 'CLAIMS', 'FTP', 'IN', 'claims@imsedi.com', 'sergei@kareo.com', 'the kareo software is best' )

INSERT [dbo].[PayerGateway] (ClearinghouseConnectionID, Active, GatewayName, GatewayClass, GatewayScope, TransportTypeCode, TransportDirectionCode, EncryptionOriginatorEmail, EncryptionRecepientEmail, EncryptionPassphrase)
    VALUES (5, 1, 'Kareo-0073922c-ProxyMed-Claims-OUT', 'PROXYMED', 'CLAIMS', 'FTP', 'OUT', 'sergei@kareo.com', 'claims@imsedi.com', 'the kareo software is best' )
INSERT [dbo].[PayerGateway] (ClearinghouseConnectionID, Active, GatewayName, GatewayClass, GatewayScope, TransportTypeCode, TransportDirectionCode, EncryptionOriginatorEmail, EncryptionRecepientEmail, EncryptionPassphrase)
    VALUES (5, 1, 'Kareo-0073922c-ProxyMed-Claims-IN', 'PROXYMED', 'CLAIMS', 'FTP', 'IN', 'claims@imsedi.com', 'sergei@kareo.com', 'the kareo software is best' )

INSERT [dbo].[PayerGateway] (ClearinghouseConnectionID, Active, GatewayName, GatewayClass, GatewayScope, TransportTypeCode, TransportDirectionCode, EncryptionOriginatorEmail, EncryptionRecepientEmail, EncryptionPassphrase)
    VALUES (6, 1, 'Kareo-0073922d-ProxyMed-Claims-OUT', 'PROXYMED', 'CLAIMS', 'FTP', 'OUT', 'sergei@kareo.com', 'claims@imsedi.com', 'the kareo software is best' )
INSERT [dbo].[PayerGateway] (ClearinghouseConnectionID, Active, GatewayName, GatewayClass, GatewayScope, TransportTypeCode, TransportDirectionCode, EncryptionOriginatorEmail, EncryptionRecepientEmail, EncryptionPassphrase)
    VALUES (6, 1, 'Kareo-0073922d-ProxyMed-Claims-IN', 'PROXYMED', 'CLAIMS', 'FTP', 'IN', 'claims@imsedi.com', 'sergei@kareo.com', 'the kareo software is best' )

INSERT [dbo].[PayerGateway] (ClearinghouseConnectionID, Active, GatewayName, GatewayClass, GatewayScope, TransportTypeCode, TransportDirectionCode, EncryptionOriginatorEmail, EncryptionRecepientEmail, EncryptionPassphrase)
    VALUES (7, 1, 'Kareo-0073922e-ProxyMed-Claims-OUT', 'PROXYMED', 'CLAIMS', 'FTP', 'OUT', 'sergei@kareo.com', 'claims@imsedi.com', 'the kareo software is best' )
INSERT [dbo].[PayerGateway] (ClearinghouseConnectionID, Active, GatewayName, GatewayClass, GatewayScope, TransportTypeCode, TransportDirectionCode, EncryptionOriginatorEmail, EncryptionRecepientEmail, EncryptionPassphrase)
    VALUES (7, 1, 'Kareo-0073922e-ProxyMed-Claims-IN', 'PROXYMED', 'CLAIMS', 'FTP', 'IN', 'claims@imsedi.com', 'sergei@kareo.com', 'the kareo software is best' )

INSERT [dbo].[PayerGateway] (ClearinghouseConnectionID, Active, GatewayName, GatewayClass, GatewayScope, TransportTypeCode, TransportDirectionCode, EncryptionOriginatorEmail, EncryptionRecepientEmail, EncryptionPassphrase)
    VALUES (9, 1, 'Kareo-0073922g-ProxyMed-Claims-OUT', 'PROXYMED', 'CLAIMS', 'FTP', 'OUT', 'sergei@kareo.com', 'claims@imsedi.com', 'the kareo software is best' )
INSERT [dbo].[PayerGateway] (ClearinghouseConnectionID, Active, GatewayName, GatewayClass, GatewayScope, TransportTypeCode, TransportDirectionCode, EncryptionOriginatorEmail, EncryptionRecepientEmail, EncryptionPassphrase)
    VALUES (9, 1, 'Kareo-0073922g-ProxyMed-Claims-IN', 'PROXYMED', 'CLAIMS', 'FTP', 'IN', 'claims@imsedi.com', 'sergei@kareo.com', 'the kareo software is best' )

INSERT [dbo].[PayerGateway] (ClearinghouseConnectionID, Active, GatewayName, GatewayClass, GatewayScope, TransportTypeCode, TransportDirectionCode, EncryptionOriginatorEmail, EncryptionRecepientEmail, EncryptionPassphrase)
    VALUES (12, 1, 'Kareo-0073922j-ProxyMed-Claims-OUT', 'PROXYMED', 'CLAIMS', 'FTP', 'OUT', 'sergei@kareo.com', 'claims@imsedi.com', 'the kareo software is best' )
INSERT [dbo].[PayerGateway] (ClearinghouseConnectionID, Active, GatewayName, GatewayClass, GatewayScope, TransportTypeCode, TransportDirectionCode, EncryptionOriginatorEmail, EncryptionRecepientEmail, EncryptionPassphrase)
    VALUES (12, 1, 'Kareo-0073922j-ProxyMed-Claims-IN', 'PROXYMED', 'CLAIMS', 'FTP', 'IN', 'claims@imsedi.com', 'sergei@kareo.com', 'the kareo software is best' )

INSERT [dbo].[PayerGateway] (ClearinghouseConnectionID, Active, GatewayName, GatewayClass, GatewayScope, TransportTypeCode, TransportDirectionCode, EncryptionOriginatorEmail, EncryptionRecepientEmail, EncryptionPassphrase)
    VALUES (14, 1, 'Kareo-0073922l-ProxyMed-Claims-OUT', 'PROXYMED', 'CLAIMS', 'FTP', 'OUT', 'sergei@kareo.com', 'claims@imsedi.com', 'the kareo software is best' )
INSERT [dbo].[PayerGateway] (ClearinghouseConnectionID, Active, GatewayName, GatewayClass, GatewayScope, TransportTypeCode, TransportDirectionCode, EncryptionOriginatorEmail, EncryptionRecepientEmail, EncryptionPassphrase)
    VALUES (14, 1, 'Kareo-0073922l-ProxyMed-Claims-IN', 'PROXYMED', 'CLAIMS', 'FTP', 'IN', 'claims@imsedi.com', 'sergei@kareo.com', 'the kareo software is best' )

INSERT [dbo].[PayerGateway] (ClearinghouseConnectionID, Active, GatewayName, GatewayClass, GatewayScope, TransportTypeCode, TransportDirectionCode, EncryptionOriginatorEmail, EncryptionRecepientEmail, EncryptionPassphrase)
    VALUES (15, 1, 'Kareo-0073922m-ProxyMed-Claims-OUT', 'PROXYMED', 'CLAIMS', 'FTP', 'OUT', 'sergei@kareo.com', 'claims@imsedi.com', 'the kareo software is best' )
INSERT [dbo].[PayerGateway] (ClearinghouseConnectionID, Active, GatewayName, GatewayClass, GatewayScope, TransportTypeCode, TransportDirectionCode, EncryptionOriginatorEmail, EncryptionRecepientEmail, EncryptionPassphrase)
    VALUES (15, 1, 'Kareo-0073922m-ProxyMed-Claims-IN', 'PROXYMED', 'CLAIMS', 'FTP', 'IN', 'claims@imsedi.com', 'sergei@kareo.com', 'the kareo software is best' )


INSERT [dbo].[PayerGateway] (ClearinghouseConnectionID, Active, GatewayName, GatewayClass, GatewayScope, TransportTypeCode, TransportDirectionCode, EncryptionOriginatorEmail, EncryptionRecepientEmail, EncryptionPassphrase)
    VALUES (25, 1, 'Kareo-OfficeAlly-Claims-OUT', 'OFFICEALLY', 'CLAIMS', 'FTP', 'OUT', 'sergei@kareo.com', 'claims@officeally.com', 'office ally is our friend' )
GO

---------------------------------------------------------------------------------------
--case 6923 - prefetcher for the Receive Conveyor
---------------------------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrefetcherFile]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PrefetcherFile]
GO

CREATE TABLE [dbo].[PrefetcherFile] (

	[PrefetcherFileId] [int] IDENTITY (1, 1) NOT NULL,

	[errors] text,
	[result] int,
	[count] int,
	[startedutc] datetime,
	[durationms] decimal,
	[data] ntext,

	[PayerGatewayId] [int] NOT NULL ,
	[ResponseType] [int] NULL ,
	[SourceAddress] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FileName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FileReceiveDate] [datetime] NULL,
	[FileStorageLocation] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,

	[TIMESTAMP] [timestamp] NULL

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[PrefetcherFile] ADD 
	CONSTRAINT [PK_PrefetcherFile] PRIMARY KEY  CLUSTERED 
	(
		[PrefetcherFileId]
	)  ON [PRIMARY] 
GO

-- Add a foreign key for the PayerGatewayId
ALTER TABLE [dbo].[PrefetcherFile] ADD
	CONSTRAINT [FK_PrefetcherFile_PayerGatewayId] FOREIGN KEY 
	(
		[PayerGatewayId]
	) REFERENCES [PayerGateway] (
		[PayerGatewayId]
	)
GO

---------------------------------------------------------------------------------------
--case 7810 - Disassembler for ProxyMed Clearinghouse responses
---------------------------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProxymedResponse]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ProxymedResponse]
GO

CREATE TABLE [dbo].[ProxymedResponse] (
	[ProxymedResponseId] [int] IDENTITY (1, 1) NOT NULL ,
	[OriginalProxymedResponseId] [int] NULL ,
	[PayerGatewayId] [int] NOT NULL ,
	[ResponseType] [int] NULL ,
	[PracticeId] [int] NULL ,
	[PracticeEin] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SourceAddress] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FileName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FileReceiveDate] [datetime] NULL ,
	[FileContents] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ProcessedFlag] [bit] NOT NULL ,
	[Title] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ReviewedFlag] [bit] NULL ,
	[TIMESTAMP] [timestamp] NULL,
	[CustomerIdCorrelated] int NULL,		-- filled if we could correlate it
	[PracticeIdCorrelated] int NULL		-- filled if we could correlate it
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProxymedResponse] ADD 
	CONSTRAINT [DF__ProxymedResponse_ReviewedFlag] DEFAULT (0) FOR [ReviewedFlag],
	CONSTRAINT [DF__ProxymedResponse_ProcessedFlag] DEFAULT (0) FOR [ProcessedFlag],
	CONSTRAINT [PK_ProxymedResponse] PRIMARY KEY  CLUSTERED 
	(
		[ProxymedResponseId]
	)  ON [PRIMARY] 
GO

-- Add a foreign key for the PayerGatewayId
ALTER TABLE [dbo].[ProxymedResponse] ADD
	CONSTRAINT [FK_ProxymedResponse_PayerGatewayId] FOREIGN KEY 
	(
		[PayerGatewayId]
	) REFERENCES [PayerGateway] (
		[PayerGatewayId]
	)
GO

---------------------------------------------------------------------------------------
--case 9775 - Disassembler for OfficeAlly Clearinghouse responses
---------------------------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OfficeAllyResponse]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[OfficeAllyResponse]
GO

CREATE TABLE [dbo].[OfficeAllyResponse] (
	[OfficeAllyResponseId] [int] IDENTITY (1, 1) NOT NULL ,
	[OriginalOfficeAllyResponseId] [int] NULL ,
	[PayerGatewayId] [int] NOT NULL ,
	[ResponseType] [int] NULL ,
	[PracticeId] [int] NULL ,
	[PracticeEin] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SourceAddress] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FileName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FileReceiveDate] [datetime] NULL ,
	[FileContents] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ProcessedFlag] [bit] NOT NULL ,
	[Title] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ReviewedFlag] [bit] NULL ,
	[TIMESTAMP] [timestamp] NULL,
	[CustomerIdCorrelated] int NULL,		-- filled if we could correlate it
	[PracticeIdCorrelated] int NULL		-- filled if we could correlate it
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[OfficeAllyResponse] ADD 
	CONSTRAINT [DF__OfficeAllyResponse_ReviewedFlag] DEFAULT (0) FOR [ReviewedFlag],
	CONSTRAINT [DF__OfficeAllyResponse_ProcessedFlag] DEFAULT (0) FOR [ProcessedFlag],
	CONSTRAINT [PK_OfficeAllyResponse] PRIMARY KEY  CLUSTERED 
	(
		[OfficeAllyResponseId]
	)  ON [PRIMARY] 
GO

-- Add a foreign key for the PayerGatewayId
ALTER TABLE [dbo].[OfficeAllyResponse] ADD
	CONSTRAINT [FK_OfficeAllyResponse_PayerGatewayId] FOREIGN KEY 
	(
		[PayerGatewayId]
	) REFERENCES [PayerGateway] (
		[PayerGatewayId]
	)
GO

---------------------------------------------------------------------------------------
--case 10701 - Disassembler for GatewayEDI Clearinghouse responses
---------------------------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GatewayEDIResponse]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[GatewayEDIResponse]
GO

CREATE TABLE [dbo].[GatewayEDIResponse] (
	[GatewayEDIResponseId] [int] IDENTITY (1, 1) NOT NULL ,
	[OriginalGatewayEDIResponseId] [int] NULL ,
	[PayerGatewayId] [int] NOT NULL ,
	[ResponseType] [int] NULL ,
	[PracticeId] [int] NULL ,
	[PracticeEin] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SourceAddress] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FileName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FileReceiveDate] [datetime] NULL ,
	[FileContents] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ProcessedFlag] [bit] NOT NULL ,
	[Title] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ReviewedFlag] [bit] NULL ,
	[TIMESTAMP] [timestamp] NULL,
	[CustomerIdCorrelated] int NULL,		-- filled if we could correlate it
	[PracticeIdCorrelated] int NULL		-- filled if we could correlate it
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[GatewayEDIResponse] ADD 
	CONSTRAINT [DF__GatewayEDIResponse_ReviewedFlag] DEFAULT (0) FOR [ReviewedFlag],
	CONSTRAINT [DF__GatewayEDIResponse_ProcessedFlag] DEFAULT (0) FOR [ProcessedFlag],
	CONSTRAINT [PK_GatewayEDIResponse] PRIMARY KEY  CLUSTERED 
	(
		[GatewayEDIResponseId]
	)  ON [PRIMARY] 
GO

-- Add a foreign key for the PayerGatewayId
ALTER TABLE [dbo].[GatewayEDIResponse] ADD
	CONSTRAINT [FK_GatewayEDIResponse_PayerGatewayId] FOREIGN KEY 
	(
		[PayerGatewayId]
	) REFERENCES [PayerGateway] (
		[PayerGatewayId]
	)
GO

---------------------------------------------------------------------------------------
--case 9775 - Storage for internal BizClaims Clearinghouse-like reports, like Validation
---------------------------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BizclaimsResponse]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BizclaimsResponse]
GO

CREATE TABLE [dbo].[BizclaimsResponse] (
	[BizclaimsResponseId] [int] IDENTITY (1, 1) NOT NULL ,
--	[OriginalBizclaimsResponseId] [int] NULL ,
--	[PayerGatewayId] [int] NOT NULL ,
	[ResponseType] [int] NULL ,
	[PracticeId] [int] NULL ,
	[PracticeEin] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
--	[SourceAddress] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
--	[FileName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FileReceiveDate] [datetime] NULL ,
	[FileContents] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
--	[ProcessedFlag] [bit] NOT NULL ,
	[Title] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ReviewedFlag] [bit] NULL ,
	[TIMESTAMP] [timestamp] NULL,
	[CustomerIdCorrelated] int NULL,		-- filled when report is created
	[PracticeIdCorrelated] int NULL			-- filled when report is created
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[BizclaimsResponse] ADD 
	CONSTRAINT [DF__BizclaimsResponse_ReviewedFlag] DEFAULT (0) FOR [ReviewedFlag],
--	CONSTRAINT [DF__BizclaimsResponse_ProcessedFlag] DEFAULT (0) FOR [ProcessedFlag],
	CONSTRAINT [PK_BizclaimsResponse] PRIMARY KEY  CLUSTERED 
	(
		[BizclaimsResponseId]
	)  ON [PRIMARY] 
GO

-- a silly little table to mark ClaimMessageTransaction records already used in reports
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BizclaimsResponseClaimMessageTransaction]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BizclaimsResponseClaimMessageTransaction]
GO

CREATE TABLE [dbo].[BizclaimsResponseClaimMessageTransaction] (
	[RID] [int] IDENTITY (1, 1) NOT NULL ,
	[BizclaimsResponseId] [int] NOT NULL ,
	[ClaimMessageTransactionId] [int] NOT NULL,
	[CreatedDate] DATETIME NOT NULL CONSTRAINT DF_BRCMT_CreatedDate DEFAULT (GETDATE())
) ON [PRIMARY] 
GO

---------------------------------------------------------------------------------------
--case 6923 - Disassembler for Clearinghouse responses -- generic storage
---------------------------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PayerGatewayResponseType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PayerGatewayResponseType]
GO

CREATE TABLE PayerGatewayResponseType (
	[PayerGatewayResponseTypeCode] varchar(10) NOT NULL PRIMARY KEY NONCLUSTERED,
	[PayerGatewayResponseType] varchar(128) NOT NULL,
	[TIMESTAMP] timestamp NOT NULL
) ON [PRIMARY]

GO

INSERT PayerGatewayResponseType (PayerGatewayResponseTypeCode, PayerGatewayResponseType) VALUES ('none', 'not specified')
INSERT PayerGatewayResponseType (PayerGatewayResponseTypeCode, PayerGatewayResponseType) VALUES ('ch-prc', 'processed at clearinghouse')
INSERT PayerGatewayResponseType (PayerGatewayResponseTypeCode, PayerGatewayResponseType) VALUES ('ch-bill', 'transaction cost billed by clearinghouse')
INSERT PayerGatewayResponseType (PayerGatewayResponseTypeCode, PayerGatewayResponseType) VALUES ('pr-prc', 'processed at payer')
INSERT PayerGatewayResponseType (PayerGatewayResponseTypeCode, PayerGatewayResponseType) VALUES ('gt-prc', 'processed at clearinghouse gateway')
INSERT PayerGatewayResponseType (PayerGatewayResponseTypeCode, PayerGatewayResponseType) VALUES ('era', 'ERA received')
INSERT PayerGatewayResponseType (PayerGatewayResponseTypeCode, PayerGatewayResponseType) VALUES ('eft', 'electronic funds transfer data received')

GO

-- ---------------------------------------------------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PayerProcessingStatusType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PayerProcessingStatusType]
GO

CREATE TABLE dbo.PayerProcessingStatusType
	(
	PayerProcessingStatusTypeCode char(3) NOT NULL,
	PayerProcessingStatusTypeDesc varchar(50) NOT NULL,
	SortOrder int NOT NULL,
	[TIMESTAMP] timestamp NOT NULL
	)  ON [PRIMARY]
GO

ALTER TABLE dbo.PayerProcessingStatusType ADD CONSTRAINT
	PK_PayerProcessingStatusType PRIMARY KEY CLUSTERED 
	(
	PayerProcessingStatusTypeCode
	) ON [PRIMARY]

GO

INSERT INTO PayerProcessingStatusType (
	PayerProcessingStatusTypeCode,
	PayerProcessingStatusTypeDesc,
	SortOrder )
VALUES (
	'A00',
	'Claim Accepted',
	1 )

INSERT INTO PayerProcessingStatusType (
	PayerProcessingStatusTypeCode,
	PayerProcessingStatusTypeDesc,
	SortOrder )
VALUES (
	'F00',
	'Claim Forwarded',
	2 )

INSERT INTO PayerProcessingStatusType (
	PayerProcessingStatusTypeCode,
	PayerProcessingStatusTypeDesc,
	SortOrder )
VALUES (
	'R00',
	'Claim Rejected',
	3 )

INSERT INTO PayerProcessingStatusType (
	PayerProcessingStatusTypeCode,
	PayerProcessingStatusTypeDesc,
	SortOrder )
VALUES (
	'DP0',
	'Claim Denied',
	4 )

INSERT INTO PayerProcessingStatusType (
	PayerProcessingStatusTypeCode,
	PayerProcessingStatusTypeDesc,
	SortOrder )
VALUES (
	'P00',
	'Paid',
	5 )

INSERT INTO PayerProcessingStatusType (
	PayerProcessingStatusTypeCode,
	PayerProcessingStatusTypeDesc,
	SortOrder )
VALUES (
	'I00',
	'Inconclusive',
	10 )

GO

-- ---------------------------------------------------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[HandyStorage]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[HandyStorage]
GO

-- storage for whatever deserves it:
CREATE TABLE [dbo].[HandyStorage] (

	[HandyStorageId] [int] IDENTITY (1, 1) NOT NULL ,
	[DataType] varchar(32),		-- something like 'era-st'
	[MetaData] ntext,		-- anything to describe data
	[data] ntext,
	[CreatedDate] DATETIME NOT NULL CONSTRAINT DF_HandyStorage_CreatedDate DEFAULT (GETDATE()),
	[TIMESTAMP] [timestamp] NULL

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


-- ---------------------------------------------------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PayerGatewayResponse]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PayerGatewayResponse]
GO

-- atomic responses in universal (payer-independent) format
CREATE TABLE [dbo].[PayerGatewayResponse] (

	[PayerGatewayResponseId] [int] IDENTITY (1, 1) NOT NULL ,
	[PayerGatewayId] [int] NOT NULL ,
	[SourceResponseId] [int] NULL ,		-- may point to ProxymedResponseId
	[PayerGatewayResponseTypeCode] varchar(10) NULL ,
	[TransactionTimestamp] datetime NULL,
	[ServiceDate] datetime NULL,
	[Charge] money,
	[Amount] money,

	[PracticeEin] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CustomerId] int NULL,		-- filled if we could correlate it
	[PracticeId] int NULL,		-- filled if we could correlate it
	[ClaimK9Number] varchar(128) NULL, 
	[ClearinghouseTrackingNumber] varchar(128) NULL, 
	[PayerTrackingNumber] varchar(128) NULL, 
	[PayerName] varchar(128) NULL, 
	[PayerProcessingStatusTypeCode] char(3) NULL,
	[PayerProcessingStatus] ntext NULL,

	[data] ntext,
	[errors] text,

	[Notes] ntext,

	[ProcessedFlag] [bit] NOT NULL ,

	[CreatedDate] DATETIME NOT NULL CONSTRAINT DF_PayerGatewayResponse_CreatedDate DEFAULT (GETDATE()),
	[TIMESTAMP] [timestamp] NULL

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[PayerGatewayResponse] ADD 
	CONSTRAINT [DF__PayerGatewayResponse_ProcessedFlag] DEFAULT (0) FOR [ProcessedFlag],
	CONSTRAINT [PK_PayerGatewayResponse] PRIMARY KEY  CLUSTERED 
	(
		[PayerGatewayResponseId]
	)  ON [PRIMARY] 
GO

-- Add a foreign key for the PayerGatewayId
ALTER TABLE [dbo].[PayerGatewayResponse] ADD
	CONSTRAINT [FK_PayerGatewayResponse_PayerGatewayId] FOREIGN KEY 
	(
		[PayerGatewayId]
	) REFERENCES [PayerGateway] (
		[PayerGatewayId]
	)
GO

-- Add a foreign key for the PayerGatewayResponseCode
ALTER TABLE [dbo].[PayerGatewayResponse] ADD
	CONSTRAINT [FK_PayerGatewayResponse_PayerGatewayResponseTypeCode] FOREIGN KEY 
	(
		[PayerGatewayResponseTypeCode]
	) REFERENCES [PayerGatewayResponseType] (
		[PayerGatewayResponseTypeCode]
	)
GO

-- Add a foreign key for the PayerProcessingStatusTypeCode
ALTER TABLE [dbo].[PayerGatewayResponse] ADD
	CONSTRAINT [FK_PayerGatewayResponse_PayerProcessingStatusTypeCode] FOREIGN KEY 
	(
		[PayerProcessingStatusTypeCode]
	) REFERENCES [PayerProcessingStatusType] (
		[PayerProcessingStatusTypeCode]
	)
GO

---------------------------------------------------------------------------------------
--case 8081 - Send to payer related tables, including RoutingOut
---------------------------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Clearinghouse]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Clearinghouse]
GO

CREATE TABLE [dbo].[Clearinghouse] (

	[ClearinghouseId] [int] IDENTITY (1, 1) NOT NULL ,
	[ClearinghouseClass] varchar(32) NULL, 
	[ClearinghouseName] varchar(128) NULL, 
	[ClearinghouseDescription] ntext NULL, 

	[data] ntext,
	[Notes] ntext,
	[Active] [bit] NOT NULL ,

	[CreatedDate] DATETIME NOT NULL CONSTRAINT DF_Clearinghouse_CreatedDate DEFAULT (GETDATE()),
	[CreatedUserID] INT NOT NULL CONSTRAINT DF_Clearinghouse_CreatedUserID DEFAULT (0),
	[ModifiedDate] DATETIME NOT NULL CONSTRAINT DF_Clearinghouse_ModifiedDate DEFAULT (GETDATE()),
	[ModifiedUserID] INT NOT NULL CONSTRAINT DF_Clearinghouse_ModifiedUserID DEFAULT (0),
	[TIMESTAMP] [timestamp] NULL

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Clearinghouse] ADD 
	CONSTRAINT [DF__Clearinghouse_Active] DEFAULT (1) FOR [Active],
	CONSTRAINT [PK_Clearinghouse] PRIMARY KEY  CLUSTERED 
	(
		[ClearinghouseId]
	)  ON [PRIMARY] 
GO

INSERT Clearinghouse (ClearinghouseClass, ClearinghouseName, ClearinghouseDescription) VALUES ('PROXYMED', 'MedAvant, Inc.', 'MedAvant Clearinghouse')
INSERT Clearinghouse (ClearinghouseClass, ClearinghouseName, ClearinghouseDescription) VALUES ('OFFICEALLY', 'Office Ally, L.L.C.', 'Office Ally Clearinghouse')
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Payer]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Payer]
GO

CREATE TABLE [dbo].[Payer] (

	[PayerId] [int] IDENTITY (1, 1) NOT NULL ,
	[PayerType] varchar(32) NULL, 			-- like MC, MR, BL, CI
	[PayerName] varchar(128) NULL, 
	[PayerNumber] varchar(32) NULL, 

	[ClearinghouseId] int NULL,

	[data] ntext,
	[Notes] ntext,
	[Active] [bit] NOT NULL ,

	[CreatedDate] DATETIME NOT NULL CONSTRAINT DF_Payer_CreatedDate DEFAULT (GETDATE()),
	[CreatedUserID] INT NOT NULL CONSTRAINT DF_Payer_CreatedUserID DEFAULT (0),
	[ModifiedDate] DATETIME NOT NULL CONSTRAINT DF_Payer_ModifiedDate DEFAULT (GETDATE()),
	[ModifiedUserID] INT NOT NULL CONSTRAINT DF_Payer_ModifiedUserID DEFAULT (0),
	[TIMESTAMP] [timestamp] NULL

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Payer] ADD 
	CONSTRAINT [DF__Payer_Active] DEFAULT (1) FOR [Active],
	CONSTRAINT [PK_Payer] PRIMARY KEY  CLUSTERED 
	(
		[PayerId]
	)  ON [PRIMARY] 
GO

-- Add a foreign key for the ClearinghouseId
ALTER TABLE [dbo].[Payer] ADD
	CONSTRAINT [FK_Payer_ClearinghouseId] FOREIGN KEY 
	(
		[ClearinghouseId]
	) REFERENCES [Clearinghouse] (
		[ClearinghouseId]
	)
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RoutingType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[RoutingType]
GO

CREATE TABLE RoutingType (
	[RoutingType] varchar(20) NOT NULL PRIMARY KEY NONCLUSTERED,
	[TypeDescription] varchar(128) NOT NULL,
	[TIMESTAMP] timestamp NOT NULL
) ON [PRIMARY]

GO

INSERT RoutingType (RoutingType, TypeDescription) VALUES ('SEND', 'Send to payer')
INSERT RoutingType (RoutingType, TypeDescription) VALUES ('REJECT', 'Reject every claim that satisfies this routing criteria')
INSERT RoutingType (RoutingType, TypeDescription) VALUES ('HOLD', 'Hold claims until this routing entry is deactivated or removed')

GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RoutingOut]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[RoutingOut]
GO

CREATE TABLE [dbo].[RoutingOut] (

	[RoutingOutId] [int] IDENTITY (1, 1) NOT NULL ,
	[RoutingType] varchar(20) NOT NULL,
	[IsForPreference] [bit] NOT NULL CONSTRAINT DF_RoutingOut_IsForPreference DEFAULT 0,
	[CustomerId] int NOT NULL,
	[PracticeId] int NULL,			-- NULL means ProviderTaxId is used
	[ProviderTaxIdType] char(2) NULL, 	-- 24=EIN or 34=SSN or XX=National Provider ID. NULL means PracticeId is used
	[ProviderTaxId] varchar(20) NULL,	-- NULL means PracticeId is used
	[PayerId] int NULL, 

	[PayerGatewayId] int NOT NULL,

	[data] ntext,
	[Notes] ntext,
	[Active] [bit] NOT NULL ,

	[CreatedDate] DATETIME NOT NULL CONSTRAINT DF_RoutingOut_CreatedDate DEFAULT (GETDATE()),
	[CreatedUserID] INT NOT NULL CONSTRAINT DF_RoutingOut_CreatedUserID DEFAULT (0),
	[ModifiedDate] DATETIME NOT NULL CONSTRAINT DF_RoutingOut_ModifiedDate DEFAULT (GETDATE()),
	[ModifiedUserID] INT NOT NULL CONSTRAINT DF_RoutingOut_ModifiedUserID DEFAULT (0),
	[TIMESTAMP] [timestamp] NULL

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Add a foreign key for the RoutingType
ALTER TABLE [dbo].[RoutingOut] ADD
	CONSTRAINT [FK_RoutingOut_RoutingType] FOREIGN KEY 
	(
		[RoutingType]
	) REFERENCES [RoutingType] (
		[RoutingType]
	)
GO

-- Add a foreign key for the PayerId
ALTER TABLE [dbo].[RoutingOut] ADD
	CONSTRAINT [FK_RoutingOut_PayerId] FOREIGN KEY 
	(
		[PayerId]
	) REFERENCES [Payer] (
		[PayerId]
	)
GO

-- Add a foreign key for the ProviderTaxIdType
ALTER TABLE [dbo].[RoutingOut] ADD
	CONSTRAINT [FK_RoutingOut_TaxIdType] FOREIGN KEY 
	(
		[ProviderTaxIdType]
	) REFERENCES [TaxIdType] (
		[TaxIdType]
	)
GO

-- ===========================================
-- foreign keys that haven't been created yet:

ALTER TABLE [dbo].[Batch] ADD
	CONSTRAINT [FK_Batch_PayerGatewayId] FOREIGN KEY 
	(
		[PayerGatewayId]
	) REFERENCES [PayerGateway] (
		[PayerGatewayId]
	)
GO

ALTER TABLE [dbo].[Batch] ADD
	CONSTRAINT [FK_Batch_RoutingType] FOREIGN KEY 
	(
		[RoutingType]
	) REFERENCES [RoutingType] (
		[RoutingType]
	)
GO

-- ===========================================
-- TaxId lookup table

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TaxId]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TaxId]
GO

CREATE TABLE TaxId (
	TaxIdId int IDENTITY (1, 1) NOT NULL ,
	TaxIdType char(2) NOT NULL, 	-- 24=EIN or 34=SSN or XX=National Provider ID
	TaxId varchar(30),
	CustomerId int,
	PracticeId int,
	Source varchar(30),
	SourceId int,			-- for example if that was a doctor, doctor ID
	SourceName varchar(256),
	SortOrder int,
	Approved bit,

	[CreatedDate] DATETIME NOT NULL CONSTRAINT DF_TaxId_CreatedDate DEFAULT (GETDATE()),
	[CreatedUserID] INT NOT NULL CONSTRAINT DF_TaxId_CreatedUserID DEFAULT (0),
	[ModifiedDate] DATETIME NOT NULL CONSTRAINT DF_TaxId_ModifiedDate DEFAULT (GETDATE()),
	[ModifiedUserID] INT NOT NULL CONSTRAINT DF_TaxId_ModifiedUserID DEFAULT (0),
	[TIMESTAMP] [timestamp] NULL
 )
GO

-- Add a foreign key for the ProviderTaxIdType
ALTER TABLE [dbo].[TaxId] ADD
	CONSTRAINT [FK_TaxId_TaxIdType] FOREIGN KEY 
	(
		[TaxIdType]
	) REFERENCES [TaxIdType] (
		[TaxIdType]
	)
GO

-- TaxId exceptions table. Contains tax ids that should be added to TaxId table to help in correlating.

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TaxIdOverride]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TaxIdOverride]
GO

CREATE TABLE TaxIdOverride (
	TaxIdOverrideId int IDENTITY (1, 1) NOT NULL ,
	TaxIdType char(2) NOT NULL, 	-- 24=EIN or 34=SSN or XX=National Provider ID
	TaxId varchar(30),
	CustomerId int,
	PracticeId int,
	Source varchar(30) CONSTRAINT DF_TaxIdOverride_Source DEFAULT ('override'),
	SourceId int CONSTRAINT DF_TaxIdOverride_SourceId DEFAULT (-1),
	SourceName varchar(256) CONSTRAINT DF_TaxIdOverride_SourceName DEFAULT ('override'),
	SortOrder int CONSTRAINT DF_TaxIdOverride_SortOrder DEFAULT (1),
	Approved bit,

	[CreatedDate] DATETIME NOT NULL CONSTRAINT DF_TaxIdOverride_CreatedDate DEFAULT (GETDATE()),
	[CreatedUserID] INT NOT NULL CONSTRAINT DF_TaxIdOverride_CreatedUserID DEFAULT (0),
	[ModifiedDate] DATETIME NOT NULL CONSTRAINT DF_TaxIdOverride_ModifiedDate DEFAULT (GETDATE()),
	[ModifiedUserID] INT NOT NULL CONSTRAINT DF_TaxIdOverride_ModifiedUserID DEFAULT (0),
	[TIMESTAMP] [timestamp] NULL
 )
GO

-- =============================================================
-- Add a foreign key for the ProviderTaxIdType
ALTER TABLE [dbo].[TaxIdOverride] ADD
	CONSTRAINT [FK_TaxIdOverride_TaxIdType] FOREIGN KEY 
	(
		[TaxIdType]
	) REFERENCES [TaxIdType] (
		[TaxIdType]
	)
GO

-- =============================================================
---- Add foreign keys for the ...Response tables
ALTER TABLE [dbo].ProxymedResponse ADD
	CONSTRAINT [FK_ProxymedResponse_ClearinghouseResponseType] FOREIGN KEY 
	(
		[ResponseType]
	) REFERENCES [ClearinghouseResponseType] (
		[ClearinghouseResponseType]
	)
GO

ALTER TABLE [dbo].OfficeAllyResponse ADD
	CONSTRAINT [FK_OfficeAllyResponse_ClearinghouseResponseType] FOREIGN KEY 
	(
		[ResponseType]
	) REFERENCES [ClearinghouseResponseType] (
		[ClearinghouseResponseType]
	)
GO

ALTER TABLE [dbo].BizclaimsResponse ADD
	CONSTRAINT [FK_BizclaimsResponse_ClearinghouseResponseType] FOREIGN KEY 
	(
		[ResponseType]
	) REFERENCES [ClearinghouseResponseType] (
		[ClearinghouseResponseType]
	)
GO

ALTER TABLE [dbo].PrefetcherFile ADD
	CONSTRAINT [FK_PrefetcherFile_ClearinghouseResponseType] FOREIGN KEY 
	(
		[ResponseType]
	) REFERENCES [ClearinghouseResponseType] (
		[ClearinghouseResponseType]
	)
GO

-- ===========================================
-- we need a linked server to get to Customer setup:

--EXEC sp_dropserver @server = 'RTMAINSERVER'
--GO

--EXEC sp_addlinkedserver 
--    @server = 'RTMAINSERVER',
--    @srvproduct = '',
--    @provider = 'SQLOLEDB',
--    @datasrc = 'KDB03.KAREOPROD.ENT',
--    @provstr = 'server=kdb04.kareoprod.ent;database=superbill_shared;Application Name=BizClaims;UID=DEVBIZCLAIMS;PWD=biz4talk;'
--GO

-- an sproc to add logins to link server is sp_addlinkedsrvlogin
EXEC sp_serveroption RTMAINSERVER,'rpc out','on'

-- EXEC sp_helpserver

---------------------------------------------------------------------------------------
--case XXXX - Description
---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
