SELECT 
	P.Name AS [Practice],
	CASE LastAssignment WHEN 1 THEN 'Current' ELSE 'Historical' END AS [Status],
	CAST(ClosingDate AS varchar(11)) AS [Closing Date],
	U.EmailAddress AS [Set By], 
	CAST(PTCD.CreatedDate AS varchar) AS [Set On]
FROM 
	PracticeToClosingDate PTCD 
	INNER JOIN superbill_shared.dbo.Users U ON PTCD.UserID = U.UserID
	INNER JOIN Practice P ON PTCD.PracticeID = P.PracticeID
WHERE
	PTCD.PracticeID <> 19
ORDER BY
	PTCD.PracticeID ASC,
	PTCD.LastAssignment ASC
