DECLARE @PracticeID int
SET @PracticeID = 47

SELECT 
	FS.ScheduleName, 
	FS.Description AS ScheduleDescription, 
	PF.PracticeFeeID, 
	PCD.ProcedureCode, 
	PCD.ProcedureName, 
	PCD.Description AS ProcedureDescription, 
	TOS.Description AS TypeOfServiceDescription,
	PF.ChargeAmount, 
	PF.Editable, 
	PF.EffectiveDate, 
	PF.ExpirationDate
FROM [dbo].[PracticeFeeSchedule] FS
	INNER JOIN [dbo].[PracticeFee] PF
	ON FS.PracticeFeeScheduleID = PF.PracticeFeeScheduleID
	INNER JOIN dbo.ProcedureCodeDictionary PCD
	ON PF.ProcedureCodeDictionaryID = PCD.ProcedureCodeDictionaryID
	LEFT OUTER JOIN dbo.TypeOfService TOS
	ON PCD.TypeOfServiceCode = TOS.TypeOfServiceCode
WHERE FS.PracticeID = 47
