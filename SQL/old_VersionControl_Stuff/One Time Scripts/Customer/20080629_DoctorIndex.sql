IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Doctor]') AND name = N'IX_Doctor_FirstName')
BEGIN
	CREATE NONCLUSTERED INDEX [IX_Doctor_FirstName] ON [dbo].Doctor 
	(
		[FirstName] ASC
	) 
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Doctor]') AND name = N'IX_Doctor_LastName')
BEGIN
	CREATE NONCLUSTERED INDEX [IX_Doctor_LastName] ON [dbo].Doctor 
	(
		LastName ASC
	) 
END