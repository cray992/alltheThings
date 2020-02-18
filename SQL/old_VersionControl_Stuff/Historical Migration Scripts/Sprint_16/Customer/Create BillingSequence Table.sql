SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

/****** Object:  Table [dbo].[BillingSequence]    Script Date: 07/22/2011 17:49:03 ******/
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BillingSequence]') AND type in (N'U'))
BEGIN	
	CREATE TABLE [dbo].[BillingSequence](
		[BillingSequenceID] [int] IDENTITY(1,1) NOT NULL,
		[Description] [varchar](50) NOT NULL,
	 CONSTRAINT [PK_BillingSequence] PRIMARY KEY CLUSTERED 
	(
		[BillingSequenceID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]	
END

