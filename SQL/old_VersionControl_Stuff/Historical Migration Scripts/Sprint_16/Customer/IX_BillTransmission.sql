IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[BillTransmission]') AND name = N'IX_BillTransmission_BillTransmissionFileTypeCode')
BEGIN
	DROP INDEX [IX_BillTransmission_BillTransmissionFileTypeCode] ON [dbo].[BillTransmission]
END
GO

CREATE NONCLUSTERED INDEX [IX_BillTransmission_BillTransmissionFileTypeCode] ON [dbo].[BillTransmission] 
(
	[BillTransmissionFileTypeCode] ASC
)
INCLUDE ([FileName], [ReferenceID])
