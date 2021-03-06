IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProviderNumber]') AND name = N'IX_ProviderNumber_DoctorID')
DROP INDEX [IX_ProviderNumber_DoctorID] ON [dbo].[ProviderNumber] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_ProviderNumber_DoctorID] ON [dbo].[ProviderNumber] 
(
	[DoctorID] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
