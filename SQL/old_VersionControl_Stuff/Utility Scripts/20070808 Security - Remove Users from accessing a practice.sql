

				DECLARE 
					@MigrationNotes VARCHAR(max),
					@PracticeID INT
				DECLARE
					@UsersToKeep TABLE ( emailAddress VARCHAR(MAX) )

				SELECT @PracticeID = 122

				INSERT INTO @UsersToKeep (
					[emailAddress]
					) 
				SELECT emailAddress
				FROM [SHAREDSERVER].[Superbill_Shared].dbo.users u
				WHERE	u.[EmailAddress] NOT LIKE '%dep%'
						AND u.[EmailAddress] NOT LIKE '%kareo%'



	-------------------------------------------------
	IF NOT( EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserLockedPractices]') AND type in (N'U')) )
		BEGIN
			CREATE TABLE [dbo].[UserLockedPractices](
				VendorID [int], 
				[UserID] [int],
				[PracticeID] [int],
				[CreatedDate] [datetime],
				[CreatedUserID] [int],
				[ModifiedDate] [datetime],
				[ModifiedUserID] [int]
				)
		END


	DECLARE @vendorImportID INT

	INSERT INTO vendorImport( vendorName,  Notes, VendorFormat )
	values ('Isolate Practice', @MigrationNotes, 'Unknown' )
	SET @vendorImportID = @@IDENTITY

	INSERT [UserLockedPractices]( 				
		VendorID, 
		[UserID],
		[PracticeID],
		[CreatedDate],
		[CreatedUserID],
		[ModifiedDate],
		[ModifiedUserID]
		)
	SELECT 		
		@vendorImportID,
		up.[UserID],
		[PracticeID],
		up.[CreatedDate],
		up.[CreatedUserID],
		up.[ModifiedDate],
		up.[ModifiedUserID]
	FROM [UserPractices] up
		INNER  JOIN [SHAREDSERVER].superbill_shared.dbo.users u
			ON u.userID = up.UserID
	WHERE u.[EmailAddress] NOT IN (SELECT emailAddress FROM @UsersToKeep )
		AND up.PracticeID = @PracticeID


DELETE up
FROM [UserPractices] up
	INNER JOIN [UserLockedPractices] ulp
		ON up.UserID = ulp.UserID 
		AND up.PracticeID = ulp.[PracticeID]
WHERE ulp.VendorID = @vendorImportID