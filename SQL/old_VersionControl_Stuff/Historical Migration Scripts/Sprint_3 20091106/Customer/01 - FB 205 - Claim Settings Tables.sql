-- Insert new tables for Claim Settings
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ClaimSettingsTaxIDType')
BEGIN
	CREATE TABLE dbo.ClaimSettingsTaxIDType(
		ClaimSettingsTaxIDTypeID int not null,
		Name varchar(50) not null,
		SortOrder int not null constraint DF_ClaimSettingsTaxIDType_SortOrder default (1),
		ViewInGeneralSettings bit constraint DF_ClaimSettingsTaxIDType_ViewInGeneralSettings default (0),
		CONSTRAINT PK_ClaimSettingsTaxIDType PRIMARY KEY CLUSTERED 
		(
			ClaimSettingsTaxIDTypeID ASC
		)
	)
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ClaimSettingsNPIType')
BEGIN
	CREATE TABLE dbo.ClaimSettingsNPIType(
		ClaimSettingsNPITypeID int not null,
		Name varchar(50) not null,
		SortOrder int not null constraint DF_ClaimSettingsNPIType_SortOrder default (1),
		ViewInGeneralSettings bit constraint DF_ClaimSettingsNPIType_ViewInGeneralSettings default (0),
		CONSTRAINT PK_ClaimSettingsNPIType PRIMARY KEY CLUSTERED 
		(
			ClaimSettingsNPITypeID ASC
		)
	)

	insert into ClaimSettingsTaxIDType (ClaimSettingsTaxIDTypeID, Name, SortOrder) values (1, 'Bill with EIN', 10)
	insert into ClaimSettingsTaxIDType (ClaimSettingsTaxIDTypeID, Name, SortOrder) values (2, 'Bill with SSN', 20)

	insert into ClaimSettingsNPIType (ClaimSettingsNPITypeID, Name, SortOrder) values (1, 'Bill with Group and Individual NPI', 10)
	insert into ClaimSettingsNPIType (ClaimSettingsNPITypeID, Name, SortOrder) values (2, 'Bill with Individual NPI Only', 20)
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ClaimSettings')
BEGIN
	--drop table dbo.ClaimSettings
	CREATE TABLE dbo.ClaimSettings(
		ClaimSettingsID int not null identity(1, 1),

		DoctorID int not null,
		InsuranceCompanyID int null,
		LocationID int null,
		ClaimSettingsTaxIDTypeID int not null,
		TaxIDOverrideValue varchar(50) null,
		ClaimSettingsNPITypeID int not null,
		NPIOverrideValue varchar(50) null,
		IndNPIOverrideValue varchar(50) null,
		SubmitterNumber varchar(7) null,
		ShowAdvancedSettings bit not null default 0,

		-- paper claim related
		Field17aNumberType int null,
		Field17aValue varchar(50) null,
		Field24jNumberType int null,
		Field24jValue varchar(50) null,
		Field33bNumberType int null,
		Field33bValue varchar(50) null,
		
		ProviderNumberType1 int null,
		ProviderNumber1 varchar(50) null,
		ProviderNumberType2 int null,
		ProviderNumber2 varchar(50) null,
		ProviderNumberType3 int null,
		ProviderNumber3 varchar(50) null,
		ProviderNumberType4 int null,
		ProviderNumber4 varchar(50) null,

		GroupNumberType1 int null,
		GroupNumber1 varchar(50) null,
		GroupNumberType2 int null,
		GroupNumber2 varchar(50) null,
		GroupNumberType3 int null,
		GroupNumber3 varchar(50) null,
		GroupNumberType4 int null,
		GroupNumber4 varchar(50) null,

		EligibilityOverride bit not null default 0,
		EligibilityNPITypeID int not null,		
		EligibilityTaxIDTypeID int not null,
		
		CONSTRAINT PK_ClaimSettings PRIMARY KEY CLUSTERED 
		(
			ClaimSettingsID ASC
		)
	)

	ALTER TABLE dbo.ClaimSettings WITH CHECK ADD CONSTRAINT FK_ClaimSettings_Doctor FOREIGN KEY(DoctorID)
	REFERENCES dbo.Doctor (DoctorID)

	ALTER TABLE dbo.ClaimSettings WITH CHECK ADD CONSTRAINT FK_ClaimSettings_InsuranceCompany FOREIGN KEY(InsuranceCompanyID)
	REFERENCES dbo.InsuranceCompany (InsuranceCompanyID)

	ALTER TABLE dbo.ClaimSettings WITH CHECK ADD CONSTRAINT FK_ClaimSettings_ServiceLocation FOREIGN KEY(LocationID)
	REFERENCES dbo.ServiceLocation (ServiceLocationID)

	ALTER TABLE dbo.ClaimSettings CHECK CONSTRAINT FK_ClaimSettings_ServiceLocation
	
	ALTER TABLE dbo.ClaimSettings WITH CHECK ADD CONSTRAINT FK_ClaimSettings_ClaimSettingsTaxIDType FOREIGN KEY(ClaimSettingsTaxIDTypeID)
	REFERENCES dbo.ClaimSettingsTaxIDType (ClaimSettingsTaxIDTypeID)
	
	ALTER TABLE dbo.ClaimSettings CHECK CONSTRAINT FK_ClaimSettings_ClaimSettingsTaxIDType
	
	ALTER TABLE dbo.ClaimSettings WITH CHECK ADD CONSTRAINT FK_ClaimSettings_ClaimSettingsNPIType FOREIGN KEY(ClaimSettingsNPITypeID)
	REFERENCES dbo.ClaimSettingsNPIType (ClaimSettingsNPITypeID)

	ALTER TABLE dbo.ClaimSettings CHECK CONSTRAINT FK_ClaimSettings_ClaimSettingsNPIType
	
	
	-- eligibility related constraints
	ALTER TABLE dbo.ClaimSettings WITH CHECK ADD CONSTRAINT FK_EligibilityClaimSettings_ClaimSettingsTaxIDType FOREIGN KEY(EligibilityTaxIDTypeID)
	REFERENCES dbo.ClaimSettingsTaxIDType (ClaimSettingsTaxIDTypeID)

	ALTER TABLE dbo.ClaimSettings CHECK CONSTRAINT FK_EligibilityClaimSettings_ClaimSettingsTaxIDType

	ALTER TABLE dbo.ClaimSettings WITH CHECK ADD CONSTRAINT FK_EligibilityClaimSettings_ClaimSettingsNPIType FOREIGN KEY(EligibilityTaxIDTypeID)
	REFERENCES dbo.ClaimSettingsNPIType (ClaimSettingsNPITypeID)

	ALTER TABLE dbo.ClaimSettings CHECK CONSTRAINT FK_EligibilityClaimSettings_ClaimSettingsNPIType

END 

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Practice' AND COLUMN_NAME = 'TaxonomyCode')
BEGIN
	-- practice TaxonomyCode
	alter table dbo.practice add TaxonomyCode char(10) null

	ALTER TABLE [dbo].[practice]  WITH CHECK ADD  CONSTRAINT [FK_Practice_TaxonomyCode] FOREIGN KEY([TaxonomyCode])
	REFERENCES [dbo].[TaxonomyCode] ([TaxonomyCode])
END


/* those are unnecessary - it was originally planed to have it on practice level

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Practice' AND COLUMN_NAME = 'ClaimSettingsTaxIDTypeID')
BEGIN
	ALTER TABLE Practice 
		ADD ClaimSettingsTaxIDTypeID int

	ALTER TABLE dbo.Practice WITH CHECK ADD CONSTRAINT FK_Practice_ClaimSettingsTaxIDType FOREIGN KEY(ClaimSettingsTaxIDTypeID)
	REFERENCES dbo.ClaimSettingsTaxIDType (ClaimSettingsTaxIDTypeID)

	ALTER TABLE dbo.Practice CHECK CONSTRAINT FK_Practice_ClaimSettingsTaxIDType

END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Practice' AND COLUMN_NAME = 'ClaimSettingsNPITypeID')
BEGIN
	ALTER TABLE Practice 
		ADD ClaimSettingsNPITypeID int

	ALTER TABLE dbo.Practice WITH CHECK ADD CONSTRAINT FK_Practice_ClaimSettingsNPIType FOREIGN KEY(ClaimSettingsNPITypeID)
	REFERENCES dbo.ClaimSettingsNPIType (ClaimSettingsNPITypeID)

	ALTER TABLE dbo.Practice CHECK CONSTRAINT FK_Practice_ClaimSettingsNPIType

END
*/