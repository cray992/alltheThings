IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Patient]') AND name = N'IX_Patient_AddressLine1')
	DROP INDEX [IX_Patient_AddressLine1] ON [dbo].[Patient] WITH ( ONLINE = OFF )
	
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Patient]') AND name = N'IX_Patient_AddressLine2')
	DROP INDEX [IX_Patient_AddressLine2] ON [dbo].[Patient] WITH ( ONLINE = OFF )
	
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Patient]') AND name = N'IX_Patient_ZipCode')
	DROP INDEX [IX_Patient_ZipCode] ON [dbo].[Patient] WITH ( ONLINE = OFF )
	
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Patient]') AND name = N'IX_Patient_City')
	DROP INDEX [IX_Patient_City] ON [dbo].[Patient] WITH ( ONLINE = OFF )
	
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Patient]') AND name = N'IX_Patient_State')
	DROP INDEX [IX_Patient_State] ON [dbo].[Patient] WITH ( ONLINE = OFF )
	
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Patient]') AND name = N'IX_Patient_HomePhone')
	DROP INDEX [IX_Patient_HomePhone] ON [dbo].[Patient] WITH ( ONLINE = OFF )
	
