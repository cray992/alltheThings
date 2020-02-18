IF NOT EXISTS (SELECT * FROM Report WHERE Name = 'A/R Aging Detail for Patient')
BEGIN
	INSERT INTO dbo.Report
			(ReportCategoryID,
			 DisplayOrder,
			 Image,
			 Name,
			 Description,
			 TaskName,
			 ReportPath,
			 ReportParameters,
			 ModifiedDate,
			 MenuName,
			 PermissionValue,
			 PracticeSpecific,
			 ReportConfigID,
			 V3ReportId)
	VALUES	(12, -- ReportCategoryID - int
			 -1, -- DisplayOrder - int
			 '', -- Image - varchar(128)
			 'A/R Aging Detail for Patient', -- Name - varchar(128)
			 'This report provides a detailed view of a patient''s accounts receivable.', -- Description - varchar(256)
			 'Report V3 Viewer', -- TaskName - varchar(128)
			 'reporting/ArReport/#/InsurancetDetail/{CustomerID}/{PracticeID}/{EntityID}', -- ReportPath - varchar(256)
			 NULL, -- ReportParameters - xml
			 '2012-10-26 15:54:21', -- ModifiedDate - datetime
			 'A/R Aging Patient Detail', -- MenuName - varchar(128)
			 'ReadARAgingDetail', -- PermissionValue - varchar(128)
			 1, -- PracticeSpecific - bit
			 1, -- ReportConfigID - int
			 0  -- V3ReportId - int
			 )
END

IF NOT EXISTS (SELECT * FROM Report WHERE Name = 'A/R Aging Detail for Insurance Plan')
BEGIN
	INSERT INTO dbo.Report
			(ReportCategoryID,
			 DisplayOrder,
			 Image,
			 Name,
			 Description,
			 TaskName,
			 ReportPath,
			 ReportParameters,
			 ModifiedDate,
			 MenuName,
			 PermissionValue,
			 PracticeSpecific,
			 ReportConfigID,
			 V3ReportId)
	VALUES	(12, -- ReportCategoryID - int
			 -1, -- DisplayOrder - int
			 '', -- Image - varchar(128)
			 'A/R Aging Detail for Insurance Plan', -- Name - varchar(128)
			 'This report provides a detailed view of an insurance''s accounts receivable.', -- Description - varchar(256)
			 'Report V3 Viewer', -- TaskName - varchar(128)
			 'reporting/ArReport/#/InsurancetDetail/{CustomerID}/{PracticeID}/{EntityID}', -- ReportPath - varchar(256)
			 NULL, -- ReportParameters - xml
			 '2012-10-26 15:54:21', -- ModifiedDate - datetime
			 'A/R Aging Insurance Detail', -- MenuName - varchar(128)
			 'ReadARAgingDetail', -- PermissionValue - varchar(128)
			 1, -- PracticeSpecific - bit
			 1, -- ReportConfigID - int
			 0  -- V3ReportId - int
			 )
END
