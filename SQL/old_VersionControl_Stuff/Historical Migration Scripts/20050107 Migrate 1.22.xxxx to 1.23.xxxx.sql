/*

DATABASE UPDATE SCRIPT

v1.22.xxxx to v1.23.xxxx
*/
----------------------------------

--BEGIN TRAN 
----------------------------------

---------------------------------------------------------------------------------------
--case 2849:  Save copy of patient statements, display from patient activity area

ALTER TABLE
	BillTransmission
ADD
	PatientID int NULL,
	ClaimID int NULL,
	FileDataFormatVersion int NULL,
	FileData text NULL
GO

INSERT INTO BillTransmissionFileType (BillTransmissionFileTypeCode, TypeName) VALUES('C', 'Claim XML')
INSERT INTO BillTransmissionFileType (BillTransmissionFileTypeCode, TypeName) VALUES('S', 'Patient Statement XML')


---------------------------------------------------------------------------------------
--case 2870 -  Change how provider and group numbers are configured for e-claims

CREATE TABLE [dbo].[AttachConditionsType] (
	[PK_ID] [int] IDENTITY (1, 1)  NOT NULL PRIMARY KEY ,
	[AttachConditionsTypeID] [int] UNIQUE NOT NULL ,
	[AttachConditionsTypeName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

INSERT INTO AttachConditionsType (AttachConditionsTypeID, AttachConditionsTypeName) VALUES(1, 'Paper And Electronic Claims')
INSERT INTO AttachConditionsType (AttachConditionsTypeID, AttachConditionsTypeName) VALUES(2, 'Paper Claims Only')
INSERT INTO AttachConditionsType (AttachConditionsTypeID, AttachConditionsTypeName) VALUES(3, 'Electronic Claims Only')

ALTER TABLE
	PracticeInsuranceGroupNumber
ADD
	AttachConditionsTypeID INT NOT NULL DEFAULT 1
GO

ALTER TABLE PracticeInsuranceGroupNumber
	ADD CONSTRAINT [FK_PracticeInsuranceGroupNumber_AttachConditionsType] FOREIGN KEY 
	(
		[AttachConditionsTypeID]
	) REFERENCES [AttachConditionsType] (
		[AttachConditionsTypeID]
	)
GO

ALTER TABLE
	ProviderNumber
ADD
	AttachConditionsTypeID INT NOT NULL DEFAULT 1
GO

ALTER TABLE ProviderNumber
	ADD CONSTRAINT [FK_ProviderNumber_AttachConditionsType] FOREIGN KEY 
	(
		[AttachConditionsTypeID]
	) REFERENCES [AttachConditionsType] (
		[AttachConditionsTypeID]
	)
GO

  ------------------------------------------------
  -- Migrate GroupNumberType to new notation
  -- (same change is going to happen in shared):
ALTER TABLE
	GroupNumberType
ADD
	SortOrder INT NOT NULL DEFAULT 0
GO

INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(21, 'State License Number', '0B', 10)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(22, 'Blue Cross Provider Number', '1A', 20)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(23, 'Blue Shield Provider Number', '1B', 30)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(24, 'Medicare Provider Number', '1C', 40)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(25, 'Medicaid Provider Number', '1D', 50)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(26, 'Provider UPIN Number', '1G', 60)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(27, 'CHAMPUS Identification Number', '1H', 70)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(28, 'Facility ID Number', '1J', 80)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(29, 'Preferred Provider Organization Number', 'B3', 90)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(30, 'Health Maintenance Organization Code Number', 'BQ', 100)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(31, 'Employer’s Identification Number', 'EI', 110)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(32, 'Clinic Number', 'FH', 120)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(33, 'Provider Commercial Number', 'G2', 130)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(34, 'Provider Site Number', 'G5', 140)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(35, 'Location Number', 'LU', 150)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(36, 'Social Security Number', 'SY', 160)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(37, 'Unique Supplier Identification Number (USIN)', 'U3', 170)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(38, 'State Industrial Accident Provider Number', 'X5', 180)
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE Name = 'temp_migrate_GroupNumberType' AND TYPE = 'P') DROP PROCEDURE dbo.temp_migrate_GroupNumberType
GO
CREATE PROCEDURE dbo.temp_migrate_GroupNumberType
	@from_id INT, @to_id INT, @attach_to INT
AS
BEGIN
	--SELECT * FROM InsuranceCompanyPlan ICP WHERE ICP.GroupNumberTypeID = @from_id
	UPDATE InsuranceCompanyPlan
	SET GroupNumberTypeID = @to_id WHERE GroupNumberTypeID = @from_id
	--SELECT * FROM InsuranceCompanyPlan ICP WHERE ICP.GroupNumberTypeID = @to_id

	--SELECT * FROM PracticeInsuranceGroupNumber PIGN WHERE PIGN.GroupNumberTypeID = @from_id
	UPDATE PracticeInsuranceGroupNumber
	SET GroupNumberTypeID = @to_id, AttachConditionsTypeID = @attach_to WHERE GroupNumberTypeID = @from_id
	--SELECT * FROM PracticeInsuranceGroupNumber PIGN WHERE PIGN.GroupNumberTypeID = @to_id
END
GO

dbo.temp_migrate_GroupNumberType 1, 33, 2
GO
dbo.temp_migrate_GroupNumberType 2, 23, 2
GO
dbo.temp_migrate_GroupNumberType 3, 24, 2
GO
dbo.temp_migrate_GroupNumberType 4, 21, 3
GO
dbo.temp_migrate_GroupNumberType 5, 22, 3
GO
dbo.temp_migrate_GroupNumberType 6, 23, 3
GO
dbo.temp_migrate_GroupNumberType 7, 24, 3
GO
dbo.temp_migrate_GroupNumberType 8, 25, 3
GO
dbo.temp_migrate_GroupNumberType 9, 27, 3
GO
dbo.temp_migrate_GroupNumberType 10, 33, 3
GO
dbo.temp_migrate_GroupNumberType 11, 38, 3
GO

-- clean-up:
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE Name = 'temp_migrate_GroupNumberType' AND TYPE = 'P') DROP PROCEDURE dbo.temp_migrate_GroupNumberType
GO
DELETE FROM GroupNumberType WHERE GroupNumberTypeID < 20
GO

  ------------------------------------------------
  -- Migrate ProviderNumberType to new notation
  -- (same change is going to happen in shared):
ALTER TABLE
	ProviderNumberType
ADD
	SortOrder INT NOT NULL DEFAULT 0
GO

INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(21, 'State License Number', '0B', 10)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(22, 'Blue Shield Provider Number', '1B', 20)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(23, 'Medicare Provider Number', '1C', 30)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(24, 'Medicaid Provider Number', '1D', 40)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(25, 'Provider UPIN Number', '1G', 50)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(26, 'CHAMPUS Identification Number', '1H', 60)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(27, 'Employer’s Identification Number', 'EI', 70)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(28, 'Provider Commercial Number', 'G2', 80)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(29, 'Location Number', 'LU', 90)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(30, 'Provider Plan Network Identification Number', 'N5', 100)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(31, 'Social Security Number', 'SY', 120)
INSERT INTO ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(32, 'State Industrial Accident Provider Number', 'X5', 130)
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE Name = 'temp_migrate_ProviderNumberType' AND TYPE = 'P') DROP PROCEDURE dbo.temp_migrate_ProviderNumberType
GO
CREATE PROCEDURE dbo.temp_migrate_ProviderNumberType
	@from_id INT, @to_id INT, @attach_to INT
AS
BEGIN
	--SELECT * FROM ProviderNumber PN WHERE PN.ProviderNumberTypeID = @from_id
	UPDATE ProviderNumber
	SET ProviderNumberTypeID = @to_id, AttachConditionsTypeID = @attach_to WHERE ProviderNumberTypeID = @from_id
	--SELECT * FROM ProviderNumber PN WHERE PN.ProviderNumberTypeID = @to_id

	--SELECT * FROM InsuranceCompanyPlan ICP WHERE ICP.ProviderNumberTypeID = @from_id
	UPDATE InsuranceCompanyPlan
	SET ProviderNumberTypeID = @to_id WHERE ProviderNumberTypeID = @from_id
	--SELECT * FROM InsuranceCompanyPlan ICP WHERE ICP.ProviderNumberTypeID = @to_id

	--SELECT * FROM InsuranceCompanyPlan ICP WHERE ICP.LocalUseProviderNumberTypeID = @from_id
	UPDATE InsuranceCompanyPlan
	SET LocalUseProviderNumberTypeID = @to_id WHERE LocalUseProviderNumberTypeID = @from_id
	--SELECT * FROM InsuranceCompanyPlan ICP WHERE ICP.LocalUseProviderNumberTypeID = @to_id
END
GO

dbo.temp_migrate_ProviderNumberType 1, 28, 2
GO
dbo.temp_migrate_ProviderNumberType 2, 25, 2
GO
dbo.temp_migrate_ProviderNumberType 3, 22, 2
GO
dbo.temp_migrate_ProviderNumberType 4, 24, 2
GO
dbo.temp_migrate_ProviderNumberType 5, 23, 2
GO
--dbo.temp_migrate_ProviderNumberType 6
--dbo.temp_migrate_ProviderNumberType 7
--dbo.temp_migrate_ProviderNumberType 8
dbo.temp_migrate_ProviderNumberType 9, 21, 3
GO
dbo.temp_migrate_ProviderNumberType 11, 22, 3
GO
dbo.temp_migrate_ProviderNumberType 10, 22, 3
GO
dbo.temp_migrate_ProviderNumberType 12, 23, 3
GO
dbo.temp_migrate_ProviderNumberType 13, 24, 3
GO
dbo.temp_migrate_ProviderNumberType 14, 26, 3
GO
dbo.temp_migrate_ProviderNumberType 15, 28, 3
GO
dbo.temp_migrate_ProviderNumberType 16, 32, 3
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE Name = 'temp_migrate_ProviderNumberType' AND TYPE = 'P') DROP PROCEDURE dbo.temp_migrate_ProviderNumberType
GO
DELETE FROM ProviderNumberType WHERE ProviderNumberTypeID IN (1, 2, 3, 4, 5, 9, 10, 11, 12, 13, 14, 15, 16)
GO

UPDATE ProviderNumberType SET SortOrder = 201 WHERE ProviderNumberTypeID = 6
GO
UPDATE ProviderNumberType SET SortOrder = 202 WHERE ProviderNumberTypeID = 7
GO
UPDATE ProviderNumberType SET SortOrder = 203 WHERE ProviderNumberTypeID = 8
GO
UPDATE ProviderNumber
SET AttachConditionsTypeID = 2 WHERE ProviderNumberTypeID < 20
GO

---------------------------------------------------------------------------------------
--case 3218 - Added tables to handle appointment recurrences

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AppointmentRecurrence]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AppointmentRecurrence]
GO

CREATE TABLE [dbo].[AppointmentRecurrence] (
	[AppointmentID] [int] NOT NULL ,
	[Type] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[WeeklyNumWeeks] [int] NULL ,
	[WeeklyOnSunday] [bit] NULL ,
	[WeeklyOnMonday] [bit] NULL ,
	[WeeklyOnTuesday] [bit] NULL ,
	[WeeklyOnWednesday] [bit] NULL ,
	[WeeklyOnThursday] [bit] NULL ,
	[WeeklyOnFriday] [bit] NULL ,
	[WeeklyOnSaturday] [bit] NULL ,
	[DailyType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DailyNumDays] [int] NULL ,
	[MonthlyType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MonthlyNumMonths] [int] NULL ,
	[MonthlyDayOfMonth] [int] NULL ,
	[MonthlyWeekTypeOfMonth] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MonthlyTypeOfDay] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[YearlyType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[YearlyDayTypeOfMonth] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[YearlyTypeOfDay] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[YearlyDayOfMonth] [int] NULL ,
	[YearlyMonth] [int] NULL ,
	[RangeType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RangeEndOccurrences] [int] NULL ,
	[RangeEndDate] [datetime] NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL 
) ON [PRIMARY]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AppointmentRecurrenceException]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AppointmentRecurrenceException]
GO

CREATE TABLE [dbo].[AppointmentRecurrenceException] (
	[AppointmentRecurrenceExceptionID] [int] IDENTITY (1, 1) NOT NULL ,
	[AppointmentID] [int] NOT NULL ,
	[ExceptionDate] [datetime] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL 
) ON [PRIMARY]
GO

-- Add primary keys
ALTER TABLE [dbo].[AppointmentRecurrence] ADD 
	CONSTRAINT [DF_AppointmentRecurrence_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate],
	CONSTRAINT [PK_AppointmentRecurrence] PRIMARY KEY  CLUSTERED 
	(
		[AppointmentID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AppointmentRecurrenceException] ADD 
	CONSTRAINT [DF_AppointmentRecurrenceException_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate],
	CONSTRAINT [PK_AppointmentRecurrenceException] PRIMARY KEY  CLUSTERED 
	(
		[AppointmentRecurrenceExceptionID]
	)  ON [PRIMARY] 
GO

-- Add foreign keys
ALTER TABLE [dbo].[AppointmentRecurrence] ADD 
	CONSTRAINT [FK_AppointmentRecurrence_Appointment] FOREIGN KEY 
	(
		[AppointmentID]
	) REFERENCES [dbo].[Appointment] (
		[AppointmentID]
	)
GO

ALTER TABLE [dbo].[AppointmentRecurrenceException] ADD 
	CONSTRAINT [FK_AppointmentRecurrenceException_Appointment] FOREIGN KEY 
	(
		[AppointmentID]
	) REFERENCES [dbo].[Appointment] (
		[AppointmentID]
	)
GO


---------------------------------------------------------------------------------------
--case 3223 - Add report hyperlink information for the Patient Referrals Detail report

insert into ReportHyperlink
(ReportHyperlinkID, 
Description, 
ReportParameters)
values
(2, 
'Patient Referrals Detail Report', 
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Patient Referrals Detail" />
      <methodParam param="true" type="System.Boolean"/>
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="Add">
            <methodParam param="ProviderID" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="BeginDate" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="EndDate" />
            <methodParam param="{2}" />
          </method>
          <method name="Add">
            <methodParam param="ServiceLocationID" />
            <methodParam param="{3}" />
          </method>
          <method name="Add">
            <methodParam param="ReferringProviderID" />
            <methodParam param="{4}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>')


insert into ReportHyperlink
(ReportHyperlinkID, 
Description, 
ReportParameters)
values
(3, 
'Patient Referrals Detail Report (All Providers)', 
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Patient Referrals Detail" />
      <methodParam param="true" type="System.Boolean"/>
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="Add">
            <methodParam param="BeginDate" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="EndDate" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="ServiceLocationID" />
            <methodParam param="{2}" />
          </method>
          <method name="Add">
            <methodParam param="ReferringProviderID" />
            <methodParam param="{3}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>')

insert into ReportHyperlink
(ReportHyperlinkID, 
Description, 
ReportParameters)
values
(4, 
'Patient Referrals Detail Report (All Locations, Specific Provider)', 
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Patient Referrals Detail" />
      <methodParam param="true" type="System.Boolean"/>
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="Add">
            <methodParam param="ProviderID" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="BeginDate" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="EndDate" />
            <methodParam param="{2}" />
          </method>
          <method name="Add">
            <methodParam param="ReferringProviderID" />
            <methodParam param="{3}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>')

insert into ReportHyperlink
(ReportHyperlinkID, 
Description, 
ReportParameters)
values
(5, 
'Patient Referrals Detail Report (All Locations, All Providers)', 
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Patient Referrals Detail" />
      <methodParam param="true" type="System.Boolean"/>
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="Add">
            <methodParam param="BeginDate" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="EndDate" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="ReferringProviderID" />
            <methodParam param="{2}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>')

---------------------------------------------------------------------------------------
--case 3224 - Add report hyperlink information for the Patient Transactions Detail report

insert into ReportHyperlink
(ReportHyperlinkID, 
Description, 
ReportParameters)
values
(6, 
'Patient Transactions Detail Report', 
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Patient Transactions Detail" />
      <methodParam param="true" type="System.Boolean"/>
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="Add">
            <methodParam param="PatientID" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="BeginDate" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="EndDate" />
            <methodParam param="{2}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>')

---------------------------------------------------------------------------------------
--case 3225 - Add report hyperlink information for the Refunds Detail report

insert into ReportHyperlink
(ReportHyperlinkID, 
Description, 
ReportParameters)
values
(7, 
'Refunds Detail Report', 
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Refunds Detail" />
      <methodParam param="true" type="System.Boolean"/>
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="Add">
            <methodParam param="PaymentMethodCode" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="BeginDate" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="EndDate" />
            <methodParam param="{2}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>')

---------------------------------------------------------------------------------------
--case 3226 - Add report hyperlink information for the Payments Detail report

insert into ReportHyperlink
(ReportHyperlinkID, 
Description, 
ReportParameters)
values
(8, 
'Payments Detail Report', 
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Payments Detail" />
      <methodParam param="true" type="System.Boolean"/>
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="Add">
            <methodParam param="PaymentMethodCode" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="BeginDate" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="EndDate" />
            <methodParam param="{2}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>')

-- Add report hyperlink information for Payments Application report
insert into ReportHyperlink
(ReportHyperlinkID, 
Description, 
ReportParameters)
values
(9, 
'Payments Application Report', 
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Payments Application" />
      <methodParam param="true" type="System.Boolean"/>
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="Add">
            <methodParam param="PaymentID" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="rpmPayerName" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="rpmPaymentNumber" />
            <methodParam param="{2}" />
          </method>
          <method name="Add">
            <methodParam param="rpmPaymentAmount" />
            <methodParam param="{3}" />
          </method>
          <method name="Add">
            <methodParam param="rpmPaymentDate" />
            <methodParam param="{4}" />
          </method>
          <method name="Add">
            <methodParam param="rpmUnappliedAmount" />
            <methodParam param="{5}" />
          </method>
          <method name="Add">
            <methodParam param="rpmRefundAmount" />
            <methodParam param="{6}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>')


GO

SET IDENTITY_INSERT [dbo].[DMSRecordType] ON
INSERT INTO [dbo].[DMSRecordType] ([RecordTypeID], [TableName]) VALUES (1, 'Patient')
INSERT INTO [dbo].[DMSRecordType] ([RecordTypeID], [TableName]) VALUES (2, 'Encounter')
INSERT INTO [dbo].[DMSRecordType] ([RecordTypeID], [TableName]) VALUES (3, 'Appointment')
INSERT INTO [dbo].[DMSRecordType] ([RecordTypeID], [TableName]) VALUES (4, 'Claim')
INSERT INTO [dbo].[DMSRecordType] ([RecordTypeID], [TableName]) VALUES (5, 'Payment')
SET IDENTITY_INSERT [dbo].[DMSRecordType] OFF
GO

INSERT VoidedClaims(ClaimID)
SELECT ClaimID
FROM dbo.ClaimTransaction CT
WHERE CT.ClaimTransactionTypeCode = 'XXX'

GO

---------------------------------------------------------------------------------------
--Initializes the ClaimTransaction TABLE WITH providerid's

---------------------------------------------------------------------------------------
DECLARE @rowcount int
set rowcount  1000
WHILE 1 = 1
BEGIN
	update ClaimTransaction
		set amount = amount
	WHERE Claim_ProviderID IS NULL

	SET @rowcount = @@ROWCOUNT
	
	IF @rowcount = 0
		BREAK
END
PRINT 'DONE!!!!'

SELECT COUNT(*)
FROM dbo.ClaimTransaction CT
WHERE CT.Claim_ProviderID IS NULL
	
GO
---------------------------------------------------------------------------------------
--Initializes the Claim TABLE WITH some summary information for reports

---------------------------------------------------------------------------------------

	--This selects the first payment made BY an insurance company for those claims that have insurance
	UPDATE C
		SET Summary_ClaimFirstPayDate = dbo.fn_DateOnly(T2.FirstPayDate)
	FROM Claim C INNER JOIN
	
	(SELECT T.ClaimID, MIN(T.FirstPayDate) AS FirstPayDate
	FROM 
	(
		SELECT CT.ClaimID, MIN(CT.TransactionDate) AS FirstPayDate
		FROM dbo.ClaimTransaction CT
			INNER JOIN dbo.PaymentClaimTransaction PCT
			ON CT.ClaimTransactionID = PCT.ClaimTransactionID
			INNER JOIN dbo.Payment PMT 
			ON PCT.PaymentID = PMT.PaymentID
				AND PMT.PayerTypeCode = 'I'
		WHERE CT.ClaimTransactionTypeCode = 'PAY'			
		GROUP BY CT.ClaimID
		UNION ALL
		--This SELECT the first payment made BY a patient when the claim has no insurance payers
		SELECT CT.ClaimID, MIN(CT.TransactionDate) AS FirstPayDate
		FROM dbo.ClaimTransaction CT
		WHERE CT.ClaimTransactionTypeCode = 'PAY'
			AND NOT EXISTS (SELECT * FROM dbo.ClaimPayer CP WHERE CP.ClaimID = CT.ClaimID)
		GROUP BY CT.ClaimID
	) AS T
	GROUP BY T.ClaimID) t2
	ON C.ClaimID = T2.ClaimID
	
GO
	
	UPDATE C
		SET C.Summary_ClaimFirstBilledDate = dbo.fn_DateOnly( T2.FirstBilled)
	FROM Claim C INNER JOIN
		(
			SELECT CT.ClaimID, MIN(CT.CreatedDate) AS FirstBilled
			FROM dbo.ClaimTransaction CT
			WHERE CT.ClaimTransactionTypeCode = 'BLL'
			GROUP BY CT.ClaimID
		) T2
		ON C.ClaimID = T2.ClaimID

---------------------------------------------------------------------------------------
--Initializes Summary AR Balances

---------------------------------------------------------------------------------------
--VERY TIME CONSUMING
EXEC DataManagement_RegenerateClaimTransactionBalances

--
EXEC DataManagement_RegenerateSummary

--
SET NOCOUNT ON
DECLARE test_cursor CURSOR
READ_ONLY
FOR SELECT TransactionDate,
		ProviderID
	FROM dbo.SummaryTransactionByProviderPerDay 

DECLARE @TransactionDate datetime
DECLARE @ProviderID int
DECLARE @TotalCount int
SELECT @TotalCount = COUNT(*)
FROM dbo.SummaryTransactionByProviderPerDay
DECLARE @RunningCount int
SET @RunningCount = 0
OPEN test_cursor

FETCH NEXT FROM test_cursor INTO @TransactionDate, @ProviderID
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		SET @RunningCount = @RunningCount + 1
		UPDATE dbo.SummaryTransactionByProviderPerDay
			SET ARBalance = 	(SELECT SUM(CT1.Claim_ARBalance) AS Balance
								FROM dbo.ClaimTransaction CT1
								WHERE CT1.ClaimTransactionID IN
									(
										SELECT MAX(CT.ClaimTransactionID) AS ClaimTransactionID
										FROM dbo.ClaimTransaction CT
										WHERE CT.TransactionDate <= (DATEADD(s, -1, DATEADD(d,1,@TransactionDate)))
											AND CT.Claim_ProviderID = @ProviderID
											AND CT.ClaimID NOT IN (SELECT ClaimID FROM dbo.VoidedClaims)
										GROUP BY ClaimID
									)
								)
		WHERE TransactionDate = @TransactionDate
			AND ProviderID = @ProviderID

		PRINT CAST(@RunningCount AS varchar) + '/' + CAST(@TotalCount AS varchar)
	END
	FETCH NEXT FROM test_cursor INTO @TransactionDate, @ProviderID
END

CLOSE test_cursor
DEALLOCATE test_cursor
GO			


---------------------------------------------------------------------------------------
--case XXXX - Description

---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
