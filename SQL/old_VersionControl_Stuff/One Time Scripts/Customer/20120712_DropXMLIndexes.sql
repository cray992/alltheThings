
/****** Object:  Index [IX_PaymentClaim_eobXML_Path]    Script Date: 07/12/2012 14:42:00 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PaymentClaim]') AND name = N'IX_PaymentClaim_eobXML_Path')
DROP INDEX [IX_PaymentClaim_eobXML_Path] ON [dbo].[PaymentClaim]
GO


/****** Object:  Index [IX_PaymentClaim_eobXML]    Script Date: 07/12/2012 14:42:30 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PaymentClaim]') AND name = N'IX_PaymentClaim_eobXML')
DROP INDEX [IX_PaymentClaim_eobXML] ON [dbo].[PaymentClaim]
GO



