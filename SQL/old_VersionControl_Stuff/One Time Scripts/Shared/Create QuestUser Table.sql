-- drop table [dbo].[QuestUser]

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuestUser]') AND type in (N'U'))
BEGIN

	CREATE TABLE [dbo].[QuestUser](
		[UserID] INT NOT NULL,
		[CustomerID] INT NOT NULL,
		[QuestID] VARCHAR(180),
		[CreatedDate] DATETIME
	)

	ALTER TABLE [dbo].[QuestUser]
	ADD CONSTRAINT [PK_QuestUser]
	PRIMARY KEY ([UserID], [CustomerID])

	ALTER TABLE [dbo].[QuestUser]
	ADD CONSTRAINT [DF_QuestUser_CreatedDate]
	DEFAULT (GETDATE()) FOR [CreatedDate]

END
GO
