--Add to integration partner

USE [Superbill_Shared]
GO

INSERT INTO [dbo].[IntegrationPartner]
           ([PartnerName]
           ,[AppID]
           ,[PrivateKey]
           ,[CreatedDate]
           ,[Active])
     VALUES
           ('EHREmergencyUser'
           ,'7596120456'
           ,'b739629a-3692-44d5-afae-c6c4a0fb88c2'
           ,'2012-12-20 15:30:00.000'
           ,1)
GO


--Create table

USE [Superbill_Shared]
GO

/****** Object:  Table [dbo].[EHREmergencyUser]    Script Date: 1/8/2013 11:06:23 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EHREmergencyUser](
	[EHREmergencyUserId] [int] IDENTITY(50000000,1) NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[PasswordHash] [varchar](50) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[PracticeId] [int] NOT NULL,
	[PracticeGuid] [uniqueidentifier] NOT NULL,
	[Active] [bit] NOT NULL,
	[Notes] [varchar](2000) NULL,
	[UtcCreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[UtcUsedDate] [datetime] NULL,
 CONSTRAINT [PK_EHREmergencyUser] PRIMARY KEY CLUSTERED 
(
	[EHREmergencyUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_EHREmergencyUser_Username] ON [dbo].[EHREmergencyUser]
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


