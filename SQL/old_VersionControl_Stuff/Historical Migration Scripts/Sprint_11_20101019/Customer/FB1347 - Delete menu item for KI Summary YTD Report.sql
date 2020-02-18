
/******DELETE REPORT MENU ITEM - KI SUMMARY YTD REPORT ******/
DECLARE @ReportID INT
SELECT @ReportID = ReportID 
FROM Report
WHERE Name = 'Key Indicators Summary YTD Review'   /*ReportID = 4*/

IF @ReportID > 0 
BEGIN
	BEGIN TRAN
	DELETE FROM ReportToSoftwareApplication
	WHERE ReportID = @ReportID
	
	DELETE FROM Report
	WHERE ReportID = @ReportID
	
	COMMIT TRAN;
	
END;

