IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[DMSFileInfo]') AND name = N'IX_DMSFileInfo_DMSDocumentID')
DROP INDEX [IX_DMSFileInfo_DMSDocumentID] ON [dbo].[DMSFileInfo] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_DMSFileInfo_DMSDocumentID] ON [dbo].[DMSFileInfo] 
(
	[DMSDocumentID] ASC
)
INCLUDE ( [Ext],
[MimeType],
[SizeInBytes]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO