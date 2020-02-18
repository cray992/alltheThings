/*

DATABASE UPDATE SCRIPT

v1.20.1753 to v1.21.xxxx
*/
----------------------------------

--BEGIN TRAN 
----------------------------------

---------------------------------------------------------------------------------------
--case 2822 - Add column to ReportCategory and Report table to allow for different text to be displayed in the menu

ALTER TABLE dbo.ReportCategory
ADD MenuName varchar(128) NULL
GO

UPDATE 	ReportCategory 
SET	MenuName = '&Key Indicators'
where	Name = 'Key Indicators'

UPDATE 	ReportCategory 
SET	MenuName = '&Payments'
where	Name = 'Payments'

UPDATE 	ReportCategory 
SET	MenuName = 'A&ccounts Receivable'
where	Name = 'Accounts Receivable'

UPDATE 	ReportCategory 
SET	MenuName = 'Pr&oductivity && Analysis'
where	Name = 'Productivity & Analysis'

UPDATE 	ReportCategory 
SET	MenuName = 'Pa&tients'
where	Name = 'Patients'

UPDATE 	ReportCategory 
SET	MenuName = '&Refunds'
where	Name = 'Refunds'

UPDATE 	ReportCategory 
SET	MenuName = '&Appointments'
where	Name = 'Appointments'
GO

ALTER TABLE dbo.ReportCategory
ALTER COLUMN MenuName varchar(128) NOT NULL
GO

ALTER TABLE dbo.Report
ADD MenuName varchar(128) NULL
GO

UPDATE 	Report
SET	MenuName = 'Key Indicators &Summary'
where	Name = 'Key Indicators Summary'

UPDATE 	Report
SET	MenuName = 'Key Indicators &Detail'
where	Name = 'Key Indicators Detail'

UPDATE 	Report
SET	MenuName = 'Key Indicators Summary &Compare Previous Year'
where	Name = 'Key Indicators Summary Compare Previous Year'

UPDATE 	Report
SET	MenuName = 'Key Indicators Summary &YTD Review'
where	Name = 'Key Indicators Summary YTD Review'

UPDATE 	Report
SET	MenuName = 'Payments &Summary'
where	Name = 'Payments Summary'

UPDATE 	Report
SET	MenuName = 'Payments &Detail'
where	Name = 'Payments Detail'

UPDATE 	Report
SET	MenuName = 'Payments &Application'
where	Name = 'Payments Application'

UPDATE 	Report
SET	MenuName = 'A/R Aging &Summary'
where	Name = 'A/R Aging Summary'

UPDATE 	Report
SET	MenuName = 'A/R Aging &Detail'
where	Name = 'A/R Aging Detail'

UPDATE 	Report
SET	MenuName = '&Provider Productivity'
where	Name = 'Provider Productivity'

UPDATE 	Report
SET	MenuName = 'Patient &History'
where	Name = 'Patient History'

UPDATE 	Report
SET	MenuName = 'Patient Transactions &Summary'
where	Name = 'Patient Transactions Summary'

UPDATE 	Report
SET	MenuName = 'Patient Transactions &Detail'
where	Name = 'Patient Transactions Detail'

UPDATE 	Report
SET	MenuName = 'Patient &Referrals Summary'
where	Name = 'Patient Referrals Summary'

UPDATE 	Report
SET	MenuName = 'Patient R&eferrals Detail'
where	Name = 'Patient Referrals Detail'

UPDATE 	Report
SET	MenuName = 'Refunds &Summary'
where	Name = 'Refunds Summary'

UPDATE 	Report
SET	MenuName = 'Refunds &Detail'
where	Name = 'Refunds Detail'

UPDATE 	Report
SET	MenuName = 'Appointments &Summary'
where	Name = 'Appointments Summary'
GO

ALTER TABLE dbo.Report
ALTER COLUMN MenuName varchar(128) NOT NULL
GO

---------------------------------------------------------------------------------------
--case 2906 - Add foreign key constraints to the ReferringPhysician table

UPDATE 	Claim
SET	ReferringProviderID = NULL
WHERE	ReferringProviderID not in (select referringphysicianid from referringphysician)
GO

ALTER TABLE dbo.Claim
ADD CONSTRAINT FK_Claim_ReferringPhysician
FOREIGN KEY (ReferringProviderID)
REFERENCES ReferringPhysician(ReferringPhysicianID)
GO

UPDATE 	Encounter
SET	ReferringPhysicianID = NULL
WHERE	ReferringPhysicianID not in (select referringphysicianid from referringphysician)
GO

ALTER TABLE dbo.Encounter
ADD CONSTRAINT FK_Encounter_ReferringPhysician
FOREIGN KEY (ReferringPhysicianID)
REFERENCES ReferringPhysician(ReferringPhysicianID)
GO

UPDATE 	Patient
SET	ReferringPhysicianID = NULL
WHERE	ReferringPhysicianID not in (select referringphysicianid from referringphysician)
GO

ALTER TABLE dbo.Patient
ADD CONSTRAINT FK_Patient_ReferringPhysician
FOREIGN KEY (ReferringPhysicianID)
REFERENCES ReferringPhysician(ReferringPhysicianID)
GO

---------------------------------------------------------------------------------------
--case 2854 - Add column for Service Manager UI lockout minutes

ALTER TABLE dbo.SecuritySetting
ADD UILockMinutesServiceManager int
GO

UPDATE dbo.SecuritySetting
SET UILockMinutesServiceManager = 30
GO

ALTER TABLE dbo.SecuritySetting
ALTER COLUMN UILockMinutesServiceManager int NOT NULL
GO

-- Add a default constraint
ALTER TABLE dbo.SecuritySetting
ADD CONSTRAINT DF_SecuritySetting_UILockMinutesServiceManager DEFAULT(30) FOR UILockMinutesServiceManager
GO

---------------------------------------------------------------------------------------
--case 2545 - Add report hyperlink table to allow for report hyperlinking to other tasks or reports

CREATE TABLE dbo.ReportHyperlink (
	ReportHyperlinkID INT NOT NULL,
	Description varchar(256) NULL, 
	ReportParameters TEXT NOT NULL, 

	ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()),
	TIMESTAMP
)
GO

---------------------------------------------------------------------------------------
--case 2545 - Add report hyperlink table to allow for report hyperlinking to other tasks or reports

INSERT INTO dbo.ReportHyperlink
(ReportHyperlinkID, Description, ReportParameters)
VALUES
(1, 
'A/R Aging Detail Report', 
'<?xml version="1.0" encoding="utf-8" ?> 
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="A/R Aging Detail" />
      <methodParam param="true" type="System.Boolean"/>
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="Add">
            <methodParam param="RespType" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="RespID" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="Date" />
            <methodParam param="{2}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>')
GO


---------------------------------------------------------------------------------------
--case 2851 - Remove insurance verified flag on insurance policy

ALTER TABLE dbo.PatientInsurance
DROP CONSTRAINT DF_PatientInsurance_Verified
GO

ALTER TABLE dbo.PatientInsurance
DROP COLUMN Verified
GO

---------------------------------------------------------------------------------------
--case 2941 - Add report information for Patient Detail report

DECLARE @server varchar(65)
DECLARE @category int

select @category = ReportCategoryID from ReportCategory where Name = 'Patients'
SET @server = 'k0'

insert into report
(ReportCategoryID, DisplayOrder, Image, Name, MenuName, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(@category, 20, '[[image[Practice.Reports.Images.reports.gif]]]', 'Patient Detail', 'Patient De&tail', 'This report provides a patient''s details including demographics and insurance information.', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptPatientDetail', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Please click on Customize and select a Patient for this report.">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
	        <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1"/>
	</extendedParameters>
</parameters>' )
GO

---------------------------------------------------------------------------------------
--case 2951 - Update all reports to use the image in the ReportsV2 directory since Reports is removed

update 	reportcategory
set	image = '[[image[Practice.ReportsV2.Images.reports.gif]]]'
GO

update 	report
set	image = '[[image[Practice.ReportsV2.Images.reports.gif]]]'
GO

---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
