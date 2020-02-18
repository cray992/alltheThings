DECLARE @EncounterID INT

-- Get encounters with more than one procedure that were created between midnight and 8:30am on 1/11
DECLARE encounter_cursor CURSOR READ_ONLY
FOR 	SELECT E.EncounterID FROM Encounter E
	INNER JOIN EncounterProcedure EP
	ON EP.EncounterID = E.EncounterID
	WHERE E.ModifiedDate > '1/11/2006 12:00am' 
	AND E.ModifiedDate < '1/11/2006 8:30am'
	AND E.EncounterStatusID = 3
	GROUP BY E.EncounterID
	HAVING COUNT(EP.EncounterProcedureID) > 1


OPEN encounter_cursor

FETCH NEXT FROM encounter_cursor 
INTO 	@EncounterID

-- Loop through each encounter to unapprove and approve
WHILE (@@FETCH_STATUS = 0)
BEGIN
	PRINT @EncounterID

	-- Unapprove the encounter
	EXEC EncounterDataProvider_UnapproveEncounter @EncounterID

	-- Approve the encounter
	EXEC EncounterDataProvider_ApproveEncounter @EncounterID

	FETCH NEXT FROM encounter_cursor
	INTO	@EncounterID
END

CLOSE encounter_cursor
DEALLOCATE encounter_cursor
