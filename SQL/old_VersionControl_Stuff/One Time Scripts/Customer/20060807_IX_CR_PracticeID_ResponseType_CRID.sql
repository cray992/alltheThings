
IF  EXISTS (SELECT * FROM sys.objects WHERE name = N'PK_ClearinghouseResponse' and type='PK')
BEGIN
	ALTER TABLE [dbo].[ClearinghouseResponse] DROP CONSTRAINT [PK_ClearinghouseResponse]	
END
GO

/****** Object:  Index [PK_ClearinghouseResponse]    Script Date: 08/07/2006 18:25:47 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'ClearinghouseResponse') AND name = N'PK_ClearinghouseResponse')
BEGIN
	DROP INDEX ClearinghouseResponse.PK_ClearinghouseResponse	
END
GO

ALTER TABLE [dbo].[ClearinghouseResponse] ADD  CONSTRAINT [PK_ClearinghouseResponse] PRIMARY KEY NONCLUSTERED 
(
	[ClearinghouseResponseID] ASC
)

GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClearinghouseResponse]') AND name = N'IX_CR_PracticeID_ResponseType_CRID')
DROP INDEX [IX_CR_PracticeID_ResponseType_CRID] ON [dbo].[ClearinghouseResponse] WITH ( ONLINE = OFF )
GO

CREATE CLUSTERED INDEX [IX_CR_PracticeID_ResponseType_CRID] ON [dbo].[ClearinghouseResponse] 
(
	[PracticeID] ASC,
	[ResponseType] ASC,
	[ClearinghouseResponseID] ASC
)


GO