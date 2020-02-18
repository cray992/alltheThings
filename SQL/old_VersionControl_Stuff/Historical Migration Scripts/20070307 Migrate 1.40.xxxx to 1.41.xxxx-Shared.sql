/*----------------------------------

DATABASE UPDATE SCRIPT

v1.42.xxxx to v1.43.xxxx
----------------------------------*/
--permissions for categories

/* Create new 'New CollectionCategory' permission ... */
DECLARE @NewCollectionCategoryPermissionID INT

EXEC @NewCollectionCategoryPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='New Collection Category',
	@Description='Create a new collection category.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=11,
	@PermissionValue='NewCollectionCategory'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='NewCategory',
	@PermissionToApplyID=@NewCollectionCategoryPermissionID
GO

/* Create new 'Edit CollectionCategory' permission ... */
DECLARE @EditCollectionCategoryPermissionID INT

EXEC @EditCollectionCategoryPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Edit Collection Category',
	@Description='Modify the details of a collections category.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=11,
	@PermissionValue='EditCollectionCategory'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='EditCategory',
	@PermissionToApplyID=@EditCollectionCategoryPermissionID
GO

/* Create new 'Read CollectionCategory' permission ... */
DECLARE @ReadCollectionCategoryPermissionID INT

EXEC @ReadCollectionCategoryPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Collection Category',
	@Description='Show the details of a collection category.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=11,
	@PermissionValue='ReadCollectionCategory'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadCategory',
	@PermissionToApplyID=@ReadCollectionCategoryPermissionID
GO

/* Create new 'Find CollectionCategory' permission ... */
DECLARE @FindCollectionCategoryPermissionID INT

EXEC @FindCollectionCategoryPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Find Collection Category',
	@Description='Display and search a list of collection categories.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=11,
	@PermissionValue='FindCollectionCategory'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindPayerScenario',
	@PermissionToApplyID=@FindCollectionCategoryPermissionID
GO

/* Create new 'Delete CollectionCategory' permission ... */
DECLARE @DeleteCollectionCategoryPermissionID INT

EXEC @DeleteCollectionCategoryPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Delete Collection Category',
	@Description='Delete a collection category.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=11,
	@PermissionValue='DeleteCollectionCategory'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='DeleteCategory',
	@PermissionToApplyID=@DeleteCollectionCategoryPermissionID
GO



/*-----------------------------------------------------------------------------
Case 20921:   Implement new Contract Management Summary
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Contract Managment Summary Report',
	@Description='Display, print, and save the contract management summary report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadContractManagementSummaryReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadPaymentsSummary',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID
GO

/*-----------------------------------------------------------------------------
Case 20922:   Implement new Contract Management Detail
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Contract Managment Detail Report',
	@Description='Display, print, and save the contract management detail report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadContractManagementDetailReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadPaymentsSummary',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID


GO

/*-----------------------------------------------------------------------------
 Case 20984: Patient Collections Summary Report
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Patient Collections Summary Report',
	@Description='Display, print, and save the patient collections summary report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadPatientCollectionsSummaryReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadARAgingByPatient',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID
GO


/*-----------------------------------------------------------------------------
Case 20985:   Implement new Patient Collections Detail report
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Patient Collections Detail Report',
	@Description='Display, print, and save the patient collections detail report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadPatientCollectionsDetailReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadARAgingByPatient',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID
GO
/*-----------------------------------------------------------------------------
	Case 17933 - No permission for Patient Detail report
-----------------------------------------------------------------------------*/

DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Patient Detail Report',
	@Description='Display, print, and save the patient detail report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadPatientDetailReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadPatient',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID

GO

declare @PermissionID INT

SELECT @PermissionID = permissionID
from permissions
where permissionValue = 'PrintPatient'

delete SecurityGroupPermissions
WHERE permissionID = @PermissionID

delete permissions 
WHERE permissionID = @PermissionID
GO


/*-----------------------------------------------------------------------------
	Case 21001 - Billing/Invoicing - Add a checkbox field to the practice record with a label “Exclude from Metrics” 
-----------------------------------------------------------------------------*/
--Make sure KareoUser does not get these permissions, so take the SignOnToServiceManager permission away from 
--this SecurityGroup which should not have the permission in the first place

DELETE SecurityGroupPermissions
WHERE PermissionID=111 AND SecurityGroupID=27

DECLARE @EditMetricsForPractice INT

EXEC @EditMetricsForPractice=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Edit Metrics For Practice',
	@Description='Modify the Metrics setting in practice record.', 
	@ViewInKareo=0,
	@ViewInServiceManager=1,
	@PermissionGroupID=12,
	@PermissionValue='EditMetricsForPractice'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='SignOnToServiceManager',
	@PermissionToApplyID=@EditMetricsForPractice

GO

/*-----------------------------------------------------------------------------
	Case 21002 - Billing/Invoicing - Add a checkbox field to the customer record with a label “Exclude from Metrics” 
-----------------------------------------------------------------------------*/
DECLARE @EditMetricsForCustomer INT

EXEC @EditMetricsForCustomer=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Edit Metrics For Customer',
	@Description='Modify the Metrics setting in customer record.', 
	@ViewInKareo=0,
	@ViewInServiceManager=1,
	@PermissionGroupID=16,
	@PermissionValue='EditMetricsForCustomer'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='SignOnToServiceManager',
	@PermissionToApplyID=@EditMetricsForCustomer

GO

/*-----------------------------------------------------------------------------
	Case 21000 - Billing/Invoicing - Add a picklist field to the provider record with label “Type:” 
-----------------------------------------------------------------------------*/
DECLARE @EditProviderTypeForProvider INT

EXEC @EditProviderTypeForProvider=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Edit Provider Type for Provider',
	@Description='Modify the Type setting in provider record.', 
	@ViewInKareo=0,
	@ViewInServiceManager=1,
	@PermissionGroupID=11,
	@PermissionValue='EditProviderTypeForProvider'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='SignOnToServiceManager',
	@PermissionToApplyID=@EditProviderTypeForProvider

GO








