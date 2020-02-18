IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProcedureCodeDictionary]') AND name = N'IX_ProcedureCodeDictionary_BillableCode')
BEGIN
	DROP INDEX [IX_ProcedureCodeDictionary_BillableCode] ON [dbo].[ProcedureCodeDictionary]
END
GO

CREATE NONCLUSTERED INDEX [IX_ProcedureCodeDictionary_BillableCode] ON [dbo].[ProcedureCodeDictionary] 
(
	[BillableCode] ASC
)

