
/****** Object:  Table [dbo].[ClaimResponseType]    Script Date: 07/10/2012 16:12:30 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__ClaimTransaction_ClaimResponseStatusID]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClaimTransaction]'))
ALTER TABLE [dbo].[ClaimTransaction] DROP CONSTRAINT [FK__ClaimTransaction_ClaimResponseStatusID]
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClaimResponseStatus]') AND type in (N'U'))
DROP TABLE [dbo].[ClaimResponseStatus]
GO


/****** Object:  Table [dbo].[ClaimResponseType]    Script Date: 07/10/2012 16:12:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ClaimResponseStatus](
	[ClaimResponseStatusID] [int] IDENTITY(1,1) NOT NULL,
	[ClaimResponseStatus] [varchar](64) NULL,
PRIMARY KEY CLUSTERED 
(
	[ClaimResponseStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


IF NOT EXISTS(SELECT *
FROM sys.columns AS c 
INNER JOIN sys.objects o ON c.OBJECT_ID=o.OBJECT_ID
WHERE c.name='ClaimResponseStatusID' AND o.name='ClaimTransaction' )
BEGIN
ALTER TABLE ClaimTransaction
ADD ClaimResponseStatusID INT 
END 




ALTER TABLE [dbo].[ClaimTransaction]  WITH NOCHECK ADD CONSTRAINT [FK__ClaimTransaction_ClaimResponseStatusID] FOREIGN KEY ([ClaimResponseStatusID])
REFERENCES [dbo].[ClaimResponseStatus] ([ClaimResponseStatusID])
GO


