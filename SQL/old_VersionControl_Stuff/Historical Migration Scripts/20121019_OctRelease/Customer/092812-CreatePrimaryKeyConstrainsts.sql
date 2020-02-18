
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS AS c WHERE c.COLUMN_NAME='ID' AND c.TABLE_NAME='ArAgingGraph_Data')
ALTER TABLE ARAGingGraph_Data ADD ID INT IDENTITY(1,1)
GO
IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_ArAgingGraph_Data_ID')
ALTER TABLE ARAGingGraph_Data ADD CONSTRAINT PK_ArAgingGraph_Data_ID PRIMARY KEY (ID)
GO
IF EXISTS(SELECT *  FROM sys.indexes AS i WHERE name='CI_ARGraphCache')
DROP INDEX [CI_ARGraphCache] ON [dbo].[ARGraphCache] WITH ( ONLINE = OFF )
GO

IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_PRacticeID_ARPeriodID')

ALTER TABLE [dbo].[ARGraphCache] ADD  CONSTRAINT [PK_PRacticeID_ARPeriodID] PRIMARY KEY NONCLUSTERED 
(
	[PracticeId] ASC,
	[ARPeriodId] ASC
)
GO


IF EXISTS(SELECT * FROM sys.tables AS t WHERE name='BigIntMap')
DROP TABLE BigIntMap
GO

IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_PaymentId_CapitatedAccountID')
ALTER TABLE CapitatedAccountToPayment ADD CONSTRAINT PK_PaymentId_CapitatedAccountID PRIMARY KEY (PaymentID, CapitatedAccountID)
GO

IF EXISTS(SELECT * FROM sys.indexes AS i WHERE name='IX_ClaimAccounting_ClaimTransactionID')
DROP INDEX [IX_ClaimAccounting_ClaimTransactionID] ON [dbo].[ClaimAccounting]
GO
IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_ClaimAccounting_ClaimTransactionID')
ALTER TABLE ClaimAccounting ADD CONSTRAINT PK_ClaimAccounting_ClaimTransactionID PRIMARY KEY (ClaimTransactionID)
GO


---------------------------------------------ClaimAccounting_Assignments------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimAccounting_Assignments]') AND name = N'CI_ClaimAccounting_Assignments')
DROP INDEX [CI_ClaimAccounting_Assignments] ON [dbo].[ClaimAccounting_Assignments] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimAccounting_Assignments]') AND name = N'IX_ClaimAccounting_Assignments_ClaimTransactionID')
DROP INDEX [IX_ClaimAccounting_Assignments_ClaimTransactionID] ON [dbo].[ClaimAccounting_Assignments]
GO

ALTER TABLE ClaimAccounting_Assignments ALTER COLUMN ClaimTransactionID INT NOT NULL

GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimAccounting_Assignments]') AND name = N'CI_ClaimAccounting_Assignments')
CREATE CLUSTERED INDEX [CI_ClaimAccounting_Assignments] ON [dbo].[ClaimAccounting_Assignments]
(
	[PracticeID] ASC,
	[DKPostingDateID] DESC,
	[DKEndPostingDateID] DESC,
	[ClaimTransactionID] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO

IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE Name = 'PK_ClaimAccounting_Assignments_ClaimTransactionID')
ALTER TABLE ClaimAccounting_Assignments ADD CONSTRAINT PK_ClaimAccounting_Assignments_ClaimTransactionID PRIMARY KEY (ClaimTransactionID)

GO

-----------------------------------------------------------------------------------------------------------------------------------



IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimAccounting_Billings]') AND name = N'CI_ClaimAccounting_Billings')
DROP INDEX [CI_ClaimAccounting_Billings] ON [dbo].[ClaimAccounting_Billings] WITH ( ONLINE = OFF )
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimAccounting_Billings]') AND name = N'IX_ClaimAccounting_Billings_ClaimTransactionID_INC_ClaimID_PostingDate')
DROP INDEX [IX_ClaimAccounting_Billings_ClaimTransactionID_INC_ClaimID_PostingDate] ON [dbo].[ClaimAccounting_Billings]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimAccounting_Billings]') AND name = N'IX_ClaimAcounting_Billings_Posting_Date_INC_PracticeID_ClaimID_ClaimTransactionID_BatchType')
DROP INDEX [IX_ClaimAcounting_Billings_Posting_Date_INC_PracticeID_ClaimID_ClaimTransactionID_BatchType] ON [dbo].[ClaimAccounting_Billings]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vReportDataProvider_LastBilledClaims]'))
DROP VIEW [dbo].[vReportDataProvider_LastBilledClaims]
GO
ALTER TABLE ClaimAccounting_Billings ALTER COLUMN ClaimTransactionID INT NOT NULL
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimAccounting_Billings]') AND name = N'CI_ClaimAccounting_Billings')
CREATE CLUSTERED INDEX [CI_ClaimAccounting_Billings] ON [dbo].[ClaimAccounting_Billings]
(
	[PracticeID] ASC,
	[DKPostingDateID] DESC,
	[DKEndPostingDateID] DESC,
	[ClaimTransactionID] DESC
)

GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vReportDataProvider_LastBilledClaims]'))
EXEC dbo.sp_executesql @statement = N'

Create View [dbo].[vReportDataProvider_LastBilledClaims]
With SCHEMABinding

AS 

SELECT 
				CAB.PracticeID,
				CAB.ClaimID
				,  ClaimTransactionID
				, case when BatchType = ''S'' THEN ''Patient'' ELSE ''Insurance'' END AS TypeGroup
				,CAB.PostingDate

			FROM dbo.ClaimAccounting_Billings CAB 
			WHERE	LastBilled=1 		
			
' 
GO




IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimAccounting_Billings]') AND name = N'IX_ClaimAcounting_Billings_Posting_Date_INC_PracticeID_ClaimID_ClaimTransactionID_BatchType')
CREATE NONCLUSTERED INDEX [IX_ClaimAcounting_Billings_Posting_Date_INC_PracticeID_ClaimID_ClaimTransactionID_BatchType] ON [dbo].[ClaimAccounting_Billings]
(
	[PostingDate] ASC
)
INCLUDE ( 	[PracticeID],
	[ClaimID],
	[ClaimTransactionID],
	[BatchType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO



IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimAccounting_Billings]') AND name = N'IX_ClaimAccounting_Billings_ClaimTransactionID_INC_ClaimID_PostingDate')
CREATE NONCLUSTERED INDEX [IX_ClaimAccounting_Billings_ClaimTransactionID_INC_ClaimID_PostingDate] ON [dbo].[ClaimAccounting_Billings]
(
	[ClaimTransactionID] ASC
)
INCLUDE ( 	[ClaimID],
	[PostingDate]) 
GO

IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_ClaimTransactionID')
ALTER TABLE ClaimAccounting_Billings ADD CONSTRAINT PK_ClaimTransactionID PRIMARY KEY (ClaimTransactionID)

GO
----------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimAccounting_ClaimPeriod]') AND name = N'CI_ClaimAccounting_ClaimPeriod')
DROP INDEX [CI_ClaimAccounting_ClaimPeriod] ON [dbo].[ClaimAccounting_ClaimPeriod] WITH ( ONLINE = OFF )
GO

ALTER TABLE ClaimAccounting_ClaimPeriod ALTER COLUMN ProviderId INT NOT NULL

ALTER TABLE ClaimAccounting_ClaimPeriod ALTER COLUMN PatientID INT NOT NULL

ALTER TABLE ClaimAccounting_ClaimPeriod ALTER COLUMN ClaimID INT NOT NULL

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimAccounting_ClaimPeriod]') AND name = N'CI_ClaimAccounting_ClaimPeriod')
CREATE CLUSTERED INDEX [CI_ClaimAccounting_ClaimPeriod] ON [dbo].[ClaimAccounting_ClaimPeriod]
(
	[ClaimID] ASC,
	[DKInitialPostingDateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO
IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_ClaimAccounting_ClaimPeriod')
ALTER TABLE ClaimAccounting_ClaimPeriod ADD CONSTRAINT PK_ClaimAccounting_ClaimPeriod PRIMARY KEY (ProviderID, PatientID, ClaimId)
GO

---------------------------------------------------------------
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS AS c where column_NAME ='ClaimDenialMessagesID' AND c.TABLE_NAME='ClaimDenialMessages')
ALTER TABLE ClaimDenialMessages ADD ClaimDenialMessagesID INT IDENTITY(1,1)
GO
IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_ClaimDenialMessagesID')
ALTER TABLE ClaimDenialMessages ADD CONSTRAINT PK_ClaimDenialMessagesID PRIMARY KEY (ClaimDenialMessagesID)
GO
------------------------------------------------------------------------


IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_ContractToDoctorID')

ALTER TABLE ContractToDoctor 
ADD CONSTRAINT PK_ContractToDoctorID PRIMARY KEY(ContractToDoctorID)
--------------------------------------------------------------
IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_ContractToInsurancePlanID')
ALTER TABLE ContractToInsurancePlan 
ADD CONSTRAINT PK_ContractToInsurancePlanID PRIMARY KEY(ContractToInsurancePlanID)
GO

IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_ContractToServiceLocationID')
ALTER TABLE ContractToServiceLocation 
ADD CONSTRAINT PK_ContractToServiceLocationID PRIMARY KEY(ContractToServiceLocationID)
GO
--------------------------------------------------------------------------
IF EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='UIX_CustomerPracticeMap')
ALTER TABLE CustomerMapPractice DROP CONSTRAINT UIX_CustomerPRacticeMap
GO
/****** Object:  Index [UIX_CustomerPracticeMap]    Script Date: 10/1/2012 9:55:31 AM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomerMapPractice]') AND name = N'UIX_CustomerPracticeMap')
ALTER TABLE [dbo].[CustomerMapPractice] ADD  CONSTRAINT [UIX_CustomerPracticeMap] PRIMARY KEY 
(
	[FromCustomerID] ASC,
	[ToCustomerID] ASC,
	[PracticeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
---------------------------------------------------------------------

Alter Table DateKey Alter Column DKID INT NOT NULL
GO
IF NOT exists(Select * from sys.key_constraints where name='PK_DateKey_DKID')
Alter TAble DateKey Add Constraint PK_DateKey_DKID Primary Key(DKID)
GO
----------------------------------------------
IF NOT exists(Select * from sys.key_constraints where name='PK_DateKeytoPractice_DKPRACTICEID')
ALTER TABLE DateKeyToPractice ADD CONSTRAINT PK_DateKeytoPractice_DKPracticeID PRIMARY KEY (DKPracticeID)
GO
------------------------------------



IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[DMSDocumentToRecordAssociation]') AND name = N'CI_DMSDocumentToRecordAssociation')
DROP INDEX [CI_DMSDocumentToRecordAssociation] ON [dbo].[DMSDocumentToRecordAssociation] WITH ( ONLINE = OFF )
GO
IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_DMSDocumentToRecordAssociation')
ALTER TABLE DMSDocumentToRecordAssociation ADD CONSTRAINT PK_DMSDocumentToRecordAssociation PRIMARY KEY ([RecordTypeID] ASC,
	[RecordID] DESC,
	[DMSDocumentID] DESC)

-----------------------------------------------------
GO
IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_PatientCaseToAttorney')
ALTER TABLE PatientCaseToAttorney ADD CONSTRAINT PK_PatientCaseToAttorney PRIMARY KEY(PatientCaseToAttorneyID)
GO
-------------------------


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PaymentAuthorization]') AND name = N'CI_PaymemtAuthorization')
DROP INDEX [CI_PaymemtAuthorization] ON [dbo].[PaymentAuthorization] WITH ( ONLINE = OFF )
GO

IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_PaymentAuthorization')
ALTER TABLE PaymentAuthorization ADD CONSTRAINT PK_PaymentAuthorization PRIMARY KEY(PaymentAuthorizationID)
GO

ALTER TABLE PaymentAVRCode ALTER COLUMN Code VARCHAR(10) NOT NULL
GO
IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_PaymentAvrCode')

ALTER TABLE PaymentAvrCode ADD CONSTRAINT PK_PaymentAvrCode PRIMARY KEY (Code)
GO

ALTER TABLE PaymentCVRCode ALTER COLUMN Code VARCHAR(10) NOT NULL
GO
IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_PaymentCVRCode')

ALTER TABLE PaymentCVRCode ADD CONSTRAINT PK_PaymentCVRCode PRIMARY KEY (Code)
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PaymentResponseCode]') AND name = N'CI_PaymentResponseCode')
DROP INDEX [CI_PaymentResponseCode] ON [dbo].[PaymentResponseCode] WITH ( ONLINE = OFF )
GO

ALTER TABLE PaymentResponseCode ALTER COLUMN Code VARCHAR(10) NOT NULL
GO
IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_PaymentResponseCode')

ALTER TABLE PaymentResponseCode ADD CONSTRAINT PK_PaymentResponseCode PRIMARY KEY (Code)
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProcedureMacroDetail]') AND name = N'CI_ProcedureMacroDetail')
DROP INDEX [CI_ProcedureMacroDetail] ON [dbo].[ProcedureMacroDetail] WITH ( ONLINE = OFF )
GO
IF NOT EXISTS (SELECT * FROM sys.key_constraints AS kc WHERE name = N'PK_ProcedureMacroDetail')
ALTER TABLE ProcedureMacroDetail ADD CONSTRAINT PK_ProcedureMacroDetail PRIMARY KEY (
	[ProcedureMacroID] ASC,
	[ProcedureMacroDetailID] ASC
)
GO
IF NOT EXISTS (SELECT * FROM sys.key_constraints AS kc WHERE name = N'PK_ProviderType')
ALTER TABLE ProviderType ADD CONSTRAINT PK_ProviderType PRIMARY KEY (ProviderTypeID)
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS AS c WHERE c.COLUMN_NAME='ClaimsAccuracyID' AND c.TABLE_NAME='Reporting_ClaimsAccuracy')
ALTER TABLE Reporting_ClaimsAccuracy ADD ClaimsAccuracyID INT IDENTITY(1,1)
GO
 IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_ClaimAccuracy')
 ALTER TABLE Reporting_ClaimsAccuracy ADD CONSTRAINT PK_ClaimAccuracy PRIMARY KEY(ClaimsAccuracyID)
GO
IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_ServiceTypeCodePayerNumber')
ALTER TABLE ServiceTypeCodePayerNumber ADD CONSTRAINT PK_ServiceTypeCodePayerNumber PRIMARY KEY(ServiceTypeCodePayerNumberID)
GO
IF EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_SystemProcedureCounter')
ALTER TABLE SystemProcedureCounter DROP CONSTRAINT PK_SystemProcedureCounter

GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[SystemProcedureCounter]') AND name = N'PK_SystemProcedureCounter')
DROP INDEX [PK_SystemProcedureCounter] ON [dbo].[SystemProcedureCounter] WITH ( ONLINE = OFF )
GO
ALTER TABLE SystemProcedureCounter ALTER COLUMN ProcedureName VARCHAR(250) NOT NULL

GO

IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_SystemProcedureCounter')
ALTER TABLE SystemProcedureCounter ADD CONSTRAINT  PK_SystemProcedureCounter PRIMARY KEY 
(
	[ProcedureName] ASC
)
GO

IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_VendorImport')
ALTER TABLE VendorImport ADD CONSTRAINT PK_VendorImport PRIMARY KEY(VendorImportID)
GO
IF NOT EXISTS(SELECT * FROM sys.key_constraints AS kc WHERE name='PK_VendorImportStatus')
ALTER TABLE VendorImportStatus ADD CONSTRAINT PK_VendorImportStatus PRIMARY KEY(VendorImportStatusID)
GO
