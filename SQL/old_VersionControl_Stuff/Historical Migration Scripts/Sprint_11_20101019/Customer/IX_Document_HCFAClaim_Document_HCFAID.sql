IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Document_HCFAClaim]') AND name = N'IX_Document_HCFAClaim_Document_HCFAID')
BEGIN
	DROP INDEX [IX_Document_HCFAClaim_Document_HCFAID] ON [dbo].[Document_HCFAClaim] WITH ( ONLINE = OFF )
END

CREATE NONCLUSTERED INDEX [IX_Document_HCFAClaim_Document_HCFAID] ON [dbo].[Document_HCFAClaim] 
(
	[Document_HCFAID] ASC
)

