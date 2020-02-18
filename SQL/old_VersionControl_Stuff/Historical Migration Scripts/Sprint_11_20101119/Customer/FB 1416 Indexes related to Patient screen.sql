--
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[InsurancePolicyAuthorization]') AND name = N'IX_InsurancePolicyAuthorization_InsurancePolicyID')
DROP INDEX [IX_InsurancePolicyAuthorization_InsurancePolicyID] ON [dbo].[InsurancePolicyAuthorization] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_InsurancePolicyAuthorization_InsurancePolicyID]
ON [dbo].[InsurancePolicyAuthorization] ([InsurancePolicyID])
INCLUDE ([InsurancePolicyAuthorizationID])
GO

--
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EligibilityHistory]') AND name = N'IX_EligibilityHistory_InsurancePolicyID')
DROP INDEX [IX_EligibilityHistory_InsurancePolicyID] ON [dbo].[EligibilityHistory] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_EligibilityHistory_InsurancePolicyID]
ON [dbo].[EligibilityHistory] ([InsurancePolicyID])
GO

--
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Appointment]') AND name = N'IX_Appointment_InsurancePolicyAuthorizationID')
DROP INDEX [IX_Appointment_InsurancePolicyAuthorizationID] ON [dbo].[Appointment] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_Appointment_InsurancePolicyAuthorizationID]
ON [dbo].[Appointment] ([InsurancePolicyAuthorizationID])
GO

--Include PatientCaseID to existing index
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Appointment]') AND name = N'IX_Appointment_PatientID')
DROP INDEX [IX_Appointment_PatientID] ON [dbo].[Appointment] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_Appointment_PatientID] ON [dbo].[Appointment] 
(
	[PatientID] ASC
)
INCLUDE ( [PatientCaseID]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 85) ON [PRIMARY]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[DMSDocumentToRecordAssociation]') AND name = N'IX_DMSDocumentToRecordAssociation_RecordID_RecordTypeID')
DROP INDEX [IX_DMSDocumentToRecordAssociation_RecordID_RecordTypeID] ON [dbo].[DMSDocumentToRecordAssociation] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_DMSDocumentToRecordAssociation_RecordID_RecordTypeID]
ON [dbo].[DMSDocumentToRecordAssociation] ([RecordID],[RecordTypeID])
GO