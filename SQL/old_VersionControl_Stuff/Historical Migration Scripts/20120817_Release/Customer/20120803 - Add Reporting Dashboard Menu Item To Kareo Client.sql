DECLARE @RowId INT 

SELECT @RowId = ReportID FROM Report WHERE Name = 'Reporting Dashboard'

IF @RowId IS NOT NULL
BEGIN
	DELETE ReportToSoftwareApplication WHERE ReportID = @RowId
	DELETE Report WHERE ReportID = @RowId
END

INSERT INTO [dbo].[Report](ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportPath, ReportParameters, ModifiedDate, TIMESTAMP, MenuName, PermissionValue, PracticeSpecific, ReportConfigID)
VALUES (1, 8, '[[image[Practice.ReportsV2.Images.reports.gif]]]', 'Reporting Dashboard', 'This dashboard provides an overview of your accounts receivables and claim rejections', 'Reporting Dashboard', '/', NULL, GETDATE(), NULL, 'Re&porting Dashboard', 'ReadARAgingSummary', 1, 1)

SELECT @RowId = ReportID
FROM Report
WHERE Name = 'Reporting Dashboard'

INSERT INTO ReportToSoftwareApplication
SELECT @RowId,'K', GETDATE()

GO
