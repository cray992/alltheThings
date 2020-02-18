UPDATE Report
SET 
  DisplayOrder = -1
, ReportCategoryID = 
(
	SELECT rc.ReportCategoryID
	FROM ReportCategory rc
	WHERE rc.[Name] = 'Hidden'
)
, ModifiedDate = 
(
	SELECT DATEADD(second, 1, MAX(Dates.ModifiedDate)) FROM
	(
		SELECT ModifiedDate FROM Report
		UNION SELECT ModifiedDate FROM ReportCategory
		UNION SELECT ModifiedDate FROM ReportCategoryToSoftwareApplication
		UNION SELECT ModifiedDate FROM ReportToSoftwareApplication
	) AS Dates
)
WHERE [Name] = 'Fee Schedule Detail'
GO
