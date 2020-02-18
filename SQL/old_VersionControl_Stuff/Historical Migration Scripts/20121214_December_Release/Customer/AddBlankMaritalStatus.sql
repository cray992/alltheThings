IF NOT EXISTS (SELECT * FROM dbo.MaritalStatus WHERE MaritalStatus = '')
BEGIN
	INSERT INTO [dbo].[MaritalStatus]([MaritalStatus], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID])
	SELECT N'', N'', '20090330 15:46:17.820', 0, '20090330 15:46:17.820', 0 
END