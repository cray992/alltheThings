IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[BillTransmission]') AND name = N'IX_BillTransmission_PatientID_BillTransmissionFileTypeCode')
	DROP INDEX [IX_BillTransmission_PatientID_BillTransmissionFileTypeCode] ON [dbo].[BillTransmission] WITH ( ONLINE = OFF )
GO
	
CREATE NONCLUSTERED INDEX [IX_BillTransmission_PatientID_BillTransmissionFileTypeCode] ON [dbo].[BillTransmission] 
(
	[PatientID],
	[BillTransmissionFileTypeCode]
)
GO

