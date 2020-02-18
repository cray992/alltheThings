
UPDATE Practice
SET IsLegacyEHRPartner=1
FROM PracticeIntegration Pi WITH (NOLOCK)  
INNER JOIN Practice WITH (NOLOCK) ON Pi.PracticeID = Practice.PracticeID
INNER JOIN SHAREDSERVER.superbill_shared.dbo.Customer AS c WITH (NOLOCK)ON c.DatabaseName=db_name() 
		AND C.customerType='N'
Inner Join SHAREDSERVER.superbill_shared.dbo.CustomerIDForPartner cp ON c.CustomerID=cp.[Kareo ID] AND (cp.PARTNER='Practice Fusion' OR cp.PARTNER='Quest')
							 
WHERE	CASE WHEN pi.PracticeFusionStatus='C'   THEN 3 
		     WHEN PI.HL7PartnerActive=1			THEN 2 END  IS NOT NULL

go

UPDATE p2
SET IsLegacyEHRPartner= 1
FROM SHAREDSERVER.superbill_shared.dbo.Users WITH (NOLOCK) 
INNER JOIN SHAREDSERVER.superbill_shared.dbo.CustomerUsers AS CU WITH (NOLOCK) ON  Users.UserID = CU.UserID
INNER JOIN SHAREDSERVER.superbill_shared.dbo.Customer AS c WITH (NOLOCK) ON CU.CustomerID = c.CustomerID
Inner Join SHAREDSERVER.superbill_shared.dbo.CustomerIDForPartner cp ON c.CustomerID=cp.[Kareo ID] AND cp.PARTNER='WebPT'
INNER JOIN SHAREDSERVER.superbill_shared.dbo.Partner AS p WITH (NOLOCK) ON c.PartnerID = p.PartnerID
INNER JOIN UserPractices AS up ON Users.UserID=up.UserID 
INNER JOIN Practice AS p2  ON up.PracticeID = p2.PracticeID
WHERE (users.EmailAddress LIKE '%webpt%' ) 
AND c.DatabaseName=DB_NAME()


GO
UPDATE Practice
SET IsLegacyEHRPartner= 1
FROM SHAREDSERVER.superbill_shared.dbo.Customer AS c WITH (NOLOCK) 
Inner Join SHAREDSERVER.superbill_shared.dbo.CustomerIDForPartner cp ON c.CustomerID=cp.[Kareo ID] AND PARTNER IN ('Modernizing Medicine', 'BackChart')
Where C.databasename=DB_NAME()

GO






 