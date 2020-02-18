IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AppointmentPhoneReminders_QueueDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AppointmentPhoneReminders] DROP CONSTRAINT [DF_AppointmentPhoneReminders_QueueDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AppointmentPhoneReminders_ReminderSent]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AppointmentPhoneReminders] DROP CONSTRAINT [DF_AppointmentPhoneReminders_ReminderSent]
END

GO

/****** Object:  Table [dbo].[AppointmentPhoneReminders]    Script Date: 01/04/2012 13:54:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AppointmentPhoneReminders]') AND type in (N'U'))
DROP TABLE [dbo].[AppointmentPhoneReminders]
GO

USE [Superbill_Shared]
GO

/****** Object:  Table [dbo].[AppointmentPhoneReminders]    Script Date: 01/04/2012 13:54:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[AppointmentPhoneReminders](
	[AppointmentPhoneReminderID] [int] IDENTITY(1,1) NOT NULL,
	[QueueDate] [datetime] NOT NULL,
	[JobID] [uniqueidentifier] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[PracticeID] [int] NOT NULL,
	[PatientID] [int] NOT NULL,
	[PracticeName] [varchar](50) NOT NULL,
	[PatientFirstName] [varchar](50) NOT NULL,
	[PatientLastName] [varchar](50) NOT NULL,
	[AppointmentDateTime] [datetime] NOT NULL,
	[ReminderSent] [bit] NOT NULL,
	[Error] [varchar](max) NULL,
	[PatientMobilePhone] [varchar](10) NULL,
	[PatientHomePhone] [varchar](10) NULL,
	[PatientWorkPhone] [varchar](10) NULL,
	[DateSent] DATETIME NULL,
	[PracticePhone] [varchar](10) NULL
 CONSTRAINT [PK_AppointmentPhoneReminders] PRIMARY KEY CLUSTERED 
(
	[AppointmentPhoneReminderID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[AppointmentPhoneReminders] ADD  CONSTRAINT [DF_AppointmentPhoneReminders_QueueDate]  DEFAULT (getdate()) FOR [QueueDate]
GO

ALTER TABLE [dbo].[AppointmentPhoneReminders] ADD  CONSTRAINT [DF_AppointmentPhoneReminders_ReminderSent]  DEFAULT ((0)) FOR [ReminderSent]
GO


