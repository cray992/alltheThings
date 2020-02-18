SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[RecurringAppointments](
	[RecurringAppointmentID] [int] IDENTITY(1,1) NOT NULL,
	[PracticeID] [int] NOT NULL,
	[TicketNumber] [varchar](32) NOT NULL,
	[AppointmentID] [int] NOT NULL,
	[PatientID] [int] NOT NULL,
	[HL7Sent] [bit] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
 CONSTRAINT [PK_RecurringAppointments] PRIMARY KEY CLUSTERED 
(
	[RecurringAppointmentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[RecurringAppointments] ADD  CONSTRAINT [DF_RecurringAppointments_HL7Sent]  DEFAULT ((0)) FOR [HL7Sent]
GO

ALTER TABLE [dbo].[RecurringAppointments] ADD  CONSTRAINT [DF_RecurringAppointments_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO

CREATE INDEX [IX_RecurringAppointments_TicketNumber] ON [dbo].[RecurringAppointments] (TicketNumber) INCLUDE (PracticeID)
GO

CREATE INDEX [IX_RecurringAppointments_HL7Sent] ON [dbo].[RecurringAppointments] (HL7Sent)
GO