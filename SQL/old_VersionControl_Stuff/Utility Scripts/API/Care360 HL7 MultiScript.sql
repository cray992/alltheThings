USE hl7_shard
go

SELECT  COUNT(*) AS UnprocessedEvents
FROM    dbo.EventNotification
WHERE   Processed = 0

SELECT TOP 10 *
FROM    dbo.EventNotification
ORDER BY EventNotificationID DESC
