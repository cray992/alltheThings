IF EXISTS(
			SELECT *
			FROM sys.objects AS o 
			WHERE o.name='ClaimDenialMessages' AND o.type='u')

DROP  TABLE ClaimDenialMessages
GO



CREATE TABLE ClaimDenialMessages(PracticeID INT,PostingDate DATETIME,TYPE VARCHAR(30), Category VARCHAR(10), DESCRIPTION VARCHAR(128), DateInserted DATETIME DEFAULT GETDATE() )


CREATE  INDEX IX_ClaimDenialMessages_PracticeID_PostingDate_Category ON ClaimDenialMessages(PracticeID, PostingDate, Category)INCLUDE ([DESCRIPTION])
