/*
	This code taken from BillDataProvider_GetHCFAFormXML_v2.sql
*/	

DECLARE @kareoStandardTimeUTCOffsetHours INT
DECLARE @kareoStandardTimeUTCOffsetMinutes INT
DECLARE @kareoDaylightSavingTimeUTCOffsetHours INT
DECLARE @kareoDaylightSavingTimeUTCOffsetMinutes INT

SELECT	@kareoStandardTimeUTCOffsetHours = StandardTimeUTCOffsetHours,
		@kareoStandardTimeUTCOffsetMinutes = StandardTimeUTCOffsetMinutes,
		@kareoDaylightSavingTimeUTCOffsetHours = DaylightSavingTimeUTCOffsetHours,
		@kareoDaylightSavingTimeUTCOffsetMinutes = DaylightSavingTimeUTCOffsetMinutes
FROM	TimeZone
WHERE	KareoServerTimeZone=1

UPDATE	EP
SET	EP.StartTimeText = CASE WHEN EP.StartTime IS NOT NULL THEN
									dbo.fn_FormatAnesthesiaTime(dbo.fn_AdjustDateTimeForTimeZone(	
										EP.StartTime, 
										@kareoStandardTimeUTCOffsetHours,
										@kareoStandardTimeUTCOffsetMinutes,
										@kareoDaylightSavingTimeUTCOffsetHours,
										@kareoDaylightSavingTimeUTCOffsetMinutes,
										TZ.StandardTimeUTCOffsetHours,
										TZ.StandardTimeUTCOffsetMinutes,
										TZ.DaylightSavingTimeUTCOffsetHours,
										TZ.DaylightSavingTimeUTCOffsetMinutes)) 
									ELSE dbo.fn_FormatAnesthesiaTime(EP.StartTime) END,
	EP.EndTimeText = CASE WHEN EP.EndTime IS NOT NULL THEN
									dbo.fn_FormatAnesthesiaTime(dbo.fn_AdjustDateTimeForTimeZone(	
										EP.EndTime, 
										@kareoStandardTimeUTCOffsetHours,
										@kareoStandardTimeUTCOffsetMinutes,
										@kareoDaylightSavingTimeUTCOffsetHours,
										@kareoDaylightSavingTimeUTCOffsetMinutes,
										TZ.StandardTimeUTCOffsetHours,
										TZ.StandardTimeUTCOffsetMinutes,
										TZ.DaylightSavingTimeUTCOffsetHours,
										TZ.DaylightSavingTimeUTCOffsetMinutes))
									ELSE dbo.fn_FormatAnesthesiaTime(ep.EndTime) END
FROM EncounterProcedure AS EP
	INNER JOIN Encounter AS E ON E.EncounterID = EP.EncounterID
	INNER JOIN	ServiceLocation SL (NOLOCK) ON SL.ServiceLocationID = E.LocationID
	INNER JOIN TimeZone TZ (NOLOCK) ON TZ.TimeZoneID = SL.TimeZoneID
WHERE EP.StartTime IS NOT NULL
	