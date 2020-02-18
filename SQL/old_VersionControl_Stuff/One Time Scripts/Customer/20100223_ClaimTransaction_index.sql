--/****** Object:  Index [IX_ClaimTransaction_PatientID_ClaimTransactionTypeCode]    Script Date: 02/23/2010 09:32:49 ******/
--IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimTransaction]') AND name = N'IX_ClaimTransaction_PatientID_ClaimTransactionTypeCode')
--DROP INDEX [IX_ClaimTransaction_PatientID_ClaimTransactionTypeCode] ON [dbo].[ClaimTransaction] WITH ( ONLINE = OFF )
--GO


--/****** Object:  Index [IX_ClaimTransaction_PatientID_ClaimTransactionTypeCode]    Script Date: 02/23/2010 09:32:50 ******/
--CREATE NONCLUSTERED INDEX [IX_ClaimTransaction_PatientID_ClaimTransactionTypeCode] ON [dbo].[ClaimTransaction] 
--(
--	[PatientID] ASC,
--	[ClaimTransactionTypeCode] ASC
--)
--INCLUDE ( [CreatedDate]) 
