-- ServiceLocationDataProvider_GetServiceLocations
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Patient]') AND name = N'IX_Patient_PracticeID_DefaultServiceLocationID')
BEGIN
	CREATE NONCLUSTERED INDEX IX_Patient_PracticeID_DefaultServiceLocationID
	ON [dbo].[Patient] ([PracticeID],[DefaultServiceLocationID])
END
GO

-- fn_BillDataProvider_GetClaimSetting
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimSettings]') AND name = N'IX_ClaimSettings_DoctorID_InsuranceCompanyID_LocationID')
BEGIN
	CREATE NONCLUSTERED INDEX [IX_ClaimSettings_DoctorID_InsuranceCompanyID_LocationID] ON [dbo].[ClaimSettings] 
	(
		[DoctorID] ASC,
		[InsuranceCompanyID] ASC,
		[LocationID] ASC
	)
END
GO


