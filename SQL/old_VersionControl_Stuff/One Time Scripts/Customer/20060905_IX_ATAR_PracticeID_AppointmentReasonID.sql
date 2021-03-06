IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AppointmentToAppointmentReason]') AND name = N'IX_ATAR_PracticeID_AppointmentReasonID')
DROP INDEX [IX_ATAR_PracticeID_AppointmentReasonID] ON [dbo].[AppointmentToAppointmentReason] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_ATAR_PracticeID_AppointmentReasonID] ON [dbo].[AppointmentToAppointmentReason] 
(
	[PracticeID] ASC,
	[AppointmentReasonID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO