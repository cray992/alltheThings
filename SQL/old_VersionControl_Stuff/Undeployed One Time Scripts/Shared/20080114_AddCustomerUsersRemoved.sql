IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomerUsersRemoved]') AND type in (N'U'))
DROP TABLE [dbo].[CustomerUsersRemoved]
GO

CREATE TABLE [dbo].[CustomerUsersRemoved](
	[CustomerID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[UserRoleID] [int] NULL,
	[ModifiedDate] [datetime]
 CONSTRAINT [PK_CustomerUsersRemoved] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO