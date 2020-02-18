/*
	FB 624 - Add table to shared for Practice Fusion link history
*/
-- DROP TABLE PracticeFusionHistory
--------------------------------------------------------------------------------------------------------------
-- PracticeFusionHistory table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PracticeFusionHistory')
BEGIN
	CREATE TABLE [dbo].[PracticeFusionHistory](
		[PracticeFusionHistoryID] [int] NOT NULL IDENTITY(1,1), 
		[CustomerID] [int] NOT NULL,
		[PracticeID] [int] NOT NULL,
		[PracticeFusionID] varchar(100) NOT NULL,
		[PracticeFusionStatus] char(1) NOT NULL,
		[NewPracticeFusionPractice] bit NULL, 
		[Error] varchar(max) NULL, 
		[CreatedDate] [datetime] NOT NULL, 
		[CreatedUserID] [int] NOT NULL, 
		[Timestamp] timestamp not null
	)

	ALTER TABLE dbo.PracticeFusionHistory
	ADD CONSTRAINT PK_PracticeFusionHistoryID PRIMARY KEY CLUSTERED ( PracticeFusionHistoryID ASC )

	ALTER TABLE dbo.PracticeFusionHistory
	ADD CONSTRAINT DF_PracticeFusionHistory_CreatedDate  DEFAULT (getdate()) FOR CreatedDate
	
	ALTER TABLE dbo.PracticeFusionHistory WITH CHECK ADD  CONSTRAINT FK_PracticeFusionHistory_Customer FOREIGN KEY(CustomerID)
	REFERENCES dbo.Customer (CustomerID)	
END
GO
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PracticeFusionHistory' AND COLUMN_NAME = 'PracticeFusionStatus')
BEGIN
	ALTER TABLE [dbo].[PracticeFusionHistory]  WITH CHECK ADD  CONSTRAINT [CK_PracticeFusionHistory_PracticeFusionStatus] CHECK  (([PracticeFusionStatus]='N' OR [PracticeFusionStatus]='C'))
	ALTER TABLE [dbo].[PracticeFusionHistory] CHECK CONSTRAINT [CK_PracticeFusionHistory_PracticeFusionStatus]
END
GO

--------------------------------------------------------------------------------------------------------------
-- Creates security for editing integration options, grants users access if they have NewProvider, places in Setting Up Practices group
IF NOT EXISTS (SELECT * FROM Permissions WHERE PermissionValue='EditIntegrationOptions')
BEGIN
	DECLARE @PermissionID INT
	DECLARE @PermissionGroupID INT

	DECLARE @PermissionName VARCHAR(128)
	DECLARE @PermissionDescription VARCHAR(500)
	DECLARE @PermissionValue VARCHAR(128)

	SELECT	@PermissionGroupID = PermissionGroupID
	FROM	PermissionGroup
	WHERE	Name = 'Setting Up Practices'

	SET @PermissionName='Edit Integration Options'
	SET @PermissionDescription='Modify the integration options.'
	SET @PermissionValue='EditIntegrationOptions'

	EXEC @PermissionID=dbo.Shared_AuthenticationDataProvider_CreatePermission @Name=@PermissionName,
	@Description=@PermissionDescription, @ViewInKareo=0, @ViewInServiceManager=1, 
	@PermissionGroupID=@PermissionGroupID, @PermissionValue=@PermissionValue

	-- Commented this out as we don't want to automatically grant anyone permission to this if we don't go live with Practice Fusion
	/*
	EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='NewPractice',
	@PermissionToApplyID=@PermissionID
	*/
END

--------------------------------------------------------------------------------------------------------------
-- Adds some config for the integration as a Software Feature
IF NOT EXISTS (SELECT * FROM SoftwareFeature WHERE FeatureValue='PracticeFusionIntegration')
BEGIN
	DECLARE @SoftwareFeatureID INT

	INSERT INTO SoftwareFeature (FeatureName, FeatureValue)
	VALUES ('Practice Fusion Integration', 'PracticeFusionIntegration')

	SET @SoftwareFeatureID = SCOPE_IDENTITY()

	-- Complete - Included
	INSERT INTO EditionTypeSoftwareFeature (EditionTypeID, SoftwareFeatureID, SoftwareFeatureUsageID)
	VALUES (1, @SoftwareFeatureID, 1)

	-- Plus - Included
	INSERT INTO EditionTypeSoftwareFeature (EditionTypeID, SoftwareFeatureID, SoftwareFeatureUsageID)
	VALUES (2, @SoftwareFeatureID, 1)

	-- Basic - Exclude with upsell
	INSERT INTO EditionTypeSoftwareFeature (EditionTypeID, SoftwareFeatureID, SoftwareFeatureUsageID)
	VALUES (3, @SoftwareFeatureID, 2)

	-- Solo - Exclude with upsell
	INSERT INTO EditionTypeSoftwareFeature (EditionTypeID, SoftwareFeatureID, SoftwareFeatureUsageID)
	VALUES (4, @SoftwareFeatureID, 2)

	-- Trial - Exclude with upsell
	INSERT INTO EditionTypeSoftwareFeature (EditionTypeID, SoftwareFeatureID, SoftwareFeatureUsageID)
	VALUES (5, @SoftwareFeatureID, 2)

	-- Max - Included
	INSERT INTO EditionTypeSoftwareFeature (EditionTypeID, SoftwareFeatureID, SoftwareFeatureUsageID)
	VALUES (7, @SoftwareFeatureID, 1)
END
