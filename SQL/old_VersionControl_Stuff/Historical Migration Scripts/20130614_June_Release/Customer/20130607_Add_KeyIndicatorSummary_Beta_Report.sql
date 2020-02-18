
IF NOT EXISTS(SELECT * FROM Report WHERE reportpath='/BusinessManagerReports/rptKeyIndicatorSummary-Beta' )


BEGIN

	BEGIN TRANSACTION;
	
	DECLARE @OldReportPath VARCHAR(200), @NewlyCreatedReportID INT 
	
	SET @OldReportPath = '/BusinessManagerReports/rptKeyIndicatorsSummary_Pivot'
	
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
	  VALUES  ( 1 , -- ReportCategoryID - int
				9 , -- DisplayOrder - int
				'[[image[Practice.ReportsV2.Images.reports.gif]]]' , -- Image - varchar(128)
				'Key Indicators Summary Beta' , -- Name - varchar(128)
				'This report is an udpdated(Beta) version of the Key Indicators Summary Report.' , -- Description - varchar(256)
				'Report V2 Viewer' , -- TaskName - varchar(128)
				'/BusinessManagerReports/rptKeyIndicatorSummary-Beta' , -- ReportPath - varchar(256)
				'<parameters csv="false">
				  <basicParameters>
					<basicParameter type="PracticeID" parameterName="PracticeID" />
					<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
					<basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
					<basicParameter type="Date" parameterName="EndDate" text="To:" />
				  </basicParameters>
				  <extendedParameters>
					<extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option." default="1">
					  <value displayText="Provider" value="P" />
					  <value displayText="Scheduling Provider" value="SP" />
					  <value displayText="Service Location" value="SL" />
					  <value displayText="Payer Scenario" value="PS" />
					  <value displayText="Insurance Company" value="IC" />
					  <value displayText="Insurance Company Plan" value="ICP" />
					  <value displayText="Batch Number" value="B" />
					</extendedParameter>
					<extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
					<extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
					<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
					<extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
					<extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
					<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
					<extendedParameter type="TextBox" parameterName="BatchID" text="Encounter Batch #:" />
				  </extendedParameters>
				</parameters>' , -- ReportParameters - xml
				GETDATE() , -- ModifiedDate - datetime
				NULL , -- TIMESTAMP - timestamp
				'Key Indicators &Summary Beta' , -- MenuName - varchar(128)
				'ReadKeyIndicatorsSummary' , -- PermissionValue - varchar(128)
				1 , -- PracticeSpecific - bit
				1 , -- ReportConfigID - int
				0  -- V3ReportId - int
			  )
			  
	SET @NewlyCreatedReportID = SCOPE_IDENTITY();
	
	INSERT INTO dbo.ReportToSoftwareApplication
			( ReportID ,
			  SoftwareApplicationID ,
			  ModifiedDate
			)
	VALUES  ( @NewlyCreatedReportID , --Grabbing ReportID after creating it
			  'K' , -- SoftwareApplicationID - char(1)
			  GETDATE()  -- ModifiedDate - datetime
			)
        
	UPDATE dbo.Report
	SET V3ReportId = @NewlyCreatedReportID, DisplayOrder = 10
	WHERE ReportPath = @OldReportPath
	
	COMMIT;
END


