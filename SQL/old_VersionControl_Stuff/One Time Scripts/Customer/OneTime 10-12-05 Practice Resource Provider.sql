IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'PracticeDataProvider_GetPracticeResources'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.PracticeDataProvider_GetPracticeResources
GO

--===========================================================================
-- GET PRACTICE RESOURCES
--===========================================================================
CREATE PROCEDURE dbo.PracticeDataProvider_GetPracticeResources
	@practice_id INT, 
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(50) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON

	CREATE TABLE #t_resources(
		PracticeResourceID int,
		PracticeID int,
		ResourceName varchar(50), 
		PracticeResourceTypeID int, 
		PracticeResourceTypeName varchar(50), 
		Deletable bit,
		RID int IDENTITY(0,1)
	)

	INSERT INTO #t_resources(
		PracticeResourceID,
		PracticeID,
		ResourceName, 
		PracticeResourceTypeID, 
		PracticeResourceTypeName, 
		Deletable
	)
	SELECT		PR.PracticeResourceID,
			PR.PracticeID,
			PR.ResourceName,
			PR.PracticeResourceTypeID,
			PRT.TypeName, 
			CAST(CASE WHEN D.ResourceID IS NULL AND D2.ResourceID IS NULL THEN 1 ELSE 0 END AS BIT) AS Deletable
	FROM		PracticeResource PR
	INNER JOIN 	PracticeResourceType PRT 
	ON 		   PRT.PracticeResourceTypeID = PR.PracticeResourceTypeID
	LEFT OUTER JOIN	(SELECT DISTINCT ATR.ResourceID FROM Appointment A INNER JOIN AppointmentToResource ATR ON ATR.AppointmentID = A.AppointmentID AND ATR.AppointmentResourceTypeID = 2 WHERE ATR.PracticeID = @practice_id) D
	ON		   D.ResourceID = PR.PracticeResourceID
	LEFT OUTER JOIN	(SELECT DISTINCT ARDR.ResourceID FROM AppointmentReasonDefaultResource ARDR INNER JOIN AppointmentReason AR ON AR.PracticeID = @practice_id AND AR.AppointmentReasonID = ARDR.AppointmentReasonID WHERE ARDR.AppointmentResourceTypeID = 2) D2
	ON		   D2.ResourceID = PR.PracticeResourceID
	WHERE		PR.PracticeID = @practice_id
	AND		((@query_domain IS NULL OR @query IS NULL)
	OR	 	((@query_domain = 'ALL' or @query_domain = 'TypeName')
	AND	   	PRT.TypeName like '%' + @query + '%')
	OR	 	((@query_domain = 'ALL' or @query_domain = 'ResourceName')
	AND	   	PR.ResourceName like '%' + @query + '%'))
	GROUP BY	PR.PracticeResourceID,
			PR.PracticeID,
			PR.ResourceName,
			PR.PracticeResourceTypeID,
			PRT.TypeName, 
			D.ResourceID, 
			D2.ResourceID
	ORDER BY	ResourceName

	SELECT @totalRecords = COUNT(*)
	FROM #t_resources

	IF @maxRecords = 0
		SET @maxRecords = @totalRecords
		
	SELECT *
	FROM #t_resources
	WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
	
	DROP TABLE #t_resources
	RETURN

END