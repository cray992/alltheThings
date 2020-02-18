IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClearinghouseResponse]') AND name = N'IX_ClearinghouseResponse_FileReceiveDate_ResponseType')
BEGIN
	DROP INDEX [IX_ClearinghouseResponse_FileReceiveDate_ResponseType] ON [dbo].[ClearinghouseResponse] WITH ( ONLINE = OFF )
END

CREATE NONCLUSTERED INDEX [IX_ClearinghouseResponse_FileReceiveDate_ResponseType] ON [dbo].[ClearinghouseResponse] 
(
	[FileReceiveDate] DESC,
	[ResponseType] ASC
)