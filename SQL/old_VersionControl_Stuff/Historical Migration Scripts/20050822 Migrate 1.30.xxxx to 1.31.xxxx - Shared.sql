/*

SHARED DATABASE UPDATE SCRIPT

v1.30.xxxx to v1.31.xxxx		
*/
----------------------------------

--BEGIN TRAN 

----------------------------------

---------------------------------------------------------------------------------------
--case 5446 - Modify data model to include InsuranceCompany table
---------------------------------------------------------------------------------------

ALTER TABLE [dbo].[InsuranceCompany] ADD 
	CONSTRAINT [DF_InsuranceCompany_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
	CONSTRAINT [DF_InsuranceCompany_CreatedUserID] DEFAULT (0) FOR [CreatedUserID],
	CONSTRAINT [DF_InsuranceCompany_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate],
	CONSTRAINT [DF_InsuranceCompany_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID],
	CONSTRAINT [DF_InsuranceCompany_InsuranceProgramCode] DEFAULT ('09') FOR [InsuranceProgramCode],
	CONSTRAINT [DF_InsuranceCompany_HCFADiagnosisReferenceFormatCode] DEFAULT ('C') FOR [HCFADiagnosisReferenceFormatCode],
	CONSTRAINT [DF_InsuranceCompany_HCFASameAsInsuredFormatCode] DEFAULT ('D') FOR [HCFASameAsInsuredFormatCode],
	CONSTRAINT [DF_InsuranceCompany_ReviewCode] DEFAULT ('') FOR [ReviewCode],
	CONSTRAINT [DF_InsuranceCompany_BillingFormID] DEFAULT (1) FOR [BillingFormID],
	CONSTRAINT [DF_InsuranceCompany_EClaimsAccepts] DEFAULT (0) FOR [EClaimsAccepts],
	CONSTRAINT [DF_InsuranceCompany_BillSecondaryInsurance] DEFAULT (0) FOR [BillSecondaryInsurance]
GO


---------------------------------------------------------------------------------------
--case 6584 - Add "closing the books" task to Business Manager
---------------------------------------------------------------------------------------
/*

DECLARE @newPerm1ID int
DECLARE @newPerm2ID int
DECLARE @permGroupID int

SET @permGroupID = (SELECT PermissionGroupID FROM PermissionGroup WHERE Name = 'Setting Up Practices')

INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Change Closing Date','Update the accounting closing date for a practice',0,0,1,1,@permGroupID,'ChangeClosingDate')

SET @newPerm1ID = SCOPE_IDENTITY()

INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Change Closing the Books Options','Toggle the closing date from on to off, and other closing the books options',0,0,1,1,@permGroupID,'ChangeClosingBooksOptions')

SET @newPerm2ID = SCOPE_IDENTITY()

DECLARE @targetPermissionID int
SET @targetPermissionID = (SELECT PermissionID FROM Permissions WHERE PermissionValue='SignOnToAdministrator')


DECLARE @currentSecurityGroupID int

DECLARE curse CURSOR
READ_ONLY
FOR 
	SELECT SecurityGroupID
	FROM dbo.SecurityGroup
	WHERE SecurityGroupID IN 
		(SELECT DISTINCT SecurityGroupID FROM SecurityGroupPermissions WHERE PermissionID = @targetPermissionID)

OPEN curse

FETCH NEXT FROM curse INTO @currentSecurityGroupID
WHILE (@@fetch_status = 0)
BEGIN
	INSERT INTO SecurityGroupPermissions
		(SecurityGroupID, PermissionID, Allowed,Denied)
	VALUES
		(@currentSecurityGroupID, @newPerm1ID, 1, 0)

	INSERT INTO SecurityGroupPermissions
		(SecurityGroupID, PermissionID, Allowed,Denied)
	VALUES
		(@currentSecurityGroupID, @newPerm2ID, 1, 0)
		
FETCH NEXT FROM curse INTO @currentSecurityGroupID
END

CLOSE curse
DEALLOCATE curse

*/
GO


---------------------------------------------------------------------------------------
--case XXXX - Description
---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
