IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProcedureCodeDictionary]') AND name = N'IX_ProcedureCodeDictionary_TypeOfServiceCode')
BEGIN
	DROP INDEX [IX_ProcedureCodeDictionary_TypeOfServiceCode] ON [dbo].[ProcedureCodeDictionary]
END
GO

CREATE NONCLUSTERED INDEX [IX_ProcedureCodeDictionary_TypeOfServiceCode] ON [dbo].[ProcedureCodeDictionary] 
(
	[TypeOfServiceCode] ASC
)

