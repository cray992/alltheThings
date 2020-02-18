/****** Object:  Table [dbo].[DeletedEntitiesInfo]    Script Date: 12/02/2012 19:13:56 ******/
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeletedEntitiesInfo]') AND type in (N'U'))

CREATE TABLE [dbo].[DeletedEntitiesInfo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EntityGuid] [uniqueidentifier] NOT NULL,
	[DeletedDate] [datetime] NOT NULL,
	[EntityType] [varchar](50) NOT NULL,
	[ModifiedUserID] INT NOT NULL
 CONSTRAINT [PK_DeletedEntitiesInfo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO



/****** Object:  Index [UX_DeletedEntitiesInfo]    Script Date: 12/02/2012 22:56:16 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[DeletedEntitiesInfo]') AND name = N'IX_DeletedEntitiesInfo_EntityType_EntityGuid_DeletedDate')

CREATE NONCLUSTERED INDEX [IX_DeletedEntitiesInfo_EntityType_EntityGuid_DeletedDate] ON [dbo].[DeletedEntitiesInfo] (EntityType, [EntityGuid], DeletedDate) INCLUDE (ModifiedUserID) ON [PRIMARY]