


-------------------------------------------------------------


declare @PatientID INT,
	@PatientJournalNoteID INT,
	@PJN_Count INT,
	@PJN_Current_Len INT,
	@PJN_Current_NoteMessage varchar(MAX),
	@Patient_Count INT,
	@Patient_Current_Count INT,
	@NoteSizeLimit INT
Declare @Notes Table (PatientID INT, PatientJournalNoteID INT, RowID INT IDENTITY, NoteMessage varchar(Max) )

SELECT @PatientID = 0,
	@PatientJournalNoteID = 0,
	@Patient_Count = 0,
	@NoteSizeLimit = 520



select PatientID, PatientJournalNoteID
INTO #LargeMessage
from PatientJournalNote
where len(NoteMessage) > @NoteSizeLimit
--	AND  PatientID IN (53, 68, 73)
ORDER BY PatientID, PatientJournalNoteID



-- Main loop to select by patient
WHILE 1 = 1
BEGIN
	-- loop control
	SELECT @PatientID = MIN(PatientID)
	FROM #LargeMessage
	WHERE PatientID > @PatientID


	IF @PatientID IS NULL OR @@Rowcount = 0
		BREAK

	select @Patient_Count = count( * ),
		@Patient_Current_Count = 0
	FROM #LargeMessage
	WHERE PatientID = @PatientID



	-- Inner Loop to select each PatientJournalNoteID
	WHILE @Patient_Current_Count < @Patient_Count
	BEGIN
		SELECT @PatientJournalNoteID = MIN(PatientJournalNoteID)
		FROM #LargeMessage
		WHERE PatientJournalNoteID > @PatientJournalNoteID

		-- Inserts any messages in between the notes to break up, this perserves the relative ordering of the PatientJournalNoteID
		INSERT @Notes (PatientID, PatientJournalNoteID, NoteMessage )
		SELECT pjn.PatientID, pjn.PatientJournalNoteID, pjn.NoteMessage
		FROM PatientJournalNote pjn
			LEFT JOIN @Notes n ON n.PatientID = pjn.PatientID AND n.PatientJournalNoteID = pjn.PatientJournalNoteID
		WHERE pjn.PatientID = @PatientID
			AND pjn.PatientJournalNoteID < @PatientJournalNoteID
			AND n.PatientID IS NULL
		ORDER BY pjn.PatientJournalNoteID


		SELECT @PJN_Current_Len = ISNULL( len(NoteMessage), 0),
			@PJN_Current_NoteMessage = NoteMessage
		FROM PatientJournalNote pjn 
		WHERE pjn.PatientJournalNoteID = @PatientJournalNoteID
				AND pjn.PatientID = @PatientID 



		SELECT @PJN_Count = 0

		-- Inner Loop to break up notes into little chucks based on character size limit
		WHILE (@PJN_Count * @NoteSizeLimit) < @PJN_Current_Len
		BEGIN
			
			
			INSERT @Notes (PatientID, PatientJournalNoteID, NoteMessage )
			SELECT @PatientID, @PatientJournalNoteID, SUBSTRING(@PJN_Current_NoteMessage, (@PJN_Count * @NoteSizeLimit) + 1, @NoteSizeLimit )
		
			
			SELECT @PJN_Count = @PJN_Count + 1
		END -- End of Inner Loop to break up notes into little chucks based on character size limit

	SELECT @Patient_Current_Count = @Patient_Current_Count + 1

	END -- End of Inner Loop to select each PatientJournalNoteID


	
	-- Inserts the remaining messages that are after the large messages
	INSERT @Notes (PatientID, PatientJournalNoteID, NoteMessage )
	SELECT pjn.PatientID, pjn.PatientJournalNoteID, pjn.NoteMessage
	FROM PatientJournalNote pjn
		LEFT JOIN @Notes n ON n.PatientID = pjn.PatientID AND n.PatientJournalNoteID = pjn.PatientJournalNoteID
	WHERE pjn.PatientID = @PatientID
		AND n.PatientID IS NULL
	ORDER BY pjn.PatientID, pjn.PatientJournalNoteID



	INSERT INTO [PatientJournalNote]
           ([CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID]
           ,[PatientID]
           ,[UserName]
           ,[SoftwareApplicationID]
           ,[Hidden]
           ,[NoteMessage]
           ,[AccountStatus])
	SELECT 
			pjn.[CreatedDate]
           ,pjn.[CreatedUserID]
           ,pjn.[ModifiedDate]
           ,pjn.[ModifiedUserID]
           ,pjn.[PatientID]
           ,pjn.[UserName]
           ,pjn.[SoftwareApplicationID]
           ,pjn.[Hidden]
           ,n.[NoteMessage]
           ,pjn.[AccountStatus]
	FROM PatientJournalNote pjn
		INNER JOIN @Notes n ON n.PatientID = pjn.PatientID AND n.PatientJournalNoteID = pjn.PatientJournalNoteID
	ORDER BY RowID


	delete pjn
	FROM [PatientJournalNote] pjn
		INNER JOIN @Notes n ON n.PatientID = pjn.PatientID AND n.PatientJournalNoteID = pjn.PatientJournalNoteID

	-- truncate Note table
	delete @Notes

END

drop table #LargeMessage



return




/* ---------Debug and Testing ---------------

select substring( '123456789', 4, 3)




select PatientID, PatientJournalNoteID, Len(NoteMessage)
from PatientJournalNote
where Len(NoteMessage) > 520
	AND PatientID IN
		(
			select patientID
			from PatientJournalNote
			GROUP BY PatientID
			having count( *) > 2
		)
ORDER BY PatientID

select  PatientID, PatientJournalNoteID, Len(NoteMessage), NoteMessage
from PatientJournalNote
where PatientID IN (330694)
order by  PatientID, PatientJournalNoteID



*/