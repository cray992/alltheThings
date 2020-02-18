IF NOT EXISTS ( SELECT * FROM dbo.ReportCategory WHERE Name= 'Reports Guide' )

BEGIN
	BEGIN TRANSACTION
		
		--Modify Report with current Display Order of 1 to 2 to ensure new report is at the top of the reports list.
		UPDATE dbo.ReportCategory
		SET DisplayOrder = 2
		WHERE DisplayOrder = 1
		
		
		DECLARE @NewlyCreatedCategoryID INT
		
		--Step 1: Create new Report Category **MUST Happen before creating new report**
		INSERT INTO dbo.ReportCategory
				( DisplayOrder ,
				  Image ,
				  Name ,
				  Description ,
				  TaskName ,
				  ModifiedDate ,
				  TIMESTAMP ,
				  MenuName ,
				  PracticeSpecific ,
				  IsVisible ,
				  Parent
				)
		VALUES  ( 1 , -- DisplayOrder - int
				  '[[image[Practice.ReportsV2.Images.reports.gif]]]' , -- Image - varchar(128)
				  'Reports Guide' , -- Name - varchar(128)
				  'View a list of reports and their intended usages.' , -- Description - varchar(256)
				  'Report List' , -- TaskName - varchar(128)
				  GETDATE() , -- ModifiedDate - datetime
				  NULL , -- TIMESTAMP - timestamp
				  '&Reports Guide' , -- MenuName - varchar(128)
				  1 , -- PracticeSpecific - bit
				  1 , -- IsVisible - bit
				  0  -- Parent - int
				)
				
		SET @NewlyCreatedCategoryID = SCOPE_IDENTITY()
		
		INSERT INTO dbo.ReportCategoryToSoftwareApplication
		        ( ReportCategoryID ,
		          SoftwareApplicationID ,
		          ModifiedDate
		        )
		VALUES  ( @NewlyCreatedCategoryID , -- ReportCategoryID - int
		          'K' , -- SoftwareApplicationID - char(1)
		          GETDATE()  -- ModifiedDate - datetime
		        )
		        
		COMMIT;
END

IF NOT EXISTS ( SELECT * FROM Report WHERE ReportPath= '/Reporting/Help/Faq/{CustomerID}/{PracticeID}' )

BEGIN
	BEGIN TRANSACTION
		
		DECLARE @NewlyCreatedReportID INT, @ReportsGuideCategoryID INT 
		
		SELECT @ReportsGuideCategoryID = ReportCategoryID 
		FROM dbo.ReportCategory 
		WHERE Name = 'Reports Guide'
		
		
		-- Step 2: Create new report entry into reports tabls. **MUST happen after creating Report Category**
		INSERT INTO dbo.Report
				( ReportCategoryID ,
				  DisplayOrder ,
				  Image ,
				  Name ,
				  Description ,
				  TaskName ,
				  ReportPath ,
				  ReportParameters ,
				  ModifiedDate ,
				  TIMESTAMP ,
				  MenuName ,
				  PermissionValue ,
				  PracticeSpecific ,
				  ReportConfigID ,
				  V3ReportId
				)
		VALUES  ( @ReportsGuideCategoryID , -- ReportCategoryID - int
				  1 , -- DisplayOrder - int
				  '[[image[Practice.ReportsV2.Images.reports.gif]]]' , -- Image - varchar(128)
				  'Reports Index' , -- Name - varchar(128)
				  'This is a guide that contains a detailed description of each report and how they can be used.' , -- Description - varchar(256)
				  'Report V3 Viewer' , -- TaskName - varchar(128)
				  '/Reporting/Help/Faq/{CustomerID}/{PracticeID}' , -- ReportPath - varchar(256)
				  NULL , -- ReportParameters - xml
				  GETDATE() , -- ModifiedDate - datetime
				  NULL , -- TIMESTAMP - timestamp
				  'Reports Index' , -- MenuName - varchar(128)
				  '' , -- PermissionValue - varchar(128)
				  1 , -- PracticeSpecific - bit
				  1, -- ReportConfigID - int
				  0  -- V3ReportId - int
				)

		SET @NewlyCreatedReportID = SCOPE_IDENTITY();
        
		INSERT INTO dbo.ReportToSoftwareApplication
				( ReportID ,
				  SoftwareApplicationID ,
				  ModifiedDate
				)
		VALUES  ( @NewlyCreatedReportID , -- ReportID - int
				  'K' , -- SoftwareApplicationID - char(1)
				  GETDATE()  -- ModifiedDate - datetime
				)
		COMMIT;
END