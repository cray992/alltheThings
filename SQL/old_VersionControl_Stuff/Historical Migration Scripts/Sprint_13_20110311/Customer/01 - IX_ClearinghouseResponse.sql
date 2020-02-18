IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClearinghouseResponse]') AND name = N'IX_ClearinghouseResponse_Title_TotalAmount')
	DROP INDEX [IX_ClearinghouseResponse_Title_TotalAmount] ON [dbo].[ClearinghouseResponse] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_ClearinghouseResponse_Title_TotalAmount] ON [dbo].[ClearinghouseResponse] 
(
	[Title] ASC,
	[TotalAmount] ASC
)
GO