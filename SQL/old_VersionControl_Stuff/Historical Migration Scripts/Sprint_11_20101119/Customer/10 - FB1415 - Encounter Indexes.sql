-- EncounterDataProvider_GetEncounterProcedures
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimTransaction]') AND name = N'IX_ClaimTransaction_ClaimID')
BEGIN
	DROP INDEX [IX_ClaimTransaction_ClaimID] ON [dbo].[ClaimTransaction] WITH ( ONLINE = OFF )
END

CREATE NONCLUSTERED INDEX [IX_ClaimTransaction_ClaimID_ClaimTransactionTypeCode] ON [dbo].[ClaimTransaction] 
(
	[ClaimID] ASC,
	[ClaimTransactionTypeCode] ASC
)

-- LookupDataProvider_DiagnosisCodeDictionary
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[DiagnosisCodeDictionary]') AND name = N'IX_DiagnosisCodeDictionary_Active_RecordTimeStamp_INC_ID_DiagnosisCode')
BEGIN
	DROP INDEX [IX_DiagnosisCodeDictionary_Active_RecordTimeStamp_INC_ID_DiagnosisCode] ON [dbo].[DiagnosisCodeDictionary] WITH ( ONLINE = OFF )
END

CREATE NONCLUSTERED INDEX [IX_DiagnosisCodeDictionary_Active_RecordTimeStamp_INC_ID_DiagnosisCode] ON [dbo].[DiagnosisCodeDictionary] 
(
	[Active] ASC,
	[RecordTimeStamp] ASC
)
INCLUDE ([DiagnosisCodeDictionaryID], [DiagnosisCode])

-- PaymentDataProvider_GetPaymentDetailForAppointment
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payment]') AND name = N'IX_Payment_AppointmentID_AppointmentStartDate')
BEGIN
	DROP INDEX [IX_Payment_AppointmentID_AppointmentStartDate] ON [dbo].[Payment] WITH ( ONLINE = OFF )
END

CREATE NONCLUSTERED INDEX [IX_Payment_AppointmentID_AppointmentStartDate] ON [dbo].[Payment] 
(
	[AppointmentID] ASC,
	[AppointmentStartDate] ASC
)