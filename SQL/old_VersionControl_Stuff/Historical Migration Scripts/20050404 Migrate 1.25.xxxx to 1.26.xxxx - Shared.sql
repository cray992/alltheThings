/*

DATABASE UPDATE SCRIPT

v1.24.1914 to v1.25.xxxx
*/
----------------------------------

--BEGIN TRAN 
----------------------------------

---------------------------------------------------------------------------------------
--case 3643:  Add Permissions for Company Indicators Summary report
DECLARE @Permission int

INSERT INTO Permissions (
	Name,
	Description,
	ViewInMedicalOffice,
	ViewInBusinessManager,
	ViewInAdministrator,
	ViewInServiceManager,
	PermissionGroupID,
	PermissionValue)
VALUES (
	'Read Company Indicators Summary',
	'Display, print, and save the Company Indicators Summary report.',
	1,
	1,
	1,
	1,
	10,
	'ReadCompanyIndicatorsSummary')

set @Permission = @@identity

INSERT INTO SecurityGroupPermissions (
		SecurityGroupID,
		PermissionID,
		Allowed,
		Denied)
SELECT 	SecurityGroupID,
	@Permission,
	1,
	0
FROM	SecurityGroup
WHERE	SecurityGroupName IN ( 'System Administrator', 'Billing Specialist' )

---------------------------------------------------------------------------------------
--case 3675:  Add Permissions for Procedure Analysis Summary report

INSERT INTO Permissions (
	Name,
	Description,
	ViewInMedicalOffice,
	ViewInBusinessManager,
	ViewInAdministrator,
	ViewInServiceManager,
	PermissionGroupID,
	PermissionValue)
VALUES (
	'Read Procedure Payments Summary',
	'Display, print, and save the Procedure Payments Summary report.',
	1,
	1,
	1,
	1,
	10,
	'ReadProcedurePaymentsSummary')

set @Permission = @@identity

INSERT INTO SecurityGroupPermissions (
		SecurityGroupID,
		PermissionID,
		Allowed,
		Denied)
SELECT 	SecurityGroupID,
	@Permission,
	1,
	0
FROM	SecurityGroup
WHERE	SecurityGroupName IN ( 'System Administrator', 'Billing Specialist', 'Doctor' )

GO

---------------------------------------------------------------------------------------
--case 3246 - New claim form needed for Michigan Medicaid 

INSERT INTO BillingForm (FormType, FormName, Transform) VALUES ('HCFA', 'Medicaid of Michigan', '')

--UPDATE InsuranceCompanyPlan SET BillingFormID = 3 WHERE (PlanName LIKE '%medicaid%') AND (PlanName LIKE '%michigan%')     -- plan 18409

/*
execute the following command from command prompt with appropriate server name and password:

textcopy /S k0.dc.kareo.com /U dev /P /D superbill_shared /T BillingForm /C Transform /W "WHERE BillingFormID = 3" /F C:\kcvs\Superbill\Software\Library\BrokerServer.Implementation\Bill_RAW-HCFA-MedicaidMichigan.xsl /I
*/

---------------------------------------------------------------------------------------
--case XXXX - Description

---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
