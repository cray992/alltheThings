IF EXISTS (SELECT NAME FROM sys.indexes WHERE name = 'IX_EventNotification_Processed_EventNotificationID_ReferenceID_CreatedDateUtc')
BEGIN
	DROP INDEX dbo.EventNotification.IX_EventNotification_Processed_EventNotificationID_ReferenceID_CreatedDateUtc
END

ALTER TABLE dbo.EventNotification
ALTER COLUMN ReferenceID VARCHAR(32)

CREATE CLUSTERED INDEX [IX_EventNotification_Processed_EventNotificationID_ReferenceID_CreatedDateUtc] ON [dbo].[EventNotification] 
(
	[Processed] ASC,
	[EventNotificationID] ASC,
	[ReferenceID] ASC,
	[CreatedDateUtc] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO



ALTER TABLE dbo.ProcessingLogEntry
ALTER COLUMN ReferenceID VARCHAR(32)