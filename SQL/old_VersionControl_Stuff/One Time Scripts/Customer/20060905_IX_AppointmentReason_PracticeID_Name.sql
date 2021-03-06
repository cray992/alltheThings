IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AppointmentReason]') AND name = N'IX_AppointmentReason_PracticeID_Name')
DROP INDEX [IX_AppointmentReason_PracticeID_Name] ON [dbo].[AppointmentReason] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_AppointmentReason_PracticeID_Name] ON [dbo].[AppointmentReason] 
(
	[PracticeID] ASC,
	[Name] ASC
)
INCLUDE ( [DefaultDurationMinutes],
[DefaultColorCode],
[Description],
[AppointmentReasonID]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO