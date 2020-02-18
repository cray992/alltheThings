BEGIN 
	DECLARE @NewReportID INT
	
	SET @NewReportID = (Select ReportID
						FROM dbo.Report
						WHERE ReportPath = '/BusinessManagerReports/rptKeyIndicatorSummary-Beta')
	
	UPDATE dbo.Report
	SET V3ReportId = 0, ModifiedDate = GETDATE()
	WHERE ReportPath = '/BusinessManagerReports/rptKeyIndicatorsSummary_Pivot'
	
	DELETE FROM dbo.ReportToSoftwareApplication
	WHERE ReportID = @NewReportID
	
	DELETE FROM dbo.Report
	WHERE ReportID = @NewReportID
END

