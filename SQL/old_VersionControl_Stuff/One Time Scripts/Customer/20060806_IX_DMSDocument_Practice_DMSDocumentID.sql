IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[DMSDocument]') AND name = N'IX_DMSDocument_PracticeID')
DROP INDEX [IX_DMSDocument_PracticeID] ON [dbo].[DMSDocument] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[DMSDocument]') AND name = N'IX_DMSDocument_PracticeID_DMSDocumentID')
DROP INDEX [IX_DMSDocument_PracticeID_DMSDocumentID] ON [dbo].[DMSDocument] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_DMSDocument_PracticeID_DMSDocumentID] ON [dbo].[DMSDocument] 
(
	[PracticeID] ASC,
	[DMSDocumentID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

GO