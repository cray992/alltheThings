IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClearinghouseResponse]') AND name = N'IX_ClearinghouseResponse_FileName')
DROP INDEX [IX_ClearinghouseResponse_FileName] ON [dbo].[ClearinghouseResponse] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_ClearinghouseResponse_FileName] ON [dbo].[ClearinghouseResponse] 
(
	[FileName] ASC
)WITH (PAD_INDEX  = ON, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF, FILLFACTOR = 90) ON [PRIMARY]
GO