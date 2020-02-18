--Add two options fields to practice table

ALTER TABLE Practice
ADD 
	EligibilityDefaultProviderID int NULL CONSTRAINT FK_Practice_EligibilityDefaultProviderID FOREIGN KEY REFERENCES Doctor (DoctorID),
	EligibilityAlwaysUseDefaultProvider bit NOT NULL CONSTRAINT DF_Practice_EligibilityAlwaysUseDefaultProvider DEFAULT 0
GO

--Migrate single-provider practices to use the one and only provider to be the default eligibility provider

UPDATE 
	Practice
SET
	EligibilityDefaultProviderID = X.DoctorID
FROM
	Practice P
	INNER JOIN 
	(
		SELECT 
			PracticeID, 
			(
				SELECT 
					DoctorID 
				FROM 
					Doctor 
				WHERE 
					PracticeID = D.PracticeID 
					AND [External] = 0
			) AS DoctorID
		FROM 
			Doctor D 
		WHERE 
			[External]=0 
		GROUP BY 
			PracticeID 
		HAVING 
			COUNT(DoctorID) = 1
	) X ON X.PracticeID = P.PracticeID
GO
