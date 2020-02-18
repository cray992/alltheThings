/*Rename all history tables in the customer database to obsolete*/
IF  EXISTS 
(
	SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[PracticeHistory]') 
	AND type in (N'U')
)
EXEC sp_rename [PracticeHistory], [PracticeHistoryObsolete]

IF  EXISTS 
(
	SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[DoctorHistory]') 
	AND type in (N'U')
)
EXEC sp_rename [DoctorHistory], [DoctorHistoryObsolete]