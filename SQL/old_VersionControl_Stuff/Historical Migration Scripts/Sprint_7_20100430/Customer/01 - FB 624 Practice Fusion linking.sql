/*
	FB 624 - Add field to Practice to allow linking to Practice Fusion
	
	DROP TABLE PracticeIntegration
*/
--------------------------------------------------------------------------------------------------------------
-- PracticeIntegration table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PracticeIntegration')
BEGIN
	CREATE TABLE [dbo].[PracticeIntegration](
		[PracticeID] [int] NOT NULL,
		[PracticeFusionID] [varchar](100) NULL,
		[PracticeFusionStatus] [char](1) NULL,
		[Notes] [varchar](max) NULL,
		[CreatedDate] [datetime] NOT NULL,
		[ModifiedDate] [datetime] NOT NULL,
		[CreatedUserID] [int] NOT NULL,
		[ModifiedUserID] [int] NOT NULL,
		[Timestamp] [timestamp] NOT NULL,
	 CONSTRAINT [PK_PracticeIntegration] PRIMARY KEY CLUSTERED 
	(
		[PracticeID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[PracticeIntegration]  WITH CHECK ADD  CONSTRAINT [FK_PracticeIntegration_Practice] FOREIGN KEY([PracticeID])
	REFERENCES [dbo].[Practice] ([PracticeID])
	ON DELETE CASCADE

	ALTER TABLE [dbo].[PracticeIntegration] CHECK CONSTRAINT [FK_PracticeIntegration_Practice]

	ALTER TABLE [dbo].[PracticeIntegration] ADD  CONSTRAINT [DF_PracticeIntegration_PracticeFusionStatus]  DEFAULT ('N') FOR [PracticeFusionStatus]
	ALTER TABLE [dbo].[PracticeIntegration]  WITH CHECK ADD  CONSTRAINT [CK_PracticeIntegration_PracticeFusionStatus] CHECK  (([PracticeFusionStatus]='N' OR [PracticeFusionStatus]='C'))
	ALTER TABLE [dbo].[PracticeIntegration] CHECK CONSTRAINT [CK_PracticeIntegration_PracticeFusionStatus]
END
GO