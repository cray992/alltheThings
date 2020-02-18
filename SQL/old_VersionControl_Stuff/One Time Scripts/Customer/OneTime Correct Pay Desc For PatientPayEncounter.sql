UPDATE P SET Description='Patient Payment made on ' + CONVERT(char(10), DateOfService, 101) + ' with Encounter ' + CONVERT(varchar(12), SourceEncounterID)
FROM Payment P INNER JOIN Encounter E 
ON P.SourceEncounterID=E.EncounterID
WHERE Description='PATIENT PAYMENT MADE AT TIME OF ENCOUNTER'