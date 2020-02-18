ALTER TABLE EditionType ADD 
	Description varchar(512),
	Active bit NOT NULL CONSTRAINT DF_EditionType_Active DEFAULT 1,
	ShowToAllCustomers bit NOT NULL CONSTRAINT DF_EditionType_ShowToAllCustomers DEFAULT 1

GO

UPDATE 
	EditionType
SET
	ShowToAllCustomers = 0
WHERE
	EditionTypeCaption IN ('Trial','Solo')

GO

CREATE TABLE EditionTypeCustomer (
	EditionTypeCustomerID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_EditionTypeCustomer PRIMARY KEY,
	EditionTypeID int NOT NULL CONSTRAINT FK_EditionTypeCustomer_EditionTypeID FOREIGN KEY REFERENCES EditionType (EditionTypeID),
	CustomerID int NOT NULL CONSTRAINT FK_EditionTypeCustomer_CustomerID FOREIGN KEY REFERENCES Customer (CustomerID)
)
GO

CREATE TABLE SoftwareFeature (
	SoftwareFeatureID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_SoftwareFeature PRIMARY KEY,
	FeatureName varchar(100) NOT NULL,
	FeatureValue varchar(100) NOT NULL,
	Description varchar(1024),
	UpsellUrl varchar(1024),
)
GO


--Table to explain possible actions of an
CREATE TABLE SoftwareFeatureUsage (
	SoftwareFeatureUsageID int NOT NULL 
		CONSTRAINT PK_SoftwareFeatureUsage PRIMARY KEY
		CONSTRAINT CK_SoftwareFeatureUsage_SoftwareFeatureUsageID CHECK (SoftwareFeatureUsageID > 0),
	Name varchar(100) NOT NULL
)
GO

INSERT INTO SoftwareFeatureUsage (SoftwareFeatureUsageID, Name) VALUES (1, 'Included')
INSERT INTO SoftwareFeatureUsage (SoftwareFeatureUsageID, Name) VALUES (2, 'Excluded with Upsell')
INSERT INTO SoftwareFeatureUsage (SoftwareFeatureUsageID, Name) VALUES (3, 'Excluded and Hidden')
GO

CREATE TABLE EditionTypeSoftwareFeature (
	EditionTypeSoftwareFeatureID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_EditionTypeSoftwareFeature PRIMARY KEY,
	EditionTypeID int NOT NULL CONSTRAINT FK_EditionTypeSoftwareFeature_EditionType FOREIGN KEY REFERENCES EditionType (EditionTypeID),
	SoftwareFeatureID int NOT NULL CONSTRAINT FK_EditionTypeSoftwareFeature_SoftwareFeature FOREIGN KEY REFERENCES SoftwareFeature (SoftwareFeatureID),
	SoftwareFeatureUsageID int NOT NULL CONSTRAINT DF_EditionTypeSoftwareFeature_SoftwareFeatureUsageID DEFAULT 1 CONSTRAINT FK_EditionTypeSoftwareFeature_SoftwareFeatureUsage FOREIGN KEY REFERENCES SoftwareFeatureUsage (SoftwareFeatureUsageID) 
)

INSERT INTO SoftwareFeature (FeatureName,FeatureValue) VALUES ('Appointments','Appointments')
INSERT INTO SoftwareFeature (FeatureName,FeatureValue) VALUES ('Code Scrubbing','CodeScrubbing')
INSERT INTO SoftwareFeature (FeatureName,FeatureValue) VALUES ('Electronic Claims','ElectronicClaims')
INSERT INTO SoftwareFeature (FeatureName,FeatureValue) VALUES ('Eligibility','Eligibility')
INSERT INTO SoftwareFeature (FeatureName,FeatureValue) VALUES ('Patient Statements','PatientStatements')
INSERT INTO SoftwareFeature (FeatureName,FeatureValue) VALUES ('Document Management','DocumentManagement')
INSERT INTO SoftwareFeature (FeatureName,FeatureValue) VALUES ('Faxing','Faxing')
INSERT INTO SoftwareFeature (FeatureName,FeatureValue) VALUES ('Practitioner','Practitioner')
GO

--define base editions

DECLARE @EditionTypeID int

SET @EditionTypeID = (SELECT EditionTypeID FROM EditionType WHERE EditionTypeCaption='Trial')
INSERT INTO EditionTypeSoftwareFeature (EditionTypeID, SoftwareFeatureID, SoftwareFeatureUsageID)
SELECT 
	@EditionTypeID, 
	SoftwareFeatureID, 
	CASE FeatureValue
		WHEN 'Appointments'			THEN 1
		WHEN 'CodeScrubbing'			THEN 3
		WHEN 'ElectronicClaims'			THEN 3
		WHEN 'Eligibility'			THEN 3
		WHEN 'PatientStatements'		THEN 3
		WHEN 'DocumentManagement'		THEN 1
		WHEN 'Faxing'				THEN 3
		WHEN 'Practitioner'			THEN 3
	END
FROM 
	SoftwareFeature 


SET @EditionTypeID = (SELECT EditionTypeID FROM EditionType WHERE EditionTypeCaption='Solo')
INSERT INTO EditionTypeSoftwareFeature (EditionTypeID, SoftwareFeatureID, SoftwareFeatureUsageID)
SELECT 
	@EditionTypeID, 
	SoftwareFeatureID, 
	CASE FeatureValue
		WHEN 'Appointments'			THEN 1
		WHEN 'CodeScrubbing'			THEN 3
		WHEN 'ElectronicClaims'			THEN 3
		WHEN 'Eligibility'			THEN 3
		WHEN 'PatientStatements'		THEN 3
		WHEN 'DocumentManagement'		THEN 3
		WHEN 'Faxing'				THEN 3
		WHEN 'Practitioner'			THEN 3
	END
FROM 
	SoftwareFeature 

SET @EditionTypeID = (SELECT EditionTypeID FROM EditionType WHERE EditionTypeCaption='Basic')
INSERT INTO EditionTypeSoftwareFeature (EditionTypeID, SoftwareFeatureID, SoftwareFeatureUsageID)
SELECT 
	@EditionTypeID, 
	SoftwareFeatureID, 
	CASE FeatureValue
		WHEN 'Appointments'			THEN 3
		WHEN 'CodeScrubbing'			THEN 3
		WHEN 'ElectronicClaims'			THEN 1
		WHEN 'Eligibility'			THEN 3
		WHEN 'PatientStatements'		THEN 1
		WHEN 'DocumentManagement'		THEN 3
		WHEN 'Faxing'				THEN 3
		WHEN 'Practitioner'			THEN 3
	END
FROM 
	SoftwareFeature 

SET @EditionTypeID = (SELECT EditionTypeID FROM EditionType WHERE EditionTypeCaption='Team')
INSERT INTO EditionTypeSoftwareFeature (EditionTypeID, SoftwareFeatureID, SoftwareFeatureUsageID)
SELECT 
	@EditionTypeID, 
	SoftwareFeatureID, 
	CASE FeatureValue
		WHEN 'Appointments'			THEN 3
		WHEN 'CodeScrubbing'			THEN 1
		WHEN 'ElectronicClaims'			THEN 1
		WHEN 'Eligibility'			THEN 1
		WHEN 'PatientStatements'		THEN 1
		WHEN 'DocumentManagement'		THEN 1
		WHEN 'Faxing'				THEN 1
		WHEN 'Practitioner'			THEN 3
	END
FROM 
	SoftwareFeature 

SET @EditionTypeID = (SELECT EditionTypeID FROM EditionType WHERE EditionTypeCaption='Enterprise')
INSERT INTO EditionTypeSoftwareFeature (EditionTypeID, SoftwareFeatureID, SoftwareFeatureUsageID)
SELECT 
	@EditionTypeID, 
	SoftwareFeatureID, 
	CASE FeatureValue
		WHEN 'Appointments'			THEN 1
		WHEN 'CodeScrubbing'			THEN 1
		WHEN 'ElectronicClaims'			THEN 1
		WHEN 'Eligibility'			THEN 1
		WHEN 'PatientStatements'		THEN 1
		WHEN 'DocumentManagement'		THEN 1
		WHEN 'Faxing'				THEN 1
		WHEN 'Practitioner'			THEN 1
	END
FROM 
	SoftwareFeature 
GO

DECLARE @NewPermissionGroupID int
INSERT INTO PermissionGroup (Name, Description) VALUES ('Adjusting Product Settings','Maintaining Kareo operational settings, subscriptions, etc.')
SET @NewPermissionGroupID = SCOPE_IDENTITY()


/* Create new 'New SubscriptionEdition' permission ... */
DECLARE @NewSubscriptionEditionPermissionID INT

EXEC @NewSubscriptionEditionPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='New Subscription Edition',
	@Description='Create a new subscription edition.', 
	@ViewInKareo=0,
	@ViewInServiceManager=1,
	@PermissionGroupID=@NewPermissionGroupID,
	@PermissionValue='NewSubscriptionEdition'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindCustomer',
	@PermissionToApplyID=@NewSubscriptionEditionPermissionID


/* Create new 'Edit SubscriptionEdition' permission ... */
DECLARE @EditSubscriptionEditionPermissionID INT

EXEC @EditSubscriptionEditionPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Edit Subscription Edition',
	@Description='Modify the details of a subscription edition.', 
	@ViewInKareo=0,
	@ViewInServiceManager=1,
	@PermissionGroupID=@NewPermissionGroupID,
	@PermissionValue='EditSubscriptionEdition'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindCustomer',
	@PermissionToApplyID=@EditSubscriptionEditionPermissionID


/* Create new 'Read SubscriptionEdition' permission ... */
DECLARE @ReadSubscriptionEditionPermissionID INT

EXEC @ReadSubscriptionEditionPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Subscription Edition',
	@Description='Show the details of a subscription edition.', 
	@ViewInKareo=0,
	@ViewInServiceManager=1,
	@PermissionGroupID=11,
	@PermissionValue='ReadSubscriptionEdition'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindCustomer',
	@PermissionToApplyID=@ReadSubscriptionEditionPermissionID


/* Create new 'Find SubscriptionEdition' permission ... */
DECLARE @FindSubscriptionEditionPermissionID INT

EXEC @FindSubscriptionEditionPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Find Subscription Edition',
	@Description='Display and search a list of subscription editions.', 
	@ViewInKareo=0,
	@ViewInServiceManager=1,
	@PermissionGroupID=@NewPermissionGroupID,
	@PermissionValue='FindSubscriptionEdition'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindCustomer',
	@PermissionToApplyID=@FindSubscriptionEditionPermissionID


/* Create new 'Delete SubscriptionEdition' permission ... */
DECLARE @DeleteSubscriptionEditionPermissionID INT

EXEC @DeleteSubscriptionEditionPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Delete Subscription Edition',
	@Description='Delete a subscription edition.', 
	@ViewInKareo=0,
	@ViewInServiceManager=1,
	@PermissionGroupID=@NewPermissionGroupID,
	@PermissionValue='DeleteSubscriptionEdition'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='DeleteCustomer',
	@PermissionToApplyID=@DeleteSubscriptionEditionPermissionID
