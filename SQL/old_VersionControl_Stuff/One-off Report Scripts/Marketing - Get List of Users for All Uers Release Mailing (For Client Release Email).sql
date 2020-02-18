USE Superbill_Shared
DECLARE @MetricsOnly BIT
SET @MetricsOnly = 0			-- 0 for release e-mail

--list of emails that shouldn't be emailed 
DECLARE @excludeEmails TABLE (EmailAddress varchar(256))
INSERT INTO @excludeEmails VALUES ('heather@heather.com')
INSERT INTO @excludeEmails VALUES ('s@s.com')
INSERT INTO @excludeEmails VALUES ('jaustin@wintellect.com')
INSERT INTO @excludeEmails VALUES ('abc@yahoo.com')
INSERT INTO @excludeEmails VALUES ('%@family.guy')
INSERT INTO @excludeEmails VALUES ('test@pmr')
INSERT INTO @excludeEmails VALUES ('rorton@sample1.com')
INSERT INTO @excludeEmails VALUES ('%@adren.com')
INSERT INTO @excludeEmails VALUES ('%@ama.com')
INSERT INTO @excludeEmails VALUES ('%@brokebackmountain.com')
INSERT INTO @excludeEmails VALUES ('no@L.com')
INSERT INTO @excludeEmails VALUES ('%@griffin.%')
INSERT INTO @excludeEmails VALUES ('%@quahog.org')
INSERT INTO @excludeEmails VALUES ('m@nuel.com')
INSERT INTO @excludeEmails VALUES ('trialtest0@kareo.com')
INSERT INTO @excludeEmails VALUES ('c@ca.com')
INSERT INTO @excludeEmails VALUES ('3_')
INSERT INTO @excludeEmails VALUES ('5_')
INSERT INTO @excludeEmails VALUES ('%@kareo.com')
INSERT INTO @excludeEmails VALUES ('%@ilya.us')
INSERT INTO @excludeEmails VALUES ('%@test.com')
INSERT INTO @excludeEmails VALUES ('%@test1122.com')
INSERT INTO @excludeEmails VALUES ('x@x.com')
INSERT INTO @excludeEmails VALUES ('%@jj.com')
INSERT INTO @excludeEmails VALUES ('jane@office.com')
INSERT INTO @excludeEmails VALUES ('admin@mfa.com')
INSERT INTO @excludeEmails VALUES ('A@A')
INSERT INTO @excludeEmails VALUES ('ab@aol.com')
INSERT INTO @excludeEmails VALUES ('shawn@microsoft.com')
INSERT INTO @excludeEmails VALUES ('Shaun@yahoo.com')
INSERT INTO @excludeEmails VALUES ('shaun@test0.net')

DECLARE @UserList TABLE (UserID int, CustomerCount int)

INSERT INTO @UserList 
SELECT
	CU.UserID,
	COUNT(CU.CustomerID) CustomerCount
FROM
	CustomerUsers CU 
	INNER JOIN Users U ON CU.UserID = U.UserID
	INNER JOIN Customer C ON C.CustomerID = CU.CustomerID 
WHERE
	C.DBActive = 1 AND C.AccountLocked = 0 AND U.AccountLocked = 0
GROUP BY
	CU.UserID
ORDER BY 
	COUNT(CU.CustomerID) DESC

/*
DECLARE @FilteredList TABLE (UserID int, BML int)

INSERT INTO @FilteredList
SELECT DISTINCT
	UL.UserID,
	CASE WHEN SGP.PermissionID = 109 THEN 1 ELSE 0 END BML
FROM
	@UserList UL
	LEFT OUTER JOIN CustomerUsers CU ON CU.UserID = UL.UserID AND UL.CustomerCount = 1
	LEFT OUTER JOIN Customer C ON C.CustomerID = CU.CustomerID
	LEFT OUTER JOIN UsersSecurityGroup USG ON UL.UserID = USG.UserID
	LEFT OUTER JOIN SecurityGroup SG ON USG.SecurityGroupID = SG.SecurityGroupID
	LEFT OUTER JOIN SecurityGroupPermissions SGP ON SGP.SecurityGroupID = SG.SecurityGroupID
*/
--DECLARE @PrivsList TABLE (UserID int, BML int)
---DECLARE @PrivsList TABLE (UserID int)

---INSERT INTO @PrivsList
---SELECT UserID FROM @UserList GROUP BY UserID HAVING UserID IS NOT NULL
--SELECT UserID, SUM(BML) FROM @FilteredList GROUP BY UserID HAVING UserID IS NOT NULL


SELECT DISTINCT
	U.EmailAddress,
	U.FirstName,
	U.LastName,
	CASE WHEN (UL.CustomerCount = 1) THEN C.CompanyName ELSE 'Multiple' END AS Customer,
	CASE WHEN (UL.CustomerCount = 1) THEN (CASE C.CustomerType WHEN 'T' THEN 'Trial' ELSE 'Normal' END) ELSE 'N/A' END AS CustomerType,
	CLT.CustomerLeadDescription --,
	---CASE WHEN (PL.BML = 1) THEN 'With BM Login' ELSE 'No Login' END AS BusinessMgrLogin
FROM
	Users U
---	INNER JOIN @PrivsList PL ON PL.UserID = U.UserID
	INNER JOIN @UserList UL ON UL.UserID = U.UserID
	LEFT OUTER JOIN CustomerUsers CU ON CU.UserID = U.UserID AND UL.CustomerCount = 1
	LEFT OUTER JOIN Customer C ON C.CustomerID = CU.CustomerID
	LEFT OUTER JOIN CustomerLeadType CLT ON C.CustomerLeadTypeID = CLT.CustomerLeadTypeID
	LEFT OUTER JOIN @excludeEmails EE ON U.EmailAddress LIKE EE.EmailAddress
WHERE 
	EE.EmailAddress IS NULL
	AND (@MetricsOnly = 0 OR (@MetricsOnly = 1 AND C.Metrics = 1))
ORDER BY Customer, Lastname, Firstname
