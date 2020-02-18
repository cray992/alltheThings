--------------------------------------------------------------------------------------------------------------
-- PracticeFusionOptOut table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PracticeFusionOptOut')
BEGIN

	CREATE TABLE [dbo].[PracticeFusionOptOut](
		[EmailAddress] [varchar](320) NOT NULL PRIMARY KEY,
		[OptOutDateTime] [datetime] NOT NULL
	)

END