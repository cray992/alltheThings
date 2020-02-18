/*
Script created by SQL Compare from Red Gate Software Ltd at 12/12/2004 21:03:28
Run this script on k0.kareo.ent.superbill_0001_dev to make it the same as dim8400.superbill_0001_dev
Please back up your database before running this script
*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
PRINT N'Dropping extended properties'
GO
sp_dropextendedproperty N'MS_DiagramPane1', 'USER', N'dbo', 'VIEW', N'DebugPatientView', NULL, NULL
GO
sp_dropextendedproperty N'MS_DiagramPane2', 'USER', N'dbo', 'VIEW', N'DebugPatientView', NULL, NULL
GO
sp_dropextendedproperty N'MS_DiagramPaneCount', 'USER', N'dbo', 'VIEW', N'DebugPatientView', NULL, NULL
GO
sp_dropextendedproperty N'MS_DiagramPane1', 'USER', N'dbo', 'VIEW', N'PatientAuthorizationNumberView', NULL, NULL
GO
sp_dropextendedproperty N'MS_DiagramPaneCount', 'USER', N'dbo', 'VIEW', N'PatientAuthorizationNumberView', NULL, NULL
GO
sp_dropextendedproperty N'MS_DiagramPane1', 'USER', N'dbo', 'VIEW', N'PatientEmployersearch', NULL, NULL
GO
sp_dropextendedproperty N'MS_DiagramPaneCount', 'USER', N'dbo', 'VIEW', N'PatientEmployersearch', NULL, NULL
GO
sp_dropextendedproperty N'MS_DiagramPane1', 'USER', N'dbo', 'VIEW', N'PatientInsuranceSearch', NULL, NULL
GO
sp_dropextendedproperty N'MS_DiagramPaneCount', 'USER', N'dbo', 'VIEW', N'PatientInsuranceSearch', NULL, NULL
GO
sp_dropextendedproperty N'MS_DiagramPane1', 'USER', N'dbo', 'VIEW', N'Recent Patients', NULL, NULL
GO
sp_dropextendedproperty N'MS_DiagramPane2', 'USER', N'dbo', 'VIEW', N'Recent Patients', NULL, NULL
GO
sp_dropextendedproperty N'MS_DiagramPaneCount', 'USER', N'dbo', 'VIEW', N'Recent Patients', NULL, NULL
GO
sp_dropextendedproperty N'MS_DiagramPane1', 'USER', N'dbo', 'VIEW', N'vPracticePatients', NULL, NULL
GO
sp_dropextendedproperty N'MS_DiagramPane2', 'USER', N'dbo', 'VIEW', N'vPracticePatients', NULL, NULL
GO
sp_dropextendedproperty N'MS_DiagramPaneCount', 'USER', N'dbo', 'VIEW', N'vPracticePatients', NULL, NULL
GO
PRINT N'Dropping foreign keys from [dbo].[InsuranceCompanyPlan]'
GO
ALTER TABLE [dbo].[InsuranceCompanyPlan] DROP
CONSTRAINT [FK_InsuranceCompanyPlan_GroupNumberType],
CONSTRAINT [FK_InsuranceCompanyPlan_ProviderNumberType],
CONSTRAINT [FK_InsuranceCompanyPlan_ProviderNumberType_LocalUse]
GO
PRINT N'Dropping foreign keys from [dbo].[PracticeInsuranceGroupNumber]'
GO
ALTER TABLE [dbo].[PracticeInsuranceGroupNumber] DROP
CONSTRAINT [FK_PracticeInsuranceGroupNumber_GroupNumberType]
GO
PRINT N'Dropping foreign keys from [dbo].[ProviderNumber]'
GO
ALTER TABLE [dbo].[ProviderNumber] DROP
CONSTRAINT [FK_ProviderNumber_ProviderNumberType]
GO
PRINT N'Dropping foreign keys from [dbo].[Report]'
GO
ALTER TABLE [dbo].[Report] DROP
CONSTRAINT [FK_Report_ReportCategory]
GO
PRINT N'Dropping foreign keys from [dbo].[UserPractices]'
GO
ALTER TABLE [dbo].[UserPractices] DROP
CONSTRAINT [FK_UserPractices_Users]
GO
PRINT N'Dropping foreign keys from [dbo].[GroupPermissions]'
GO
ALTER TABLE [dbo].[GroupPermissions] DROP
CONSTRAINT [FK_GroupPermissions_Groups],
CONSTRAINT [FK_GroupPermissions_Permissions]
GO
PRINT N'Dropping foreign keys from [dbo].[UserGroups]'
GO
ALTER TABLE [dbo].[UserGroups] DROP
CONSTRAINT [FK_UserGroups_Groups],
CONSTRAINT [FK_UserGroups_Users]
GO
PRINT N'Dropping foreign keys from [dbo].[Users]'
GO
ALTER TABLE [dbo].[Users] DROP
CONSTRAINT [FK_Users_UserPassword]
GO
PRINT N'Dropping constraints from [dbo].[Report]'
GO
ALTER TABLE [dbo].[Report] DROP CONSTRAINT [PK_Report]
GO
PRINT N'Dropping constraints from [dbo].[Report]'
GO
ALTER TABLE [dbo].[Report] DROP CONSTRAINT [DF__Report__Modified__55EAA1D1]
GO
PRINT N'Dropping constraints from [dbo].[Tokens]'
GO
ALTER TABLE [dbo].[Tokens] DROP CONSTRAINT [PK_Tokens]
GO
PRINT N'Dropping constraints from [dbo].[SecurityGroup]'
GO
ALTER TABLE [dbo].[SecurityGroup] DROP CONSTRAINT [PK_SecurityGroup]
GO
PRINT N'Dropping constraints from [dbo].[SecurityGroup]'
GO
ALTER TABLE [dbo].[SecurityGroup] DROP CONSTRAINT [DF_SecurityGroup_CreatedDate]
GO
PRINT N'Dropping constraints from [dbo].[SecurityGroup]'
GO
ALTER TABLE [dbo].[SecurityGroup] DROP CONSTRAINT [DF_SecurityGroup_ModifiedDate]
GO
PRINT N'Dropping constraints from [dbo].[InsuranceCompanyPlan]'
GO
ALTER TABLE [dbo].[InsuranceCompanyPlan] DROP CONSTRAINT [DF_EClaimsRequiresEnrollment]
GO
PRINT N'Dropping constraints from [dbo].[InsuranceCompanyPlan]'
GO
ALTER TABLE [dbo].[InsuranceCompanyPlan] DROP CONSTRAINT [DF_EClaimsRequiresAuthorization]
GO
PRINT N'Dropping constraints from [dbo].[InsuranceCompanyPlan]'
GO
ALTER TABLE [dbo].[InsuranceCompanyPlan] DROP CONSTRAINT [DF_EClaimsRequiresProviderID]
GO
PRINT N'Dropping constraints from [dbo].[InsuranceCompanyPlan]'
GO
ALTER TABLE [dbo].[InsuranceCompanyPlan] DROP CONSTRAINT [DF__Insurance__EClai__75B09349]
GO
PRINT N'Dropping constraints from [dbo].[InsuranceCompanyPlan]'
GO
ALTER TABLE [dbo].[InsuranceCompanyPlan] DROP CONSTRAINT [DF__Insurance__EClai__76A4B782]
GO
PRINT N'Dropping constraints from [dbo].[tmp_PracticeToInsuranceCompanyPlan]'
GO
ALTER TABLE [dbo].[tmp_PracticeToInsuranceCompanyPlan] DROP CONSTRAINT [DF__tmp_Pract__Creat__164F3FA9]
GO
PRINT N'Dropping constraints from [dbo].[tmp_PracticeToInsuranceCompanyPlan]'
GO
ALTER TABLE [dbo].[tmp_PracticeToInsuranceCompanyPlan] DROP CONSTRAINT [DF__tmp_Pract__Creat__174363E2]
GO
PRINT N'Dropping constraints from [dbo].[tmp_PracticeToInsuranceCompanyPlan]'
GO
ALTER TABLE [dbo].[tmp_PracticeToInsuranceCompanyPlan] DROP CONSTRAINT [DF__tmp_Pract__Modif__1837881B]
GO
PRINT N'Dropping constraints from [dbo].[tmp_PracticeToInsuranceCompanyPlan]'
GO
ALTER TABLE [dbo].[tmp_PracticeToInsuranceCompanyPlan] DROP CONSTRAINT [DF__tmp_Pract__Modif__192BAC54]
GO
PRINT N'Dropping constraints from [dbo].[tmp_PracticeToInsuranceCompanyPlan]'
GO
ALTER TABLE [dbo].[tmp_PracticeToInsuranceCompanyPlan] DROP CONSTRAINT [DF__tmp_Pract__EClai__1A1FD08D]
GO
PRINT N'Dropping constraints from [dbo].[tmp_PracticeToInsuranceCompanyPlan]'
GO
ALTER TABLE [dbo].[tmp_PracticeToInsuranceCompanyPlan] DROP CONSTRAINT [DF__tmp_Pract__EStat__1B13F4C6]
GO
PRINT N'Dropping constraints from [dbo].[Users]'
GO
ALTER TABLE [dbo].[Users] DROP CONSTRAINT [PK_Users]
GO
PRINT N'Dropping constraints from [dbo].[Users]'
GO
ALTER TABLE [dbo].[Users] DROP CONSTRAINT [UX_UsersEmailAddress]
GO
PRINT N'Dropping constraints from [dbo].[Users]'
GO
ALTER TABLE [dbo].[Users] DROP CONSTRAINT [DF_Users_CreatedDate]
GO
PRINT N'Dropping constraints from [dbo].[Users]'
GO
ALTER TABLE [dbo].[Users] DROP CONSTRAINT [DF_Users_CreatedUserID]
GO
PRINT N'Dropping constraints from [dbo].[Users]'
GO
ALTER TABLE [dbo].[Users] DROP CONSTRAINT [DF_Users_ModifiedDate]
GO
PRINT N'Dropping constraints from [dbo].[Users]'
GO
ALTER TABLE [dbo].[Users] DROP CONSTRAINT [DF_Users_ModifiedUserID]
GO
PRINT N'Dropping constraints from [dbo].[Users]'
GO
ALTER TABLE [dbo].[Users] DROP CONSTRAINT [DF__Users__AccountLo__71B2B7D7]
GO
PRINT N'Dropping constraints from [dbo].[Users]'
GO
ALTER TABLE [dbo].[Users] DROP CONSTRAINT [DF__Users__AccountLo__72A6DC10]
GO
PRINT N'Dropping constraints from [dbo].[GroupPermissions]'
GO
ALTER TABLE [dbo].[GroupPermissions] DROP CONSTRAINT [PK_GroupPermissions]
GO
PRINT N'Dropping constraints from [dbo].[GroupPermissions]'
GO
ALTER TABLE [dbo].[GroupPermissions] DROP CONSTRAINT [IX_GroupPermissions]
GO
PRINT N'Dropping constraints from [dbo].[GroupPermissions]'
GO
ALTER TABLE [dbo].[GroupPermissions] DROP CONSTRAINT [DF_GroupPermissions_CreatedDate]
GO
PRINT N'Dropping constraints from [dbo].[GroupPermissions]'
GO
ALTER TABLE [dbo].[GroupPermissions] DROP CONSTRAINT [DF_GroupPerm_CreatedUserID]
GO
PRINT N'Dropping constraints from [dbo].[GroupPermissions]'
GO
ALTER TABLE [dbo].[GroupPermissions] DROP CONSTRAINT [DF_GroupPermissions_ModifiedDate]
GO
PRINT N'Dropping constraints from [dbo].[GroupPermissions]'
GO
ALTER TABLE [dbo].[GroupPermissions] DROP CONSTRAINT [DF_GroupPerm_ModifiedUserID]
GO
PRINT N'Dropping constraints from [dbo].[SubApplications]'
GO
ALTER TABLE [dbo].[SubApplications] DROP CONSTRAINT [PK_Functionality]
GO
PRINT N'Dropping constraints from [dbo].[SubApplications]'
GO
ALTER TABLE [dbo].[SubApplications] DROP CONSTRAINT [DF_Functionality_Enabled]
GO
PRINT N'Dropping constraints from [dbo].[SubApplications]'
GO
ALTER TABLE [dbo].[SubApplications] DROP CONSTRAINT [DF_SubApplications_CreatedDate]
GO
PRINT N'Dropping constraints from [dbo].[SubApplications]'
GO
ALTER TABLE [dbo].[SubApplications] DROP CONSTRAINT [DF_SubApplications_ModifiedDate]
GO
PRINT N'Dropping constraints from [dbo].[tmp_ClearinghouseResponse]'
GO
ALTER TABLE [dbo].[tmp_ClearinghouseResponse] DROP CONSTRAINT [DF__tmp_Clear__Revie__1466F737]
GO
PRINT N'Dropping constraints from [dbo].[UserPassword]'
GO
ALTER TABLE [dbo].[UserPassword] DROP CONSTRAINT [PK_UserPassword]
GO
PRINT N'Dropping constraints from [dbo].[UserPassword]'
GO
ALTER TABLE [dbo].[UserPassword] DROP CONSTRAINT [DF__UserPassw__Creat__6ED64B2C]
GO
PRINT N'Dropping constraints from [dbo].[UserPassword]'
GO
ALTER TABLE [dbo].[UserPassword] DROP CONSTRAINT [DF__UserPassw__Expir__6FCA6F65]
GO
PRINT N'Dropping constraints from [dbo].[BillingForm]'
GO
ALTER TABLE [dbo].[BillingForm] DROP CONSTRAINT [PK_BillingForm]
GO
PRINT N'Dropping constraints from [dbo].[ProviderNumberType]'
GO
ALTER TABLE [dbo].[ProviderNumberType] DROP CONSTRAINT [PK_BillingIdentifier]
GO
PRINT N'Dropping constraints from [dbo].[GroupNumberType]'
GO
ALTER TABLE [dbo].[GroupNumberType] DROP CONSTRAINT [PK_GroupNumberType]
GO
PRINT N'Dropping constraints from [dbo].[UserGroups]'
GO
ALTER TABLE [dbo].[UserGroups] DROP CONSTRAINT [PK_UserGroups]
GO
PRINT N'Dropping constraints from [dbo].[UserGroups]'
GO
ALTER TABLE [dbo].[UserGroups] DROP CONSTRAINT [IX_UserGroups]
GO
PRINT N'Dropping constraints from [dbo].[UserGroups]'
GO
ALTER TABLE [dbo].[UserGroups] DROP CONSTRAINT [DF_UserGroups_CreatedDate]
GO
PRINT N'Dropping constraints from [dbo].[UserGroups]'
GO
ALTER TABLE [dbo].[UserGroups] DROP CONSTRAINT [DF_UserGroups_CreatedUserID]
GO
PRINT N'Dropping constraints from [dbo].[UserGroups]'
GO
ALTER TABLE [dbo].[UserGroups] DROP CONSTRAINT [DF_UserGroups_ModifiedDate]
GO
PRINT N'Dropping constraints from [dbo].[UserGroups]'
GO
ALTER TABLE [dbo].[UserGroups] DROP CONSTRAINT [DF_UserGroups_ModifiedUserID]
GO
PRINT N'Dropping constraints from [dbo].[Permissions]'
GO
ALTER TABLE [dbo].[Permissions] DROP CONSTRAINT [PK_Permissions]
GO
PRINT N'Dropping constraints from [dbo].[Permissions]'
GO
ALTER TABLE [dbo].[Permissions] DROP CONSTRAINT [DF_Permissions_CreatedDate]
GO
PRINT N'Dropping constraints from [dbo].[Permissions]'
GO
ALTER TABLE [dbo].[Permissions] DROP CONSTRAINT [DF_Permissions_CreatedUserID]
GO
PRINT N'Dropping constraints from [dbo].[Permissions]'
GO
ALTER TABLE [dbo].[Permissions] DROP CONSTRAINT [DF_Permissions_ModifiedDate]
GO
PRINT N'Dropping constraints from [dbo].[Permissions]'
GO
ALTER TABLE [dbo].[Permissions] DROP CONSTRAINT [DF_Permissions_ModifiedUserID]
GO
PRINT N'Dropping constraints from [dbo].[SecuritySetting]'
GO
ALTER TABLE [dbo].[SecuritySetting] DROP CONSTRAINT [PK_SecuritySetting]
GO
PRINT N'Dropping constraints from [dbo].[SecuritySetting]'
GO
ALTER TABLE [dbo].[SecuritySetting] DROP CONSTRAINT [DF__SecurityS__Passw__60882BD5]
GO
PRINT N'Dropping constraints from [dbo].[SecuritySetting]'
GO
ALTER TABLE [dbo].[SecuritySetting] DROP CONSTRAINT [DF__SecurityS__Passw__617C500E]
GO
PRINT N'Dropping constraints from [dbo].[SecuritySetting]'
GO
ALTER TABLE [dbo].[SecuritySetting] DROP CONSTRAINT [DF__SecurityS__Passw__62707447]
GO
PRINT N'Dropping constraints from [dbo].[SecuritySetting]'
GO
ALTER TABLE [dbo].[SecuritySetting] DROP CONSTRAINT [DF__SecurityS__Passw__63649880]
GO
PRINT N'Dropping constraints from [dbo].[SecuritySetting]'
GO
ALTER TABLE [dbo].[SecuritySetting] DROP CONSTRAINT [DF__SecurityS__Passw__6458BCB9]
GO
PRINT N'Dropping constraints from [dbo].[SecuritySetting]'
GO
ALTER TABLE [dbo].[SecuritySetting] DROP CONSTRAINT [DF__SecurityS__Passw__654CE0F2]
GO
PRINT N'Dropping constraints from [dbo].[SecuritySetting]'
GO
ALTER TABLE [dbo].[SecuritySetting] DROP CONSTRAINT [DF__SecurityS__Passw__6641052B]
GO
PRINT N'Dropping constraints from [dbo].[SecuritySetting]'
GO
ALTER TABLE [dbo].[SecuritySetting] DROP CONSTRAINT [DF__SecurityS__Passw__67352964]
GO
PRINT N'Dropping constraints from [dbo].[SecuritySetting]'
GO
ALTER TABLE [dbo].[SecuritySetting] DROP CONSTRAINT [DF__SecurityS__Locko__68294D9D]
GO
PRINT N'Dropping constraints from [dbo].[SecuritySetting]'
GO
ALTER TABLE [dbo].[SecuritySetting] DROP CONSTRAINT [DF__SecurityS__UILoc__691D71D6]
GO
PRINT N'Dropping constraints from [dbo].[SecuritySetting]'
GO
ALTER TABLE [dbo].[SecuritySetting] DROP CONSTRAINT [DF__SecurityS__UILoc__6A11960F]
GO
PRINT N'Dropping constraints from [dbo].[SecuritySetting]'
GO
ALTER TABLE [dbo].[SecuritySetting] DROP CONSTRAINT [DF__SecurityS__UILoc__6B05BA48]
GO
PRINT N'Dropping constraints from [dbo].[SecuritySetting]'
GO
ALTER TABLE [dbo].[SecuritySetting] DROP CONSTRAINT [DF__SecurityS__UILoc__6BF9DE81]
GO
PRINT N'Dropping constraints from [dbo].[SecuritySetting]'
GO
ALTER TABLE [dbo].[SecuritySetting] DROP CONSTRAINT [DF_SecuritySetting_UILockMinutesServiceManager]
GO
PRINT N'Dropping constraints from [dbo].[Groups]'
GO
ALTER TABLE [dbo].[Groups] DROP CONSTRAINT [PK_Groups]
GO
PRINT N'Dropping constraints from [dbo].[Groups]'
GO
ALTER TABLE [dbo].[Groups] DROP CONSTRAINT [DF_Groups_CreatedDate]
GO
PRINT N'Dropping constraints from [dbo].[Groups]'
GO
ALTER TABLE [dbo].[Groups] DROP CONSTRAINT [DF_Groups_CreatedUserID]
GO
PRINT N'Dropping constraints from [dbo].[Groups]'
GO
ALTER TABLE [dbo].[Groups] DROP CONSTRAINT [DF_Groups_ModifiedDate]
GO
PRINT N'Dropping constraints from [dbo].[Groups]'
GO
ALTER TABLE [dbo].[Groups] DROP CONSTRAINT [DF_Groups_ModifiedUserID]
GO
PRINT N'Dropping index [IX_InsuranceCompanyPlan_InsuranceCompanyPlanID_EDIPayerNumber] from [dbo].[InsuranceCompanyPlan]'
GO
DROP INDEX [dbo].[InsuranceCompanyPlan].[IX_InsuranceCompanyPlan_InsuranceCompanyPlanID_EDIPayerNumber]
GO
PRINT N'Dropping index [TokensToken] from [dbo].[Tokens]'
GO
DROP INDEX [dbo].[Tokens].[TokensToken]
GO
PRINT N'Dropping statistics [Statistic_UserId] from [dbo].[UserGroups]'
GO
DROP STATISTICS [dbo].[UserGroups].[Statistic_UserId]
GO
PRINT N'Dropping statistics [Statistic_GroupId] from [dbo].[UserGroups]'
GO
DROP STATISTICS [dbo].[UserGroups].[Statistic_GroupId]
GO
PRINT N'Dropping [dbo].[usp_CONFIGURE_ReplicationSizeForBlobs]'
GO
DROP PROCEDURE [dbo].[usp_CONFIGURE_ReplicationSizeForBlobs]
GO
PRINT N'Dropping [dbo].[GetPermissionsForUser]'
GO
DROP PROCEDURE [dbo].[GetPermissionsForUser]
GO
PRINT N'Dropping [dbo].[_20041115_ClaimTransaction]'
GO
DROP TABLE [dbo].[_20041115_ClaimTransaction]
GO
PRINT N'Dropping [dbo].[_20040707_PatientAuthorization_NoMatchPatient]'
GO
DROP TABLE [dbo].[_20040707_PatientAuthorization_NoMatchPatient]
GO
PRINT N'Dropping [dbo].[__ClaimBackup]'
GO
DROP TABLE [dbo].[__ClaimBackup]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_DeleteGroup]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_DeleteGroup]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_DeleteUser]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_DeleteUser]
GO
PRINT N'Dropping [dbo].[apL_GetPracticesForUser]'
GO
DROP PROCEDURE [dbo].[apL_GetPracticesForUser]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_SetPasswordWithOldSecretAnswer]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_SetPasswordWithOldSecretAnswer]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_SetPasswordWithOldPassword]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_SetPasswordWithOldPassword]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_SetPassword]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_SetPassword]
GO
PRINT N'Dropping [dbo].[DeleteEntirePracticeChain]'
GO
DROP PROCEDURE [dbo].[DeleteEntirePracticeChain]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_CreateUser]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_CreateUser]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_UnsetUserGroup]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_UnsetUserGroup]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_GetGroup]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_GetGroup]
GO
PRINT N'Dropping [dbo].[apL_AuthenticateUser]'
GO
DROP PROCEDURE [dbo].[apL_AuthenticateUser]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_GetUser]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_GetUser]
GO
PRINT N'Dropping [dbo].[apD_UserGroup]'
GO
DROP PROCEDURE [dbo].[apD_UserGroup]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_UpdateGroup]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_UpdateGroup]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_UnsetGroupPermission]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_UnsetGroupPermission]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_SetGroupPermission]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_SetGroupPermission]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_GetGroups]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_GetGroups]
GO
PRINT N'Dropping [dbo].[StoredProcedure2]'
GO
DROP PROCEDURE [dbo].[StoredProcedure2]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_GetSecuritySettings]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_GetSecuritySettings]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_UpdateUser]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_UpdateUser]
GO
PRINT N'Dropping [dbo].[apD_GroupPermission]'
GO
DROP PROCEDURE [dbo].[apD_GroupPermission]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_UpdateSecuritySettings]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_UpdateSecuritySettings]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_SetUserGroup]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_SetUserGroup]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_UnsetGroupUser]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_UnsetGroupUser]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_GetGroupPermissions]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_GetGroupPermissions]
GO
PRINT N'Dropping [dbo].[apL_GetPermissionsForUser]'
GO
DROP PROCEDURE [dbo].[apL_GetPermissionsForUser]
GO
PRINT N'Dropping [dbo].[apD_Permission]'
GO
DROP PROCEDURE [dbo].[apD_Permission]
GO
PRINT N'Dropping [dbo].[apD_User]'
GO
DROP PROCEDURE [dbo].[apD_User]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_Authenticate]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_Authenticate]
GO
PRINT N'Dropping [dbo].[BusinessRule_UserIsValid]'
GO
DROP FUNCTION [dbo].[BusinessRule_UserIsValid]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_GetUsers]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_GetUsers]
GO
PRINT N'Dropping [dbo].[GetUserForNtlmName]'
GO
DROP PROCEDURE [dbo].[GetUserForNtlmName]
GO
PRINT N'Dropping [dbo].[apL_GetUserSecurityInformation]'
GO
DROP PROCEDURE [dbo].[apL_GetUserSecurityInformation]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_GetUserGroups]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_GetUserGroups]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_CreateGroup]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_CreateGroup]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_SetGroupUser]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_SetGroupUser]
GO
PRINT N'Dropping [dbo].[apL_GetGroupsForUser]'
GO
DROP PROCEDURE [dbo].[apL_GetGroupsForUser]
GO
PRINT N'Dropping [dbo].[apL_CheckPermissionForUser]'
GO
DROP PROCEDURE [dbo].[apL_CheckPermissionForUser]
GO
PRINT N'Dropping [dbo].[apD_Group]'
GO
DROP PROCEDURE [dbo].[apD_Group]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_AuthenticateSecretAnswer]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_AuthenticateSecretAnswer]
GO
PRINT N'Dropping [dbo].[apL_GetUserByName]'
GO
DROP PROCEDURE [dbo].[apL_GetUserByName]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_GetGroupUsers]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_GetGroupUsers]
GO
PRINT N'Dropping [dbo].[apL_GetPermissionsForGroup]'
GO
DROP PROCEDURE [dbo].[apL_GetPermissionsForGroup]
GO
PRINT N'Dropping [dbo].[Groups]'
GO
DROP TABLE [dbo].[Groups]
GO
PRINT N'Dropping [dbo].[GetSubApplicationsForUser]'
GO
DROP PROCEDURE [dbo].[GetSubApplicationsForUser]
GO
PRINT N'Dropping [dbo].[SecurityGroup]'
GO
DROP TABLE [dbo].[SecurityGroup]
GO
PRINT N'Dropping [dbo].[GetToken]'
GO
DROP PROCEDURE [dbo].[GetToken]
GO
PRINT N'Dropping [dbo].[vTokens]'
GO
DROP VIEW [dbo].[vTokens]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_GetSecretQuestion]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_GetSecretQuestion]
GO
PRINT N'Dropping [dbo].[SubApplications]'
GO
DROP TABLE [dbo].[SubApplications]
GO
PRINT N'Dropping [dbo].[tmp_PracticeToInsuranceCompanyPlan]'
GO
DROP TABLE [dbo].[tmp_PracticeToInsuranceCompanyPlan]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_GetPermissionsByUser]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_GetPermissionsByUser]
GO
PRINT N'Dropping [dbo].[GroupPermissions]'
GO
DROP TABLE [dbo].[GroupPermissions]
GO
PRINT N'Dropping [dbo].[UserPassword]'
GO
DROP TABLE [dbo].[UserPassword]
GO
PRINT N'Dropping [dbo].[BillDataProvider_GetClearinghouseResponseCount]'
GO
DROP PROCEDURE [dbo].[BillDataProvider_GetClearinghouseResponseCount]
GO
PRINT N'Dropping [dbo].[AuthenticationDataProvider_GetPermissions]'
GO
DROP PROCEDURE [dbo].[AuthenticationDataProvider_GetPermissions]
GO
PRINT N'Dropping [dbo].[Permissions]'
GO
DROP TABLE [dbo].[Permissions]
GO
PRINT N'Dropping [dbo].[SecuritySetting]'
GO
DROP TABLE [dbo].[SecuritySetting]
GO
PRINT N'Dropping [dbo].[eosp_UpdateDoctor]'
GO
DROP PROCEDURE [dbo].[eosp_UpdateDoctor]
GO
PRINT N'Dropping [dbo].[UserGroups]'
GO
DROP TABLE [dbo].[UserGroups]
GO
PRINT N'Dropping [dbo].[Users]'
GO
DROP TABLE [dbo].[Users]
GO
PRINT N'Dropping [dbo].[DeleteToken]'
GO
DROP PROCEDURE [dbo].[DeleteToken]
GO
PRINT N'Dropping [dbo].[SetTokenExpires]'
GO
DROP PROCEDURE [dbo].[SetTokenExpires]
GO
PRINT N'Dropping [dbo].[tmp_ClearinghouseResponse]'
GO
DROP TABLE [dbo].[tmp_ClearinghouseResponse]
GO
PRINT N'Dropping [dbo].[CreateSecurityToken]'
GO
DROP PROCEDURE [dbo].[CreateSecurityToken]
GO
PRINT N'Dropping [dbo].[SetTokenForToken]'
GO
DROP PROCEDURE [dbo].[SetTokenForToken]
GO
PRINT N'Dropping [dbo].[Tokens]'
GO
DROP TABLE [dbo].[Tokens]
GO
PRINT N'Rebuilding [dbo].[BillingForm]'
GO
CREATE TABLE [dbo].[tmp_rg_xx_BillingForm]
(
[BillingFormID] [int] NOT NULL,
[FormType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FormName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Transform] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TIMESTAMP] [timestamp] NOT NULL
)

GO
INSERT INTO [dbo].[tmp_rg_xx_BillingForm]([BillingFormID], [FormType], [FormName], [Transform]) SELECT [BillingFormID], [FormType], [FormName], [Transform] FROM [dbo].[BillingForm]
GO
DROP TABLE [dbo].[BillingForm]
GO
sp_rename N'[dbo].[tmp_rg_xx_BillingForm]', N'BillingForm'
GO
PRINT N'Creating primary key [PK_BillingForm] on [dbo].[BillingForm]'
GO
ALTER TABLE [dbo].[BillingForm] ADD CONSTRAINT [PK_BillingForm] PRIMARY KEY CLUSTERED  ([BillingFormID])
GO
PRINT N'Rebuilding [dbo].[Report]'
GO
CREATE TABLE [dbo].[tmp_rg_xx_Report]
(
[ReportID] [int] NOT NULL IDENTITY(1, 1),
[ReportCategoryID] [int] NOT NULL,
[DisplayOrder] [int] NOT NULL,
[Image] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaskName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReportServer] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReportPath] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReportParameters] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF__Report__Modified__55EAA1D1] DEFAULT (getdate()),
[TIMESTAMP] [timestamp] NULL,
[MenuName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PermissionValue] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL default ('NotSet')
)

GO
SET IDENTITY_INSERT [dbo].[tmp_rg_xx_Report] ON
GO
INSERT INTO [dbo].[tmp_rg_xx_Report]([ReportID], [ReportCategoryID], [DisplayOrder], [Image], [Name], [Description], [TaskName], [ReportServer], [ReportPath], [ReportParameters], [ModifiedDate], [MenuName]) SELECT [ReportID], [ReportCategoryID], [DisplayOrder], [Image], [Name], [Description], [TaskName], [ReportServer], [ReportPath], [ReportParameters], [ModifiedDate], [MenuName] FROM [dbo].[Report]
GO
SET IDENTITY_INSERT [dbo].[tmp_rg_xx_Report] OFF
GO
DROP TABLE [dbo].[Report]
GO
sp_rename N'[dbo].[tmp_rg_xx_Report]', N'Report'
GO
PRINT N'Creating primary key [PK_Report] on [dbo].[Report]'
GO
ALTER TABLE [dbo].[Report] ADD CONSTRAINT [PK_Report] PRIMARY KEY CLUSTERED  ([ReportID])
GO
PRINT N'Rebuilding [dbo].[ProviderNumberType]'
GO
CREATE TABLE [dbo].[tmp_rg_xx_ProviderNumberType]
(
[ProviderNumberTypeID] [int] NOT NULL,
[TypeName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ANSIReferenceIdentificationQualifier] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
INSERT INTO [dbo].[tmp_rg_xx_ProviderNumberType]([ProviderNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) SELECT [ProviderNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier] FROM [dbo].[ProviderNumberType]
GO
DROP TABLE [dbo].[ProviderNumberType]
GO
sp_rename N'[dbo].[tmp_rg_xx_ProviderNumberType]', N'ProviderNumberType'
GO
PRINT N'Creating primary key [PK_BillingIdentifier] on [dbo].[ProviderNumberType]'
GO
ALTER TABLE [dbo].[ProviderNumberType] ADD CONSTRAINT [PK_BillingIdentifier] PRIMARY KEY CLUSTERED  ([ProviderNumberTypeID])
GO
PRINT N'Rebuilding [dbo].[GroupNumberType]'
GO
CREATE TABLE [dbo].[tmp_rg_xx_GroupNumberType]
(
[GroupNumberTypeID] [int] NOT NULL,
[TypeName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ANSIReferenceIdentificationQualifier] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
INSERT INTO [dbo].[tmp_rg_xx_GroupNumberType]([GroupNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) SELECT [GroupNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier] FROM [dbo].[GroupNumberType]
GO
DROP TABLE [dbo].[GroupNumberType]
GO
sp_rename N'[dbo].[tmp_rg_xx_GroupNumberType]', N'GroupNumberType'
GO
PRINT N'Creating primary key [PK_GroupNumberType] on [dbo].[GroupNumberType]'
GO
ALTER TABLE [dbo].[GroupNumberType] ADD CONSTRAINT [PK_GroupNumberType] PRIMARY KEY CLUSTERED  ([GroupNumberTypeID])
GO
PRINT N'Altering [dbo].[ReportDataProvider_GetReportParameters]'
GO

ALTER PROCEDURE dbo.ReportDataProvider_GetReportParameters
	@ReportName varchar(128)
AS
BEGIN

	select		ReportID, 
			Name, 
			ReportServer, 
			ReportPath, 
			ReportParameters, 
			PermissionValue
	from		Report
	where		Name = @ReportName

END


GO
PRINT N'Altering [dbo].[InsuranceCompanyPlan]'
GO
ALTER TABLE [dbo].[InsuranceCompanyPlan] ADD
[ClearinghousePayerID] [int] NULL,
[KareoInsuranceCompanyPlanID] [int] NULL,
[KareoLastModifiedDate] [datetime] NULL
ALTER TABLE [dbo].[InsuranceCompanyPlan] DROP
COLUMN [EDIPayerNumber],
COLUMN [IsGovernment],
COLUMN [StateSpecific],
COLUMN [EClaimsRequiresEnrollment],
COLUMN [EClaimsRequiresAuthorization],
COLUMN [EClaimsRequiresProviderID],
COLUMN [EClaimsResponseLevel],
COLUMN [EClaimsPaperOnly],
COLUMN [EClaimsRequiresTest]
GO
PRINT N'Creating index [IX_InsuranceCompanyPlan_KareoInsuranceCompanyPlanID] on [dbo].[InsuranceCompanyPlan]'
GO
CREATE NONCLUSTERED INDEX [IX_InsuranceCompanyPlan_KareoInsuranceCompanyPlanID] ON [dbo].[InsuranceCompanyPlan] ([KareoInsuranceCompanyPlanID])
GO
PRINT N'Altering [dbo].[Doctor]'
GO
ALTER TABLE [dbo].[Doctor] DROP
COLUMN [UPIN],
COLUMN [MedicareIndividualProviderNumber]
GO
PRINT N'Altering [dbo].[ProcedureCodeDictionary]'
GO
ALTER TABLE [dbo].[ProcedureCodeDictionary] ADD
[KareoProcedureCodeDictionaryID] [int] NULL,
[KareoLastModifiedDate] [datetime] NULL
GO
PRINT N'Creating index [IX_ProcedureCodeDictionary_KareoProcedureCodeDictionaryID] on [dbo].[ProcedureCodeDictionary]'
GO
CREATE NONCLUSTERED INDEX [IX_ProcedureCodeDictionary_KareoProcedureCodeDictionaryID] ON [dbo].[ProcedureCodeDictionary] ([KareoProcedureCodeDictionaryID])
GO
PRINT N'Altering [dbo].[DiagnosisCodeDictionary]'
GO
ALTER TABLE [dbo].[DiagnosisCodeDictionary] ADD
[KareoDiagnosisCodeDictionaryID] [int] NULL,
[KareoLastModifiedDate] [datetime] NULL
GO
PRINT N'Creating index [IX_DiagnosisCodeDictionary_KareoDiagnosisCodeDictionaryID] on [dbo].[DiagnosisCodeDictionary]'
GO
CREATE NONCLUSTERED INDEX [IX_DiagnosisCodeDictionary_KareoDiagnosisCodeDictionaryID] ON [dbo].[DiagnosisCodeDictionary] ([KareoDiagnosisCodeDictionaryID])
GO
PRINT N'Altering [dbo].[Handheld_DoctorDataProvider_GetDoctorForUser]'
GO


--===========================================================================
-- GET DOCTOR FOR USER
--===========================================================================
ALTER  PROCEDURE dbo.Handheld_DoctorDataProvider_GetDoctorForUser
	@username VARCHAR(255)
AS
BEGIN
SELECT	U.USERID,
		U.NTLMNAME,
		D.DOCTORID,
		D.PRACTICEID,
		D.PREFIX,
		D.FIRSTNAME,
		D.MIDDLENAME,
		D.LASTNAME,
		D.SUFFIX,
		P.NAME AS PRACTICENAME
	FROM	DOCTOR D
		INNER JOIN USERS U
		ON U.USERID = D.USERID
		INNER JOIN PRACTICE P
		ON P.PRACTICEID = D.PRACTICEID
	WHERE	U.EmailAddress = @username	
END


GO
PRINT N'Creating [dbo].[ClearinghousePayersList]'
GO
CREATE TABLE [dbo].[ClearinghousePayersList]
(
[ClearinghousePayerID] [int] NOT NULL,
[ClearinghouseID] [int] NULL,
[PayerNumber] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StateSpecific] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsPaperOnly] [bit] NOT NULL CONSTRAINT [DF_ClearinghousePayersList_IsPaperOnly] DEFAULT (0),
[IsGovernment] [bit] NOT NULL CONSTRAINT [DF_ClearinghousePayersList_IsGovernment] DEFAULT (0),
[IsCommercial] [bit] NOT NULL CONSTRAINT [DF_ClearinghousePayersList_IsCommercial] DEFAULT (0),
[IsParticipating] [bit] NOT NULL CONSTRAINT [DF_ClearinghousePayersList_IsParticipating] DEFAULT (0),
[IsProviderIdRequired] [bit] NOT NULL CONSTRAINT [DF_ClearinghousePayersList_IsProviderIdRequired] DEFAULT (0),
[IsEnrollmentRequired] [bit] NOT NULL CONSTRAINT [DF_ClearinghousePayersList_IsEnrollmentRequired] DEFAULT (0),
[IsAuthorizationRequired] [bit] NOT NULL CONSTRAINT [DF_ClearinghousePayersList_IsAuthorizationRequired] DEFAULT (0),
[IsTestRequired] [bit] NOT NULL CONSTRAINT [DF_ClearinghousePayersList_IsTestRequired] DEFAULT (0),
[ResponseLevel] [int] NULL,
[IsNewPayer] [bit] NOT NULL CONSTRAINT [DF_ClearinghousePayersList_IsNewPayer] DEFAULT (0),
[DateNewPayerSince] [datetime] NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ClearinghousePayersList_CreatedDate] DEFAULT (getdate()),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ClearinghousePayersList_ModifiedDate] DEFAULT (getdate()),
[TIMESTAMP] [timestamp] NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_ClearinghousePayersList_Active] DEFAULT (1),
[IsModifiedPayer] [bit] NOT NULL CONSTRAINT [DF_ClearinghousePayersList_IsModifiedPayer] DEFAULT (0),
[DateModifiedPayerSince] [datetime] NULL,
[KareoClearinghousePayersListID] [int] NULL,
[KareoLastModifiedDate] [datetime] NULL
)

GO
PRINT N'Creating primary key [PK__ClearinghousePay__5106BC7A] on [dbo].[ClearinghousePayersList]'
GO
ALTER TABLE [dbo].[ClearinghousePayersList] ADD CONSTRAINT [PK__ClearinghousePay__5106BC7A] PRIMARY KEY CLUSTERED  ([ClearinghousePayerID])
GO
PRINT N'Creating index [IX_ClearinghousePayersList_KareoClearinghousePayersListID] on [dbo].[ClearinghousePayersList]'
GO
CREATE NONCLUSTERED INDEX [IX_ClearinghousePayersList_KareoClearinghousePayersListID] ON [dbo].[ClearinghousePayersList] ([KareoClearinghousePayersListID])
GO
PRINT N'Creating [dbo].[InsurancePlanDataProvider_GetClearinghousePayer]'
GO

--===========================================================================
-- GET CLEARINGHOUSE PAYER
--===========================================================================
CREATE PROCEDURE dbo.InsurancePlanDataProvider_GetClearinghousePayer
	@ClearinghousePayerId INT
AS
BEGIN
	SELECT	CAST(CPL.ClearinghousePayerID AS INT) AS ClearinghousePayerID,      -- loose the identity
		CPL.ClearinghouseID,
		'ProxyMed' AS ClearinghouseName,
		CPL.PayerNumber,
		CPL.[Name],
		CPL.Notes,
		CPL.StateSpecific,
		CAST((CASE (CPL.IsGovernment) WHEN 1 THEN 1 ELSE (CASE (CPL.IsCommercial) WHEN 1 THEN 2 ELSE 0 END) END) AS INT) AS PayerType,
		CPL.IsParticipating,
		CPL.IsProviderIdRequired,
		CPL.IsEnrollmentRequired,
		CPL.IsAuthorizationRequired,
		CPL.IsTestRequired,
		CPL.ResponseLevel,
		CPL.IsNewPayer,
		CPL.DateNewPayerSince,
		CPL.ModifiedDate,
		CPL.Active
	INTO 
		#t_ClearinghousePayer
	FROM	ClearinghousePayersList CPL
	WHERE	CPL.ClearinghousePayerID = @ClearinghousePayerId
	
	SELECT *
	FROM #t_ClearinghousePayer
	
	DROP TABLE #t_ClearinghousePayer
	RETURN
END


GO
PRINT N'Altering [dbo].[BillDataProvider_GetClearinghouseResponses]'
GO

--===========================================================================
-- GET Clearinghouse Responses
--===========================================================================
ALTER PROCEDURE dbo.BillDataProvider_GetClearinghouseResponses
	@practice_id int,
	@status VARCHAR(25),
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(50) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	CREATE TABLE #t_responses (
		ClearinghouseResponseID int,
		ResponseType int,
		Title varchar(256),
		PracticeID int,
		PracticeName varchar(100),
		SourceAddress varchar(100),
		[FileName] varchar(100),
		FileReceiveDate datetime,
		ReviewedFlag bit,
		ProcessedFlag bit,
		RID int IDENTITY(0,1)
	)
	
	INSERT #t_responses
	SELECT	CR.ClearinghouseResponseID,
		CR.ResponseType,
		CR.Title,
		CR.PracticeID,
		P.Name AS PracticeName,
		CR.SourceAddress,
		CR.FileName,
		CR.FileReceiveDate,
		CR.ReviewedFlag,
		CR.ProcessedFlag
	FROM	ClearinghouseResponse CR
	LEFT OUTER JOIN Practice P
	ON P.PracticeID = CR.PracticeID 
	WHERE	(	(@status = 'All')
		OR	(@status = 'Reviewed' AND ReviewedFlag = 1)
		OR	(@status = 'Unreviewed' AND ReviewedFlag = 0))
	AND	(	(@query_domain IS NULL OR @query IS NULL)
		OR	((@query_domain = 'ReceiveDate'
				OR @query_domain = 'All')
			AND	(CONVERT(VARCHAR,FileReceiveDate,101) LIKE '%' + @query + '%'))
		OR	((@query_domain = 'Title'
				OR @query_domain = 'All')
			AND	(CR.Title LIKE '%' + @query + '%'))
		OR	((@query_domain = 'PracticeName'
				OR @query_domain = 'All')
			AND	(@practice_id = -1)
			AND	((P.Name LIKE '%' + @query + '%')
					OR (CR.PracticeID = -1 AND 'All' LIKE '%' + @query + '%')
					OR (CR.PracticeID = -2 AND 'Multiple' LIKE '%' + @query + '%')
				)
			)
		OR	((@query_domain = 'FileName'
				OR @query_domain = 'All')
			AND	(CR.FileName LIKE '%' + @query + '%')))
	AND (@practice_id = -1 OR CR.PracticeID  = @practice_id)
	AND CR.ResponseType < 30
	ORDER BY CR.FileReceiveDate DESC, CR.ResponseType
	-- ORDER BY SUBSTRING(CR.FileName,5,4), SUBSTRING(CR.FileName,3,2), SUBSTRING(CR.FileName,1,2)

	SET @totalRecords = @@ROWCOUNT
	
	IF @maxRecords = 0
		SET @maxRecords = @totalRecords

	--Get rid of the records we don't want
	DELETE #t_responses
	WHERE RID < @startRecord
		OR RID > (@startRecord + @maxRecords - 1)
		
	CREATE UNIQUE CLUSTERED INDEX #ux_t_responses_response_id
	ON #t_responses (ClearinghouseResponseID)
	WITH FILLFACTOR = 100

	UPDATE #t_responses
		SET PracticeName = '(All)' WHERE PracticeID = -1
	
	UPDATE #t_responses
		SET PracticeName = '(Multiple)' WHERE PracticeID = -2
	
	UPDATE #t_responses
		SET PracticeName = '(unknown)' WHERE PracticeName IS NULL
	
	SELECT *, 
		(CASE (ReviewedFlag)
				WHEN 1 THEN 'yes'
				ELSE 'no'
				END) AS ReviewedFlagString,
		(CASE (ProcessedFlag)
				WHEN 1 THEN 'yes'
				ELSE 'no'
				END) AS ProcessedFlagString
	FROM #t_responses T
	ORDER BY T.FileReceiveDate DESC, T.ResponseType
	
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	
	DROP TABLE #t_responses
	RETURN
END

GO
PRINT N'Altering [dbo].[ProcedureModifier]'
GO
ALTER TABLE [dbo].[ProcedureModifier] DROP
COLUMN [TIMESTAMP]
GO
ALTER TABLE [dbo].[ProcedureModifier] ADD
[CreatedDate] [datetime] NULL CONSTRAINT [DF_ProcedureModifier_CreatedDate] DEFAULT (getdate()),
[CreatedUserID] [int] NULL,
[ModifiedDate] [datetime] NULL CONSTRAINT [DF_ProcedureModifier_ModifiedDate] DEFAULT (getdate()),
[ModifiedUserID] [int] NULL,
[RecordTimeStamp] [timestamp] NULL,
[KareoProcedureModifierCode] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KareoLastModifiedDate] [datetime] NULL
GO
PRINT N'Creating [dbo].[Handheld_AppointmentDataProvider_GetAppointmentPatients]'
GO

--===========================================================================
-- GET APPOINTMENT PATIENTS
--===========================================================================
CREATE PROCEDURE dbo.Handheld_AppointmentDataProvider_GetAppointmentPatients
	@doctorId int,
	@startDate datetime,
	@endDate datetime
AS
BEGIN
	SELECT	P.PatientID,
		P.SSN,
		P.Prefix,
		P.FirstName,
		P.MiddleName,
		P.LastName,
		P.Suffix
	FROM	PATIENT P	
	WHERE EXISTS (
		SELECT	*
		FROM	APPOINTMENT A
		INNER JOIN AppointmentToResource ATR
		ON	ATR.AppointmentResourceTypeID = 1
		AND	ATR.ResourceID = @doctorID
		AND	ATR.AppointmentID = A.AppointmentID 
		WHERE	A.PatientID = P.PatientID
		AND	A.StartDate >= @startDate
		AND	A.EndDate <= @endDate)
END


GO
PRINT N'Altering [dbo].[InsurancePlanDataProvider_UpdateInsurancePlan]'
GO

--===========================================================================
-- UPDATE INSURANCE PLAN
--===========================================================================
ALTER PROCEDURE dbo.InsurancePlanDataProvider_UpdateInsurancePlan
	@plan_id INT,
	@name VARCHAR(64),
	@street_1 VARCHAR(64),
	@street_2 VARCHAR(64),
	@city VARCHAR(32),
	@state CHAR(2),
	@country VARCHAR(32),
	@zip VARCHAR(9),
	@contact_prefix VARCHAR(16),
	@contact_first_name VARCHAR(32),
	@contact_middle_name VARCHAR(32),
	@contact_last_name VARCHAR(32),
	@contact_suffix VARCHAR(16),
	@phone VARCHAR(10),
	@phone_x VARCHAR(10),
	@fax VARCHAR(10),
	@fax_x VARCHAR(10),
	@copay_flag BIT,
	@program_code CHAR(1) = 'O',
	@provider_number_type_id INT = NULL,
	@group_number_type_id INT = NULL,
	@local_use_provider_number_type_id INT = NULL,
	@hcfa_diag_code CHAR(1) = 'C',
	@hcfa_same_code CHAR(1) = 'D',
	@review_code CHAR(1) = '',
	@EClaimsAccepts BIT = 0,
	@ClearinghousePayerID INT = NULL,
	@notes TEXT,
	@practice_id INT = NULL,
	@eclaims_enrollment_status_id INT = NULL,
	@eclaims_disable BIT = NULL

AS
BEGIN
	UPDATE	
		InsuranceCompanyPlan
	SET	
		PlanName = @name,
		AddressLine1 = @street_1,
		AddressLine2 = @street_2,
		City = @city,
		State = @state,
		Country = @country,
		ZipCode = @zip,
		ContactPrefix = @contact_prefix,
		ContactFirstName = @contact_first_name,
		ContactMiddleName = @contact_middle_name,
		ContactLastName = @contact_last_name,
		ContactSuffix = @contact_suffix,
		Phone = @phone,
		PhoneExt = @phone_x,
		Fax = @fax,
		FaxExt = @fax_x,
		CoPay = @copay_flag,
		InsuranceProgramCode = @program_code,
		ProviderNumberTypeID = @provider_number_type_id,
		GroupNumberTypeID = @group_number_type_id,
		LocalUseProviderNumberTypeID = @local_use_provider_number_type_id,
		HCFADiagnosisReferenceFormatCode = @hcfa_diag_code,
		HCFASameAsInsuredFormatCode = @hcfa_same_code,
		ReviewCode = @review_code,
		EClaimsAccepts = @EClaimsAccepts,
		ClearinghousePayerID = @ClearinghousePayerID,
		Notes = @notes,
		ModifiedDate = GETDATE()
	WHERE	InsuranceCompanyPlanID = @plan_id

	DECLARE @EClaimsRequiresEnrollment BIT

	SELECT @EClaimsRequiresEnrollment = CPL.IsEnrollmentRequired
	FROM	dbo.InsuranceCompanyPlan IP
		LEFT OUTER JOIN dbo.ClearinghousePayersList CPL
		  ON IP.ClearinghousePayerID = CPL.ClearinghousePayerID
	WHERE IP.InsuranceCompanyPlanID = @plan_id

	-- list maintenance - for tracking EClaims enrollment status and disabling sending EClaims to this plan for a practice:
	IF @practice_id IS NOT NULL
	BEGIN
	    -- create, modify or delete listing that specifies non-default behavior of this plan for this practice:
	    DECLARE @tmp INT
	    SELECT @tmp = COUNT(*)
	    FROM
		PracticeToInsuranceCompanyPlan
	    WHERE InsuranceCompanyPlanID = @plan_id AND PracticeID = @practice_id
	    IF (@tmp = 0 AND ((@eclaims_enrollment_status_id IS NOT NULL AND @EClaimsRequiresEnrollment <> 0) OR @eclaims_disable <> 0))
	    BEGIN
		-- non-default behavior requested, record not present in the list yet:
		INSERT INTO 
			PracticeToInsuranceCompanyPlan (InsuranceCompanyPlanID, PracticeID, EClaimsEnrollmentStatusID, EClaimsDisable)
		VALUES (@plan_id, @practice_id, @eclaims_enrollment_status_id, @eclaims_disable)
	    END	
	    ELSE
	    BEGIN
		IF ((@eclaims_enrollment_status_id IS NULL OR @EClaimsRequiresEnrollment = 0) AND @eclaims_disable = 0)
		BEGIN
		    -- we are getting back to default behavior, delete the record:
		    DELETE	
			PracticeToInsuranceCompanyPlan
		    WHERE InsuranceCompanyPlanID = @plan_id AND PracticeID = @practice_id
		END
		ELSE
		BEGIN
		    -- changing record to some other non-default state:
		    UPDATE	
			PracticeToInsuranceCompanyPlan
		    SET
			EClaimsEnrollmentStatusID = @eclaims_enrollment_status_id,
			EClaimsDisable = @eclaims_disable
		    WHERE InsuranceCompanyPlanID = @plan_id AND PracticeID = @practice_id
		END
	    END
	END
END

GO
PRINT N'Altering [dbo].[BusinessRule_ClaimsAreReadyForEDI]'
GO

--===========================================================================
-- CLAIMS ARE READY FOR EDI
--===========================================================================
-- Indicates whether any claims exist in the proper State for preparing an
-- bill EDI batch.
--===========================================================================
ALTER FUNCTION dbo.BusinessRule_ClaimsAreReadyForEDI (@practice_id INT)
RETURNS BIT
AS
BEGIN
	--Look for claims that are 'Ready' and assigned to Insurance.	
	IF EXISTS (
		SELECT	*
		FROM	Claim C
			INNER JOIN ClaimPayer CP
				INNER JOIN PatientInsurance PI
				ON PI.PatientInsuranceID = CP.PatientInsuranceID
				INNER JOIN InsuranceCompanyPlan ICP
					LEFT OUTER JOIN ClearinghousePayersList CPL
					ON ICP.ClearinghousePayerID = CPL.ClearinghousePayerID
				ON ICP.InsuranceCompanyPlanID = PI.InsuranceCompanyPlanID
			ON CP.ClaimID = C.ClaimID
			AND CAST(CP.Precedence AS VARCHAR) = 
				C.AssignmentIndicator
		WHERE	C.PracticeID = @practice_id
		AND	C.ClaimStatusCode = 'R'
		AND	C.AssignmentIndicator IS NOT NULL
		AND	C.AssignmentIndicator <> 'P'
		AND	CPL.PayerNumber IS NOT NULL
	)
		RETURN 1
	
	RETURN 0
END


GO
PRINT N'Altering [dbo].[ReportDataProvider_ARAgingSummary]'
GO


ALTER PROCEDURE dbo.ReportDataProvider_ARAgingSummary
	@PracticeID int = NULL,
	@PayerTypeCode char(1) = 'I', --Can be I, P, O, or A for all
	@EndDate datetime = NULL
AS
BEGIN
	SET NOCOUNT ON
	--Select the type of payer for each section of the report

	DECLARE @PayerTypeText varchar(128)
	
	CREATE TABLE #ARAgingSummary (
		TypeGroup varchar(128),	
		TypeSort int, 
		Num int,
		TypeCode char(1), 
		Type varchar(128),	
		Name varchar(256),
		Phone varchar(10),
		LastBilled datetime,
		LastPaid datetime,
		Unapplied money default(0),
		CurrentBalance money default(0),
		Age31_60 money default(0),
		Age61_90 money default(0),
		Age91_120 money default(0),
		AgeOver120 money default(0),
		TotalBalance money default(0)
		)
	
	SET @EndDate = DATEADD(s, -1, DATEADD(d,1,dbo.fn_DateOnly(@EndDate)))
	
	--================================================================================ 
	--Let's get the Insurance assigned information
	--================================================================================ 
	IF @PayerTypeCode = 'I' or @PayerTypeCode = 'A'
	BEGIN
		SET @PayerTypeText = 'Insurance'
		
		SELECT TClaimsWithARBalance.AssignedToID, 
			COUNT(TLB.ClaimID) ClaimCount, 
			AVG(DATEDIFF(d, TInsuranceLastBilled.LastBilled, @EndDate)) AS ARAge, 
			SUM(TClaimsWithARBalance.Claim_ARBalance) AS ARBal,
			CASE 
				WHEN (DATEDIFF(d, TLB.ClaimLastBilled, @EndDate)) between 0 and 30 THEN 1
				WHEN (DATEDIFF(d, TLB.ClaimLastBilled, @EndDate)) between 31 and 60 THEN 2
				WHEN (DATEDIFF(d, TLB.ClaimLastBilled, @EndDate)) between 61 and 90 THEN 3
				WHEN (DATEDIFF(d, TLB.ClaimLastBilled, @EndDate)) between 91 and 120 THEN 4
				WHEN (DATEDIFF(d, TLB.ClaimLastBilled, @EndDate)) >= 121  THEN 5
			END AS AgeGroup,
			MAX(TInsuranceLastBilled.LastBilled) AS LastBilled,
			MAX(TInsuranceLastPaid.LastPaid) AS LastPaid
		INTO #TInsuranceBalances
		FROM
			(
				SELECT CT.ClaimID, MAX(CT.TransactionDate) AS ClaimLastBilled
				FROM dbo.ClaimTransaction CT
				WHERE CT.PracticeID = @PracticeID
					AND CT.TransactionDate <= @EndDate
					AND CT.ClaimTransactionTypeCode = 'BLL'
				GROUP BY CT.ClaimID
			) TLB 
			INNER JOIN
			(
				--We only want the claims whose most recent assignment was to insurance
				SELECT CT.AssignedToID, CT.ClaimID, CT.ClaimTransactionID, CT.Claim_ARBalance
				FROM dbo.ClaimTransaction CT
					INNER JOIN 
					(
						SELECT CT.ClaimID, MAX(CT.ClaimTransactionID) AS MaxTransID
						FROM dbo.ClaimTransaction CT
						WHERE CT.TransactionDate <= @EndDate
							AND CT.PracticeID = @PracticeID
						GROUP BY CT.ClaimID
					) AS T		
					ON CT.ClaimTransactionID = T.MaxTransID
				WHERE CT.TransactionDate <= @EndDate
					AND CT.PracticeID = @PracticeID
					AND CT.Claim_ARBalance > 0
					AND CT.AssignedToType = 'I'
			) TClaimsWithARBalance
			ON TLB.ClaimID = TClaimsWithARBalance.ClaimID
			--Get the last billed and last paid dates
			LEFT OUTER JOIN
			(
				SELECT CT.AssignedToID, MAX(CT.TransactionDate) AS LastBilled
				FROM dbo.ClaimTransaction CT
				WHERE CT.PracticeID = @PracticeID
					AND CT.TransactionDate <= @EndDate
					AND CT.ClaimTransactionTypeCode = 'BLL'
					AND CT.AssignedToType = 'I'
				GROUP BY CT.AssignedToID
			) TInsuranceLastBilled
			ON TClaimsWithARBalance.AssignedToID = TInsuranceLastBilled.AssignedToID
			LEFT OUTER JOIN
			(
				SELECT CT.AssignedToID, MAX(CT.TransactionDate) AS LastPaid
				FROM dbo.ClaimTransaction CT
				WHERE CT.PracticeID = @PracticeID
					AND CT.TransactionDate <= @EndDate
					AND CT.ClaimTransactionTypeCode = 'PAY'
					AND CT.AssignedToType = 'I'
				GROUP BY CT.AssignedToID
			) TInsuranceLastPaid
			ON TClaimsWithARBalance.AssignedToID = TInsuranceLastPaid.AssignedToID
		--WHERE C.PracticeID = @PracticeID
		GROUP BY TClaimsWithARBalance.AssignedToID,
			CASE 
				WHEN (DATEDIFF(d, TLB.ClaimLastBilled, @EndDate)) between 0 and 30 THEN 1
				WHEN (DATEDIFF(d, TLB.ClaimLastBilled, @EndDate)) between 31 and 60 THEN 2
				WHEN (DATEDIFF(d, TLB.ClaimLastBilled, @EndDate)) between 61 and 90 THEN 3
				WHEN (DATEDIFF(d, TLB.ClaimLastBilled, @EndDate)) between 91 and 120 THEN 4
				WHEN (DATEDIFF(d, TLB.ClaimLastBilled, @EndDate)) >= 121  THEN 5
			END
	
	
		INSERT #ARAgingSummary(
			TypeGroup,	
			TypeSort, 
			Num,
			TypeCode, 
			Type,	
			Name,
			Phone,
			LastBilled,
			LastPaid
		)
		SELECT distinct @PayerTypeText,
			1,
			TIB.AssignedToID,
			'I', 
			@PayerTypeText,
			ICP.PlanName AS Name,	
			ICP.Phone AS Phone,	
			LastBilled,
			LastPaid
		FROM #TInsuranceBalances TIB
			INNER JOIN dbo.InsuranceCompanyPlan ICP
			ON TIB.AssignedToID = ICP.InsuranceCompanyPlanID
	
	
		--Update the balances
		UPDATE ARAS
			SET CurrentBalance = TIB.ARBal
		FROM #ARAgingSummary ARAS
			INNER JOIN #TInsuranceBalances TIB
			ON ARAS.Num = TIB.AssignedToID
		WHERE AgeGroup = 1
			AND ARAS.Type = @PayerTypeText
			
		UPDATE ARAS
			SET Age31_60 = TIB.ARBal
		FROM #ARAgingSummary ARAS
			INNER JOIN #TInsuranceBalances TIB
			ON ARAS.Num = TIB.AssignedToID
		WHERE AgeGroup = 2
			AND ARAS.Type = @PayerTypeText
			
		UPDATE ARAS
			SET Age61_90 = TIB.ARBal
		FROM #ARAgingSummary ARAS
			INNER JOIN #TInsuranceBalances TIB
			ON ARAS.Num = TIB.AssignedToID
		WHERE AgeGroup = 3
			AND ARAS.Type = @PayerTypeText
			
		UPDATE ARAS
			SET Age91_120 = TIB.ARBal
		FROM #ARAgingSummary ARAS
			INNER JOIN #TInsuranceBalances TIB
			ON ARAS.Num = TIB.AssignedToID
		WHERE AgeGroup = 4
			AND ARAS.Type = @PayerTypeText
	
		UPDATE ARAS
			SET AgeOver120 = TIB.ARBal
		FROM #ARAgingSummary ARAS
			INNER JOIN #TInsuranceBalances TIB
			ON ARAS.Num = TIB.AssignedToID
		WHERE AgeGroup = 5
			AND ARAS.Type = @PayerTypeText
			
			
		--Unapplied Amount
		UPDATE ARAS
			SET Unapplied = TPMT.PaymentAmount
		FROM #ARAgingSummary ARAS
			INNER JOIN 
			(SELECT PMT.PayerID, SUM(PMT.PaymentAmount) AS PaymentAmount
			FROM [dbo].[Payment] PMT
			WHERE PMT.PaymentDate <= @EndDate
				AND PMT.PracticeID = @PracticeID
				AND PMT.PayerTypeCode = 'I'
			GROUP BY PMT.PayerID) AS TPMT
			ON ARAS.Num = TPMT.PayerID
		WHERE ARAS.Type = @PayerTypeText
			
		UPDATE ARAS
			SET Unapplied = ISNULL(Unapplied,0) - ISNULL(TAPP.AppliedAmount,0)
		FROM #ARAgingSummary ARAS
			INNER JOIN 
			(	SELECT PMT.PayerID, SUM(CT.Amount) AS AppliedAmount
				FROM [dbo].[Payment] PMT
					INNER JOIN [dbo].[PaymentClaimTransaction] PCT
					ON PMT.PaymentID = PCT.PaymentID
					INNER JOIN dbo.ClaimTransaction CT
					ON PCT.ClaimTransactionID = CT.ClaimTransactionID
				WHERE PMT.PaymentDate <= @EndDate
					AND PMT.PracticeID = @PracticeID
					AND PMT.PayerTypeCode = 'I'
					AND CT.PracticeID = @PracticeID
					AND CT.ClaimTransactionTypeCode = 'PAY'
					AND CT.TransactionDate <= @EndDate
				GROUP BY PMT.PayerID) AS TAPP
			ON ARAS.Num = TAPP.PayerID
		WHERE ARAS.Type = @PayerTypeText
				
		UPDATE ARAS
			SET Unapplied = ISNULL(Unapplied,0) - ISNULL(TRFD.RefundAmount,0)
		FROM #ARAgingSummary ARAS
			INNER JOIN 
			(	SELECT RecipientID, SUM(RefundAmount) AS RefundAmount
				FROM [dbo].[Refund]	RFD
				WHERE RFD.RecipientTypeCode = 'I'
					AND RFD.RefundDate <= @EndDate
					AND RFD.PracticeID = @PracticeID
				GROUP BY RecipientID) AS TRFD
			ON ARAS.Num = TRFD.RecipientID
		WHERE ARAS.Type = @PayerTypeText
				
	END

	--================================================================================ 
	--Let's get the patient assigned information
	--================================================================================ 
	IF @PayerTypeCode = 'P' or @PayerTypeCode = 'A'
	BEGIN
		SET @PayerTypeText = 'Patient'
		
		SELECT C.PatientID, 
			COUNT(TLB.ClaimID) ClaimCount, 
			AVG(DATEDIFF(d, TPatientLastBilled.LastBilled, @EndDate)) AS ARAge, 
			SUM(TClaimsWithARBalance.Claim_ARBalance) AS ARBal,
			CASE 
				WHEN (DATEDIFF(d, TLB.ClaimLastBilled, @EndDate)) between 0 and 30 THEN 1
				WHEN (DATEDIFF(d, TLB.ClaimLastBilled, @EndDate)) between 31 and 60 THEN 2
				WHEN (DATEDIFF(d, TLB.ClaimLastBilled, @EndDate)) between 61 and 90 THEN 3
				WHEN (DATEDIFF(d, TLB.ClaimLastBilled, @EndDate)) between 91 and 120 THEN 4
				WHEN (DATEDIFF(d, TLB.ClaimLastBilled, @EndDate)) >= 121  THEN 5
			END AS AgeGroup,
			MAX(TPatientLastBilled.LastBilled) AS LastBilled,
			MAX(TPatientLastPaid.LastPaid) AS LastPaid
		INTO #TPatientBalances
		FROM
			(
				SELECT CT.ClaimID, MAX(CT.TransactionDate) AS ClaimLastBilled
				FROM dbo.ClaimTransaction CT
				WHERE CT.PracticeID = @PracticeID
					AND CT.TransactionDate <= @EndDate
					AND CT.ClaimTransactionTypeCode = 'BLL'
				GROUP BY CT.ClaimID
			) TLB 
			INNER JOIN
			(
				SELECT CT.ClaimID, CT.ClaimTransactionID, CT.Claim_ARBalance
				FROM dbo.ClaimTransaction CT
					INNER JOIN 
					(
						SELECT CT.ClaimID, MAX(CT.ClaimTransactionID) AS MaxTransID
						FROM dbo.ClaimTransaction CT
						WHERE CT.TransactionDate <= @EndDate
							AND CT.PracticeID = @PracticeID
						GROUP BY CT.ClaimID
					) AS T		
					ON CT.ClaimTransactionID = T.MaxTransID
				WHERE CT.TransactionDate <= @EndDate
					AND CT.PracticeID = @PracticeID
					AND CT.Claim_ARBalance > 0
			) TClaimsWithARBalance
			ON TLB.ClaimID = TClaimsWithARBalance.ClaimID
			INNER JOIN dbo.Claim C
			ON TLB.ClaimID = C.ClaimID
			--Get the last billed and last paid amounts
			LEFT OUTER JOIN
			(
				SELECT CT.PatientID, MAX(CT.TransactionDate) AS LastBilled
				FROM dbo.ClaimTransaction CT
				WHERE CT.PracticeID = @PracticeID
					AND CT.TransactionDate <= @EndDate
					AND CT.ClaimTransactionTypeCode = 'BLL'
				GROUP BY CT.PatientID
			) TPatientLastBilled
			ON C.PatientID = TPatientLastBilled.PatientID
			LEFT OUTER JOIN
			(
				SELECT CT.PatientID, MAX(CT.TransactionDate) AS LastPaid
				FROM dbo.ClaimTransaction CT
				WHERE CT.PracticeID = @PracticeID
					AND CT.TransactionDate <= @EndDate
					AND CT.ClaimTransactionTypeCode = 'PAY'
				GROUP BY CT.PatientID
			) TPatientLastPaid
			ON C.PatientID = TPatientLastPaid.PatientID
	
		WHERE C.PracticeID = @PracticeID
			AND C.AssignmentIndicator = 'P'
		GROUP BY C.PatientID,
			CASE 
				WHEN (DATEDIFF(d, TLB.ClaimLastBilled, @EndDate)) between 0 and 30 THEN 1
				WHEN (DATEDIFF(d, TLB.ClaimLastBilled, @EndDate)) between 31 and 60 THEN 2
				WHEN (DATEDIFF(d, TLB.ClaimLastBilled, @EndDate)) between 61 and 90 THEN 3
				WHEN (DATEDIFF(d, TLB.ClaimLastBilled, @EndDate)) between 91 and 120 THEN 4
				WHEN (DATEDIFF(d, TLB.ClaimLastBilled, @EndDate)) >= 121  THEN 5
			END
	
	
		INSERT #ARAgingSummary(
			TypeGroup,	
			TypeSort, 
			Num,
			TypeCode, 
			Type,	
			Name,
			Phone,
			LastBilled,
			LastPaid
		)
		SELECT distinct @PayerTypeText,
			2,
			TPB.PatientID,
			'P', 
			@PayerTypeText,
			RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')) AS Name,	
			P.HomePhone AS Phone,	
			LastBilled,
			LastPaid
		FROM #TPatientBalances TPB
			INNER JOIN dbo.Patient P
			ON TPB.PatientID = P.PatientID
	
	
		--Update the balances
		UPDATE ARAS
			SET CurrentBalance = TPB.ARBal
		FROM #ARAgingSummary ARAS
			INNER JOIN #TPatientBalances TPB
			ON ARAS.Num = TPB.PatientID
		WHERE AgeGroup = 1
			AND ARAS.Type = @PayerTypeText
			
		UPDATE ARAS
			SET Age31_60 = TPB.ARBal
		FROM #ARAgingSummary ARAS
			INNER JOIN #TPatientBalances TPB
			ON ARAS.Num = TPB.PatientID
		WHERE AgeGroup = 2
			AND ARAS.Type = @PayerTypeText
			
		UPDATE ARAS
			SET Age61_90 = TPB.ARBal
		FROM #ARAgingSummary ARAS
			INNER JOIN #TPatientBalances TPB
			ON ARAS.Num = TPB.PatientID
		WHERE AgeGroup = 3
			AND ARAS.Type = @PayerTypeText
			
		UPDATE ARAS
			SET Age91_120 = TPB.ARBal
		FROM #ARAgingSummary ARAS
			INNER JOIN #TPatientBalances TPB
			ON ARAS.Num = TPB.PatientID
		WHERE AgeGroup = 4
			AND ARAS.Type = @PayerTypeText
	
		UPDATE ARAS
			SET AgeOver120 = TPB.ARBal
		FROM #ARAgingSummary ARAS
			INNER JOIN #TPatientBalances TPB
			ON ARAS.Num = TPB.PatientID
		WHERE AgeGroup = 5
			AND ARAS.Type = @PayerTypeText
			
			
		--Unapplied Amount
		UPDATE ARAS
			SET Unapplied = TPMT.PaymentAmount
		FROM #ARAgingSummary ARAS
			INNER JOIN 
			(SELECT PMT.PayerID, SUM(PMT.PaymentAmount) AS PaymentAmount
			FROM [dbo].[Payment] PMT
			WHERE PMT.PaymentDate <= @EndDate
				AND PMT.PracticeID = @PracticeID
				AND PMT.PayerTypeCode = 'P'
			GROUP BY PMT.PayerID) AS TPMT
			ON ARAS.Num = TPMT.PayerID
		WHERE ARAS.Type = @PayerTypeText
			
		UPDATE ARAS
			SET Unapplied = ISNULL(Unapplied,0) - ISNULL(TAPP.AppliedAmount,0)
		FROM #ARAgingSummary ARAS
			INNER JOIN 
			(	SELECT PMT.PayerID, SUM(CT.Amount) AS AppliedAmount
				FROM [dbo].[Payment] PMT
					INNER JOIN [dbo].[PaymentClaimTransaction] PCT
					ON PMT.PaymentID = PCT.PaymentID
					INNER JOIN dbo.ClaimTransaction CT
					ON PCT.ClaimTransactionID = CT.ClaimTransactionID
				WHERE PMT.PaymentDate <= @EndDate
					AND PMT.PracticeID = @PracticeID
					AND PMT.PayerTypeCode = 'P'
					AND CT.PracticeID = @PracticeID
					AND CT.CreatedDate <= @EndDate
					AND CT.ClaimTransactionTypeCode = 'PAY'
				GROUP BY PMT.PayerID) AS TAPP
			ON ARAS.Num = TAPP.PayerID
		WHERE ARAS.Type = @PayerTypeText
					
		UPDATE ARAS
			SET Unapplied = ISNULL(Unapplied,0) - ISNULL(TRFD.RefundAmount,0)
		FROM #ARAgingSummary ARAS
			INNER JOIN 
			(	SELECT RecipientID, SUM(RefundAmount) AS RefundAmount
				FROM [dbo].[Refund]	RFD
				WHERE RFD.RecipientTypeCode = 'P'
					AND RFD.RefundDate <= @EndDate
					AND RFD.PracticeID = @PracticeID
				GROUP BY RecipientID) AS TRFD
			ON ARAS.Num = TRFD.RecipientID
		WHERE ARAS.Type = @PayerTypeText
			
	END		

	--================================================================================ 
	--Let's get the Other payer information
	--================================================================================ 
	IF @PayerTypeCode = 'O' or @PayerTypeCode = 'A'
	BEGIN
		SET @PayerTypeText = 'Other'
				
		INSERT #ARAgingSummary(
			TypeGroup,	
			TypeSort, 
			Num,
			TypeCode, 
			Type,	
			Name,
			Unapplied
		)
		SELECT distinct @PayerTypeText,
			3,
			PMT.PayerID,
			'A', 
			@PayerTypeText,
			O.OtherName AS Name,	
			SUM(PMT.PaymentAmount)
		FROM dbo.Payment PMT 
			INNER JOIN dbo.Other O
			ON PMT.PayerID = O.OtherID
				AND PMT.PayerTypeCode = 'O'
		WHERE PMT.PracticeID = @PracticeID
			AND PMT.PaymentDate <= @EndDate
		GROUP BY PMT.PayerID, O.OtherName
			
		--Unapplied Amount
		UPDATE ARAS
			SET Unapplied = ISNULL(Unapplied,0) - ISNULL(TAPP.AppliedAmount,0),
				LastPaid = TAPP.LastPaid
		FROM #ARAgingSummary ARAS
			INNER JOIN 
			(	SELECT PMT.PayerID, SUM(CT.Amount) AS AppliedAmount, MAX(CT.CreatedDate) AS LastPaid
				FROM [dbo].[Payment] PMT
					INNER JOIN [dbo].[PaymentClaimTransaction] PCT
					ON PMT.PaymentID = PCT.PaymentID
					INNER JOIN dbo.ClaimTransaction CT
					ON PCT.ClaimTransactionID = CT.ClaimTransactionID
				WHERE PMT.PaymentDate <= @EndDate
					AND PMT.PracticeID = @PracticeID
					AND PMT.PayerTypeCode = 'O'
					AND CT.PracticeID = @PracticeID
					AND CT.CreatedDate <= @EndDate
					AND CT.ClaimTransactionTypeCode = 'PAY'
				GROUP BY PMT.PayerID) AS TAPP
			ON ARAS.Num = TAPP.PayerID
		WHERE ARAS.Type = @PayerTypeText
					
		UPDATE ARAS
			SET Unapplied = ISNULL(Unapplied,0) - ISNULL(TRFD.RefundAmount,0)
		FROM #ARAgingSummary ARAS
			INNER JOIN 
			(	SELECT RecipientID, SUM(RefundAmount) AS RefundAmount
				FROM [dbo].[Refund]	RFD
				WHERE RFD.RecipientTypeCode = 'O'
					AND RFD.RefundDate <= @EndDate
					AND RFD.PracticeID = @PracticeID
				GROUP BY RecipientID) AS TRFD
			ON ARAS.Num = TRFD.RecipientID
		WHERE ARAS.Type = @PayerTypeText
			
	END		
	
	UPDATE #ARAgingSummary
		SET TotalBalance = CurrentBalance + Age31_60 + Age61_90 + Age91_120 + AgeOver120

	SELECT 	* FROM #ARAgingSummary

	DROP TABLE #ARAgingSummary
		
	RETURN
	
END


GO
PRINT N'Altering [dbo].[Handheld_ProcedureDataProvider_GetProcedureCodes]'
GO

--===========================================================================
-- GET PROCEDURE CodeS
--===========================================================================
ALTER PROCEDURE dbo.Handheld_ProcedureDataProvider_GetProcedureCodes
	@practice_id INT,
	@sync_date DATETIME
AS
BEGIN
	IF EXISTS (
		SELECT	*
		FROM	PROCEDURECODEDICTIONARY PCD
			INNER JOIN PROCEDURECATEGORYTOPROCEDURECODEDICTIONARY PTC
			ON PTC.ProcedureCodeDictionaryID = PCD.ProcedureCodeDictionaryID
			INNER JOIN PROCEDURECATEGORY PC
			ON PC.ProcedureCategoryID = PTC.ProcedureCategoryID
			INNER JOIN CodingTemplate CT
			ON CT.CodingTemplateID = PC.CodingTemplateID
		WHERE	CT.PracticeID = @practice_id
		AND	(PCD.ModifiedDate > @sync_date
			OR PCD.CreatedDate > @sync_date
			OR PTC.ModifiedDate > @sync_date
			OR PTC.CreatedDate > @sync_date
			OR PC.ModifiedDate > @sync_date
			OR PC.CreatedDate > @sync_date
			OR CT.ModifiedDate > @sync_date
			OR CT.CreatedDate > @sync_date))
	BEGIN
		SELECT	DISTINCT PCD.ProcedureCodeDictionaryID,
			PCD.ProcedureCode,
			PCD.ProcedureName,
			PCD.Description
		FROM	PROCEDURECODEDICTIONARY PCD
			INNER JOIN PROCEDURECATEGORYTOPROCEDURECODEDICTIONARY PTC
			ON PTC.ProcedureCodeDictionaryID = PCD.ProcedureCodeDictionaryID
			INNER JOIN PROCEDURECATEGORY PC
			ON PC.ProcedureCategoryID = PTC.ProcedureCategoryID
			INNER JOIN CodingTemplate CT
			ON CT.CodingTemplateID = PC.CodingTemplateID
		WHERE	CT.PracticeID = @practice_id
	END
END


GO
PRINT N'Altering [dbo].[PracticeDataProvider_GetPractices]'
GO

--===========================================================================
-- GET PRACTICES
--===========================================================================
ALTER PROCEDURE dbo.PracticeDataProvider_GetPractices
	@userName VARCHAR(64)
AS
BEGIN
/*
	--Check if user is an administrator.
	IF EXISTS (
		SELECT	P.Name
		FROM	USERS U
			INNER JOIN USERGROUPS UG
			ON UG.UserID = U.UserID
			INNER JOIN GROUPPERMISSIONS GP
			ON GP.GroupID = UG.GroupID
			INNER JOIN PERMISSIONS P
			ON P.PermissionID = GP.PermissionID
		WHERE	(U.NtlmName = 'PMR\' + @userName OR U.EmailAddress = @userName)
		AND	P.Name = 'Admin'
	)
		SELECT	PR.PracticeID,
			PR.Name,
			COALESCE(PR.City + ', ','') + COALESCE(S.LongName,'') AS Location,
			(	SELECT	COUNT(PatientID)
				FROM	PATIENT PA
				WHERE	PA.PracticeID = PR.PracticeID
			) AS PATIENTCOUNT,
			(	SELECT	COUNT(*)
				FROM	DOCTOR D
				WHERE	D.PracticeID = PR.PracticeID
			) AS DOCTORCOUNT,
			(	SELECT	COUNT(*)
				FROM	CLAIM C
				WHERE	PracticeID = PR.PracticeID
				AND	ClaimStatusCode = 'R'
				AND 	AssignmentIndicator IS NOT NULL
				AND 	AssignmentIndicator IN ('1','2','3','4','5','6','7','8','9')
			) AS READYCLAIMCOUNT,
			0 AS UNAPPLIEDPAYMENTCOUNT,
			(
				SELECT	COUNT(*)
				FROM	ENCOUNTER E
				WHERE	E.PracticeID = PR.PracticeID
				AND	E.EncounterStatusID = 2
			) AS UNREVIEWEDENCOUNTERCOUNT,
			(
				SELECT	COUNT(*)
				FROM	dbo.ClearinghouseResponse CHR
				WHERE	CHR.ReviewedFlag = 0 
				AND 	(CHR.PracticeID = PR.PracticeID OR CHR.PracticeID = -1)
			) AS UNREVIEWEDERACOUNT
		FROM	dbo.Practice PR
			LEFT OUTER JOIN dbo.State S 
			ON PR.State = S.State
		ORDER BY
			PR.Name
	ELSE
*/
		SELECT	PR.PracticeID,
			PR.Name,
			COALESCE(PR.City + ', ','') + COALESCE(S.LongName,'') AS Location,
			(	
				SELECT	COUNT(PatientID)
				FROM	PATIENT PA
				WHERE	PA.PracticeID = PR.PracticeID
			) AS PATIENTCOUNT,
			(	
				SELECT	COUNT(*)
				FROM	DOCTOR D
				WHERE	D.PracticeID = PR.PracticeID
			) AS DOCTORCOUNT,
			(	
				SELECT	COUNT(*)
				FROM	CLAIM C
				WHERE	C.PracticeID = PR.PracticeID
				AND	ClaimStatusCode = 'R'
				AND 	AssignmentIndicator IS NOT NULL
				AND 	AssignmentIndicator IN ('1','2','3','4','5','6','7','8','9')
			) AS READYCLAIMCOUNT,
			ISNULL(T2.UnappliedPaymentCount,0) AS UNAPPLIEDPAYMENTCOUNT
			,
			(
				SELECT	COUNT(*)
				FROM	ENCOUNTER E
				WHERE	E.PracticeID = PR.PracticeID
				AND	E.EncounterStatusID = 2
			) AS UNREVIEWEDENCOUNTERCOUNT,
			(
				SELECT	COUNT(*)
				FROM	dbo.ClearinghouseResponse CHR
				WHERE	CHR.ReviewedFlag = 0 
				AND 	(CHR.PracticeID = PR.PracticeID) AND (PR.EClaimsEnrollmentStatusID > 1)
			) AS UNREVIEWEDERACOUNT
		FROM	superbill_shared.dbo.Users U
			INNER JOIN dbo.UserPractices UP
			ON UP.UserID = U.UserID
			INNER JOIN dbo.Practice PR
			ON PR.PracticeID = UP.PracticeID
			LEFT OUTER JOIN State S 
			ON PR.State = S.State
			LEFT OUTER JOIN
			(
				SELECT T.PracticeID, COUNT(T.PaymentID) AS UnappliedPaymentCount
				FROM
					(
					SELECT PMT.PracticeID
						, PMT.PaymentID
					FROM [dbo].[Payment] PMT
						LEFT OUTER JOIN dbo.PaymentClaimTransaction PCT
						ON PMT.PaymentID = PCT.PaymentID
						LEFT OUTER JOIN dbo.ClaimTransaction CT
						ON PCT.ClaimTransactionID = CT.ClaimTransactionID
					GROUP BY PMT.PracticeID, PMT.PaymentID
					HAVING  MAX(ISNULL(PMT.PaymentAmount,0)) - SUM(ISNULL(CT.Amount,0)) > 0
					) T
				GROUP BY T.PracticeID
			) T2
			ON PR.PracticeID = T2.PracticeID
		WHERE	U.EmailAddress = @userName
		ORDER BY
			PR.Name
	
END

GO
PRINT N'Altering [dbo].[DiagnosisDataProvider_GetDiagnosis]'
GO

--===========================================================================
-- GET DIAGNOSIS
--===========================================================================
ALTER PROCEDURE dbo.DiagnosisDataProvider_GetDiagnosis
	@diagnosis_id INT
AS
BEGIN
	SELECT	DiagnosisCodeDictionaryID,
		DiagnosisCode,
		DiagnosisName,
		Description,
		KareoDiagnosisCodeDictionaryID
--		CAST(dbo.BusinessRule_DiagnosisIsDeletable(DiagnosisCodeDictionaryID) AS BIT) AS Deletable
	FROM	dbo.DiagnosisCodeDictionary
	WHERE	DiagnosisCodeDictionaryID = @diagnosis_id
END

GO
PRINT N'Altering [dbo].[DashboardDataProvider_GetToDoDataForBusinessManagerDisplay]'
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER PROCEDURE dbo.DashboardDataProvider_GetToDoDataForBusinessManagerDisplay
	@PracticeID int = 34
AS
BEGIN
	DECLARE @flat TABLE (
		[PracticeID] [int] NULL ,
		NeedContactInfo bit default(0),
		NeedProviders bit default(0),
		NeedServiceLocations bit default(0),
		NeedProviderNumbers bit default(0),
		NeedGroupNumber bit default(0),
		NeedCodingForm bit default(0),
		NeedElectronicClaimConfigure bit default(0),
		NeedPatientStatmentConfigure bit default(0),
		CountReviewEncounters int default(0),
		CountClaimsToSend int default(0),
		CountClearingHouseReportsToReview int default(0),
		CountPaymentsToApply int default(0),
		CountPatientStatementsToSend int default(0),
		NeedReviewReports bit default(1)
	)
	
	INSERT @flat (PracticeID, CountPaymentsToApply)
	VALUES(@PracticeID, 0)

	--Contact Info
	IF EXISTS(
				SELECT *
				FROM dbo.Practice P
				WHERE P.PracticeID = @PracticeID
					AND (
						isnull(LEN(P.AddressLine1), 0) = 0
						OR isnull(LEN(P.City), 0) = 0
						OR isnull(LEN(P.State), 0) = 0
						OR isnull(LEN(P.ZipCode), 0) = 0
						OR isnull(LEN(P.Phone), 0) < 10
						OR isnull(LEN(P.Fax), 0) < 10
						OR isnull(LEN(P.EIN), 0) < 9
					)
				)
	BEGIN
		UPDATE @flat
			SET NeedContactInfo = 1
	END
	
	--Providers
	IF NOT EXISTS(
				SELECT *
				FROM dbo.Doctor D
				WHERE D.PracticeID = @PracticeID
				)
	BEGIN
		UPDATE @flat
			SET NeedProviders = 1
	END	
	
	--NeedServiceLocations
	IF NOT EXISTS(
				SELECT *
				FROM dbo.ServiceLocation SL
				WHERE SL.PracticeID = @PracticeID
				)
	BEGIN
		UPDATE @flat
			SET NeedServiceLocations = 1
	END	

	--NeedProviderNumbers
	IF EXISTS(
				SELECT *
				FROM dbo.Doctor D
				WHERE D.PracticeID = @PracticeID
					AND NOT EXISTS (SELECT *
									FROM dbo.ProviderNumber PN
									WHERE PN.DoctorID = D.DoctorID)
				)
	BEGIN
		UPDATE @flat
			SET NeedProviderNumbers = 1
	END	

	--NeedGroupNumber
	IF NOT EXISTS(
				SELECT *
				FROM dbo.PracticeInsuranceGroupNumber PIGN
				WHERE PIGN.PracticeID = @PracticeID
				)
	BEGIN
		UPDATE @flat
			SET NeedGroupNumber = 1
	END	

	--NeedCodingForm 
	IF NOT EXISTS(
				SELECT *
				FROM dbo.CodingTemplate CTMP
				WHERE CTMP.PracticeID = @PracticeID
				)
	BEGIN
		UPDATE @flat
			SET NeedCodingForm = 1
	END

	--NeedElectronicClaimConfigure 
	IF EXISTS(
				SELECT *
				FROM dbo.Practice P
				WHERE P.PracticeID = @PracticeID
					AND ISNULL(P.EClaimsEnrollmentStatusID,0) =0
				)
	BEGIN
		UPDATE @flat
			SET NeedElectronicClaimConfigure = 1
	END

	--NeedPatientStatmentConfigure 
	IF EXISTS(
				SELECT *
				FROM dbo.Practice P
				WHERE P.PracticeID = @PracticeID
					AND ISNULL(P.EnrolledForEStatements,0) =0
				)
	BEGIN
		UPDATE @flat
			SET NeedPatientStatmentConfigure = 1
	END

	UPDATE @flat
		SET CountReviewEncounters = (SELECT COUNT(*)
									FROM dbo.Encounter E
									WHERE E.PracticeID = @PracticeID
										AND E.EncounterStatusID = 2
									)
									
	UPDATE @flat
		SET CountClaimsToSend = (SELECT COUNT(*)
									FROM dbo.Claim C
									WHERE PracticeID = @PracticeID
									AND ClaimStatusCode = 'R'
									AND AssignmentIndicator IS NOT NULL
									AND AssignmentIndicator IN ('1','2','3','4','5','6','7','8','9')
									)

	DECLARE @EClaimsEnrollmentStatus INT
	SELECT @EClaimsEnrollmentStatus = EClaimsEnrollmentStatusID FROM Practice WHERE PracticeID = @PracticeID

	IF ( @EClaimsEnrollmentStatus > 1)
	BEGIN
		UPDATE @flat
		    SET CountClearingHouseReportsToReview = (SELECT COUNT(*)
									FROM dbo.ClearinghouseResponse CR
									WHERE CR.ReviewedFlag = 0
									AND CR.PracticeID = @PracticeID AND CR.ResponseType < 30
								)
	END

	UPDATE @flat
		SET CountPatientStatementsToSend = 	(
								SELECT COUNT(DISTINCT PatientID) 
								FROM Claim 
								WHERE 
									ClaimStatusCode <> 'C' 
									AND AssignmentIndicator = 'P'
									AND PracticeID = @PracticeID
							)
		/*
							(SELECT COUNT(DISTINCT C.PatientID) 
											FROM dbo.Claim C
											WHERE C.PracticeID = @PracticeID
												AND C.ClaimStatusCode IN ('P', 'R')
												AND C.ClaimID NOT IN (	SELECT ClaimID 
																		FROM dbo.ClaimTransaction CT 
																		WHERE CT.ClaimTransactionTypeCode = 'XXX' 
																			AND CT.PracticeID = @PracticeID
																	)
												AND C.PatientID NOT IN (		
																		SELECT BS.PatientID 
																		FROM dbo.Bill_Statement BS
																			INNER JOIN dbo.BillBatch BB
																			ON BS.BillBatchID = BB.BillBatchID
																		WHERE BB.ConfirmedDate BETWEEN DATEADD(d,-45,GETDATE()) AND GETDATE()
																			AND BB.PracticeID = @PracticeID
																			AND BB.BillBatchTypeCode = 'S' 
																	)
												)
		*/
		
	--Get the data		
	SELECT *
	FROM @flat
	
	RETURN
END


GO
PRINT N'Altering [dbo].[BusinessRule_ProcedureModifierIsDuplicate]'
GO
SET QUOTED_IDENTIFIER ON
GO

--===========================================================================
-- PROCEDURE MODIFIER IS DUPLICATE
--===========================================================================
ALTER FUNCTION dbo.BusinessRule_ProcedureModifierIsDuplicate (@code varchar(16))
RETURNS BIT
AS
BEGIN
	IF EXISTS (
		SELECT	*
		FROM	ProcedureModifier
		WHERE	ProcedureModifierCode = @code
	)
		RETURN 1
	
	RETURN 0
END


GO
PRINT N'Altering [dbo].[AuthenticationDataProvider_GetUserPractices]'
GO

--===========================================================================
-- GET USER PRACTICES
--===========================================================================
ALTER PROCEDURE dbo.AuthenticationDataProvider_GetUserPractices
	@UserID int
AS
BEGIN
	SELECT	@UserID AS UserID,
		PracticeID,
		Name
	FROM	PRACTICE P
	WHERE	PracticeID IN (
			SELECT	PracticeID
			FROM	dbo.UserPractices
			WHERE	UserID = @UserID)
	ORDER BY
		Name
END


GO
PRINT N'Altering [dbo].[ReportDataProvider_GetReportMenuStructureXML]'
GO

ALTER PROCEDURE dbo.ReportDataProvider_GetReportMenuStructureXML
AS
BEGIN

	-- returns <MenuStructure><ReportCategory ID="1"><Report ID="1" /><Report ID="2" /></ReportCategory></MenuStructure>

	SELECT
		1 AS Tag, 
		NULL AS Parent,
		NULL AS [MenuStructure!1!ID],
		NULL AS [ReportCategory!2!ID],
		NULL AS [ReportCategory!2!DisplayOrder],
		NULL AS [Report!3!ID], 
		NULL AS [Report!3!DisplayOrder],
		NULL AS [Report!3!PermissionValue]

	UNION ALL

	SELECT
		2 AS Tag, 
		1 AS Parent,
		NULL AS [MenuStructure!1!ID],
		ReportCategoryID AS [ReportCategory!2!ID],
		DisplayOrder AS [ReportCategory!2!DisplayOrder], 
		NULL AS [Report!3!ID], 
		NULL AS [Report!3!DisplayOrder], 
		NULL AS [Report!3!PermissionValue]

	FROM
		ReportCategory

	UNION ALL

	SELECT
		3 AS Tag,
		2 AS Parent,
		NULL AS [MenuStructure!1!ID],
		NULL AS [ReportCategory!2!DisplayOrder], 
		R.ReportCategoryID AS [ReportCategory!2!ID],
		R.ReportID AS [Report!3!ID],
		R.DisplayOrder AS [Report!3!DisplayOrder], 
		R.PermissionValue AS [Report!3!PermissionValue]
	FROM
		Report R
		INNER JOIN ReportCategory RC ON RC.ReportCategoryID = R.ReportCategoryID
	ORDER BY
		[MenuStructure!1!ID],
		[ReportCategory!2!DisplayOrder],
		[Report!3!DisplayOrder]
	FOR XML EXPLICIT









END


GO
PRINT N'Creating [dbo].[BusinessRule_ProcedureModifierIsCustomerDeletable]'
GO

--===========================================================================
-- PROCEDURE MODIFIER IS CUSTOMER DELETABLE
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_ProcedureModifierIsCustomerDeletable (@procedure_modifier_code varchar(16))
RETURNS BIT
AS
BEGIN
	--Not deletable if it is a Kareo record.
	IF EXISTS (
		SELECT	*
		FROM	ProcedureModifier WITH (NOLOCK)
		WHERE	ProcedureModifierCode = @procedure_modifier_code
		AND	NOT KareoProcedureModifierCode IS NULL
	)
		RETURN 0

	RETURN 1
END

GO
PRINT N'Creating [dbo].[InsurancePlanDataProvider_GetClearinghousePayers]'
GO

--===========================================================================
-- GET Clearinghouse Payers
--===========================================================================
CREATE PROCEDURE dbo.InsurancePlanDataProvider_GetClearinghousePayers
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(50) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT
AS
BEGIN

	SELECT	CAST(CPL.ClearinghousePayerID AS INT) AS ClearinghousePayerID,      -- loose the identity
		CPL.[Name],
		CPL.PayerNumber,
		CPL.Notes,
		'ProxyMed' AS Clearinghouse,
		(CASE (CPL.IsEnrollmentRequired)
				WHEN 1 THEN 'yes'
				ELSE 'no'
				END) AS IsEnrollmentRequired,
		(CASE (CPL.IsAuthorizationRequired)
				WHEN 1 THEN 'yes'
				ELSE 'no'
				END) AS IsAuthorizationRequired,
		(CASE (CPL.IsProviderIdRequired)
				WHEN 1 THEN 'yes'
				ELSE 'no'
				END) AS IsProviderIdRequired,
		(CASE (CPL.IsTestRequired)
				WHEN 1 THEN 'yes'
				ELSE 'no'
				END) AS IsTestRequired,
		(CASE (CPL.IsParticipating)
				WHEN 1 THEN 'yes'
				ELSE 'no'
				END) AS IsParticipating,
		CPL.StateSpecific,
		COALESCE((CASE (CPL.IsGovernment) WHEN 1 THEN 'Government ' ELSE '' END), '')
			+ COALESCE((CASE (CPL.IsCommercial) WHEN 1 THEN 'Comm ' ELSE '' END), '')
			AS PayerType,
		CPL.ResponseLevel,
		IDENTITY(int, 0, 1) as RID
	INTO 
		#t_ClearinghousePayers
	FROM	
		dbo.ClearinghousePayersList CPL
	WHERE
		(	(@query_domain IS NULL OR @query IS NULL)
			OR	((@query_domain = 'ClearinghousePayerID' OR @query_domain = 'All')
				AND CAST(CPL.ClearinghousePayerID AS VARCHAR(50)) LIKE '%' + @query + '%')
			OR	((@query_domain = 'Name' OR @query_domain = 'All')
				AND CPL.[Name] LIKE '%' + @query + '%')
			OR	((@query_domain = 'PayerNumber' OR @query_domain = 'All')
				AND CPL.PayerNumber LIKE '%' + @query + '%')
			OR	((@query_domain = 'Clearinghouse' OR @query_domain = 'All')
				AND 'ProxyMed' LIKE '%' + @query + '%')
			OR	((@query_domain = 'StateSpecific' OR @query_domain = 'All')
				AND CPL.StateSpecific LIKE '%' + @query + '%')
			OR	((@query_domain = 'IsEnrollmentRequired' OR @query_domain = 'All')
				AND ((CPL.IsEnrollmentRequired = 1 AND (@query = 'yes' OR @query = '')) OR (CPL.IsEnrollmentRequired = 0 AND @query = 'no')))
			OR	((@query_domain = 'IsProviderIdRequired' OR @query_domain = 'All')
				AND ((CPL.IsProviderIdRequired = 1 AND (@query = 'yes' OR @query = '')) OR (CPL.IsProviderIdRequired = 0 AND @query = 'no')))
			OR	((@query_domain = 'IsTestRequired' OR @query_domain = 'All')
				AND ((CPL.IsTestRequired = 1 AND (@query = 'yes' OR @query = '')) OR (CPL.IsTestRequired = 0 AND @query = 'no')))
			OR	((@query_domain = 'IsParticipating' OR @query_domain = 'All')
				AND ((CPL.IsParticipating = 1 AND (@query = 'yes' OR @query = '')) OR (CPL.IsParticipating = 0 AND @query = 'no')))
			OR	((@query_domain = 'PayerType' OR @query_domain = 'All')
				AND ((CPL.IsGovernment = 1 AND ('Government' LIKE '%' + @query + '%')) OR ((CPL.IsCommercial = 1 AND ('Comm' LIKE '%' + @query + '%')))))
		)
	ORDER BY Name

--	UPDATE #t_ClearinghousePayers
--	SET EClaimsStatus = 'Yes' WHERE EClaimsAccepts = 1
	
	SELECT @totalRecords = COUNT(*)
	FROM #t_ClearinghousePayers
	
	IF @maxRecords = 0
		SET @maxRecords = @totalRecords
		
	SELECT *
	FROM #t_ClearinghousePayers
	WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
	
	DROP TABLE #t_ClearinghousePayers
	RETURN
	
END

GO
PRINT N'Altering [dbo].[RefundDataProvider_GetRefunds]'
GO

--===========================================================================
-- GET REFUNDS
--===========================================================================
ALTER PROCEDURE dbo.RefundDataProvider_GetRefunds
	@practice_id INT,
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(50) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT
AS
BEGIN

	DECLARE @paymentID INT
	SET @paymentID = -1
	IF (@query_domain = 'PaymentID')
	BEGIN
		SET @paymentID = CAST(@query AS integer)
	END

	CREATE TABLE #t_refunds(
		RefundID int,
		RefundDate DateTime,
		RefundAmount money,
		RefundFromPaymentAmount money,
		RefundStatus varchar(50),
		RecipientName varchar(128),
		RecipientType varchar(50),
		[Description] varchar(250),
		Deletable bit, 
		RID int IDENTITY(0,1)
	)

	--Main Query
	INSERT
	INTO #t_refunds (
		RefundID,
		RefundDate,
		RefundAmount,
		RefundFromPaymentAmount,
		RefundStatus,
		RecipientName,
		RecipientType,
		[Description],
		Deletable
	)
	SELECT	P.RefundID,
		P.RefundDate,
		P.RefundAmount,
		CAST(RTP.Amount AS MONEY) AS RefundFromPaymentAmount,
		RS.[Description] AS RefundStatus,
		CASE (P.RecipientTypeCode)
			WHEN 'I' THEN
			COALESCE(I.PlanName,'') 
			+ ' (' + CAST(I.InsuranceCompanyPlanID AS VARCHAR) + ')' 
			WHEN 'P' THEN
			COALESCE(PA.FirstName + ' ','') 
			+ COALESCE(PA.MiddleName + ' ','') 
			+ COALESCE(PA.LastName,'') 
			+ ' (' + CAST(PA.PatientID AS VARCHAR) + ')'

			WHEN 'O' THEN
			O.OtherName

			END
			AS RecipientName,
		PT.[Description] AS RecipientType,
		P.[Description],
		CAST(1 AS BIT)	AS Deletable
	FROM	dbo.REFUND P INNER JOIN 
			dbo.PayerTypeCode PT
		ON PT.PayerTypeCode = P.RecipientTypeCode
		INNER JOIN dbo.RefundStatusCode RS
		ON RS.RefundStatusCode = P.RefundStatusCode
		LEFT OUTER JOIN INSURANCECOMPANYPLAN I
		ON P.RecipientTypeCode = 'I'
		AND I.InsuranceCompanyPlanID = P.RecipientID
		LEFT OUTER JOIN PATIENT PA
		ON P.RecipientTypeCode = 'P'
		AND PA.PatientID = P.RecipientID
		LEFT OUTER JOIN OTHER O
		ON P.RecipientTypeCode = 'O'
		AND O.OtherID = P.RecipientID
		LEFT OUTER JOIN RefundToPayments RTP
		ON RTP.RefundID = P.RefundID AND RTP.PaymentID = @paymentID
	WHERE	P.PracticeID = @practice_id
	AND (	(	(@query_domain IS NULL OR @query IS NULL)
		OR	((@query_domain = 'RefundDate'
				OR @query_domain = 'All')
			AND	(CONVERT(VARCHAR,P.RefundDate,101) LIKE '%' + @query + '%'))
		OR	((@query_domain = 'RecipientName' 
				OR @query_domain = 'All')
			AND	(
				I.PlanName LIKE @query + '%'
				OR PA.FirstName LIKE @query + '%'
				OR PA.LastName LIKE @query + '%'
				OR O.OtherName LIKE @query + '%'))
		OR	((@query_domain = 'RecipientID'
				OR @query_domain = 'All')
			AND	(CAST(COALESCE(I.InsuranceCompanyPlanID, PA.PatientID) AS VARCHAR) LIKE @query + '%'))
		OR	((@query_domain = 'RefundID'
				OR @query_domain = 'All')
			AND	(P.RefundID LIKE  @query + '%')))
	OR	(@query_domain = 'PaymentID'
		AND	(P.RefundID IN (SELECT DISTINCT RefundID from RefundToPayments RTP WHERE RTP.PaymentID = COALESCE(CAST(@query as integer),0) )))
	)
	ORDER BY RefundDate DESC

	SELECT @totalRecords = COUNT(*)
	FROM #t_refunds
		
	SELECT * 
	FROM #t_refunds T
	WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
	
	DROP TABLE #t_refunds
	RETURN
END


GO
PRINT N'Altering [dbo].[ReportDataProvider_ARAgingDetail]'
GO

--===========================================================================
-- SRS AR Aging Detail
--===========================================================================
ALTER PROCEDURE dbo.ReportDataProvider_ARAgingDetail
	@PracticeID int = NULL
	,@EndDate datetime = NULL
	,@RespType char(1) = I
	,@RespID int = 0
AS
BEGIN
	SET @EndDate = DATEADD(s, -1, DATEADD(d,1,dbo.fn_DateOnly(@EndDate)))

	CREATE TABLE #OpenClaimListWithLastTransaction(ClaimID int, MostRecentTransID int)
	CREATE TABLE #OpenClaimListWithLastBilledOrAssignedTransaction(ClaimID int, MostRecentTransID int)
	
	--Find all of the claims that were NOT
	--paid off BY the END date
	INSERT #OpenClaimListWithLastTransaction(ClaimID, MostRecentTransID)
	SELECT CT.ClaimID
		, MAX(CT.ClaimTransactionID) AS MaxTransID 
	FROM dbo.ClaimTransaction CT
	WHERE CT.PracticeID = @PracticeID
		AND CT.TransactionDate <= @EndDate
	GROUP BY CT.ClaimID
	HAVING MIN(CT.Claim_TotalBalance) > 0

	CREATE UNIQUE CLUSTERED INDEX UX_#OpenClaimListWithLastTransaction_ClaimID ON #OpenClaimListWithLastTransaction(ClaimID)
		WITH FILLFACTOR = 100

	--Create a new table with the same claims but with the last billed or assigned transaction
	INSERT	#OpenClaimListWithLastBilledOrAssignedTransaction(ClaimID, MostRecentTransID)
	SELECT CT.ClaimID
		, MAX(CT.ClaimTransactionID) AS MaxTranID 
	FROM dbo.ClaimTransaction CT
		INNER JOIN #OpenClaimListWithLastTransaction OCL
		ON CT.ClaimID = OCL.ClaimID
	WHERE CT.PracticeID = @PracticeID
		AND CT.TransactionDate <= @EndDate
		AND CT.ClaimTransactionTypeCode IN( 'BLL', 'ASN' )
	GROUP BY CT.ClaimID

	CREATE UNIQUE CLUSTERED INDEX UX_#OpenClaimListWithLastBilledOrAssignedTransaction_ClaimID ON #OpenClaimListWithLastBilledOrAssignedTransaction(ClaimID)
		WITH FILLFACTOR = 100
	
	CREATE TABLE #ARList (
		BillID int
		, Code varchar(10)
		, RespType varchar(9) 
		, RespName varchar(128)
		, ClaimID int
		, ServiceDate datetime
		, ProcedureCode varchar(48)
		, PatientFullname varchar(128)
		, AdjustedCharges money
		, Receipts money
		, BilledDate datetime
		, Aging int
		, OpenBalance money
		, ClaimTransactionID int
		, PatientID int
		, InsuranceCompanyPlanID int
	)
	
	--	
	IF @RespType = 'I'
	BEGIN	
		INSERT #ARList(
			BillID
			, Code
			, RespType
			, RespName
			, ClaimID
			, ServiceDate
			, ProcedureCode
			, PatientFullname
			, AdjustedCharges
			, Receipts
			, BilledDate
			, Aging
			, OpenBalance
			, ClaimTransactionID
			, PatientID
			, InsuranceCompanyPlanID
		)
		SELECT CTBilled.ReferenceID AS BillID 
			, CTBilled.Code
			, 'Insurance' AS RespType
			, 'Insurance' AS RespName
			, C.ClaimID
			, C.ServiceBeginDate AS ServiceDate
			, C.ProcedureCode
			, RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')) AS PatientFullname
			, (CTBal.Claim_Amount - CTBal.Claim_TotalAdjustments) AS AdjustedCharges
			, CTBal.Claim_TotalPayments AS Receipts
			, CTBilled.TransactionDate AS BilledDate
			, DATEDIFF(d,CTBilled.TransactionDate, @EndDate) AS Aging
			, CTBal.Claim_TotalBalance AS OpenBalance
			, CTBilled.ClaimTransactionID
			, C.PatientID
			, CASE
				WHEN CTBilled.AssignedToType = 'I' THEN CTBilled.AssignedToID
				ELSE null
			  END
		FROM dbo.ClaimTransaction CTBilled
			INNER JOIN #OpenClaimListWithLastBilledOrAssignedTransaction OCL
			ON CTBilled.ClaimID = OCL.ClaimID 
			AND CTBilled.ClaimTransactionID = OCL.MostRecentTransID 
			INNER JOIN #OpenClaimListWithLastTransaction OCLT
			ON CTBilled.ClaimID = OCLT.ClaimID
			INNER JOIN dbo.ClaimTransaction CTBal
			ON OCLT.MostRecentTransID = CTBal.ClaimTransactionID
			INNER JOIN dbo.Claim C
			ON CTBilled.ClaimID = C.ClaimID
			INNER JOIN dbo.Patient P
			ON C.PatientID = P.PatientID
		WHERE CTBilled.PracticeID = @PracticeID
			AND CTBilled.TransactionDate <= @EndDate
			AND CTBal.PracticeID = @PracticeID
			AND C.PracticeID = @PracticeID
			AND P.PracticeID = @PracticeID
			AND CTBilled.AssignedToType = 'I'
			--AND CTBilled.Code IN ('1','2')
	END
	ELSE IF @RespType = 'P'
	BEGIN	
		INSERT #ARList(
			BillID
			, Code
			, RespType
			, RespName
			, ClaimID
			, ServiceDate
			, ProcedureCode
			, PatientFullname
			, AdjustedCharges
			, Receipts
			, BilledDate
			, Aging
			, OpenBalance
			, ClaimTransactionID
			, PatientID
		)
		SELECT CTBilled.ReferenceID AS BillID 
			, CTBilled.Code
			, 'Patient' AS RespType
			, RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')) AS RespName
			, C.ClaimID
			, C.ServiceBeginDate AS ServiceDate
			, C.ProcedureCode
			, RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')) AS PatientFullname
			, (CTBal.Claim_Amount - CTBal.Claim_TotalAdjustments) AS AdjustedCharges
			, CTBal.Claim_TotalPayments AS Receipts
			, CTBilled.TransactionDate AS BilledDate
			, DATEDIFF(d,CTBilled.TransactionDate, @EndDate) AS Aging
			, CTBal.Claim_TotalBalance AS OpenBalance
			, CTBilled.ClaimTransactionID
			, C.PatientID
		FROM dbo.ClaimTransaction CTBilled
			INNER JOIN #OpenClaimListWithLastBilledOrAssignedTransaction OCL
			ON CTBilled.ClaimID = OCL.ClaimID 
			AND CTBilled.ClaimTransactionID = OCL.MostRecentTransID 
			INNER JOIN #OpenClaimListWithLastTransaction OCLT
			ON CTBilled.ClaimID = OCLT.ClaimID
			INNER JOIN dbo.ClaimTransaction CTBal
			ON OCLT.MostRecentTransID = CTBal.ClaimTransactionID
			INNER JOIN dbo.Claim C
			ON CTBilled.ClaimID = C.ClaimID
			INNER JOIN dbo.Patient P
			ON C.PatientID = P.PatientID
		WHERE CTBilled.PracticeID = @PracticeID
			AND CTBilled.TransactionDate <= @EndDate
			AND CTBal.PracticeID = @PracticeID
			AND C.PracticeID = @PracticeID
			AND P.PracticeID = @PracticeID
			AND (@RespType = 'P' AND C.PatientID = @RespID)
			AND CTBilled.AssignedToType = 'P'
	END
	ELSE
	BEGIN
		INSERT #ARList(
			BillID
			, Code
			, RespType
			, RespName
			, ClaimID
			, ServiceDate
			, ProcedureCode
			, PatientFullname
			, AdjustedCharges
			, Receipts
			, BilledDate
			, Aging
			, OpenBalance
			, ClaimTransactionID
			, PatientID
			, InsuranceCompanyPlanID
		)
		SELECT CTBilled.ReferenceID AS BillID 
			, CTBilled.Code
			,CASE
				WHEN CTBilled.Code IN ('1', '2') THEN 'Insurance'
				WHEN CTBilled.Code = 'P' THEN 'Patient'
				ELSE 'Other'
			END AS RespType
			,CASE
				WHEN CTBilled.AssignedToType IN ('I') THEN CAST('Insurance' AS varchar(128))
				WHEN CTBilled.AssignedToType = 'P' THEN RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, ''))
				ELSE 'RespName'
			END AS RespName
			, C.ClaimID
			, C.ServiceBeginDate AS ServiceDate
			, C.ProcedureCode
			, RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')) AS PatientFullname
			, (CTBal.Claim_Amount - CTBal.Claim_TotalAdjustments) AS AdjustedCharges
			, CTBal.Claim_TotalPayments AS Receipts
			, CTBilled.TransactionDate AS BilledDate
			, DATEDIFF(d,CTBilled.TransactionDate, @EndDate) AS Aging
			, CTBal.Claim_TotalBalance AS OpenBalance
			, CTBilled.ClaimTransactionID
			, C.PatientID
			, CASE
				WHEN CTBilled.AssignedToType IN ('I') THEN CTBilled.AssignedToID
				ELSE null
			  END
		FROM dbo.ClaimTransaction CTBilled
			INNER JOIN #OpenClaimListWithLastBilledOrAssignedTransaction OCL
			ON CTBilled.ClaimID = OCL.ClaimID 
			AND CTBilled.ClaimTransactionID = OCL.MostRecentTransID 
			INNER JOIN #OpenClaimListWithLastTransaction OCLT
			ON CTBilled.ClaimID = OCLT.ClaimID
			INNER JOIN dbo.ClaimTransaction CTBal
			ON OCLT.MostRecentTransID = CTBal.ClaimTransactionID
			INNER JOIN dbo.Claim C
			ON CTBilled.ClaimID = C.ClaimID
			INNER JOIN dbo.Patient P
			ON C.PatientID = P.PatientID
		WHERE CTBilled.PracticeID = @PracticeID
			AND CTBilled.TransactionDate <= @EndDate
			AND CTBal.PracticeID = @PracticeID
			AND C.PracticeID = @PracticeID
			AND P.PracticeID = @PracticeID
	END
	--	
	
	IF @RespType IN ('I', 'A')
	BEGIN 
		UPDATE T
			SET RespName = ICP.PlanName
		FROM #ARList T
			INNER JOIN dbo.InsuranceCompanyPlan ICP
			ON  ICP.InsuranceCompanyPlanID = T.InsuranceCompanyPlanID
		WHERE RespType = 'Insurance'
			AND RespName = 'Insurance'
	END

	IF @RespType = 'I'
	BEGIN
		--Only elminate the other data IF I IS passed
		DELETE #ARList WHERE InsuranceCompanyPlanID <> @RespID OR InsuranceCompanyPlanID IS NULL
	END		
	--
	SELECT *,
		CASE 
			WHEN Aging BETWEEN 0 and 30 THEN 1
			WHEN Aging BETWEEN 31 and 60 THEN 2
			WHEN Aging BETWEEN 61 and 90 THEN 3
			WHEN Aging BETWEEN 91 and 120 THEN 4
			WHEN Aging >= 12 THEN 5
		END AS AgeGroup
	FROM #ARList
	
	DROP TABLE #OpenClaimListWithLastTransaction
	DROP TABLE #OpenClaimListWithLastBilledOrAssignedTransaction
	DROP TABLE #ARList

	
	RETURN
END


GO
PRINT N'Altering [dbo].[InsurancePlanDataProvider_CreateInsurancePlan]'
GO

--===========================================================================
-- CREATE INSURANCE PLAN
--===========================================================================
ALTER PROCEDURE dbo.InsurancePlanDataProvider_CreateInsurancePlan
	@name VARCHAR(64),
	@street_1 VARCHAR(64),
	@street_2 VARCHAR(64),
	@city VARCHAR(32),
	@state CHAR(2),
	@country VARCHAR(32),
	@zip VARCHAR(9),
	@contact_prefix VARCHAR(16),
	@contact_first_name VARCHAR(32),
	@contact_middle_name VARCHAR(32),
	@contact_last_name VARCHAR(32),
	@contact_suffix VARCHAR(16),
	@phone VARCHAR(10),
	@phone_x VARCHAR(10),
	@fax VARCHAR(10),
	@fax_x VARCHAR(10),
	@copay_flag BIT,
	@program_code CHAR(1) = 'O',
	@provider_number_type_id INT = NULL,
	@group_number_type_id INT = NULL,
	@local_use_provider_number_type_id INT = NULL,
	@hcfa_diag_code CHAR(1) = 'C',
	@hcfa_same_code CHAR(1) = 'D',
	@review_code CHAR(1) = '',
	@EClaimsAccepts BIT = 0,
	@ClearinghousePayerID INT = NULL,
	@notes TEXT,
	@practice_id INT = NULL,
	@eclaims_enrollment_status_id INT = NULL,
	@eclaims_disable BIT = NULL
AS
BEGIN
	DECLARE @plan_id INT

	INSERT	INSURANCECOMPANYPLAN (
		PlanName,
		AddressLine1,
		AddressLine2,
		City,
		State,
		Country,
		ZipCode,
		ContactPrefix,
		ContactFirstName,
		ContactMiddleName,
		ContactLastName,
		ContactSuffix,
		Phone,
		PhoneExt,
		Fax,
		FaxExt,
		CoPay,
		InsuranceProgramCode,
		ProviderNumberTypeID,
		GroupNumberTypeID,
		LocalUseProviderNumberTypeID,
		HCFADiagnosisReferenceFormatCode,
		HCFASameAsInsuredFormatCode,
		ReviewCode,
		EClaimsAccepts,
		ClearinghousePayerID,
		CreatedPracticeID,
		Notes)
	VALUES	(
		@name,
		@street_1,
		@street_2,
		@city,
		@state,
		@country,
		@zip,
		@contact_prefix,
		@contact_first_name,
		@contact_middle_name,
		@contact_last_name,
		@contact_suffix,
		@phone,
		@phone_x,
		@fax,
		@fax_x,
		@copay_flag,
		@program_code,
		@provider_number_type_id,
		@group_number_type_id,
		@local_use_provider_number_type_id,
		@hcfa_diag_code,
		@hcfa_same_code,
		@review_code,
		@EClaimsAccepts,
		@ClearinghousePayerID,
		@practice_id,
		@notes)

	SET @plan_id = SCOPE_IDENTITY()

	DECLARE @EClaimsRequiresEnrollment BIT

	SELECT @EClaimsRequiresEnrollment = CPL.IsEnrollmentRequired
	FROM	dbo.InsuranceCompanyPlan IP
		LEFT OUTER JOIN dbo.ClearinghousePayersList CPL
		  ON IP.ClearinghousePayerID = CPL.ClearinghousePayerID
	WHERE IP.InsuranceCompanyPlanID = @plan_id

	-- list maintenance - for tracking EClaims enrollment status and disabling sending EClaims to this plan for a practice:
	IF @practice_id IS NOT NULL
	BEGIN
	    -- create, modify or delete listing that specifies non-default behavior of this plan for this practice:
	    DECLARE @tmp INT
	    SELECT @tmp = COUNT(*)
	    FROM
		PracticeToInsuranceCompanyPlan
	    WHERE InsuranceCompanyPlanID = @plan_id AND PracticeID = @practice_id
	    IF (@tmp = 0 AND ((@eclaims_enrollment_status_id IS NOT NULL AND @EClaimsRequiresEnrollment <> 0) OR @eclaims_disable <> 0))
	    BEGIN
		-- non-default behavior requested, record not present in the list yet:
		INSERT INTO 
			PracticeToInsuranceCompanyPlan (InsuranceCompanyPlanID, PracticeID, EClaimsEnrollmentStatusID, EClaimsDisable)
		VALUES (@plan_id, @practice_id, @eclaims_enrollment_status_id, @eclaims_disable)
	    END	
	    ELSE
	    BEGIN
		IF ((@eclaims_enrollment_status_id IS NULL OR @EClaimsRequiresEnrollment = 0) AND @eclaims_disable = 0)
		BEGIN
		    -- we are getting back to default behavior, delete the record:
		    DELETE	
			PracticeToInsuranceCompanyPlan
		    WHERE InsuranceCompanyPlanID = @plan_id AND PracticeID = @practice_id
		END
		ELSE
		BEGIN
		    -- changing record to some other non-default state:
		    UPDATE	
			PracticeToInsuranceCompanyPlan
		    SET
			EClaimsEnrollmentStatusID = @eclaims_enrollment_status_id,
			EClaimsDisable = @eclaims_disable
		    WHERE InsuranceCompanyPlanID = @plan_id AND PracticeID = @practice_id
		END
	    END
	END

	RETURN @plan_id 
END

GO
PRINT N'Altering [dbo].[MedicalCodeDataProvider_GetProcedureModifier]'
GO

--===========================================================================
-- GET PROCEDURE MODIFIER
--===========================================================================
ALTER PROCEDURE dbo.MedicalCodeDataProvider_GetProcedureModifier
	@modifier_code VARCHAR(16)
AS
BEGIN
	SELECT	ProcedureModifierCode,
		ModifierName, 
		KareoProcedureModifierCode
	FROM	ProcedureModifier
	WHERE	ProcedureModifierCode = @modifier_code
END

GO
PRINT N'Creating [dbo].[InsurancePlanDataProvider_UpdateClearinghousePayer]'
GO

--===========================================================================
-- UPDATE INSURANCE PLAN
--===========================================================================
CREATE PROCEDURE dbo.InsurancePlanDataProvider_UpdateClearinghousePayer
	@ClearinghousePayerID INT,
	@ClearinghouseID INT,
	@PayerNumber VARCHAR(32),
	@Name VARCHAR(1000),
	@Notes VARCHAR(1000) = NULL,
	@StateSpecific VARCHAR(16) = NULL,
	@PayerType INT = 0,
	@IsParticipating BIT = 0,
	@IsProviderIdRequired BIT = 0,
	@IsEnrollmentRequired BIT = 0,
	@IsAuthorizationRequired BIT = 0,
	@IsTestRequired BIT = 0,
	@ResponseLevel INT = NULL,
	@IsNewPayer BIT = 0,
	@DateNewPayerSince DATETIME = NULL,
	@Active INT = 1

AS
BEGIN
	UPDATE	
		ClearinghousePayersList
	SET	
		ClearinghouseID = @ClearinghouseID,
		PayerNumber = @PayerNumber,
		[Name] = @Name,
		Notes = @Notes,
		StateSpecific = @StateSpecific,
		IsGovernment = CAST((CASE (@PayerType) WHEN 1 THEN 1 ELSE  0 END) AS BIT),
		IsCommercial = CAST((CASE (@PayerType) WHEN 2 THEN 1 ELSE  0 END) AS BIT),
		IsParticipating = @IsParticipating,
		IsProviderIdRequired = @IsProviderIdRequired,
		IsEnrollmentRequired = @IsEnrollmentRequired,
		IsAuthorizationRequired = @IsAuthorizationRequired,
		IsTestRequired = @IsTestRequired,
		ResponseLevel = @ResponseLevel,
		IsNewPayer = @IsNewPayer,
		DateNewPayerSince = @DateNewPayerSince,
		Active = @Active,
		ModifiedDate = GETDATE()
	WHERE	ClearinghousePayerID = @ClearinghousePayerID

END


GO
PRINT N'Altering [dbo].[ReportDataProvider_GetReportCategoriesAndReports]'
GO


--===========================================================================
-- GET REPORT CATEGORIES AND REPORTS
--===========================================================================
ALTER PROCEDURE dbo.ReportDataProvider_GetReportCategoriesAndReports
AS
BEGIN
	SELECT		RC.ReportCategoryID,
			RC.DisplayOrder,
			RC.Image,
			RC.Name,
			RC.Description,
			RC.TaskName,
			R.ReportID,
			R.DisplayOrder AS ReportDisplayOrder,
			R.Image AS ReportImage,
			R.Name AS ReportName,
			R.Description AS ReportDescription,
			R.TaskName AS ReportTaskName,
			R.ReportServer,
			R.ReportPath,
			R.ReportParameters,
			R.PermissionValue
	FROM		ReportCategory RC
	INNER JOIN	Report R
	ON		R.ReportCategoryID = RC.ReportCategoryID
	WHERE 		RC.DisplayOrder > 0 AND R.DisplayOrder > 0
	ORDER BY	RC.DisplayOrder, R.DisplayOrder
/*
	SELECT	1 AS Tag, NULL AS Parent,
		RC.ReportCategoryID  AS [ReportCategory!1!ReportCategoryID],
		RC.Name AS [ReportCategory!1!ReportCategoryName],
		RC.Description AS [ReportCategory!1!ReportCategoryDescription]

	FROM		ReportCategory RC
	ORDER BY	RC.DisplayOrder

	FOR XML EXPLICIT
*/
END


GO
PRINT N'Altering [dbo].[InsurancePlanDataProvider_GetInsurancePlansForPractice]'
GO

--===========================================================================
-- GET INSURANCE PLANS FOR PRACTICE
--===========================================================================
ALTER PROCEDURE dbo.InsurancePlanDataProvider_GetInsurancePlansForPractice
	@practice_id INT = NULL,
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(50) = NULL,
	@review_code CHAR(2) = NULL,
	@show_code CHAR(2) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT
AS
BEGIN

	SELECT	CAST(IP.InsuranceCompanyPlanID AS int) AS InsuranceCompanyPlanID,
		IP.PlanName,
		IP.AddressLine1,
		IP.AddressLine2,
		IP.City,
		IP.State,
		IP.Country,
		IP.ZipCode,
		IP.ContactPrefix,
		IP.ContactFirstName,
		IP.ContactMiddleName,
		IP.ContactLastName,
		IP.ContactSuffix,
		IP.Phone,
		IP.PhoneExt,
		IP.Fax,
		IP.FaxExt,
		IP.CoPay,
		IP.InsuranceProgramCode,
		IP.ProviderNumberTypeID,
		IP.GroupNumberTypeID,
		IP.LocalUseProviderNumberTypeID,
		IP.HCFADiagnosisReferenceFormatCode,
		IP.HCFASameAsInsuredFormatCode,
		CPL.PayerNumber AS EDIPayerNumber,
		CASE WHEN CPL.ClearinghousePayerID IS NULL THEN '' ELSE 'ProxyMed' END AS ClearinghouseDisplayName,
		(CPL.[Name] + '   (' + CAST(CPL.ClearinghousePayerID AS VARCHAR) + ')') AS ClearinghousePayerDisplayName,
		COALESCE(CPL.Notes,'') AS ClearinghouseNotes,
		IP.Notes,
		IP.ReviewCode,
		IP.ClearinghousePayerID,
		CAST (CPL.IsGovernment AS INT) AS IsGovernment,
		CPL.StateSpecific,
		CAST (ISNULL(CPL.IsEnrollmentRequired,0) AS BIT) AS EClaimsRequiresEnrollment,
		CAST (ISNULL(CPL.IsAuthorizationRequired,0) AS BIT) AS EClaimsRequiresAuthorization,
		CAST (ISNULL(CPL.IsProviderIdRequired,0) AS BIT) AS EClaimsRequiresProviderID,
		CAST (ISNULL(CPL.IsTestRequired,0) AS BIT) AS EClaimsRequiresTest,
		CAST (ISNULL(CPL.IsPaperOnly,0) AS BIT) AS EClaimsPaperOnly,
		CAST (ISNULL(CPL.ResponseLevel,0) AS INT) AS EClaimsResponseLevel,
		IP.EClaimsAccepts,
		CASE WHEN IP.CreatedPracticeID IS NULL THEN 'Administrator' ELSE COALESCE(CP.Name + ' (','(') + COALESCE(CAST(CP.PracticeID AS VARCHAR),'0') + ')' END AS CreatorPractice,
		CAST('Not enrolled' AS VARCHAR (50)) AS EClaimsStatus,
		'Not approved' AS ApprovalStatus,
		CAST(PTICP.EClaimsEnrollmentStatusID AS INT) AS EClaimsEnrollmentStatusID,
		CAST(PTICP.EClaimsDisable AS BIT) AS EClaimsDisable,
		CAST(1 AS BIT) AS Deletable,
		IDENTITY(int, 0, 1) as RID
	INTO 
		#t_InsuranceCompanyPlan
	FROM	
		dbo.InsuranceCompanyPlan IP
		LEFT OUTER JOIN ClearinghousePayersList CPL
		 ON IP.ClearinghousePayerID = CPL.ClearinghousePayerID
		LEFT OUTER JOIN Practice CP
		 ON CP.PracticeID = IP.CreatedPracticeID
		LEFT OUTER JOIN PracticeToInsuranceCompanyPlan PTICP
		 ON PTICP.InsuranceCompanyPlanID = IP.InsuranceCompanyPlanID AND PTICP.PracticeID = @practice_id
	WHERE
		(	(@query_domain IS NULL OR @query IS NULL)
			OR	((@query_domain = 'PlanName' OR @query_domain = 'All')
				AND IP.PlanName LIKE '%' + @query + '%')
			OR	((@query_domain = 'PlanAddress' OR @query_domain = 'All')
				AND	(IP.AddressLine1 LIKE '%' + @query + '%'
					OR IP.AddressLine2 LIKE '%' + @query + '%'
					OR IP.City LIKE '%' + @query + '%'
					OR IP.State LIKE '%' + @query + '%'
					OR IP.ZipCode LIKE '%' + @query + '%'))
			OR	((@query_domain = 'PlanPhone' OR @query_domain = 'All')
				AND	(IP.Phone LIKE '%' + REPLACE(REPLACE(REPLACE(@query,'-',''),'(',''),')','') + '%'))
		)

		AND	((@review_code IS NULL)
			  OR	(@review_code IS NOT NULL
				AND CPL.StateSpecific = @review_code))
				
		AND	(								-- only approved plans, or ones created by this practice
				IP.ReviewCode = 'R' 
				OR COALESCE(IP.CreatedPracticeID,0) = @practice_id
			)

		AND	((@show_code IS NULL)
--			  OR	(@show_code = 'S' AND IP.EClaimsAccepts = 1)		-- Payers setup for accepting claims
			  OR	(@show_code = 'NS' AND IP.EClaimsAccepts = 0)		-- Not setup (for accepting claims)
			  OR	(@show_code = 'RE' AND IP.EClaimsAccepts = 1 		-- Requires enrollment (can accept, but needs practice to enroll)
					AND CPL.IsEnrollmentRequired = 1
					AND (PTICP.EClaimsEnrollmentStatusID IS NULL OR PTICP.EClaimsEnrollmentStatusID = 0))
			  OR	(@show_code = 'PE'  AND IP.EClaimsAccepts = 1		-- Pending Enrollment (can accept, practice enrollment in progress)
					AND CPL.IsEnrollmentRequired = 1
					AND PTICP.EClaimsEnrollmentStatusID = 1)
			  OR	(@show_code = 'TE'  AND IP.EClaimsAccepts = 1		-- Test mode Enrollment (can accept, practice enrolled and in test with payer)
					AND (PTICP.EClaimsDisable IS NULL OR PTICP.EClaimsDisable = 0)
					AND CPL.IsEnrollmentRequired = 1 AND CPL.IsTestRequired = 1 AND PTICP.EClaimsEnrollmentStatusID = 3)
			  OR	(@show_code = 'LE'  AND IP.EClaimsAccepts = 1		-- Live mode Enrollment (can accept, practice enrolled)
					AND (PTICP.EClaimsDisable IS NULL OR PTICP.EClaimsDisable = 0)
					AND CPL.IsEnrollmentRequired = 0 OR PTICP.EClaimsEnrollmentStatusID = 2)
			  OR	(@show_code = 'D' AND IP.EClaimsAccepts = 1		-- Disabled (can accept but disabled for this practice)
					AND PTICP.EClaimsDisable = 1)
--			  OR	(@show_code = 'ED' AND IP.EClaimsAccepts = 1		-- Enrolled (explicitly or by default) and ready to accept claims
--					AND (PTICP.EClaimsDisable IS NULL OR PTICP.EClaimsDisable = 0)
--					AND (CPL.IsEnrollmentRequired = 0 OR PTICP.EClaimsEnrollmentStatusID = 2))
			)
	ORDER BY PlanName

	-- overwrite the default 'Not enrolled':
	UPDATE #t_InsuranceCompanyPlan
	SET EClaimsStatus = 'Enrolled (live)' WHERE EClaimsAccepts = 1 AND (EClaimsDisable IS NULL OR EClaimsDisable = 0)
							 AND (EClaimsRequiresEnrollment = 0 OR EClaimsEnrollmentStatusID = 2)

	UPDATE #t_InsuranceCompanyPlan
	SET EClaimsStatus = 'Enrolled (test)' WHERE EClaimsAccepts = 1 AND (EClaimsDisable IS NULL OR EClaimsDisable = 0)
							 AND EClaimsRequiresEnrollment = 1 AND EClaimsEnrollmentStatusID = 3

--	UPDATE #t_InsuranceCompanyPlan
--	SET EClaimsStatus = 'Enrolled by default' WHERE EClaimsAccepts = 1 AND EClaimsRequiresEnrollment = 0

	UPDATE #t_InsuranceCompanyPlan
	SET EClaimsStatus = 'Pending enrollment' WHERE EClaimsAccepts = 1 AND EClaimsRequiresEnrollment = 1 AND EClaimsEnrollmentStatusID = 1

	UPDATE #t_InsuranceCompanyPlan
	SET EClaimsStatus = 'Disabled' WHERE EClaimsAccepts = 1 AND EClaimsDisable = 1
	
	UPDATE #t_InsuranceCompanyPlan
	SET EClaimsStatus = 'Payer not setup' WHERE EClaimsAccepts = 0

	-- overwrite approval status:
	UPDATE #t_InsuranceCompanyPlan
	SET ApprovalStatus = 'Approved' WHERE ReviewCode = 'R'
	
	SELECT @totalRecords = COUNT(*)
	FROM #t_InsuranceCompanyPlan
	
	IF @maxRecords = 0
		SET @maxRecords = @totalRecords
		
	SELECT *
	FROM #t_InsuranceCompanyPlan
	WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
	
	DROP TABLE #t_InsuranceCompanyPlan
	RETURN
	
END

GO
PRINT N'Altering [dbo].[ReportDataProvider_GetReportCategories]'
GO


--===========================================================================
-- GET REPORTS
--===========================================================================
ALTER PROCEDURE dbo.ReportDataProvider_GetReportCategories
AS
BEGIN
	SELECT		RC.ReportCategoryID,
			RC.DisplayOrder,
			RC.Image,
			RC.Name,
			RC.Description,
			RC.TaskName
	FROM		ReportCategory RC
	WHERE 		RC.DisplayOrder > 0
	ORDER BY	RC.DisplayOrder

	SELECT		RC.Name, 
			R.PermissionValue
	FROM		Report R
	INNER JOIN	ReportCategory RC
	ON		   RC.ReportCategoryID = R.ReportCategoryID
	ORDER BY	RC.Name
	
END


GO
PRINT N'Altering [dbo].[Handheld_ProcedureDataProvider_GetProcedureToCategory]'
GO

--===========================================================================
-- GET PROCEDURE TO CATEGORY
--===========================================================================
ALTER PROCEDURE dbo.Handheld_ProcedureDataProvider_GetProcedureToCategory
	@practice_id INT,
	@sync_date DATETIME
AS
BEGIN
	IF EXISTS (
		SELECT	*
		FROM	PROCEDURECATEGORYTOPROCEDURECODEDICTIONARY PTC
			INNER JOIN PROCEDURECATEGORY PC
			ON PC.ProcedureCategoryID = PTC.ProcedureCategoryID
			INNER JOIN CodingTemplate CT
			ON CT.CodingTemplateID = PC.CodingTemplateID
		WHERE	CT.PracticeID = @practice_id
		AND	(PTC.ModifiedDate > @sync_date
			OR PTC.CreatedDate > @sync_date
			OR PC.ModifiedDate > @sync_date
			OR PC.CreatedDate > @sync_date
			OR CT.ModifiedDate > @sync_date
			OR CT.CreatedDate > @sync_date))
	BEGIN
		SELECT	DISTINCT PTC.ID_PK AS PROCEDURECODEDICTIONARYTOProcedureCategoryID,
			PTC.ProcedureCodeDictionaryID,
			PTC.ProcedureCategoryID
		FROM	PROCEDURECATEGORYTOPROCEDURECODEDICTIONARY PTC
			INNER JOIN PROCEDURECATEGORY PC
			ON PC.ProcedureCategoryID = PTC.ProcedureCategoryID
			INNER JOIN CodingTemplate CT
			ON CT.CodingTemplateID = PC.CodingTemplateID
		WHERE	CT.PracticeID = @practice_id
	END
END


GO
PRINT N'Altering [dbo].[InsurancePlanDataProvider_GetInsurancePlans]'
GO

--===========================================================================
-- GET INSURANCE PLANS
--===========================================================================
ALTER PROCEDURE dbo.InsurancePlanDataProvider_GetInsurancePlans
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(50) = NULL,
	@review_code CHAR(1) = NULL,
	@show_code CHAR(1) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT
AS
BEGIN

	SELECT	CAST(IP.InsuranceCompanyPlanID AS int) AS InsuranceCompanyPlanID,
		IP.PlanName,
		IP.AddressLine1,
		IP.AddressLine2,
		IP.City,
		IP.State,
		IP.Country,
		IP.ZipCode,
		IP.ContactPrefix,
		IP.ContactFirstName,
		IP.ContactMiddleName,
		IP.ContactLastName,
		IP.ContactSuffix,
		IP.Phone,
		IP.PhoneExt,
		IP.Fax,
		IP.FaxExt,
		IP.CoPay,
		IP.InsuranceProgramCode,
		IP.ProviderNumberTypeID,
		IP.GroupNumberTypeID,
		IP.LocalUseProviderNumberTypeID,
		IP.HCFADiagnosisReferenceFormatCode,
		IP.HCFASameAsInsuredFormatCode,
		CPL.PayerNumber AS EDIPayerNumber,
		CASE WHEN CPL.ClearinghousePayerID IS NULL THEN '' ELSE 'ProxyMed' END AS ClearinghouseDisplayName,
		(CPL.[Name] + '   (' + CAST(CPL.ClearinghousePayerID AS VARCHAR) + ')') AS ClearinghousePayerDisplayName,
		COALESCE(CPL.Notes,'') AS ClearinghouseNotes,
		IP.Notes,
		IP.ReviewCode,
		IP.ClearinghousePayerID,
		CAST (CPL.IsGovernment AS INT) AS IsGovernment,
		CPL.StateSpecific,
		CAST (ISNULL(CPL.IsEnrollmentRequired,0) AS BIT) AS EClaimsRequiresEnrollment,
		CAST (ISNULL(CPL.IsAuthorizationRequired,0) AS BIT) AS EClaimsRequiresAuthorization,
		CAST (ISNULL(CPL.IsProviderIdRequired,0) AS BIT) AS EClaimsRequiresProviderID,
		CAST (ISNULL(CPL.IsTestRequired,0) AS BIT) AS EClaimsRequiresTest,
		CAST (ISNULL(CPL.IsPaperOnly,0) AS BIT) AS EClaimsPaperOnly,
		CAST (ISNULL(CPL.ResponseLevel,0) AS INT) AS EClaimsResponseLevel,
		IP.EClaimsAccepts,
		CASE WHEN IP.CreatedPracticeID IS NULL THEN 'Administrator' ELSE COALESCE(CP.Name + ' (','(') + COALESCE(CAST(CP.PracticeID AS VARCHAR),'0') + ')' END AS CreatorPractice,
		CAST('No' AS VARCHAR (10)) AS EClaimsStatus,
		'Not approved' AS ApprovalStatus,
		CASE WHEN PIn.InsuranceCompanyPlanID IS NULL THEN CAST(1 as BIT) ELSE CAST(0 AS BIT) END AS Deletable,
		KareoInsuranceCompanyPlanID, 
		IDENTITY(int, 0, 1) as RID
	INTO 
		#t_InsuranceCompanyPlan
	FROM	
		dbo.InsuranceCompanyPlan IP
		LEFT OUTER JOIN ClearinghousePayersList CPL
		  ON IP.ClearinghousePayerID = CPL.ClearinghousePayerID
		LEFT OUTER JOIN Practice CP
		  ON IP.CreatedPracticeID = CP.PracticeID
		LEFT OUTER JOIN (SELECT	DISTINCT InsuranceCompanyPlanID FROM PATIENTINSURANCE) PIn
		  ON PIn.InsuranceCompanyPlanID = IP.InsuranceCompanyPlanID
	WHERE
		(	(@query_domain IS NULL OR @query IS NULL)
			OR	((@query_domain = 'PlanName' OR @query_domain = 'All')
				AND IP.PlanName LIKE '%' + @query + '%')
			OR	((@query_domain = 'PlanAddress' OR @query_domain = 'All')
				AND	(IP.AddressLine1 LIKE '%' + @query + '%'
					OR IP.AddressLine2 LIKE '%' + @query + '%'
					OR IP.City LIKE '%' + @query + '%'
					OR IP.State LIKE '%' + @query + '%'
					OR IP.ZipCode LIKE '%' + @query + '%'))
			OR	((@query_domain = 'PlanPhone' OR @query_domain = 'All')
				AND	(IP.Phone LIKE '%' + REPLACE(REPLACE(REPLACE(@query,'-',''),'(',''),')','') + '%'))
		)
		AND	((@review_code IS NULL)
			  OR	(@review_code IS NOT NULL
				AND IP.ReviewCode = @review_code))
		AND	((@show_code IS NULL)
			  OR	(@show_code = '1' AND IP.EClaimsAccepts = 1)
			  OR	(@show_code = '0' AND IP.EClaimsAccepts = 0))
	ORDER BY PlanName

	UPDATE #t_InsuranceCompanyPlan
	SET EClaimsStatus = 'Yes' WHERE EClaimsAccepts = 1
	
	UPDATE #t_InsuranceCompanyPlan
	SET ApprovalStatus = 'Approved' WHERE ReviewCode = 'R'
	
	SELECT @totalRecords = COUNT(*)
	FROM #t_InsuranceCompanyPlan
	
	IF @maxRecords = 0
		SET @maxRecords = @totalRecords
		
	SELECT *
	FROM #t_InsuranceCompanyPlan
	WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
	
	DROP TABLE #t_InsuranceCompanyPlan
	RETURN
	
END

GO
PRINT N'Creating [dbo].[InsurancePlanDataProvider_DeleteClearinghousePayer]'
GO

--===========================================================================
-- DELETE CLEARINGHOUSE PAYER
--===========================================================================
CREATE PROCEDURE dbo.InsurancePlanDataProvider_DeleteClearinghousePayer
	@ClearinghousePayerID INT
AS
BEGIN
	--Delete the payer.
	DELETE	ClearinghousePayersList
	WHERE	ClearinghousePayerID = @ClearinghousePayerId
END


GO
PRINT N'Altering [dbo].[BusinessRule_ProcedureModifierIsDeletable]'
GO

--===========================================================================
-- PROCEDURE MODIFIER IS DELETABLE
--===========================================================================
ALTER FUNCTION dbo.BusinessRule_ProcedureModifierIsDeletable (@code varchar(16))
RETURNS BIT
AS
BEGIN
	IF EXISTS (
		SELECT	*
		FROM	EncounterProcedure
		WHERE	ProcedureModifier1 = @code
		OR	ProcedureModifier2 = @code
		OR	ProcedureModifier3 = @code
		OR	ProcedureModifier4 = @code
	)
		RETURN 0
	
	RETURN 1
END


GO
PRINT N'Altering [dbo].[Handheld_ProcedureDataProvider_GetProcedureCategories]'
GO

--===========================================================================
-- GET PROCEDURE CATEGORIES
--===========================================================================
ALTER PROCEDURE dbo.Handheld_ProcedureDataProvider_GetProcedureCategories
	@practice_id INT,
	@sync_date DATETIME
AS
BEGIN
	IF EXISTS (
		SELECT	*
		FROM	PROCEDURECATEGORY PC
			INNER JOIN CodingTemplate CT
			ON CT.CodingTemplateID = PC.CodingTemplateID
		WHERE	CT.PracticeID = @practice_id
		AND	(PC.ModifiedDate > @sync_date
			OR PC.CreatedDate > @sync_date
			OR CT.ModifiedDate > @sync_date
			OR CT.CreatedDate > @sync_date))
	BEGIN
		SELECT	DISTINCT PC.ProcedureCategoryID,
			PC.Name
		FROM	PROCEDURECATEGORY PC
			INNER JOIN CodingTemplate CT
			ON CT.CodingTemplateID = PC.CodingTemplateID
		WHERE	CT.PracticeID = @practice_id
	END
END


GO
PRINT N'Altering [dbo].[ProcedureDataProvider_GetProcedure]'
GO

--===========================================================================
-- GET PROCEDURE
--===========================================================================
ALTER PROCEDURE dbo.ProcedureDataProvider_GetProcedure
	@procedure_id INT
AS
BEGIN
	SELECT	PCD.ProcedureCodeDictionaryID,
		PCD.ProcedureCode,
		PCD.ProcedureName,
		PCD.Description,
		PCD.TypeOfServiceCode,
		PCD.KareoProcedureCodeDictionaryID
	FROM	PROCEDURECODEDICTIONARY PCD
		INNER JOIN TYPEOFSERVICE TOS
		ON TOS.TypeOfServiceCode = PCD.TypeOfServiceCode
	WHERE	ProcedureCodeDictionaryID = @procedure_id
END

GO
PRINT N'Creating [dbo].[Handheld_AppointmentDataProvider_GetAppointments]'
GO

--===========================================================================
-- GET APPOINTMENTS
--===========================================================================
CREATE PROCEDURE dbo.Handheld_AppointmentDataProvider_GetAppointments
	@doctorId int,
	@startDate datetime,
	@endDate datetime
AS
BEGIN
SELECT	A.AppointmentID,
		A.StartDate,
		A.EndDate,
		A.AppointmentType,
		A.Subject,
		A.Notes,
		A.ServiceLocationID,
		ATR.ResourceID as DoctorID,
		A.PatientID,
		P.SSN AS PATIENTSSN
	FROM	APPOINTMENT A
			LEFT OUTER JOIN PATIENT P
			ON P.PatientID = A.PatientID
	INNER JOIN AppointmentToResource ATR
	ON		ATR.AppointmentID = A.AppointmentID
	AND		ATR.AppointmentResourceTypeID = 1
	AND		ATR.ResourceID = @doctorID
	WHERE		A.StartDate >= @startDate
	AND		A.EndDate <= @endDate
END


GO
PRINT N'Altering [dbo].[Handheld_ProcedureDataProvider_GetCategoryToTemplate]'
GO

--===========================================================================
-- GET CATEGORY TO TEMPLATE
--===========================================================================
ALTER PROCEDURE dbo.Handheld_ProcedureDataProvider_GetCategoryToTemplate
	@practice_id INT,
	@sync_date DATETIME
AS
BEGIN
	IF EXISTS (
		SELECT	*
		FROM	PROCEDURECATEGORY PC
			INNER JOIN CodingTemplate CT
			ON CT.CodingTemplateID = PC.CodingTemplateID
		WHERE	CT.PracticeID = @practice_id
		AND	(PC.ModifiedDate > @sync_date
			OR PC.CreatedDate > @sync_date
			OR CT.ModifiedDate > @sync_date
			OR CT.CreatedDate > @sync_date))
	BEGIN
		SELECT	DISTINCT PC.ProcedureCategoryID AS PROCEDURECATEGORYTOCodingTemplateID,
			PC.ProcedureCategoryID,
			PC.CodingTemplateID
		FROM	PROCEDURECATEGORY PC
			INNER JOIN CodingTemplate CT
			ON CT.CodingTemplateID = PC.CodingTemplateID
		WHERE	CT.PracticeID = @practice_id
	END
END


GO
PRINT N'Creating [dbo].[InsurancePlanDataProvider_CreateClearinghousePayer]'
GO

--===========================================================================
-- CREATE CLEARINGHOUSE PAYER
--===========================================================================
CREATE PROCEDURE dbo.InsurancePlanDataProvider_CreateClearinghousePayer
	@ClearinghouseID INT,
	@PayerNumber VARCHAR(32),
	@Name VARCHAR(1000),
	@Notes VARCHAR(1000) = NULL,
	@StateSpecific VARCHAR(16) = NULL,
	@PayerType INT = 0,
	@IsParticipating BIT = 0,
	@IsProviderIdRequired BIT = 0,
	@IsEnrollmentRequired BIT = 0,
	@IsAuthorizationRequired BIT = 0,
	@IsTestRequired BIT = 0,
	@ResponseLevel INT = NULL,
	@IsNewPayer BIT = 0,
	@DateNewPayerSince DATETIME = NULL,
	@Active INT = 1
AS
BEGIN
	DECLARE @ClearinghousePayerID INT

	INSERT ClearinghousePayersList
	(
		ClearinghouseID,
		PayerNumber,
		[Name],
		Notes,
		StateSpecific,
		IsGovernment,
		IsCommercial,
		IsParticipating,
		IsProviderIdRequired,
		IsEnrollmentRequired,
		IsAuthorizationRequired,
		IsTestRequired,
		ResponseLevel,
		IsNewPayer,
		DateNewPayerSince,
		Active,
		ModifiedDate
	)
	VALUES	(
		@ClearinghouseID,
		@PayerNumber,
		@Name,
		@Notes,
		@StateSpecific,
		CAST((CASE (@PayerType) WHEN 1 THEN 1 ELSE  0 END) AS BIT),
		CAST((CASE (@PayerType) WHEN 2 THEN 1 ELSE  0 END) AS BIT),
		@IsParticipating,
		@IsProviderIdRequired,
		@IsEnrollmentRequired,
		@IsAuthorizationRequired,
		@IsTestRequired,
		@ResponseLevel,
		@IsNewPayer,
		@DateNewPayerSince,
		@Active,
		GETDATE()
	)

	SET @ClearinghousePayerID = SCOPE_IDENTITY()

	RETURN @ClearinghousePayerID 
END


GO
PRINT N'Creating [dbo].[BusinessRule_DiagnosisIsCustomerDeletable]'
GO

--===========================================================================
-- DIAGNOSIS IS CUSTOMER DELETABLE
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_DiagnosisIsCustomerDeletable (@diagnosis_id INT)
RETURNS BIT
AS
BEGIN
	--Not deletable if it is a Kareo record.
	IF EXISTS (
		SELECT	*
		FROM	DiagnosisCodeDictionary WITH (NOLOCK)
		WHERE	DiagnosisCodeDictionaryID = @diagnosis_id
		AND	NOT KareoDiagnosisCodeDictionaryID IS NULL
	)
		RETURN 0

	RETURN 1
END

GO
PRINT N'Altering [dbo].[Handheld_DiagnosisDataProvider_GetCodingTemplates]'
GO

--===========================================================================
-- GET CODING TEMPLATES
--===========================================================================
ALTER PROCEDURE dbo.Handheld_DiagnosisDataProvider_GetCodingTemplates
	@practice_id INT,
	@sync_date DATETIME
AS
BEGIN
	IF EXISTS (
		SELECT	*
		FROM	CODINGTEMPLATE
		WHERE	PracticeID = @practice_id
		AND	(ModifiedDate > @sync_date
			OR CreatedDate > @sync_date))
	BEGIN
		SELECT	CodingTemplateID,
			Name,
			Description
		FROM	CODINGTEMPLATE
		WHERE	PracticeID = @practice_id
	END
END


GO
PRINT N'Altering [dbo].[DoctorDataProvider_UpdateDoctor]'
GO

--===========================================================================
-- UPDATE DOCTOR
--===========================================================================
ALTER PROCEDURE dbo.DoctorDataProvider_UpdateDoctor
	@doctor_id INT,
	@prefix VARCHAR(16),
	@first_name VARCHAR(32),
	@middle_name VARCHAR(32),
	@last_name VARCHAR(32),
	@suffix VARCHAR(16),
	@degree VARCHAR(8) = NULL,
	@ssn VARCHAR(9) = NULL,
	@address_1 VARCHAR(128) = NULL,
	@address_2 VARCHAR(128) = NULL,
	@city VARCHAR(32) = NULL,
	@state VARCHAR(2) = NULL,
	@country VARCHAR(32) = NULL,
	@zip VARCHAR(9) = NULL,
	@home_phone VARCHAR(10) = NULL,
	@home_phone_x VARCHAR(10) = NULL,
	@work_phone VARCHAR(10) = NULL,
	@work_phone_x VARCHAR(10) = NULL,
	@pager_phone VARCHAR(10) = NULL,
	@pager_phone_x VARCHAR(10) = NULL,
	@mobile_phone VARCHAR(10) = NULL,
	@mobile_phone_x VARCHAR(10) = NULL,
	@dob DATETIME = NULL,
	@email VARCHAR(128) = NULL,
	@notes TEXT = NULL,
	@specialty_code CHAR(10) = NULL,
	@taxonomy_code VARCHAR(20) = NULL,
	@user_id INT = NULL
AS
BEGIN
	UPDATE	DOCTOR
	SET	Prefix = @prefix,
		FirstName = @first_name,
		MiddleName = @middle_name,
		LastName = @last_name,
		Suffix = @suffix,
		Degree = @degree,
		SSN = @ssn,
		AddressLine1 = @address_1,
		AddressLine2 = @address_2,
		City = @city,
		State = @state,
		Country = @country,
		ZipCode = @zip,
		HomePhone = @home_phone,
		HomePhoneExt = @home_phone_x,
		WorkPhone = @work_phone,
		WorkPhoneExt = @work_phone_x,
		PagerPhone = @pager_phone,
		PagerPhoneExt = @pager_phone_x,
		MobilePhone = @mobile_phone,
		MobilePhoneExt = @mobile_phone_x,
		DOB = @dob,
		EmailAddress = @email,
		Notes = @notes,
		ProviderSpecialtyCode = coalesce(@specialty_code, ProviderSpecialtyCode), 
		HipaaProviderTaxonomyCode = coalesce(@taxonomy_code, HipaaProviderTaxonomyCode),
		UserID = coalesce(@user_id, UserID),
		ModifiedDate = GETDATE()
	WHERE	DoctorID = @doctor_id
END


GO
PRINT N'Creating [dbo].[BusinessRule_ProcedureIsCustomerDeletable]'
GO

--===========================================================================
-- PROCEDURE IS CUSTOMER DELETABLE
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_ProcedureIsCustomerDeletable (@procedure_id INT)
RETURNS BIT
AS
BEGIN
	--Not deletable if it is a Kareo record.
	IF EXISTS (
		SELECT	*
		FROM	ProcedureCodeDictionary WITH (NOLOCK)
		WHERE	ProcedureCodeDictionaryID = @procedure_id
		AND	NOT KareoProcedureCodeDictionaryID IS NULL
	)
		RETURN 0

	RETURN 1
END

GO
PRINT N'Altering [dbo].[DoctorDataProvider_CreateDoctor]'
GO

--===========================================================================
-- CREATE DOCTOR
--===========================================================================
ALTER PROCEDURE dbo.DoctorDataProvider_CreateDoctor
	@practice_id INT,
	@prefix VARCHAR(16),
	@first_name VARCHAR(32),
	@middle_name VARCHAR(32),
	@last_name VARCHAR(32),
	@suffix VARCHAR(16),
	@degree VARCHAR(8) = NULL,
	@ssn VARCHAR(9) = NULL,
	@address_1 VARCHAR(128) = NULL,
	@address_2 VARCHAR(128) = NULL,
	@city VARCHAR(32) = NULL,
	@state VARCHAR(2) = NULL,
	@country VARCHAR(32) = NULL,
	@zip VARCHAR(9) = NULL,
	@home_phone VARCHAR(10) = NULL,
	@home_phone_x VARCHAR(10) = NULL,
	@work_phone VARCHAR(10) = NULL,
	@work_phone_x VARCHAR(10) = NULL,
	@pager_phone VARCHAR(10) = NULL,
	@pager_phone_x VARCHAR(10) = NULL,
	@mobile_phone VARCHAR(10) = NULL,
	@mobile_phone_x VARCHAR(10) = NULL,
	@dob DATETIME = NULL,
	@email VARCHAR(128) = NULL,
	@notes TEXT = NULL,
	@specialty_code CHAR(10) = NULL,
	@taxonomy_code VARCHAR(20) = NULL,
	@user_id INT = NULL
AS
BEGIN
	INSERT	DOCTOR (
		PracticeID,
		Prefix,
		FirstName,
		MiddleName,
		LastName,
		Suffix,
		Degree,
		SSN,
		AddressLine1,
		AddressLine2,
		City,
		State,
		Country,
		ZipCode,
		HomePhone,
		HomePhoneExt,
		WorkPhone,
		WorkPhoneExt,
		PagerPhone,
		PagerPhoneExt,
		MobilePhone,
		MobilePhoneExt,
		DOB,
		EmailAddress,
		Notes,
		ProviderSpecialtyCode,
		HipaaProviderTaxonomyCode, 
		UserID)
	VALUES	(
		@practice_id,
		@prefix,
		@first_name,
		@middle_name,
		@last_name,
		@suffix,
		@degree,
		@ssn,
		@address_1,
		@address_2,
		@city,
		@state,
		@country,
		@zip,
		@home_phone,
		@home_phone_x,
		@work_phone,
		@work_phone_x,
		@pager_phone,
		@pager_phone_x,
		@mobile_phone,
		@mobile_phone_x,
		@dob,
		@email,
		@notes,
		@specialty_code,
		@taxonomy_code, 
		@user_id)

	RETURN SCOPE_IDENTITY()
END


GO
PRINT N'Creating [dbo].[BusinessRule_InsuranceCompanyPlanIsCustomerDeletable]'
GO

--===========================================================================
-- INSURANCE COMPANY PLAN IS CUSTOMER DELETABLE
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_InsuranceCompanyPlanIsCustomerDeletable (@plan_id INT)
RETURNS BIT
AS
BEGIN
	--Not deletable if it is a Kareo record.
	IF EXISTS (
		SELECT	*
		FROM	InsuranceCompanyPlan WITH (NOLOCK)
		WHERE	InsuranceCompanyPlanID = @plan_id
		AND	NOT KareoInsuranceCompanyPlanID IS NULL
	)
		RETURN 0

	RETURN 1
END

GO
PRINT N'Altering [dbo].[BusinessRule_ProcedureIsDeletable]'
GO

--===========================================================================
-- PROCEDURE IS DELETABLE
--===========================================================================
ALTER FUNCTION dbo.BusinessRule_ProcedureIsDeletable (@procedure_id INT)
RETURNS BIT
AS
BEGIN
	--Not deletable if there are encounters associated with it.
	IF EXISTS (
		SELECT	*
		FROM	ENCOUNTERPROCEDURE WITH (NOLOCK)
		WHERE	ProcedureCodeDictionaryID = @procedure_id
	)
		RETURN 0
	
	RETURN 1
END

GO
PRINT N'Altering [dbo].[InsurancePlanDataProvider_GetPlanPractices]'
GO

--===========================================================================
-- GET PLAN PRACTICES
--===========================================================================
ALTER PROCEDURE dbo.InsurancePlanDataProvider_GetPlanPractices
	@plan_id INT,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT
AS
BEGIN

	DECLARE @EClaimsAccepts BIT
	DECLARE @EClaimsRequiresEnrollment BIT
	DECLARE @EClaimsRequiresTest BIT
	DECLARE @EClaimsRequiresProviderID BIT

	SELECT @EClaimsAccepts=ICP.EClaimsAccepts, @EClaimsRequiresEnrollment=CPL.IsEnrollmentRequired,
				@EClaimsRequiresTest=CPL.IsTestRequired, @EClaimsRequiresProviderID=CPL.IsProviderIdRequired
	FROM InsuranceCompanyPlan ICP
		LEFT OUTER JOIN ClearinghousePayersList CPL
		ON ICP.ClearinghousePayerID = CPL.ClearinghousePayerID
	WHERE	ICP.InsuranceCompanyPlanID = @plan_id
	

	SELECT	ICP.InsuranceCompanyPlanID,
		P.PracticeID,
		P.Name,
		PTICP.EClaimsProviderID,
		ISNULL(PTICP.EClaimsDisable, 0) AS EClaimsDisable,
		ISNULL(ICP.EClaimsAccepts, @EClaimsAccepts) AS EClaimsAccepts,
		ISNULL(CPL.IsTestRequired, @EClaimsRequiresTest) AS EClaimsRequiresTest,
		ISNULL(CPL.IsEnrollmentRequired, @EClaimsRequiresEnrollment) AS EClaimsRequiresEnrollment,
		ISNULL(CPL.IsProviderIdRequired, @EClaimsRequiresProviderID) AS EClaimsRequiresProviderID,
		PTICP.EClaimsEnrollmentStatusID,
		CEST.EnrollmentStatusName,
		CAST ('Payer not setup' AS VARCHAR(50)) AS EClaimsStatus,
		CAST(1 AS BIT) AS Deletable,
		IDENTITY(int, 0, 1) as RID
	INTO 
		#t_InsuranceCompanyPlanPractices
	FROM	PRACTICE P
	LEFT OUTER JOIN PracticeToInsuranceCompanyPlan PTICP
		ON P.PracticeID = PTICP.PracticeID 
	LEFT OUTER JOIN InsuranceCompanyPlan ICP
		ON ICP.InsuranceCompanyPlanID = PTICP.InsuranceCompanyPlanID 
	LEFT OUTER JOIN ClearinghouseEnrollmentStatusType CEST
		ON PTICP.EClaimsEnrollmentStatusID = CEST.EnrollmentStatusID 
	INNER JOIN ClearinghousePayersList CPL
		ON ICP.ClearinghousePayerID = CPL.ClearinghousePayerID
	WHERE	ICP.InsuranceCompanyPlanID = @plan_id OR ICP.InsuranceCompanyPlanID IS NULL
	ORDER BY P.Name

	-- overwrite the default 'Payer not setup':
	UPDATE #t_InsuranceCompanyPlanPractices
	SET EClaimsStatus = 'Practice not enrolled' WHERE EClaimsAccepts = 1 AND EClaimsRequiresEnrollment = 1 AND (EClaimsEnrollmentStatusID IS NULL OR EClaimsEnrollmentStatusID = 0)

	UPDATE #t_InsuranceCompanyPlanPractices
	SET EClaimsStatus = 'Enrolled (test)' WHERE EClaimsAccepts = 1 AND EClaimsRequiresEnrollment = 1 AND EClaimsRequiresTest = 1 AND EClaimsEnrollmentStatusID = 3

	UPDATE #t_InsuranceCompanyPlanPractices
	SET EClaimsStatus = 'Enrolled (live)' WHERE EClaimsAccepts = 1 AND EClaimsRequiresEnrollment = 1 AND EClaimsEnrollmentStatusID = 2

	UPDATE #t_InsuranceCompanyPlanPractices
	SET EClaimsStatus = 'Enrolled (live)' WHERE EClaimsAccepts = 1 AND EClaimsRequiresEnrollment = 0

	UPDATE #t_InsuranceCompanyPlanPractices
	SET EClaimsStatus = 'Pending enrollment' WHERE EClaimsAccepts = 1 AND EClaimsRequiresEnrollment = 1 AND EClaimsEnrollmentStatusID = 1

	UPDATE #t_InsuranceCompanyPlanPractices
	SET EClaimsStatus = 'Disabled' WHERE EClaimsDisable = 1
	
	UPDATE #t_InsuranceCompanyPlanPractices
	SET EClaimsStatus = 'Payer not setup' WHERE EClaimsAccepts = 0


	SELECT @totalRecords = COUNT(*)
	FROM #t_InsuranceCompanyPlanPractices
	
	IF @maxRecords = 0
		SET @maxRecords = @totalRecords
		
	SELECT *
	FROM #t_InsuranceCompanyPlanPractices
	WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
	
	DROP TABLE #t_InsuranceCompanyPlanPractices
	RETURN
END

GO
PRINT N'Altering [dbo].[DoctorDataProvider_GetDoctors]'
GO

--===========================================================================
-- GET DOCTORS
--===========================================================================
ALTER PROCEDURE dbo.DoctorDataProvider_GetDoctors
	@practice_id INT,
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(50) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON
	
	CREATE TABLE #t_doctors(
		DoctorID int,
		PracticeID int,
		Prefix varchar(16), 
		FirstName varchar(64), 
		MiddleName varchar(64), 
		LastName varchar(64), 
		Suffix varchar(16), 
		Degree varchar(8), 
		WorkPhone varchar(10), 
		WorkPhoneExt varchar(10), 
		MobilePhone varchar(10), 
		MobilePhoneExt varchar(10), 
		HomePhone varchar(10), 
		HomePhoneExt varchar(10), 
		PagerPhone varchar(10), 
		PagerPhoneExt varchar(10), 
		EmailAddress varchar(256), 
		Deletable bit, 
		HasAppointments bit, 
		RID int IDENTITY(0,1)
	)

	INSERT INTO #t_doctors(
		DoctorID,
		PracticeID,
		Prefix, 
		FirstName, 
		MiddleName, 
		LastName, 
		Suffix, 
		Degree, 
		WorkPhone, 
		WorkPhoneExt, 
		MobilePhone, 
		MobilePhoneExt, 
		HomePhone, 
		HomePhoneExt, 
		PagerPhone, 
		PagerPhoneExt, 
		EmailAddress, 
		Deletable, 
		HasAppointments
	)
	SELECT	D.DoctorID,
		D.PracticeID,
		D.Prefix,
		D.FirstName,
		D.MiddleName,
		D.LastName,
		D.Suffix,
		D.Degree,
		D.WorkPhone, 
		D.WorkPhoneExt, 
		D.MobilePhone, 
		D.MobilePhoneExt, 
		D.HomePhone, 
		D.HomePhoneExt, 
		D.PagerPhone, 
		D.PagerPhoneExt, 
		D.EmailAddress, 
		CAST(CASE WHEN (D1.DoctorID IS NULL) and (H.DoctorID IS NULL) THEN 1 ELSE 0 END AS BIT) AS Deletable, 
		CASE WHEN H.DoctorID IS NULL THEN 0 ELSE 1 END AS HasAppointments
	FROM	DOCTOR D
	LEFT OUTER JOIN (SELECT DISTINCT DoctorID FROM Encounter WHERE PracticeID = @practice_id) D1
	ON	   D1.DoctorID = D.DoctorID
	LEFT OUTER JOIN (SELECT DISTINCT ATR.ResourceID as DoctorID FROM Appointment A INNER JOIN AppointmentToResource ATR ON ATR.AppointmentID = A.AppointmentID AND ATR.AppointmentResourceTypeID = 1 WHERE A.PracticeID = @practice_id) H
	ON	   H.DoctorID = D.DoctorID
	WHERE	D.PracticeID = @practice_id
	AND	(	(@query_domain IS NULL OR @query IS NULL)
	OR	(	(@query_domain = 'DoctorName'
				OR @query_domain = 'All')
				AND (D.FirstName LIKE '%' + @query + '%'
				OR D.MiddleName LIKE '%' + @query + '%'
				OR D.LastName LIKE '%' + @query + '%'
				OR (D.FirstName + D.LastName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%'
				OR (D.LastName + D.FirstName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%'))
	OR 	(	(@query_domain = 'DoctorWorkPhone'
				OR @query_domain = 'All')
				AND (D.WorkPhone LIKE '%' + @query + '%'
				OR  D.WorkPhoneExt LIKE '%' + @query + '%'))
	OR 	(	(@query_domain = 'DoctorMobilePhone'
				OR @query_domain = 'All')
				AND (D.MobilePhone LIKE '%' + @query + '%'
				OR  D.MobilePhoneExt LIKE '%' + @query + '%'))
	OR 	(	(@query_domain = 'DoctorHomePhone'
				OR @query_domain = 'All')
				AND (D.HomePhone LIKE '%' + @query + '%'
				OR  D.HomePhoneExt LIKE '%' + @query + '%'))
	OR 	(	(@query_domain = 'DoctorEmail'
				OR @query_domain = 'All')
				AND (D.EmailAddress LIKE '%' + @query + '%'))
	OR 	(	(@query_domain = 'DoctorSSN'
				OR @query_domain = 'All')
				AND (D.SSN LIKE '%' + REPLACE(@query, '-', '') + '%'))
--	OR	(	(@query_domain = 'DoctorUPIN'
--				OR @query_domain = 'All')
--				AND (D.UPIN LIKE '%' + @query + '%'))
	)
	ORDER BY D.LastName
	
	SELECT @totalRecords = COUNT(*)
	FROM #t_doctors
	
	IF @maxRecords = 0
		SET @maxRecords = @totalRecords
		
	SELECT *
	FROM #t_doctors
	WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
	
	DROP TABLE #t_doctors
	RETURN
END


GO
PRINT N'Altering [dbo].[Handheld_DiagnosisDataProvider_GetDiagnosisCodes]'
GO

--===========================================================================
-- GET DIAGNOSIS CodeS
--===========================================================================
ALTER PROCEDURE dbo.Handheld_DiagnosisDataProvider_GetDiagnosisCodes
	@practice_id INT,
	@sync_date DATETIME
AS
BEGIN
	IF EXISTS (
		SELECT	*
		FROM	DIAGNOSISCODEDICTIONARY DCD
			INNER JOIN DIAGNOSISCODEDICTIONARYTOCODINGTEMPLATE DTT
			ON DTT.DiagnosisCodeDictionaryID = DCD.DiagnosisCodeDictionaryID
			INNER JOIN CodingTemplate CT
			ON CT.CodingTemplateID = DTT.CodingTemplateID
		WHERE	CT.PracticeID = @practice_id
		AND	(DCD.ModifiedDate > @sync_date
			OR DCD.CreatedDate > @sync_date
			OR DTT.ModifiedDate > @sync_date
			OR DTT.CreatedDate > @sync_date
			OR CT.ModifiedDate > @sync_date
			OR CT.CreatedDate > @sync_date))
	BEGIN
		SELECT	DISTINCT DCD.DiagnosisCodeDictionaryID,
			DCD.DiagnosisCode,
			DCD.DiagnosisName,
			DCD.Description
		FROM	DIAGNOSISCODEDICTIONARY DCD
			INNER JOIN DIAGNOSISCODEDICTIONARYTOCODINGTEMPLATE DTT
			ON DTT.DiagnosisCodeDictionaryID = DCD.DiagnosisCodeDictionaryID
			INNER JOIN CodingTemplate CT
			ON CT.CodingTemplateID = DTT.CodingTemplateID
		WHERE	PracticeID = @practice_id
	END 
END


GO
PRINT N'Altering [dbo].[Handheld_DiagnosisDataProvider_GetDiagnosisToTemplate]'
GO

--===========================================================================
-- GET DIAGNOSIS TO TEMPLATE
--===========================================================================
ALTER PROCEDURE dbo.Handheld_DiagnosisDataProvider_GetDiagnosisToTemplate
	@practice_id INT,
	@sync_date DATETIME
AS
BEGIN
	IF EXISTS (
		SELECT	*
		FROM	DIAGNOSISCODEDICTIONARYTOCODINGTEMPLATE DTT
			INNER JOIN CodingTemplate CT
			ON CT.CodingTemplateID = DTT.CodingTemplateID
		WHERE	CT.PracticeID = @practice_id
		AND	(DTT.ModifiedDate > @sync_date
			OR DTT.CreatedDate > @sync_date
			OR CT.ModifiedDate > @sync_date
			OR CT.CreatedDate > @sync_date))
	BEGIN
		SELECT	DISTINCT DTT.ID_PK AS DIAGNOSISCODEDICTIONARYTOCodingTemplateID,
			DTT.DiagnosisCodeDictionaryID,
			DTT.CodingTemplateID
		FROM	DIAGNOSISCODEDICTIONARYTOCODINGTEMPLATE DTT
			INNER JOIN CodingTemplate CT
			ON CT.CodingTemplateID = DTT.CodingTemplateID
		WHERE	PracticeID = @practice_id
	END
END


GO
PRINT N'Altering [dbo].[BillDataProvider_CreateEDIBatch]'
GO

--===========================================================================
-- CREATE EDI BATCH
--===========================================================================
ALTER PROCEDURE dbo.BillDataProvider_CreateEDIBatch
	@practice_id INT
AS
BEGIN
	--Create batch.
	DECLARE @batch_id INT
	DECLARE @dt datetime
	SET @dt = GETDATE()

	INSERT	BillBatch (PracticeID, BillBatchTypeCode, CreatedDate)
	VALUES	(@practice_id, 'E', GETDATE())

	SET @batch_id = SCOPE_IDENTITY()

	--Retrieve ready claims.
	DECLARE @claim_id INT
	DECLARE @payer_id INT
	DECLARE @payer_code CHAR(1)

	SELECT	C.ClaimID,
			CP.PatientInsuranceID,
			CASE 
				WHEN CP.Precedence = 1 THEN 'P'
				WHEN CP.Precedence = 2 THEN 'S'
				WHEN CP.Precedence > 2 AND EXISTS (
					SELECT	*
					FROM	ClaimPayer CPP
					WHERE	CPP.ClaimID = CP.ClaimID
					AND	CPP.Precedence > CP.Precedence)
					THEN 'S'
				ELSE 'T'
				END AS Payer_Code
	INTO #t
		FROM	Claim C
			INNER JOIN ClaimPayer CP
				INNER JOIN PatientInsurance PI
				ON PI.PatientInsuranceID = CP.PatientInsuranceID
				INNER JOIN InsuranceCompanyPlan ICP
					LEFT OUTER JOIN ClearinghousePayersList CPL
					ON ICP.ClearinghousePayerID = CPL.ClearinghousePayerID
				ON ICP.InsuranceCompanyPlanID = PI.InsuranceCompanyPlanID
			ON CP.ClaimID = C.ClaimID
			AND CAST(CP.Precedence AS VARCHAR) = 
				C.AssignmentIndicator
			INNER JOIN Practice PR
			ON C.PracticeID = PR.PracticeID
			LEFT OUTER JOIN PracticeToInsuranceCompanyPlan PTICP
			ON PTICP.PracticeID = PR.PracticeID AND PTICP.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
		WHERE	C.PracticeID = @practice_id
	-- see ClaimDataProvider.sql: ClaimDataProvider_GetClaims (and keep the code there in sync)
		AND C.ClaimStatusCode = 'R'
		AND PR.EClaimsEnrollmentStatusID > 1
		AND ICP.EClaimsAccepts = 1 AND (PTICP.EClaimsDisable IS NULL OR PTICP.EClaimsDisable = 0)
		AND CPL.PayerNumber IS NOT NULL
		AND (CPL.IsEnrollmentRequired = 0 OR PTICP.EClaimsEnrollmentStatusID > 1) 
		AND C.AssignmentIndicator IS NOT NULL
		AND C.AssignmentIndicator <> 'P'
		AND C.AutoAccidentRelatedFlag = 0
		AND C.EmploymentRelatedFlag = 0
		AND C.NonElectronicOverrideFlag <> 1
		AND CP.Precedence = 1
		AND NOT EXISTS (SELECT	CT.ClaimTransactionID
				FROM	ClaimTransaction CT
				WHERE	CT.ClaimID = CP.ClaimID AND CT.ClaimTransactionTypeCode = 'ADJ')
	
		-- here is a sanity check: claims will show up in the list but will not be submitted, and will stay in the list:
		AND NOT (C.HospitalizationBeginDate IS NULL AND C.PlaceOfServiceCode IN (21,51))

	CREATE UNIQUE CLUSTERED INDEX #t_claim ON #t (ClaimID)

	DECLARE claim_cursor CURSOR READ_ONLY
	FOR	
		SELECT * FROM #t
	
	OPEN claim_cursor

	-- PRINT CAST(DATEDIFF(ms, @dt, GETDATE()) AS varchar(12)) + ' ms'
	-- PRINT 'Cursor opened'
	FETCH NEXT FROM claim_cursor
	INTO	@claim_id,
		@payer_id,
		@payer_code
	/*	
	print 'claim_id'
	PRINT @claim_id
	print 'payer_id'
	print @payer_id
	print 'payer_code'
	print @payer_code
	
	IF @@FETCH_STATUS <> 10
	BEGIN
		PRINT CAST(DATEDIFF(ms, @dt, GETDATE()) AS varchar(12)) + ' ms'
		PRINT 'IF @@FETCH_STATUS = 10'
	END
	*/
	
	
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		--PRINT CAST(DATEDIFF(ms, @dt, GETDATE()) AS varchar(12)) + ' ms'
		--PRINT 'Inside Begin'
		--Check for existing bill to add this to.
		DECLARE @bill_id INT
		SET @bill_id = (
			SELECT	B.BillID
			FROM	Bill_EDI B
				INNER JOIN Claim C
				ON C.ClaimID = B.RepresentativeClaimID
				INNER JOIN Claim CC
				ON CC.ClaimID = @claim_id
			WHERE	B.BillBatchID = @batch_id
			AND	B.PayerPatientInsuranceID = @payer_id
			AND	B.PayerResponsibilityCode = @payer_code
			AND	CC.PatientID = C.PatientID
			AND	CC.FacilityID = C.FacilityID
			AND	CC.RenderingProviderID = C.RenderingProviderID
			AND	CC.ReferringProviderID = C.ReferringProviderID
			AND	CC.AuthorizationID = C.AuthorizationID
			AND	CC.DiagnosisCode1 = C.DiagnosisCode1
			AND	CC.DiagnosisCode2 = C.DiagnosisCode2
			AND	CC.DiagnosisCode3 = C.DiagnosisCode3
			AND	CC.DiagnosisCode4 = C.DiagnosisCode4
			AND	CC.DiagnosisCode5 = C.DiagnosisCode5
			AND	CC.DiagnosisCode6 = C.DiagnosisCode6
			AND	CC.DiagnosisCode7 = C.DiagnosisCode7
			AND	CC.DiagnosisCode8 = C.DiagnosisCode8
			AND	CC.CurrentIllnessDate = C.CurrentIllnessDate
			AND	CC.SimilarIllnessDate = C.SimilarIllnessDate
			AND	CC.InitialTreatmentDate = C.InitialTreatmentDate
			AND	CC.LastWorkedDate = C.LastWorkedDate
			AND	CC.ReturnToWorkDate = C.ReturnToWorkDate
			AND	CC.DisabilityBeginDate = C.DisabilityBeginDate
			AND	CC.DisabilityEndDate = C.DisabilityEndDate
			AND	CC.HospitalizationBeginDate = C.HospitalizationBeginDate
			AND	CC.HospitalizationEndDate = C.HospitalizationEndDate
			AND	CC.ReferralDate = C.ReferralDate
			AND	CC.LastSeenDate = C.LastSeenDate
			AND	CC.LastXrayDate = C.LastXrayDate
			AND	CC.AcuteManifestationDate = C.AcuteManifestationDate
			AND	CC.AutoAccidentRelatedFlag = C.AutoAccidentRelatedFlag
			AND	CC.AutoAccidentRelatedState = C.AutoAccidentRelatedState
			AND	CC.AbuseRelatedFlag = C.AbuseRelatedFlag
			AND	CC.EmploymentRelatedFlag = C.EmploymentRelatedFlag
			AND	CC.OtherAccidentRelatedFlag = C.OtherAccidentRelatedFlag
			AND	CC.SpecialProgramCode = C.SpecialProgramCode
			AND	CC.PropertyCasualtyClaimNumber = C.PropertyCasualtyClaimNumber)

--PRINT CAST(DATEDIFF(ms, @dt, GETDATE()) AS varchar(12)) + ' ms'
--PRINT 'Billid found'
	
		IF (@bill_id IS NULL)
		BEGIN
			INSERT	Bill_EDI (
				BillBatchID,
				RepresentativeClaimID,
				PayerPatientInsuranceID,
				PayerResponsibilityCode)
			VALUES	(
				@batch_id,
				@claim_id,
				@payer_id,
				@payer_code)

			SET @bill_id = SCOPE_IDENTITY()
		END

		--Add the claim to the bill.
		INSERT	BillClaim (BillID, BillBatchTypeCode, ClaimID)
		VALUES	(@bill_id, 'E', @claim_id)

		FETCH NEXT FROM claim_cursor
		INTO	@claim_id,
			@payer_id,
			@payer_code
	END
--PRINT CAST(DATEDIFF(ms, @dt, GETDATE()) AS varchar(12)) + ' ms'
--PRINT 'Cursor about to be closed'

	CLOSE claim_cursor
	DEALLOCATE claim_cursor
	
--PRINT CAST(DATEDIFF(ms, @dt, GETDATE()) AS varchar(12)) + ' ms'	
--PRINT 'Cursor closed'

	DROP TABLE #t
	
	RETURN @batch_id
END


GO
PRINT N'Creating [dbo].[ReportDataProvider_ARAgingDetailTest]'
GO

--===========================================================================
-- SRS Refunds Summary
/*
select * from claimtransaction where claimid = 48365 order by claimtransactionid desc
select * from insurancecompanyplan where insurancecompanyplanid = 19032

ReportDataProvider_ARAgingDetailTest 42, '11/4/2004', 'I', 19032
ReportDataProvider_ARAgingDetailTest 37, '11/4/2004', 'I', 18382
ReportDataProvider_ARAgingDetailTest 37, '11/4/2004', 'I', 18382
*/
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_ARAgingDetailTest
	@PracticeID int = NULL
	,@EndDate datetime = NULL
	,@RespType char(1) = I
	,@RespID int = 0
AS
BEGIN
	SET @EndDate = DATEADD(s, -1, DATEADD(d,1,dbo.fn_DateOnly(@EndDate)))

	CREATE TABLE #OpenClaimList(ClaimID int, MostRecentTransID int)
	
	--Find all of the claims that were NOT
	--paid off BY the END date
	INSERT #OpenClaimList(ClaimID, MostRecentTransID)
	SELECT CT.ClaimID
		, MAX(CT.ClaimTransactionID) AS MaxTransID 
	FROM dbo.ClaimTransaction CT
	WHERE CT.PracticeID = @PracticeID
		AND CT.TransactionDate <= @EndDate
	GROUP BY CT.ClaimID
	HAVING MIN(CT.Claim_TotalBalance) > 0

	CREATE UNIQUE CLUSTERED INDEX UX_#OpenClaimList_ClaimID ON #OpenClaimList(ClaimID)
		WITH FILLFACTOR = 100

	--Update the #OpenClaimList to use the max transaction of a BLL or ASN type
	UPDATE	#OpenClaimList
	SET	MostRecentTransID = C.MaxTranID
	FROM	#OpenClaimList OCL
	INNER JOIN
		(SELECT CT.ClaimID, MAX(CT.ClaimTransactionID) AS MaxTranID 
		 FROM dbo.ClaimTransaction CT
		 INNER JOIN #OpenClaimList OCL
		 ON CT.ClaimID = OCL.ClaimID
		 WHERE CT.PracticeID = @PracticeID
		 AND CT.TransactionDate <= @EndDate
		 AND CT.ClaimTransactionTypeCode IN( 'BLL', 'ASN' )
		 GROUP BY CT.ClaimID) C
	ON	C.ClaimID = OCL.CLaimID

/*		SELECT CT.ClaimID, MAX(CT.ClaimTransactionID) AS MaxTranID 
		 FROM dbo.ClaimTransaction CT
		 INNER JOIN #OpenClaimList OCL
		 ON CT.ClaimID = OCL.ClaimID
		 WHERE CT.PracticeID = @PracticeID
		 AND CT.TransactionDate <= @EndDate
		 AND CT.ClaimTransactionTypeCode IN( 'BLL', 'ASN' )
		 GROUP BY CT.ClaimID
*/
/*	
	--Find the last bill, less than or equal to the END date
	INSERT INTO #LastBilledTransaction(LastBilledTransactionID)
	SELECT MAX(CT.ClaimTransactionID) AS MaxTranID 
	FROM dbo.ClaimTransaction CT
		INNER JOIN #OpenClaimList OCL
		ON CT.ClaimID = OCL.ClaimID
	WHERE CT.PracticeID = @PracticeID
		AND CT.TransactionDate <= @EndDate
		AND CT.ClaimTransactionTypeCode IN( 'BLL', 'ASN', 'PAY' )
	GROUP BY CT.ClaimID
*/	
	
	CREATE TABLE #ARList (
		BillID int
		, Code varchar(10)
		, RespType varchar(9) 
		, RespName varchar(128)
		, ClaimID int
		, ServiceDate datetime
		, ProcedureCode varchar(48)
		, PatientFullname varchar(128)
		, AdjustedCharges money
		, Receipts money
		, BilledDate datetime
		, Aging int
		, OpenBalance money
		, ClaimTransactionID int
		, PatientID int
		, InsuranceCompanyPlanID int
	)
	
	--	
	IF @RespType = 'I'
	BEGIN	
		INSERT #ARList(
			BillID
			, Code
			, RespType
			, RespName
			, ClaimID
			, ServiceDate
			, ProcedureCode
			, PatientFullname
			, AdjustedCharges
			, Receipts
			, BilledDate
			, Aging
			, OpenBalance
			, ClaimTransactionID
			, PatientID
		)
		SELECT CTBilled.ReferenceID AS BillID 
			, CTBilled.Code
			, 'Insurance' AS RespType
			, 'Insurance' AS RespName
			, C.ClaimID
			, C.ServiceBeginDate AS ServiceDate
			, C.ProcedureCode
			, RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')) AS PatientFullname
			, (CTBal.Claim_Amount - CTBal.Claim_TotalAdjustments) AS AdjustedCharges
			, CTBal.Claim_TotalPayments AS Receipts
			, CTBilled.TransactionDate AS BilledDate
			, DATEDIFF(d,CTBilled.TransactionDate, @EndDate) AS Aging
			, CTBal.Claim_TotalBalance AS OpenBalance
			, CTBilled.ClaimTransactionID
			, C.PatientID
		FROM dbo.ClaimTransaction CTBilled
			INNER JOIN #OpenClaimList OCL
			ON CTBilled.ClaimID = OCL.ClaimID 
			AND CTBilled.ClaimTransactionID = OCL.MostRecentTransID 
			INNER JOIN dbo.ClaimTransaction CTBal
			ON OCL.MostRecentTransID = CTBal.ClaimTransactionID
			INNER JOIN dbo.Claim C
			ON CTBilled.ClaimID = C.ClaimID
			INNER JOIN dbo.Patient P
			ON C.PatientID = P.PatientID
		WHERE CTBilled.PracticeID = @PracticeID
			AND CTBilled.TransactionDate <= @EndDate
			AND CTBal.PracticeID = @PracticeID
			AND C.PracticeID = @PracticeID
			AND P.PracticeID = @PracticeID
			AND CTBilled.Code IN ('1','2')
--select * from #arlist where claimid = 48365
	END
	ELSE IF @RespType = 'P'
	BEGIN	
		INSERT #ARList(
			BillID
			, Code
			, RespType
			, RespName
			, ClaimID
			, ServiceDate
			, ProcedureCode
			, PatientFullname
			, AdjustedCharges
			, Receipts
			, BilledDate
			, Aging
			, OpenBalance
			, ClaimTransactionID
			, PatientID
		)
		SELECT CTBilled.ReferenceID AS BillID 
			, CTBilled.Code
			, 'Patient' AS RespType
			, RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')) AS RespName
			, C.ClaimID
			, C.ServiceBeginDate AS ServiceDate
			, C.ProcedureCode
			, RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')) AS PatientFullname
			, (CTBal.Claim_Amount - CTBal.Claim_TotalAdjustments) AS AdjustedCharges
			, CTBal.Claim_TotalPayments AS Receipts
			, CTBilled.TransactionDate AS BilledDate
			, DATEDIFF(d,CTBilled.TransactionDate, @EndDate) AS Aging
			, CTBal.Claim_TotalBalance AS OpenBalance
			, CTBilled.ClaimTransactionID
			, C.PatientID
		FROM dbo.ClaimTransaction CTBilled
			INNER JOIN #OpenClaimList OCL
			ON CTBilled.ClaimID = OCL.ClaimID 
			AND CTBilled.ClaimTransactionID = OCL.MostRecentTransID 
			INNER JOIN dbo.ClaimTransaction CTBal
			ON OCL.MostRecentTransID = CTBal.ClaimTransactionID
			INNER JOIN dbo.Claim C
			ON CTBilled.ClaimID = C.ClaimID
			INNER JOIN dbo.Patient P
			ON C.PatientID = P.PatientID
		WHERE CTBilled.PracticeID = @PracticeID
			AND CTBilled.TransactionDate <= @EndDate
			AND CTBal.PracticeID = @PracticeID
			AND C.PracticeID = @PracticeID
			AND P.PracticeID = @PracticeID
			AND (@RespType = 'P' AND C.PatientID = @RespID AND CTBilled.Code = 'P')
	END
	/*
	ELSE IF @RespType = 'O'
	BEGIN
		INSERT #ARList(
			BillID
			, Code
			, RespType
			, RespName
			, ClaimID
			, ServiceDate
			, ProcedureCode
			, PatientFullname
			, AdjustedCharges
			, Receipts
			, BilledDate
			, Aging
			, OpenBalance
			, ClaimTransactionID
			, PatientID
		)
		SELECT CTBilled.ReferenceID AS BillID 
			, CTBilled.Code
			, 'Other' AS RespType
			, 'RespName' AS RespName
			, C.ClaimID
			, C.ServiceBeginDate AS ServiceDate
			, C.ProcedureCode
			, RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')) AS PatientFullname
			, (CTBal.Claim_Amount - CTBal.Claim_TotalAdjustments) AS AdjustedCharges
			, CTBal.Claim_TotalPayments AS Receipts
			, CTBilled.TransactionDate AS BilledDate
			, DATEDIFF(d,CTBilled.TransactionDate, @EndDate) AS Aging
			, CTBal.Claim_TotalBalance AS OpenBalance
			, CTBilled.ClaimTransactionID
			, C.PatientID
		FROM dbo.ClaimTransaction CTBilled
			INNER JOIN #LastBilledTransaction LBT
			ON CTBilled.ClaimTransactionID = LBT.LastBilledTransactionID
			INNER JOIN #OpenClaimList OCL
			ON CTBilled.ClaimID = OCL.ClaimID 
			INNER JOIN dbo.ClaimTransaction CTBal
			ON OCL.MostRecentTransID = CTBal.ClaimTransactionID
			INNER JOIN dbo.Claim C
			ON CTBilled.ClaimID = C.ClaimID
			INNER JOIN dbo.Patient P
			ON C.PatientID = P.PatientID
		WHERE CTBilled.PracticeID = @PracticeID
			AND CTBilled.TransactionDate <= @EndDate
			AND CTBal.PracticeID = @PracticeID
			AND C.PracticeID = @PracticeID
			AND P.PracticeID = @PracticeID
			AND (CTBilled.Code IS NULL OR CTBilled.Code NOT IN ('P','1','2'))
	END
	*/
	ELSE
	BEGIN
		INSERT #ARList(
			BillID
			, Code
			, RespType
			, RespName
			, ClaimID
			, ServiceDate
			, ProcedureCode
			, PatientFullname
			, AdjustedCharges
			, Receipts
			, BilledDate
			, Aging
			, OpenBalance
			, ClaimTransactionID
			, PatientID
		)
		SELECT CTBilled.ReferenceID AS BillID 
			, CTBilled.Code
			,CASE
				WHEN CTBilled.Code IN ('1', '2') THEN 'Insurance'
				WHEN CTBilled.Code = 'P' THEN 'Patient'
				ELSE 'Other'
			END AS RespType
			,CASE
				WHEN CTBilled.Code IN ('1', '2') THEN CAST('Insurance' AS varchar(128))
				WHEN CTBilled.Code = 'P' THEN RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, ''))
				ELSE 'RespName'
			END AS RespName
			, C.ClaimID
			, C.ServiceBeginDate AS ServiceDate
			, C.ProcedureCode
			, RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')) AS PatientFullname
			, (CTBal.Claim_Amount - CTBal.Claim_TotalAdjustments) AS AdjustedCharges
			, CTBal.Claim_TotalPayments AS Receipts
			, CTBilled.TransactionDate AS BilledDate
			, DATEDIFF(d,CTBilled.TransactionDate, @EndDate) AS Aging
			, CTBal.Claim_TotalBalance AS OpenBalance
			, CTBilled.ClaimTransactionID
			, C.PatientID
		FROM dbo.ClaimTransaction CTBilled
			INNER JOIN #OpenClaimList OCL
			ON CTBilled.ClaimID = OCL.ClaimID 
			AND CTBilled.ClaimTransactionID = OCL.MostRecentTransID 
			INNER JOIN dbo.ClaimTransaction CTBal
			ON OCL.MostRecentTransID = CTBal.ClaimTransactionID
			INNER JOIN dbo.Claim C
			ON CTBilled.ClaimID = C.ClaimID
			INNER JOIN dbo.Patient P
			ON C.PatientID = P.PatientID
		WHERE CTBilled.PracticeID = @PracticeID
			AND CTBilled.TransactionDate <= @EndDate
			AND CTBal.PracticeID = @PracticeID
			AND C.PracticeID = @PracticeID
			AND P.PracticeID = @PracticeID
	END
	--	
	
	IF @RespType IN ('I', 'A')
	BEGIN
		UPDATE T
			SET RespName = ICP1.PlanName,
				InsuranceCompanyPlanID = PI1.InsuranceCompanyPlanID
		FROM #ARList T
			INNER JOIN dbo.Bill_EDI BE
			ON  T.BillID = BE.BillID
			INNER JOIN dbo.PatientInsurance PI1
			ON BE.PayerPatientInsuranceID = PI1.PatientInsuranceID
			INNER JOIN dbo.InsuranceCompanyPlan ICP1
			ON PI1.InsuranceCompanyPlanID = ICP1.InsuranceCompanyPlanID
			INNER JOIN dbo.BillBatch BB
			ON BE.BillBatchID = BB.BillBatchID
		WHERE RespType = 'Insurance'
			AND RespName = 'Insurance'
			AND BB.ConfirmedDate IS NOT NULL
/*
select * from claimtransaction where claimid = 48365 order by claimtransactionid desc
select * from bill_hcfa where billid = 7977
select * from patientinsurance where patientinsuranceid = 218880
select * from insurancecompanyplan where insurancecompanyplanid = 16170

*/
		
		UPDATE T
			SET RespName = ICP1.PlanName,
				InsuranceCompanyPlanID = PI1.InsuranceCompanyPlanID
		FROM #ARList T
			INNER JOIN dbo.Bill_HCFA BE
			ON  T.BillID = BE.BillID
			INNER JOIN dbo.PatientInsurance PI1
			ON BE.PayerPatientInsuranceID = PI1.PatientInsuranceID
			INNER JOIN dbo.InsuranceCompanyPlan ICP1
			ON PI1.InsuranceCompanyPlanID = ICP1.InsuranceCompanyPlanID
			INNER JOIN dbo.BillBatch BB
			ON BE.BillBatchID = BB.BillBatchID
		WHERE RespType = 'Insurance'
			AND T.RespName = 'Insurance'
			AND T.Code = '1'	
			AND BB.ConfirmedDate IS NOT NULL
		
		UPDATE T
			SET RespName = ICP1.PlanName,
				InsuranceCompanyPlanID = PI1.InsuranceCompanyPlanID
		FROM #ARList T
			INNER JOIN dbo.Bill_HCFA BH
			ON  T.BillID = BH.BillID
			INNER JOIN dbo.PatientInsurance PI1
			ON BH.OtherPayerPatientInsuranceID = PI1.PatientInsuranceID
			INNER JOIN dbo.InsuranceCompanyPlan ICP1
			ON PI1.InsuranceCompanyPlanID = ICP1.InsuranceCompanyPlanID
			INNER JOIN dbo.BillBatch BB
			ON BH.BillBatchID = BB.BillBatchID
		WHERE T.RespType = 'Insurance'
			AND T.RespName = 'Insurance'
			AND T.Code = '2'	
			AND BB.ConfirmedDate IS NOT NULL

	END

	IF @RespType = 'I'
	BEGIN
		--Only elminate the other data IF I IS passed
		DELETE #ARList WHERE InsuranceCompanyPlanID <> @RespID OR InsuranceCompanyPlanID IS NULL
	END		
	--
	SELECT *,
		CASE 
			WHEN Aging BETWEEN 0 and 30 THEN 1
			WHEN Aging BETWEEN 31 and 60 THEN 2
			WHEN Aging BETWEEN 61 and 90 THEN 3
			WHEN Aging BETWEEN 91 and 120 THEN 4
			WHEN Aging >= 12 THEN 5
		END AS AgeGroup
	FROM #ARList
--	WHERE BillID = 2685
	
	DROP TABLE #OpenClaimList
	DROP TABLE #ARList

	
	RETURN
END


GO
PRINT N'Altering [dbo].[InsurancePlanDataProvider_GetInsurancePlan]'
GO

--===========================================================================
-- GET INSURANCE PLAN
--===========================================================================
ALTER PROCEDURE dbo.InsurancePlanDataProvider_GetInsurancePlan
	@insurance_plan_id INT,
	@practice_id INT = NULL
AS
BEGIN
	SELECT	IP.InsuranceCompanyPlanID,
		IP.PlanName,
		IP.AddressLine1,
		IP.AddressLine2,
		IP.City,
		IP.State,
		IP.Country,
		IP.ZipCode,
		IP.ContactPrefix,
		IP.ContactFirstName,
		IP.ContactMiddleName,
		IP.ContactLastName,
		IP.ContactSuffix,
		IP.Phone,
		IP.PhoneExt,
		IP.Fax,
		IP.FaxExt,
		IP.CoPay,
		IP.InsuranceProgramCode,
		IP.ProviderNumberTypeID,
		IP.GroupNumberTypeID,
		IP.LocalUseProviderNumberTypeID,
		IP.HCFADiagnosisReferenceFormatCode,
		IP.HCFASameAsInsuredFormatCode,
		CPL.PayerNumber AS EDIPayerNumber,
		IP.Notes,
		IP.ReviewCode,
		IP.ClearinghousePayerID,
		CASE WHEN CPL.ClearinghousePayerID IS NULL THEN '' ELSE 'ProxyMed' END AS ClearinghouseDisplayName,
		(CPL.[Name] + '   (' + CAST(CPL.ClearinghousePayerID AS VARCHAR) + ')') AS ClearinghousePayerDisplayName,
		COALESCE(CPL.Notes,'') AS ClearinghouseNotes,
		CAST (CPL.IsGovernment AS INT) AS IsGovernment,
		CPL.StateSpecific,
		CAST (ISNULL(CPL.IsEnrollmentRequired,0) AS BIT) AS EClaimsRequiresEnrollment,
		CAST (ISNULL(CPL.IsAuthorizationRequired,0) AS BIT) AS EClaimsRequiresAuthorization,
		CAST (ISNULL(CPL.IsProviderIdRequired,0) AS BIT) AS EClaimsRequiresProviderID,
		CAST (ISNULL(CPL.IsTestRequired,0) AS BIT) AS EClaimsRequiresTest,
		CAST (ISNULL(CPL.IsPaperOnly,0) AS BIT) AS EClaimsPaperOnly,
		CAST (ISNULL(CPL.ResponseLevel,0) AS INT) AS EClaimsResponseLevel,
		IP.EClaimsAccepts,
		'Not approved' AS ApprovalStatus,
		CAST (dbo.BusinessRule_InsurancePlanIsDeletable(IP.InsuranceCompanyPlanID) AS BIT) AS Deletable,
		CASE WHEN IP.CreatedPracticeID IS NULL THEN 'Administrator' ELSE COALESCE(CP.Name + ' (','(') + COALESCE(CAST(CP.PracticeID AS VARCHAR),'0') + ')'  END AS CreatorPractice,
		@practice_id AS PracticeID,
		CreatedPracticeID,
		CAST (0 AS INT) AS EClaimsEnrollmentStatusID,
		CAST (0 AS BIT) AS EClaimsDisable, 
		IP.KareoInsuranceCompanyPlanID
	INTO 
		#t_InsuranceCompanyPlan
	FROM	InsuranceCompanyPlan IP
			LEFT OUTER JOIN ClearinghousePayersList CPL
			ON IP.ClearinghousePayerID = CPL.ClearinghousePayerID
		LEFT OUTER JOIN Practice CP ON CP.PracticeID = IP.CreatedPracticeID
	WHERE	IP.InsuranceCompanyPlanID = @insurance_plan_id

	UPDATE #t_InsuranceCompanyPlan
	SET ApprovalStatus = 'Approved' WHERE ReviewCode = 'R'

	IF @practice_id IS NOT NULL
	BEGIN
	    DECLARE @EClaimsRequiresEnrollment BIT
	    SELECT TOP 1
		@EClaimsRequiresEnrollment = EClaimsRequiresEnrollment
	    FROM
		#t_InsuranceCompanyPlan

	    UPDATE	
		#t_InsuranceCompanyPlan
	    SET EClaimsEnrollmentStatusID =
	    (SELECT TOP 1
		PTICP.EClaimsEnrollmentStatusID
	    FROM
		PracticeToInsuranceCompanyPlan PTICP
	    WHERE PTICP.InsuranceCompanyPlanID = @insurance_plan_id AND PTICP.PracticeID = @practice_id)

	    -- make "Enrolled in live mode" appear when "EClaimsRequiresEnrollment" is unchecked:
	    IF @EClaimsRequiresEnrollment = 0
	    BEGIN
		UPDATE	
		    #t_InsuranceCompanyPlan
	        SET EClaimsEnrollmentStatusID = 2 WHERE EClaimsEnrollmentStatusID IS NULL
	    END
	    ELSE
	    BEGIN
		UPDATE	
		    #t_InsuranceCompanyPlan
	        SET EClaimsEnrollmentStatusID = 0 WHERE EClaimsEnrollmentStatusID IS NULL
	    END

	    UPDATE	
		#t_InsuranceCompanyPlan
	    SET EClaimsDisable =
	    (SELECT TOP 1
		PTICP.EClaimsDisable
	    FROM
		PracticeToInsuranceCompanyPlan PTICP
	    WHERE PTICP.InsuranceCompanyPlanID = @insurance_plan_id AND PTICP.PracticeID = @practice_id)

	    UPDATE	
		#t_InsuranceCompanyPlan
	    SET EClaimsDisable = 0 
	    WHERE EClaimsDisable IS NULL
	END
	
	SELECT *
	FROM #t_InsuranceCompanyPlan
	
	DROP TABLE #t_InsuranceCompanyPlan
	RETURN
END

GO
PRINT N'Altering [dbo].[DoctorDataProvider_GetDoctor]'
GO

--===========================================================================
-- GET DOCTOR
--===========================================================================
ALTER PROCEDURE dbo.DoctorDataProvider_GetDoctor
	@doctor_id INT
AS
BEGIN
	SELECT	D.DoctorID,
		D.PracticeID,
		D.Prefix,
		D.FirstName,
		D.MiddleName,
		D.LastName,
		D.Suffix,
		D.Degree,
		D.SSN,
		D.DOB,
		D.AddressLine1,
		D.AddressLine2,
		D.City,
		D.State,
		D.ZipCode,
		D.Country,
		D.HomePhone,
		D.HomePhoneExt,
		D.WorkPhone,
		D.WorkPhoneExt,
		D.MobilePhone,
		D.MobilePhoneExt,
		D.PagerPhone,
		D.PagerPhoneExt,
		D.EmailAddress,
		D.Notes,
		D.ProviderSpecialtyCode,
		D.HipaaProviderTaxonomyCode,
		U.UserID, 
		U.EmailAddress AS UserName,
		CAST(dbo.BusinessRule_DoctorIsDeletable(DoctorID) AS BIT) AS Deletable, 
		dbo.BusinessRule_DoctorHasAppointments(DoctorID) AS HasAppointments
	FROM	DOCTOR D
		LEFT OUTER JOIN USERS U
		ON U.UserID = D.UserID
	WHERE	DoctorID = @doctor_id
END


GO
PRINT N'Altering [dbo].[BillDataProvider_GetEDIBatchXML]'
GO

--===========================================================================
-- GET EDI BATCH XML
--===========================================================================
ALTER PROCEDURE dbo.BillDataProvider_GetEDIBatchXML
	@batch_id INT
AS
BEGIN
	SELECT	1 AS Tag, NULL AS Parent,
		BillBatchID AS [transaction!1!transaction-id],
		CONVERT(VARCHAR,BillBatchID) AS [transaction!1!control-number],
		CreatedDate AS [transaction!1!created-date],
		GETDATE() AS [transaction!1!current-date],
		NULL AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!ein],
		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],
		NULL AS [subscriber!3!subscriber-id],
		NULL AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
		NULL AS [subscriber!3!responsible-different-than-patient-flag],
		NULL AS [subscriber!3!responsible-first-name],
		NULL AS [subscriber!3!responsible-middle-name],
		NULL AS [subscriber!3!responsible-last-name],
		NULL AS [subscriber!3!responsible-suffix],
		NULL AS [subscriber!3!responsible-street-1],
		NULL AS [subscriber!3!responsible-street-2],
		NULL AS [subscriber!3!responsible-city],
		NULL AS [subscriber!3!responsible-state],
		NULL AS [subscriber!3!responsible-zip],
		NULL AS [patient!4!patient-id],
		NULL AS [patient!4!relation-to-insured-code],
		NULL AS [patient!4!dependent-policy-number],
		NULL AS [patient!4!first-name],
		NULL AS [patient!4!middle-name],
		NULL AS [patient!4!last-name],
		NULL AS [patient!4!suffix],
		NULL AS [patient!4!street-1],
		NULL AS [patient!4!street-2],
		NULL AS [patient!4!city],
		NULL AS [patient!4!state],
		NULL AS [patient!4!zip],
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		NULL AS [claim!5!claim-id],
		NULL AS [claim!5!control-number],
		NULL AS [claim!5!total-claim-amount],
		NULL AS [claim!5!place-of-service-code],
		NULL AS [claim!5!provider-signature-flag],
		NULL AS [claim!5!medicare-assignment-code],
		NULL AS [claim!5!assignment-of-benefits-flag],
		NULL AS [claim!5!release-of-information-code],
		NULL AS [claim!5!patient-signature-source-code],
		NULL AS [claim!5!auto-accident-related-flag],
		NULL AS [claim!5!abuse-related-flag],
		NULL AS [claim!5!employment-related-flag],
		NULL AS [claim!5!other-accident-related-flag],
		NULL AS [claim!5!auto-accident-state],
		NULL AS [claim!5!special-program-code],
		NULL AS [claim!5!initial-treatment-date],
		NULL AS [claim!5!referral-date],
		NULL AS [claim!5!last-seen-date],
		NULL AS [claim!5!current-illness-date],
		NULL AS [claim!5!acute-manifestation-date],
		NULL AS [claim!5!similar-illness-date],
		NULL AS [claim!5!accident-date],
		NULL AS [claim!5!last-xray-date],
		NULL AS [claim!5!disability-begin-date],
		NULL AS [claim!5!disability-end-date],
		NULL AS [claim!5!last-worked-date],
		NULL AS [claim!5!return-to-work-date],
		NULL AS [claim!5!hospitalization-begin-date],
		NULL AS [claim!5!hospitalization-end-date],
		NULL AS [claim!5!patient-paid-amount],
		NULL AS [claim!5!authorization-number],
		NULL AS [claim!5!diagnosis-1],
		NULL AS [claim!5!diagnosis-2],
		NULL AS [claim!5!diagnosis-3],
		NULL AS [claim!5!diagnosis-4],
		NULL AS [claim!5!diagnosis-5],
		NULL AS [claim!5!diagnosis-6],
		NULL AS [claim!5!diagnosis-7],
		NULL AS [claim!5!diagnosis-8],
		NULL AS [claim!5!referring-provider-flag],
		NULL AS [claim!5!referring-provider-first-name],
		NULL AS [claim!5!referring-provider-middle-name],
		NULL AS [claim!5!referring-provider-last-name],
		NULL AS [claim!5!referring-provider-suffix],
		NULL AS [claim!5!referring-provider-upin],
		NULL AS [claim!5!rendering-provider-first-name],
		NULL AS [claim!5!rendering-provider-middle-name],
		NULL AS [claim!5!rendering-provider-last-name],
		NULL AS [claim!5!rendering-provider-suffix],
		NULL AS [claim!5!rendering-provider-ssn],
		NULL AS [claim!5!rendering-provider-upin],
		NULL AS [claim!5!rendering-provider-specialty-code],
		NULL AS [claim!5!service-facility-name],
		NULL AS [claim!5!service-facility-street-1],
		NULL AS [claim!5!service-facility-street-2],
		NULL AS [claim!5!service-facility-city],
		NULL AS [claim!5!service-facility-state],
		NULL AS [claim!5!service-facility-zip],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [secondary!6!secondary-id],
		NULL AS [secondary!6!insured-different-than-patient-flag],
		NULL AS [secondary!6!subscriber-first-name],
		NULL AS [secondary!6!subscriber-middle-name],
		NULL AS [secondary!6!subscriber-last-name],
		NULL AS [secondary!6!subscriber-suffix],
		NULL AS [secondary!6!subscriber-street-1],
		NULL AS [secondary!6!subscriber-street-2],
		NULL AS [secondary!6!subscriber-city],
		NULL AS [secondary!6!subscriber-state],
		NULL AS [secondary!6!subscriber-zip],
		NULL AS [secondary!6!subscriber-birth-date],
		NULL AS [secondary!6!subscriber-gender],
		NULL AS [secondary!6!relation-to-insured-code],
		NULL AS [secondary!6!payer-responsibility-code],
		NULL AS [secondary!6!plan-name],
		NULL AS [secondary!6!group-number],
		NULL AS [secondary!6!policy-numer],
		NULL AS [secondary!6!payer-name],
		NULL AS [secondary!6!payer-identifier],
		NULL AS [secondary!6!payer-contact-name],
		NULL AS [secondary!6!payer-contact-phone],
		NULL AS [secondary!6!payer-paid-flag],
		NULL AS [secondary!6!payer-paid-amount],
		NULL AS [service!7!service-id],
		NULL AS [service!7!control-number],
		NULL AS [service!7!procedure-code],
		NULL AS [service!7!service-date],
		NULL AS [service!7!service-charge-amount],
		NULL AS [service!7!service-unit-count],
		NULL AS [service!7!place-of-service-code],
		NULL AS [service!7!procedure-modifier-1],
		NULL AS [service!7!procedure-modifier-2],
		NULL AS [service!7!procedure-modifier-3],
		NULL AS [service!7!procedure-modifier-4],
		NULL AS [service!7!diagnosis-pointer-1],
		NULL AS [service!7!diagnosis-pointer-2],
		NULL AS [service!7!diagnosis-pointer-3],
		NULL AS [service!7!diagnosis-pointer-4],
		NULL AS [adjudication!8!adjudication-id],
		NULL AS [adjudication!8!payer-identifier],
		NULL AS [adjudication!8!paid-amount],
		NULL AS [adjudication!8!paid-unit-count],
		NULL AS [adjudication!8!paid-date],
		NULL AS [adjudication!8!payer-adjusted-flag],
		NULL AS [adjudication!8!adjustment-reason-1],
		NULL AS [adjudication!8!adjustment-amount-1],
		NULL AS [adjudication!8!adjustment-reason-2],
		NULL AS [adjudication!8!adjustment-amount-2],
		NULL AS [adjudication!8!adjustment-reason-3],
		NULL AS [adjudication!8!adjustment-amount-3],
		NULL AS [adjudication!8!adjustment-reason-4],
		NULL AS [adjudication!8!adjustment-amount-4],
		NULL AS [adjudication!8!adjustment-reason-5],
		NULL AS [adjudication!8!adjustment-amount-5],
		NULL AS [adjudication!8!adjustment-reason-6],
		NULL AS [adjudication!8!adjustment-amount-6]
	FROM	BillBatch
	WHERE	BillBatchID = @batch_id

	UNION ALL

	SELECT	2, 1,
		BB.BillBatchID AS [transaction!1!transaction-id],
		NULL AS [transaction!1!control-number],
		NULL AS [transaction!1!created-date],
		NULL AS [transaction!1!current-date],
		PR.PracticeID AS [billing!2!billing-id],
		UPPER(PR.Name) AS [billing!2!name],
		UPPER(PR.AddressLine1) AS [billing!2!street-1],
		UPPER(PR.AddressLine2) AS [billing!2!street-2],
		UPPER(PR.City) AS [billing!2!city],
		UPPER(PR.State) AS [billing!2!state],
		PR.ZipCode AS [billing!2!zip],
		PR.EIN AS [billing!2!ein],
		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],
		NULL AS [subscriber!3!subscriber-id],
		NULL AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
		NULL AS [subscriber!3!responsible-different-than-patient-flag],
		NULL AS [subscriber!3!responsible-first-name],
		NULL AS [subscriber!3!responsible-middle-name],
		NULL AS [subscriber!3!responsible-last-name],
		NULL AS [subscriber!3!responsible-suffix],
		NULL AS [subscriber!3!responsible-street-1],
		NULL AS [subscriber!3!responsible-street-2],
		NULL AS [subscriber!3!responsible-city],
		NULL AS [subscriber!3!responsible-state],
		NULL AS [subscriber!3!responsible-zip],
		NULL AS [patient!4!patient-id],
		NULL AS [patient!4!relation-to-insured-code],
		NULL AS [patient!4!dependent-policy-number],
		NULL AS [patient!4!first-name],
		NULL AS [patient!4!middle-name],
		NULL AS [patient!4!last-name],
		NULL AS [patient!4!suffix],
		NULL AS [patient!4!street-1],
		NULL AS [patient!4!street-2],
		NULL AS [patient!4!city],
		NULL AS [patient!4!state],
		NULL AS [patient!4!zip],
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		NULL AS [claim!5!claim-id],
		NULL AS [claim!5!control-number],
		NULL AS [claim!5!total-claim-amount],
		NULL AS [claim!5!place-of-service-code],
		NULL AS [claim!5!provider-signature-flag],
		NULL AS [claim!5!medicare-assignment-code],
		NULL AS [claim!5!assignment-of-benefits-flag],
		NULL AS [claim!5!release-of-information-code],
		NULL AS [claim!5!patient-signature-source-code],
		NULL AS [claim!5!auto-accident-related-flag],
		NULL AS [claim!5!abuse-related-flag],
		NULL AS [claim!5!employment-related-flag],
		NULL AS [claim!5!other-accident-related-flag],
		NULL AS [claim!5!auto-accident-state],
		NULL AS [claim!5!special-program-code],
		NULL AS [claim!5!initial-treatment-date],
		NULL AS [claim!5!referral-date],
		NULL AS [claim!5!last-seen-date],
		NULL AS [claim!5!current-illness-date],
		NULL AS [claim!5!acute-manifestation-date],
		NULL AS [claim!5!similar-illness-date],
		NULL AS [claim!5!accident-date],
		NULL AS [claim!5!last-xray-date],
		NULL AS [claim!5!disability-begin-date],
		NULL AS [claim!5!disability-end-date],
		NULL AS [claim!5!last-worked-date],
		NULL AS [claim!5!return-to-work-date],
		NULL AS [claim!5!hospitalization-begin-date],
		NULL AS [claim!5!hospitalization-end-date],
		NULL AS [claim!5!patient-paid-amount],
		NULL AS [claim!5!authorization-number],
		NULL AS [claim!5!diagnosis-1],
		NULL AS [claim!5!diagnosis-2],
		NULL AS [claim!5!diagnosis-3],
		NULL AS [claim!5!diagnosis-4],
		NULL AS [claim!5!diagnosis-5],
		NULL AS [claim!5!diagnosis-6],
		NULL AS [claim!5!diagnosis-7],
		NULL AS [claim!5!diagnosis-8],
		NULL AS [claim!5!referring-provider-flag],
		NULL AS [claim!5!referring-provider-first-name],
		NULL AS [claim!5!referring-provider-middle-name],
		NULL AS [claim!5!referring-provider-last-name],
		NULL AS [claim!5!referring-provider-suffix],
		NULL AS [claim!5!referring-provider-upin],
		NULL AS [claim!5!rendering-provider-first-name],
		NULL AS [claim!5!rendering-provider-middle-name],
		NULL AS [claim!5!rendering-provider-last-name],
		NULL AS [claim!5!rendering-provider-suffix],
		NULL AS [claim!5!rendering-provider-ssn],
		NULL AS [claim!5!rendering-provider-upin],
		NULL AS [claim!5!rendering-provider-specialty-code],
		NULL AS [claim!5!service-facility-name],
		NULL AS [claim!5!service-facility-street-1],
		NULL AS [claim!5!service-facility-street-2],
		NULL AS [claim!5!service-facility-city],
		NULL AS [claim!5!service-facility-state],
		NULL AS [claim!5!service-facility-zip],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [secondary!6!secondary-id],
		NULL AS [secondary!6!insured-different-than-patient-flag],
		NULL AS [secondary!6!subscriber-first-name],
		NULL AS [secondary!6!subscriber-middle-name],
		NULL AS [secondary!6!subscriber-last-name],
		NULL AS [secondary!6!subscriber-suffix],
		NULL AS [secondary!6!subscriber-street-1],
		NULL AS [secondary!6!subscriber-street-2],
		NULL AS [secondary!6!subscriber-city],
		NULL AS [secondary!6!subscriber-state],
		NULL AS [secondary!6!subscriber-zip],
		NULL AS [secondary!6!subscriber-birth-date],
		NULL AS [secondary!6!subscriber-gender],
		NULL AS [secondary!6!relation-to-insured-code],
		NULL AS [secondary!6!payer-responsibility-code],
		NULL AS [secondary!6!plan-name],
		NULL AS [secondary!6!group-number],
		NULL AS [secondary!6!policy-numer],
		NULL AS [secondary!6!payer-name],
		NULL AS [secondary!6!payer-identifier],
		NULL AS [secondary!6!payer-contact-name],
		NULL AS [secondary!6!payer-contact-phone],
		NULL AS [secondary!6!payer-paid-flag],
		NULL AS [secondary!6!payer-paid-amount],
		NULL AS [service!7!service-id],
		NULL AS [service!7!control-number],
		NULL AS [service!7!procedure-code],
		NULL AS [service!7!service-date],
		NULL AS [service!7!service-charge-amount],
		NULL AS [service!7!service-unit-count],
		NULL AS [service!7!place-of-service-code],
		NULL AS [service!7!procedure-modifier-1],
		NULL AS [service!7!procedure-modifier-2],
		NULL AS [service!7!procedure-modifier-3],
		NULL AS [service!7!procedure-modifier-4],
		NULL AS [service!7!diagnosis-pointer-1],
		NULL AS [service!7!diagnosis-pointer-2],
		NULL AS [service!7!diagnosis-pointer-3],
		NULL AS [service!7!diagnosis-pointer-4],
		NULL AS [adjudication!8!adjudication-id],
		NULL AS [adjudication!8!payer-identifier],
		NULL AS [adjudication!8!paid-amount],
		NULL AS [adjudication!8!paid-unit-count],
		NULL AS [adjudication!8!paid-date],
		NULL AS [adjudication!8!payer-adjusted-flag],
		NULL AS [adjudication!8!adjustment-reason-1],
		NULL AS [adjudication!8!adjustment-amount-1],
		NULL AS [adjudication!8!adjustment-reason-2],
		NULL AS [adjudication!8!adjustment-amount-2],
		NULL AS [adjudication!8!adjustment-reason-3],
		NULL AS [adjudication!8!adjustment-amount-3],
		NULL AS [adjudication!8!adjustment-reason-4],
		NULL AS [adjudication!8!adjustment-amount-4],
		NULL AS [adjudication!8!adjustment-reason-5],
		NULL AS [adjudication!8!adjustment-amount-5],
		NULL AS [adjudication!8!adjustment-reason-6],
		NULL AS [adjudication!8!adjustment-amount-6]
	FROM	BillBatch BB
		INNER JOIN Practice PR
		ON PR.PracticeID = BB.PracticeID
	WHERE	BB.BillBatchID = @batch_id

	UNION ALL

	SELECT	3, 2,
		B.BillBatchID AS [transaction!1!transaction-id],
		NULL AS [transaction!1!control-number],
		NULL AS [transaction!1!created-date],
		NULL AS [transaction!1!current-date],
		P.PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!ein],
		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],
		B.PayerPatientInsuranceID AS [subscriber!3!subscriber-id],
		B.BillID AS [subscriber!3!encounter-id],
		UPPER(CASE PI.HolderDifferentThanPatient
			WHEN 1 THEN PI.HolderFirstName
			ELSE P.FirstName END) 
			AS [subscriber!3!first-name],
		UPPER(CASE PI.HolderDifferentThanPatient
			WHEN 1 THEN PI.HolderMiddleName
			ELSE P.MiddleName END)
			AS [subscriber!3!middle-name],
		UPPER(CASE PI.HolderDifferentThanPatient
			WHEN 1 THEN PI.HolderLastName
			ELSE P.LastName END)
			AS [subscriber!3!last-name],
		UPPER(CASE PI.HolderDifferentThanPatient
			WHEN 1 THEN PI.HolderSuffix
			ELSE P.Suffix END)
			AS [subscriber!3!suffix],
		PI.HolderDifferentThanPatient
			AS [subscriber!3!insured-different-than-patient-flag],
		B.PayerResponsibilityCode 
			AS [subscriber!3!payer-responsibility-code],
		UPPER(ICP.PlanName) AS [subscriber!3!plan-name],
		UPPER(PI.GroupNumber) AS [subscriber!3!group-number],
		UPPER(PI.PolicyNumber) AS [subscriber!3!policy-number],
		UPPER(ICP.PlanName) AS [subscriber!3!payer-name],
		UPPER(CPL.PayerNumber) AS [subscriber!3!payer-identifier],
		UPPER(ICP.AddressLine1) AS [subscriber!3!payer-street-1],
		UPPER(ICP.AddressLine2) AS [subscriber!3!payer-street-2],
		UPPER(ICP.City) AS [subscriber!3!payer-city],
		UPPER(ICP.State) AS [subscriber!3!payer-state],
		ICP.ZipCode AS [subscriber!3!payer-zip],
		P.ResponsibleDifferentThanPatient
			AS [subscriber!3!responsible-different-than-patient-flag],
		UPPER(P.ResponsibleFirstName) 
			AS [subscriber!3!responsible-first-name],
		UPPER(P.ResponsibleMiddleName) 
			AS [subscriber!3!responsible-middle-name],
		UPPER(P.ResponsibleLastName) 
			AS [subscriber!3!responsible-last-name],
		UPPER(P.ResponsibleSuffix) AS [subscriber!3!responsible-suffix],
		UPPER(P.ResponsibleAddressLine1)
			AS [subscriber!3!responsible-street-1],
		UPPER(P.ResponsibleAddressLine2)
			AS [subscriber!3!responsible-street-2],
		UPPER(P.ResponsibleCity) AS [subscriber!3!responsible-city],
		UPPER(P.ResponsibleState) AS [subscriber!3!responsible-state],
		P.ResponsibleZipCode AS [subscriber!3!responsible-zip],
		NULL AS [patient!4!patient-id],
		NULL AS [patient!4!relation-to-insured-code],
		NULL AS [patient!4!dependent-policy-number],
		NULL AS [patient!4!first-name],
		NULL AS [patient!4!middle-name],
		NULL AS [patient!4!last-name],
		NULL AS [patient!4!suffix],
		NULL AS [patient!4!street-1],
		NULL AS [patient!4!street-2],
		NULL AS [patient!4!city],
		NULL AS [patient!4!state],
		NULL AS [patient!4!zip],
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		NULL AS [claim!5!claim-id],
		NULL AS [claim!5!control-number],
		NULL AS [claim!5!total-claim-amount],
		NULL AS [claim!5!place-of-service-code],
		NULL AS [claim!5!provider-signature-flag],
		NULL AS [claim!5!medicare-assignment-code],
		NULL AS [claim!5!assignment-of-benefits-flag],
		NULL AS [claim!5!release-of-information-code],
		NULL AS [claim!5!patient-signature-source-code],
		NULL AS [claim!5!auto-accident-related-flag],
		NULL AS [claim!5!abuse-related-flag],
		NULL AS [claim!5!employment-related-flag],
		NULL AS [claim!5!other-accident-related-flag],
		NULL AS [claim!5!auto-accident-state],
		NULL AS [claim!5!special-program-code],
		NULL AS [claim!5!initial-treatment-date],
		NULL AS [claim!5!referral-date],
		NULL AS [claim!5!last-seen-date],
		NULL AS [claim!5!current-illness-date],
		NULL AS [claim!5!acute-manifestation-date],
		NULL AS [claim!5!similar-illness-date],
		NULL AS [claim!5!accident-date],
		NULL AS [claim!5!last-xray-date],
		NULL AS [claim!5!disability-begin-date],
		NULL AS [claim!5!disability-end-date],
		NULL AS [claim!5!last-worked-date],
		NULL AS [claim!5!return-to-work-date],
		NULL AS [claim!5!hospitalization-begin-date],
		NULL AS [claim!5!hospitalization-end-date],
		NULL AS [claim!5!patient-paid-amount],
		NULL AS [claim!5!authorization-number],
		NULL AS [claim!5!diagnosis-1],
		NULL AS [claim!5!diagnosis-2],
		NULL AS [claim!5!diagnosis-3],
		NULL AS [claim!5!diagnosis-4],
		NULL AS [claim!5!diagnosis-5],
		NULL AS [claim!5!diagnosis-6],
		NULL AS [claim!5!diagnosis-7],
		NULL AS [claim!5!diagnosis-8],
		NULL AS [claim!5!referring-provider-flag],
		NULL AS [claim!5!referring-provider-first-name],
		NULL AS [claim!5!referring-provider-middle-name],
		NULL AS [claim!5!referring-provider-last-name],
		NULL AS [claim!5!referring-provider-suffix],
		NULL AS [claim!5!referring-provider-upin],
		NULL AS [claim!5!rendering-provider-first-name],
		NULL AS [claim!5!rendering-provider-middle-name],
		NULL AS [claim!5!rendering-provider-last-name],
		NULL AS [claim!5!rendering-provider-suffix],
		NULL AS [claim!5!rendering-provider-ssn],
		NULL AS [claim!5!rendering-provider-upin],
		NULL AS [claim!5!rendering-provider-specialty-code],
		NULL AS [claim!5!service-facility-name],
		NULL AS [claim!5!service-facility-street-1],
		NULL AS [claim!5!service-facility-street-2],
		NULL AS [claim!5!service-facility-city],
		NULL AS [claim!5!service-facility-state],
		NULL AS [claim!5!service-facility-zip],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [secondary!6!secondary-id],
		NULL AS [secondary!6!insured-different-than-patient-flag],
		NULL AS [secondary!6!subscriber-first-name],
		NULL AS [secondary!6!subscriber-middle-name],
		NULL AS [secondary!6!subscriber-last-name],
		NULL AS [secondary!6!subscriber-suffix],
		NULL AS [secondary!6!subscriber-street-1],
		NULL AS [secondary!6!subscriber-street-2],
		NULL AS [secondary!6!subscriber-city],
		NULL AS [secondary!6!subscriber-state],
		NULL AS [secondary!6!subscriber-zip],
		NULL AS [secondary!6!subscriber-birth-date],
		NULL AS [secondary!6!subscriber-gender],
		NULL AS [secondary!6!relation-to-insured-code],
		NULL AS [secondary!6!payer-responsibility-code],
		NULL AS [secondary!6!plan-name],
		NULL AS [secondary!6!group-number],
		NULL AS [secondary!6!policy-numer],
		NULL AS [secondary!6!payer-name],
		NULL AS [secondary!6!payer-identifier],
		NULL AS [secondary!6!payer-contact-name],
		NULL AS [secondary!6!payer-contact-phone],
		NULL AS [secondary!6!payer-paid-flag],
		NULL AS [secondary!6!payer-paid-amount],
		NULL AS [service!7!service-id],
		NULL AS [service!7!control-number],
		NULL AS [service!7!procedure-code],
		NULL AS [service!7!service-date],
		NULL AS [service!7!service-charge-amount],
		NULL AS [service!7!service-unit-count],
		NULL AS [service!7!place-of-service-code],
		NULL AS [service!7!procedure-modifier-1],
		NULL AS [service!7!procedure-modifier-2],
		NULL AS [service!7!procedure-modifier-3],
		NULL AS [service!7!procedure-modifier-4],
		NULL AS [service!7!diagnosis-pointer-1],
		NULL AS [service!7!diagnosis-pointer-2],
		NULL AS [service!7!diagnosis-pointer-3],
		NULL AS [service!7!diagnosis-pointer-4],
		NULL AS [adjudication!8!adjudication-id],
		NULL AS [adjudication!8!payer-identifier],
		NULL AS [adjudication!8!paid-amount],
		NULL AS [adjudication!8!paid-unit-count],
		NULL AS [adjudication!8!paid-date],
		NULL AS [adjudication!8!payer-adjusted-flag],
		NULL AS [adjudication!8!adjustment-reason-1],
		NULL AS [adjudication!8!adjustment-amount-1],
		NULL AS [adjudication!8!adjustment-reason-2],
		NULL AS [adjudication!8!adjustment-amount-2],
		NULL AS [adjudication!8!adjustment-reason-3],
		NULL AS [adjudication!8!adjustment-amount-3],
		NULL AS [adjudication!8!adjustment-reason-4],
		NULL AS [adjudication!8!adjustment-amount-4],
		NULL AS [adjudication!8!adjustment-reason-5],
		NULL AS [adjudication!8!adjustment-amount-5],
		NULL AS [adjudication!8!adjustment-reason-6],
		NULL AS [adjudication!8!adjustment-amount-6]
	FROM	Bill_EDI B
		INNER JOIN PatientInsurance PI
			INNER JOIN InsuranceCompanyPlan ICP
				LEFT OUTER JOIN ClearinghousePayersList CPL
				ON ICP.ClearinghousePayerID = CPL.ClearinghousePayerID
			ON ICP.InsuranceCompanyPlanID = PI.InsuranceCompanyPlanID
		ON PI.PatientInsuranceID = B.PayerPatientInsuranceID
		INNER JOIN Patient P
		ON P.PatientID = PI.PatientID
	WHERE	B.BillBatchID = @batch_id

	UNION ALL

	SELECT	4, 3,
		B.BillBatchID AS [transaction!1!transaction-id],
		NULL AS [transaction!1!control-number],
		NULL AS [transaction!1!created-date],
		NULL AS [transaction!1!current-date],
		P.PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!ein],
		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],
		B.PayerPatientInsuranceID AS [subscriber!3!subscriber-id],
		B.BillID AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
		NULL AS [subscriber!3!responsible-different-than-patient-flag],
		NULL AS [subscriber!3!responsible-first-name],
		NULL AS [subscriber!3!responsible-middle-name],
		NULL AS [subscriber!3!responsible-last-name],
		NULL AS [subscriber!3!responsible-suffix],
		NULL AS [subscriber!3!responsible-street-1],
		NULL AS [subscriber!3!responsible-street-2],
		NULL AS [subscriber!3!responsible-city],
		NULL AS [subscriber!3!responsible-state],
		NULL AS [subscriber!3!responsible-zip],
		RC.PatientID AS [patient!4!patient-id],
		PI.PatientRelationshipToInsured
			AS [patient!4!relation-to-insured-code],
		UPPER(PI.DependentPolicyNumber) 
			AS [patient!4!dependent-policy-number],
		UPPER(P.FirstName) AS [patient!4!first-name],
		UPPER(P.MiddleName) AS [patient!4!middle-name],
		UPPER(P.LastName) AS [patient!4!last-name],
		UPPER(P.Suffix) AS [patient!4!suffix],
		UPPER(P.AddressLine1) AS [patient!4!street-1],
		UPPER(P.AddressLine2) AS [patient!4!street-2],
		UPPER(P.City) AS [patient!4!city],
		UPPER(P.State) AS [patient!4!state],
		P.ZipCode AS [patient!4!zip],
		P.DOB AS [patient!4!birth-date],
		UPPER(P.Gender) AS [patient!4!gender],
		NULL AS [claim!5!claim-id],
		NULL AS [claim!5!control-number],
		NULL AS [claim!5!total-claim-amount],
		NULL AS [claim!5!place-of-service-code],
		NULL AS [claim!5!provider-signature-flag],
		NULL AS [claim!5!medicare-assignment-code],
		NULL AS [claim!5!assignment-of-benefits-flag],
		NULL AS [claim!5!release-of-information-code],
		NULL AS [claim!5!patient-signature-source-code],
		NULL AS [claim!5!auto-accident-related-flag],
		NULL AS [claim!5!abuse-related-flag],
		NULL AS [claim!5!employment-related-flag],
		NULL AS [claim!5!other-accident-related-flag],
		NULL AS [claim!5!auto-accident-state],
		NULL AS [claim!5!special-program-code],
		NULL AS [claim!5!initial-treatment-date],
		NULL AS [claim!5!referral-date],
		NULL AS [claim!5!last-seen-date],
		NULL AS [claim!5!current-illness-date],
		NULL AS [claim!5!acute-manifestation-date],
		NULL AS [claim!5!similar-illness-date],
		NULL AS [claim!5!accident-date],
		NULL AS [claim!5!last-xray-date],
		NULL AS [claim!5!disability-begin-date],
		NULL AS [claim!5!disability-end-date],
		NULL AS [claim!5!last-worked-date],
		NULL AS [claim!5!return-to-work-date],
		NULL AS [claim!5!hospitalization-begin-date],
		NULL AS [claim!5!hospitalization-end-date],
		NULL AS [claim!5!patient-paid-amount],
		NULL AS [claim!5!authorization-number],
		NULL AS [claim!5!diagnosis-1],
		NULL AS [claim!5!diagnosis-2],
		NULL AS [claim!5!diagnosis-3],
		NULL AS [claim!5!diagnosis-4],
		NULL AS [claim!5!diagnosis-5],
		NULL AS [claim!5!diagnosis-6],
		NULL AS [claim!5!diagnosis-7],
		NULL AS [claim!5!diagnosis-8],
		NULL AS [claim!5!referring-provider-flag],
		NULL AS [claim!5!referring-provider-first-name],
		NULL AS [claim!5!referring-provider-middle-name],
		NULL AS [claim!5!referring-provider-last-name],
		NULL AS [claim!5!referring-provider-suffix],
		NULL AS [claim!5!referring-provider-upin],
		NULL AS [claim!5!rendering-provider-first-name],
		NULL AS [claim!5!rendering-provider-middle-name],
		NULL AS [claim!5!rendering-provider-last-name],
		NULL AS [claim!5!rendering-provider-suffix],
		NULL AS [claim!5!rendering-provider-ssn],
		NULL AS [claim!5!rendering-provider-upin],
		NULL AS [claim!5!rendering-provider-specialty-code],
		NULL AS [claim!5!service-facility-name],
		NULL AS [claim!5!service-facility-street-1],
		NULL AS [claim!5!service-facility-street-2],
		NULL AS [claim!5!service-facility-city],
		NULL AS [claim!5!service-facility-state],
		NULL AS [claim!5!service-facility-zip],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [secondary!6!secondary-id],
		NULL AS [secondary!6!insured-different-than-patient-flag],
		NULL AS [secondary!6!subscriber-first-name],
		NULL AS [secondary!6!subscriber-middle-name],
		NULL AS [secondary!6!subscriber-last-name],
		NULL AS [secondary!6!subscriber-suffix],
		NULL AS [secondary!6!subscriber-street-1],
		NULL AS [secondary!6!subscriber-street-2],
		NULL AS [secondary!6!subscriber-city],
		NULL AS [secondary!6!subscriber-state],
		NULL AS [secondary!6!subscriber-zip],
		NULL AS [secondary!6!subscriber-birth-date],
		NULL AS [secondary!6!subscriber-gender],
		NULL AS [secondary!6!relation-to-insured-code],
		NULL AS [secondary!6!payer-responsibility-code],
		NULL AS [secondary!6!plan-name],
		NULL AS [secondary!6!group-number],
		NULL AS [secondary!6!policy-numer],
		NULL AS [secondary!6!payer-name],
		NULL AS [secondary!6!payer-identifier],
		NULL AS [secondary!6!payer-contact-name],
		NULL AS [secondary!6!payer-contact-phone],
		NULL AS [secondary!6!payer-paid-flag],
		NULL AS [secondary!6!payer-paid-amount],
		NULL AS [service!7!service-id],
		NULL AS [service!7!control-number],
		NULL AS [service!7!procedure-code],
		NULL AS [service!7!service-date],
		NULL AS [service!7!service-charge-amount],
		NULL AS [service!7!service-unit-count],
		NULL AS [service!7!place-of-service-code],
		NULL AS [service!7!procedure-modifier-1],
		NULL AS [service!7!procedure-modifier-2],
		NULL AS [service!7!procedure-modifier-3],
		NULL AS [service!7!procedure-modifier-4],
		NULL AS [service!7!diagnosis-pointer-1],
		NULL AS [service!7!diagnosis-pointer-2],
		NULL AS [service!7!diagnosis-pointer-3],
		NULL AS [service!7!diagnosis-pointer-4],
		NULL AS [adjudication!8!adjudication-id],
		NULL AS [adjudication!8!payer-identifier],
		NULL AS [adjudication!8!paid-amount],
		NULL AS [adjudication!8!paid-unit-count],
		NULL AS [adjudication!8!paid-date],
		NULL AS [adjudication!8!payer-adjusted-flag],
		NULL AS [adjudication!8!adjustment-reason-1],
		NULL AS [adjudication!8!adjustment-amount-1],
		NULL AS [adjudication!8!adjustment-reason-2],
		NULL AS [adjudication!8!adjustment-amount-2],
		NULL AS [adjudication!8!adjustment-reason-3],
		NULL AS [adjudication!8!adjustment-amount-3],
		NULL AS [adjudication!8!adjustment-reason-4],
		NULL AS [adjudication!8!adjustment-amount-4],
		NULL AS [adjudication!8!adjustment-reason-5],
		NULL AS [adjudication!8!adjustment-amount-5],
		NULL AS [adjudication!8!adjustment-reason-6],
		NULL AS [adjudication!8!adjustment-amount-6]
	FROM	Bill_EDI B
		INNER JOIN Claim RC
		ON RC.ClaimID = B.RepresentativeClaimID
		INNER JOIN Patient P
		ON P.PatientID = RC.PatientID
		INNER JOIN PatientInsurance PI
		ON PI.PatientInsuranceID = B.PayerPatientInsuranceID
	WHERE	B.BillBatchID = @batch_id

	UNION ALL

	SELECT	5, 4,
		B.BillBatchID AS [transaction!1!transaction-id],
		NULL AS [transaction!1!control-number],
		NULL AS [transaction!1!created-date],
		NULL AS [transaction!1!current-date],
		RC.PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!ein],
		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],
		B.PayerPatientInsuranceID AS [subscriber!3!subscriber-id],
		B.BillID AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
		NULL AS [subscriber!3!responsible-different-than-patient-flag],
		NULL AS [subscriber!3!responsible-first-name],
		NULL AS [subscriber!3!responsible-middle-name],
		NULL AS [subscriber!3!responsible-last-name],
		NULL AS [subscriber!3!responsible-suffix],
		NULL AS [subscriber!3!responsible-street-1],
		NULL AS [subscriber!3!responsible-street-2],
		NULL AS [subscriber!3!responsible-city],
		NULL AS [subscriber!3!responsible-state],
		NULL AS [subscriber!3!responsible-zip],
		RC.PatientID AS [patient!4!patient-id],
		NULL AS [patient!4!relation-to-insured-code],
		NULL AS [patient!4!dependent-policy-number],
		NULL AS [patient!4!first-name],
		NULL AS [patient!4!middle-name],
		NULL AS [patient!4!last-name],
		NULL AS [patient!4!suffix],
		NULL AS [patient!4!street-1],
		NULL AS [patient!4!street-2],
		NULL AS [patient!4!city],
		NULL AS [patient!4!state],
		NULL AS [patient!4!zip],
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		B.BillID AS [claim!5!claim-id],
		-- [claim!5!control-number] cannot be more than 20 chars:
		CONVERT(VARCHAR,RC.PatientID) + '-'
			+ CONVERT(VARCHAR,RC.ClaimID) + '-'
			-- + CONVERT(VARCHAR,B.BillBatchID) + '-' 
			+ CONVERT(VARCHAR,B.BillID) AS [claim!5!control-number],
		dbo.BusinessRule_EDIBillTotalAdjustedChargeAmount(B.BillID) 
			AS [claim!5!total-claim-amount],
		RC.PlaceOfServiceCode AS [claim!5!place-of-service-code],
		RC.ProviderSignatureOnFileFlag 
			AS [claim!5!provider-signature-flag],
		RC.MedicareAssignmentCode AS [claim!5!medicare-assignment-code],
		RC.AssignmentOfBenefitsFlag 
			AS [claim!5!assignment-of-benefits-flag],
		RC.ReleaseOfInformationCode 	
			AS [claim!5!release-of-information-code],
		'B' -- RC.ReleaseSignatureSourceCode 
			AS [claim!5!patient-signature-source-code],
		RC.AutoAccidentRelatedFlag
			AS [claim!5!auto-accident-related-flag],
		RC.AbuseRelatedFlag AS [claim!5!abuse-related-flag],
		RC.EmploymentRelatedFlag AS [claim!5!employment-related-flag],
		RC.OtherAccidentRelatedFlag 
			AS [claim!5!other-accident-related-flag],
		RC.AutoAccidentRelatedFlag AS [claim!5!auto-accident-state],
		RC.SpecialProgramCode AS [claim!5!special-program-code],
		RC.InitialTreatmentDate AS [claim!5!initial-treatment-date],
		RC.ReferralDate AS [claim!5!referral-date],
		RC.LastSeenDate AS [claim!5!last-seen-date],
		RC.CurrentIllnessDate AS [claim!5!current-illness-date],
		RC.AcuteManifestationDate AS [claim!5!acute-manifestation-date],
		RC.SimilarIllnessDate AS [claim!5!similar-illness-date],
		RC.CurrentIllnessDate AS [claim!5!accident-date],
		RC.LastXrayDate AS [claim!5!last-xray-date],
		RC.DisabilityBeginDate AS [claim!5!disability-begin-date],
		RC.DisabilityEndDate AS [claim!5!disability-end-date],
		RC.LastWorkedDate AS [claim!5!last-worked-date],
		RC.ReturnToWorkDate AS [claim!5!return-to-work-date],
		RC.HospitalizationBeginDate 
			AS [claim!5!hospitalization-begin-date],
		RC.HospitalizationEndDate AS [claim!5!hospitalization-end-date],
		RC.PatientPaidAmount AS [claim!5!patient-paid-amount],
		UPPER(A.AuthorizationNumber) AS [claim!5!authorization-number],
		(CASE WHEN (RC.DiagnosisCode1 <> '') THEN UPPER(RC.DiagnosisCode1) ELSE NULL END) AS [claim!5!diagnosis-1],
		(CASE WHEN (RC.DiagnosisCode2 <> '') THEN UPPER(RC.DiagnosisCode2) ELSE NULL END) AS [claim!5!diagnosis-2],
		(CASE WHEN (RC.DiagnosisCode3 <> '') THEN UPPER(RC.DiagnosisCode3) ELSE NULL END) AS [claim!5!diagnosis-3],
		(CASE WHEN (RC.DiagnosisCode4 <> '') THEN UPPER(RC.DiagnosisCode4) ELSE NULL END) AS [claim!5!diagnosis-4],
		(CASE WHEN (RC.DiagnosisCode5 <> '') THEN UPPER(RC.DiagnosisCode5) ELSE NULL END) AS [claim!5!diagnosis-5],
		(CASE WHEN (RC.DiagnosisCode6 <> '') THEN UPPER(RC.DiagnosisCode6) ELSE NULL END) AS [claim!5!diagnosis-6],
		(CASE WHEN (RC.DiagnosisCode7 <> '') THEN UPPER(RC.DiagnosisCode7) ELSE NULL END) AS [claim!5!diagnosis-7],
		(CASE WHEN (RC.DiagnosisCode8 <> '') THEN UPPER(RC.DiagnosisCode8) ELSE NULL END) AS [claim!5!diagnosis-8],
		(CASE WHEN (RC.ReferringProviderID IS NOT NULL AND RP.UPIN IS NOT NULL) THEN 1 ELSE 0 END)
			AS [claim!5!referring-provider-flag],
		UPPER(RP.FirstName) AS [claim!5!referring-provider-first-name],
		UPPER(RP.MiddleName) 
			AS [claim!5!referring-provider-middle-name],
		UPPER(RP.LastName) AS [claim!5!referring-provider-last-name],
		UPPER(RP.Suffix) AS [claim!5!referring-provider-suffix],
		UPPER(RP.UPIN) AS [claim!5!referring-provider-upin],
		UPPER(D.FirstName) AS [claim!5!rendering-provider-first-name],
		UPPER(D.MiddleName) AS [claim!5!rendering-provider-middle-name],
		UPPER(D.LastName) AS [claim!5!rendering-provider-last-name],
		UPPER(D.Suffix) AS [claim!5!rendering-provider-suffix],
		UPPER(D.SSN) AS [claim!5!rendering-provider-ssn],
		NULL AS [claim!5!rendering-provider-upin],
		-- UPPER(D.UPIN) AS [claim!5!rendering-provider-upin],
		UPPER(D.HipaaProviderTaxonomyCode) 
			AS [claim!5!rendering-provider-specialty-code],
		UPPER(L.BillingName) AS [claim!5!service-facility-name],
		UPPER(L.AddressLine1) AS [claim!5!service-facility-street-1],
		UPPER(L.AddressLine2) AS [claim!5!service-facility-street-2],
		UPPER(L.City) AS [claim!5!service-facility-city],
		UPPER(L.State) AS [claim!5!service-facility-state],
		L.ZipCode AS [claim!5!service-facility-zip],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [secondary!6!secondary-id],
		NULL AS [secondary!6!insured-different-than-patient-flag],
		NULL AS [secondary!6!subscriber-first-name],
		NULL AS [secondary!6!subscriber-middle-name],
		NULL AS [secondary!6!subscriber-last-name],
		NULL AS [secondary!6!subscriber-suffix],
		NULL AS [secondary!6!subscriber-street-1],
		NULL AS [secondary!6!subscriber-street-2],
		NULL AS [secondary!6!subscriber-city],
		NULL AS [secondary!6!subscriber-state],
		NULL AS [secondary!6!subscriber-zip],
		NULL AS [secondary!6!subscriber-birth-date],
		NULL AS [secondary!6!subscriber-gender],
		NULL AS [secondary!6!relation-to-insured-code],
		NULL AS [secondary!6!payer-responsibility-code],
		NULL AS [secondary!6!plan-name],
		NULL AS [secondary!6!group-number],
		NULL AS [secondary!6!policy-numer],
		NULL AS [secondary!6!payer-name],
		NULL AS [secondary!6!payer-identifier],
		NULL AS [secondary!6!payer-contact-name],
		NULL AS [secondary!6!payer-contact-phone],
		NULL AS [secondary!6!payer-paid-flag],
		NULL AS [secondary!6!payer-paid-amount],
		NULL AS [service!7!service-id],
		NULL AS [service!7!control-number],
		NULL AS [service!7!procedure-code],
		NULL AS [service!7!service-date],
		NULL AS [service!7!service-charge-amount],
		NULL AS [service!7!service-unit-count],
		NULL AS [service!7!place-of-service-code],
		NULL AS [service!7!procedure-modifier-1],
		NULL AS [service!7!procedure-modifier-2],
		NULL AS [service!7!procedure-modifier-3],
		NULL AS [service!7!procedure-modifier-4],
		NULL AS [service!7!diagnosis-pointer-1],
		NULL AS [service!7!diagnosis-pointer-2],
		NULL AS [service!7!diagnosis-pointer-3],
		NULL AS [service!7!diagnosis-pointer-4],
		NULL AS [adjudication!8!adjudication-id],
		NULL AS [adjudication!8!payer-identifier],
		NULL AS [adjudication!8!paid-amount],
		NULL AS [adjudication!8!paid-unit-count],
		NULL AS [adjudication!8!paid-date],
		NULL AS [adjudication!8!payer-adjusted-flag],
		NULL AS [adjudication!8!adjustment-reason-1],
		NULL AS [adjudication!8!adjustment-amount-1],
		NULL AS [adjudication!8!adjustment-reason-2],
		NULL AS [adjudication!8!adjustment-amount-2],
		NULL AS [adjudication!8!adjustment-reason-3],
		NULL AS [adjudication!8!adjustment-amount-3],
		NULL AS [adjudication!8!adjustment-reason-4],
		NULL AS [adjudication!8!adjustment-amount-4],
		NULL AS [adjudication!8!adjustment-reason-5],
		NULL AS [adjudication!8!adjustment-amount-5],
		NULL AS [adjudication!8!adjustment-reason-6],
		NULL AS [adjudication!8!adjustment-amount-6]
	FROM	Bill_EDI B
		INNER JOIN Claim RC
		ON RC.ClaimID = B.RepresentativeClaimID
		INNER JOIN Doctor D
		ON D.DoctorID = RC.RenderingProviderID
		INNER JOIN ServiceLocation L
		ON L.ServiceLocationID = RC.FacilityID
		LEFT OUTER JOIN ReferringPhysician RP
--		ON (RP.ReferringPhysicianID = RC.ReferringProviderID)
		ON (RP.ReferringPhysicianID = RC.ReferringProviderID AND RP.UPIN <> '')
		LEFT OUTER JOIN PatientAuthorization A
		ON A.PatientAuthorizationID = RC.AuthorizationID
	WHERE	B.BillBatchID = @batch_id

	UNION ALL

	SELECT	6, 5,
		B.BillBatchID AS [transaction!1!transaction-id],
		NULL AS [transaction!1!control-number],
		NULL AS [transaction!1!created-date],
		NULL AS [transaction!1!current-date],
		RC.PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!ein],
		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],
		B.PayerPatientInsuranceID AS [subscriber!3!subscriber-id],
		B.BillID AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
		NULL AS [subscriber!3!responsible-different-than-patient-flag],
		NULL AS [subscriber!3!responsible-first-name],
		NULL AS [subscriber!3!responsible-middle-name],
		NULL AS [subscriber!3!responsible-last-name],
		NULL AS [subscriber!3!responsible-suffix],
		NULL AS [subscriber!3!responsible-street-1],
		NULL AS [subscriber!3!responsible-street-2],
		NULL AS [subscriber!3!responsible-city],
		NULL AS [subscriber!3!responsible-state],
		NULL AS [subscriber!3!responsible-zip],
		RC.PatientID AS [patient!4!patient-id],
		NULL AS [patient!4!relation-to-insured-code],
		NULL AS [patient!4!dependent-policy-number],
		NULL AS [patient!4!first-name],
		NULL AS [patient!4!middle-name],
		NULL AS [patient!4!last-name],
		NULL AS [patient!4!suffix],
		NULL AS [patient!4!street-1],
		NULL AS [patient!4!street-2],
		NULL AS [patient!4!city],
		NULL AS [patient!4!state],
		NULL AS [patient!4!zip],
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		B.BillID AS [claim!5!claim-id],
		NULL AS [claim!5!control-number],
		NULL AS [claim!5!total-claim-amount],
		NULL AS [claim!5!place-of-service-code],
		NULL AS [claim!5!provider-signature-flag],
		NULL AS [claim!5!medicare-assignment-code],
		NULL AS [claim!5!assignment-of-benefits-flag],
		NULL AS [claim!5!release-of-information-code],
		NULL AS [claim!5!patient-signature-source-code],
		NULL AS [claim!5!auto-accident-related-flag],
		NULL AS [claim!5!abuse-related-flag],
		NULL AS [claim!5!employment-related-flag],
		NULL AS [claim!5!other-accident-related-flag],
		NULL AS [claim!5!auto-accident-state],
		NULL AS [claim!5!special-program-code],
		NULL AS [claim!5!initial-treatment-date],
		NULL AS [claim!5!referral-date],
		NULL AS [claim!5!last-seen-date],
		NULL AS [claim!5!current-illness-date],
		NULL AS [claim!5!acute-manifestation-date],
		NULL AS [claim!5!similar-illness-date],
		NULL AS [claim!5!accident-date],
		NULL AS [claim!5!last-xray-date],
		NULL AS [claim!5!disability-begin-date],
		NULL AS [claim!5!disability-end-date],
		NULL AS [claim!5!last-worked-date],
		NULL AS [claim!5!return-to-work-date],
		NULL AS [claim!5!hospitalization-begin-date],
		NULL AS [claim!5!hospitalization-end-date],
		NULL AS [claim!5!patient-paid-amount],
		NULL AS [claim!5!authorization-number],
		NULL AS [claim!5!diagnosis-1],
		NULL AS [claim!5!diagnosis-2],
		NULL AS [claim!5!diagnosis-3],
		NULL AS [claim!5!diagnosis-4],
		NULL AS [claim!5!diagnosis-5],
		NULL AS [claim!5!diagnosis-6],
		NULL AS [claim!5!diagnosis-7],
		NULL AS [claim!5!diagnosis-8],
		NULL AS [claim!5!referring-provider-flag],
		NULL AS [claim!5!referring-provider-first-name],
		NULL AS [claim!5!referring-provider-middle-name],
		NULL AS [claim!5!referring-provider-last-name],
		NULL AS [claim!5!referring-provider-suffix],
		NULL AS [claim!5!referring-provider-upin],
		NULL AS [claim!5!rendering-provider-first-name],
		NULL AS [claim!5!rendering-provider-middle-name],
		NULL AS [claim!5!rendering-provider-last-name],
		NULL AS [claim!5!rendering-provider-suffix],
		NULL AS [claim!5!rendering-provider-ssn],
		NULL AS [claim!5!rendering-provider-upin],
		NULL AS [claim!5!rendering-provider-specialty-code],
		NULL AS [claim!5!service-facility-name],
		NULL AS [claim!5!service-facility-street-1],
		NULL AS [claim!5!service-facility-street-2],
		NULL AS [claim!5!service-facility-city],
		NULL AS [claim!5!service-facility-state],
		NULL AS [claim!5!service-facility-zip],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		PI.PatientInsuranceID AS [secondary!6!secondary-id],
		PI.HolderDifferentThanPatient
			AS [secondary!6!insured-different-than-patient-flag],
		UPPER(CASE PI.HolderDifferentThanPatient
			WHEN 1 THEN PI.HolderFirstName
			ELSE P.FirstName END)
			AS [secondary!6!subscriber-first-name],
		UPPER(CASE PI.HolderDifferentThanPatient
			WHEN 1 THEN PI.HolderMiddleName
			ELSE P.MiddleName END)
			AS [secondary!6!subscriber-middle-name],
		UPPER(CASE PI.HolderDifferentThanPatient
			WHEN 1 THEN PI.HolderLastName
			ELSE P.Lastname END)
			AS [secondary!6!subscriber-last-name],
		UPPER(CASE PI.HolderDifferentThanPatient
			WHEN 1 THEN PI.HolderSuffix
			ELSE P.Suffix END)
			AS [secondary!6!subscriber-suffix],
		UPPER(CASE PI.HolderDifferentThanPatient
			WHEN 1 THEN PI.HolderAddressLine1
			ELSE P.AddressLine1 END)
			AS [secondary!6!subscriber-street-1],
		UPPER(CASE PI.HolderDifferentThanPatient
			WHEN 1 THEN PI.HolderAddressLine2
			ELSE P.AddressLine2 END)
			AS [secondary!6!subscriber-street-2],
		UPPER(CASE PI.HolderDifferentThanPatient
			WHEN 1 THEN PI.HolderCity
			ELSE P.City END)
			AS [secondary!6!subscriber-city],
		UPPER(CASE PI.HolderDifferentThanPatient
			WHEN 1 THEN PI.HolderState
			ELSE P.State END)
			AS [secondary!6!subscriber-state],
		UPPER(CASE PI.HolderDifferentThanPatient
			WHEN 1 THEN PI.HolderZipCode
			ELSE P.ZipCode END)
			AS [secondary!6!subscriber-zip],
		UPPER(CASE PI.HolderDifferentThanPatient
			WHEN 1 THEN PI.HolderDOB
			ELSE P.DOB END)
			AS [secondary!6!subscriber-birth-date],
		UPPER(CASE PI.HolderDifferentThanPatient
			WHEN 1 THEN PI.HolderGender
			ELSE P.Gender END)
			AS [secondary!6!subscriber-gender],
		UPPER(PI.PatientRelationshipToInsured)
			AS [secondary!6!relation-to-insured-code],
		B.PayerResponsibilityCode 	
			AS [secondary!6!payer-responsibility-code],
		UPPER(ICP.PlanName) AS [secondary!6!plan-name],
		UPPER(PI.GroupNumber) AS [secondary!6!group-number],
		UPPER(PI.PolicyNumber) AS [secondary!6!policy-numer],
		UPPER(ICP.PlanName) AS [secondary!6!payer-name],
		CPL.PayerNumber AS [secondary!6!payer-identifier],
		UPPER(COALESCE(ICP.ContactFirstName + ' ', '')
			+ COALESCE(ICP.ContactMiddleName + ' ', '')
			+ COALESCE(ICP.ContactLastName, ''))
			AS [secondary!6!payer-contact-name],
		ICP.Phone AS [secondary!6!payer-contact-phone],
		dbo.BusinessRule_EDIBillPayerPaid(
			B.BillID, 
			ICP.InsuranceCompanyPlanID) 
			AS [secondary!6!payer-paid-flag],
		dbo.BusinessRule_EDIBillPayerPaidAmount(
			B.BillID,
			ICP.InsuranceCompanyPlanID)
			AS [secondary!6!payer-paid-amount],
		NULL AS [service!7!service-id],
		NULL AS [service!7!control-number],
		NULL AS [service!7!procedure-code],
		NULL AS [service!7!service-date],
		NULL AS [service!7!service-charge-amount],
		NULL AS [service!7!service-unit-count],
		NULL AS [service!7!place-of-service-code],
		NULL AS [service!7!procedure-modifier-1],
		NULL AS [service!7!procedure-modifier-2],
		NULL AS [service!7!procedure-modifier-3],
		NULL AS [service!7!procedure-modifier-4],
		NULL AS [service!7!diagnosis-pointer-1],
		NULL AS [service!7!diagnosis-pointer-2],
		NULL AS [service!7!diagnosis-pointer-3],
		NULL AS [service!7!diagnosis-pointer-4],
		NULL AS [adjudication!8!adjudication-id],
		NULL AS [adjudication!8!payer-identifier],
		NULL AS [adjudication!8!paid-amount],
		NULL AS [adjudication!8!paid-unit-count],
		NULL AS [adjudication!8!paid-date],
		NULL AS [adjudication!8!payer-adjusted-flag],
		NULL AS [adjudication!8!adjustment-reason-1],
		NULL AS [adjudication!8!adjustment-amount-1],
		NULL AS [adjudication!8!adjustment-reason-2],
		NULL AS [adjudication!8!adjustment-amount-2],
		NULL AS [adjudication!8!adjustment-reason-3],
		NULL AS [adjudication!8!adjustment-amount-3],
		NULL AS [adjudication!8!adjustment-reason-4],
		NULL AS [adjudication!8!adjustment-amount-4],
		NULL AS [adjudication!8!adjustment-reason-5],
		NULL AS [adjudication!8!adjustment-amount-5],
		NULL AS [adjudication!8!adjustment-reason-6],
		NULL AS [adjudication!8!adjustment-amount-6]
	FROM	Bill_EDI B
		INNER JOIN Claim RC
		ON RC.ClaimID = B.RepresentativeClaimID
		INNER JOIN Patient P
		ON P.PatientID = RC.PatientID
		INNER JOIN ClaimPayer CP
			INNER JOIN PatientInsurance PI
			ON PI.PatientInsuranceID = CP.PatientInsuranceID
			INNER JOIN InsuranceCompanyPlan ICP
				LEFT OUTER JOIN ClearinghousePayersList CPL
				ON ICP.ClearinghousePayerID = CPL.ClearinghousePayerID
			ON ICP.InsuranceCompanyPlanID = PI.InsuranceCompanyPlanID
		ON CP.ClaimID = RC.ClaimID
		AND CP.PatientInsuranceID <> B.PayerPatientInsuranceID
	WHERE	B.BillBatchID = @batch_id

	UNION ALL

	-- Rendering provider numbers for REF (Doctor provider numbers, Loop 2310B):
	SELECT DISTINCT	10, 5,
		B.BillBatchID AS [transaction!1!transaction-id],
		NULL AS [transaction!1!control-number],
		NULL AS [transaction!1!created-date],
		NULL AS [transaction!1!current-date],
		RC.PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!ein],
		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],
		B.PayerPatientInsuranceID AS [subscriber!3!subscriber-id],
		B.BillID AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
		NULL AS [subscriber!3!responsible-different-than-patient-flag],
		NULL AS [subscriber!3!responsible-first-name],
		NULL AS [subscriber!3!responsible-middle-name],
		NULL AS [subscriber!3!responsible-last-name],
		NULL AS [subscriber!3!responsible-suffix],
		NULL AS [subscriber!3!responsible-street-1],
		NULL AS [subscriber!3!responsible-street-2],
		NULL AS [subscriber!3!responsible-city],
		NULL AS [subscriber!3!responsible-state],
		NULL AS [subscriber!3!responsible-zip],
		RC.PatientID AS [patient!4!patient-id],
		NULL AS [patient!4!relation-to-insured-code],
		NULL AS [patient!4!dependent-policy-number],
		NULL AS [patient!4!first-name],
		NULL AS [patient!4!middle-name],
		NULL AS [patient!4!last-name],
		NULL AS [patient!4!suffix],
		NULL AS [patient!4!street-1],
		NULL AS [patient!4!street-2],
		NULL AS [patient!4!city],
		NULL AS [patient!4!state],
		NULL AS [patient!4!zip],
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		B.BillID AS [claim!5!claim-id],
		NULL AS [claim!5!control-number],
		NULL AS [claim!5!total-claim-amount],
		NULL AS [claim!5!place-of-service-code],
		NULL AS [claim!5!provider-signature-flag],
		NULL AS [claim!5!medicare-assignment-code],
		NULL AS [claim!5!assignment-of-benefits-flag],
		NULL AS [claim!5!release-of-information-code],
		NULL AS [claim!5!patient-signature-source-code],
		NULL AS [claim!5!auto-accident-related-flag],
		NULL AS [claim!5!abuse-related-flag],
		NULL AS [claim!5!employment-related-flag],
		NULL AS [claim!5!other-accident-related-flag],
		NULL AS [claim!5!auto-accident-state],
		NULL AS [claim!5!special-program-code],
		NULL AS [claim!5!initial-treatment-date],
		NULL AS [claim!5!referral-date],
		NULL AS [claim!5!last-seen-date],
		NULL AS [claim!5!current-illness-date],
		NULL AS [claim!5!acute-manifestation-date],
		NULL AS [claim!5!similar-illness-date],
		NULL AS [claim!5!accident-date],
		NULL AS [claim!5!last-xray-date],
		NULL AS [claim!5!disability-begin-date],
		NULL AS [claim!5!disability-end-date],
		NULL AS [claim!5!last-worked-date],
		NULL AS [claim!5!return-to-work-date],
		NULL AS [claim!5!hospitalization-begin-date],
		NULL AS [claim!5!hospitalization-end-date],
		NULL AS [claim!5!patient-paid-amount],
		NULL AS [claim!5!authorization-number],
		NULL AS [claim!5!diagnosis-1],
		NULL AS [claim!5!diagnosis-2],
		NULL AS [claim!5!diagnosis-3],
		NULL AS [claim!5!diagnosis-4],
		NULL AS [claim!5!diagnosis-5],
		NULL AS [claim!5!diagnosis-6],
		NULL AS [claim!5!diagnosis-7],
		NULL AS [claim!5!diagnosis-8],
		NULL AS [claim!5!referring-provider-flag],
		NULL AS [claim!5!referring-provider-first-name],
		NULL AS [claim!5!referring-provider-middle-name],
		NULL AS [claim!5!referring-provider-last-name],
		NULL AS [claim!5!referring-provider-suffix],
		NULL AS [claim!5!referring-provider-upin],
		NULL AS [claim!5!rendering-provider-first-name],
		NULL AS [claim!5!rendering-provider-middle-name],
		NULL AS [claim!5!rendering-provider-last-name],
		NULL AS [claim!5!rendering-provider-suffix],
		NULL AS [claim!5!rendering-provider-ssn],
		NULL AS [claim!5!rendering-provider-upin],
		NULL AS [claim!5!rendering-provider-specialty-code],
		NULL AS [claim!5!service-facility-name],
		NULL AS [claim!5!service-facility-street-1],
		NULL AS [claim!5!service-facility-street-2],
		NULL AS [claim!5!service-facility-city],
		NULL AS [claim!5!service-facility-state],
		NULL AS [claim!5!service-facility-zip],
		PNT.ANSIReferenceIdentificationQualifier AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		PN.ProviderNumber AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		PN.ProviderNumberID AS [secondary!6!secondary-id],		-- the NULL here would break some rare submissions, and any variable may ruin DISTINCT.
		NULL AS [secondary!6!insured-different-than-patient-flag],
		NULL AS [secondary!6!subscriber-first-name],
		NULL AS [secondary!6!subscriber-middle-name],
		NULL AS [secondary!6!subscriber-last-name],
		NULL AS [secondary!6!subscriber-suffix],
		NULL AS [secondary!6!subscriber-street-1],
		NULL AS [secondary!6!subscriber-street-2],
		NULL AS [secondary!6!subscriber-city],
		NULL AS [secondary!6!subscriber-state],
		NULL AS [secondary!6!subscriber-zip],
		NULL AS [secondary!6!subscriber-birth-date],
		NULL AS [secondary!6!subscriber-gender],
		NULL AS [secondary!6!relation-to-insured-code],
		NULL AS [secondary!6!payer-responsibility-code],
		NULL AS [secondary!6!plan-name],
		NULL AS [secondary!6!group-number],
		NULL AS [secondary!6!policy-numer],
		NULL AS [secondary!6!payer-name],
		NULL AS [secondary!6!payer-identifier],
		NULL AS [secondary!6!payer-contact-name],
		NULL AS [secondary!6!payer-contact-phone],
		NULL AS [secondary!6!payer-paid-flag],
		NULL AS [secondary!6!payer-paid-amount],
		NULL AS [service!7!service-id],
		NULL AS [service!7!control-number],
		NULL AS [service!7!procedure-code],
		NULL AS [service!7!service-date],
		NULL AS [service!7!service-charge-amount],
		NULL AS [service!7!service-unit-count],
		NULL AS [service!7!place-of-service-code],
		NULL AS [service!7!procedure-modifier-1],
		NULL AS [service!7!procedure-modifier-2],
		NULL AS [service!7!procedure-modifier-3],
		NULL AS [service!7!procedure-modifier-4],
		NULL AS [service!7!diagnosis-pointer-1],
		NULL AS [service!7!diagnosis-pointer-2],
		NULL AS [service!7!diagnosis-pointer-3],
		NULL AS [service!7!diagnosis-pointer-4],
		NULL AS [adjudication!8!adjudication-id],
		NULL AS [adjudication!8!payer-identifier],
		NULL AS [adjudication!8!paid-amount],
		NULL AS [adjudication!8!paid-unit-count],
		NULL AS [adjudication!8!paid-date],
		NULL AS [adjudication!8!payer-adjusted-flag],
		NULL AS [adjudication!8!adjustment-reason-1],
		NULL AS [adjudication!8!adjustment-amount-1],
		NULL AS [adjudication!8!adjustment-reason-2],
		NULL AS [adjudication!8!adjustment-amount-2],
		NULL AS [adjudication!8!adjustment-reason-3],
		NULL AS [adjudication!8!adjustment-amount-3],
		NULL AS [adjudication!8!adjustment-reason-4],
		NULL AS [adjudication!8!adjustment-amount-4],
		NULL AS [adjudication!8!adjustment-reason-5],
		NULL AS [adjudication!8!adjustment-amount-5],
		NULL AS [adjudication!8!adjustment-reason-6],
		NULL AS [adjudication!8!adjustment-amount-6]
	FROM	Bill_EDI B
		INNER JOIN Claim RC
		ON RC.ClaimID = B.RepresentativeClaimID
		INNER JOIN ClaimPayer CP
			INNER JOIN PatientInsurance PI
			ON PI.PatientInsuranceID = CP.PatientInsuranceID
			INNER JOIN InsuranceCompanyPlan ICP
			ON ICP.InsuranceCompanyPlanID = 
				PI.InsuranceCompanyPlanID
		ON CP.ClaimID = RC.ClaimID
		INNER JOIN Doctor D
		ON D.DoctorID = RC.RenderingProviderID
		INNER JOIN ProviderNumber PN
		ON PN.DoctorID = D.DoctorID 
		INNER JOIN ProviderNumberType PNT
		ON PN.ProviderNumberTypeID = PNT.ProviderNumberTypeID
	WHERE	B.BillBatchID = @batch_id AND
		 ((PN.InsuranceCompanyPlanID IS NULL AND PNT.ANSIReferenceIdentificationQualifier IN ('0B','1B','1C','1D','1G','1H'))    -- 'EI','G2','LU','N5','SY','X5'
			OR
		 (PN.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID AND PNT.ANSIReferenceIdentificationQualifier = 'G2'))  -- payer-assigned Provider ID

	UNION ALL

	SELECT	7, 5,
		B.BillBatchID AS [transaction!1!transaction-id],
		NULL AS [transaction!1!control-number],
		NULL AS [transaction!1!created-date],
		NULL AS [transaction!1!current-date],
		RC.PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!ein],
		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],
		B.PayerPatientInsuranceID AS [subscriber!3!subscriber-id],
		B.BillID AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
		NULL AS [subscriber!3!responsible-different-than-patient-flag],
		NULL AS [subscriber!3!responsible-first-name],
		NULL AS [subscriber!3!responsible-middle-name],
		NULL AS [subscriber!3!responsible-last-name],
		NULL AS [subscriber!3!responsible-suffix],
		NULL AS [subscriber!3!responsible-street-1],
		NULL AS [subscriber!3!responsible-street-2],
		NULL AS [subscriber!3!responsible-city],
		NULL AS [subscriber!3!responsible-state],
		NULL AS [subscriber!3!responsible-zip],
		RC.PatientID AS [patient!4!patient-id],
		NULL AS [patient!4!relation-to-insured-code],
		NULL AS [patient!4!dependent-policy-number],
		NULL AS [patient!4!first-name],
		NULL AS [patient!4!middle-name],
		NULL AS [patient!4!last-name],
		NULL AS [patient!4!suffix],
		NULL AS [patient!4!street-1],
		NULL AS [patient!4!street-2],
		NULL AS [patient!4!city],
		NULL AS [patient!4!state],
		NULL AS [patient!4!zip],
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		B.BillID AS [claim!5!claim-id],
		NULL AS [claim!5!control-number],
		NULL AS [claim!5!total-claim-amount],
		NULL AS [claim!5!place-of-service-code],
		NULL AS [claim!5!provider-signature-flag],
		NULL AS [claim!5!medicare-assignment-code],
		NULL AS [claim!5!assignment-of-benefits-flag],
		NULL AS [claim!5!release-of-information-code],
		NULL AS [claim!5!patient-signature-source-code],
		NULL AS [claim!5!auto-accident-related-flag],
		NULL AS [claim!5!abuse-related-flag],
		NULL AS [claim!5!employment-related-flag],
		NULL AS [claim!5!other-accident-related-flag],
		NULL AS [claim!5!auto-accident-state],
		NULL AS [claim!5!special-program-code],
		NULL AS [claim!5!initial-treatment-date],
		NULL AS [claim!5!referral-date],
		NULL AS [claim!5!last-seen-date],
		NULL AS [claim!5!current-illness-date],
		NULL AS [claim!5!acute-manifestation-date],
		NULL AS [claim!5!similar-illness-date],
		NULL AS [claim!5!accident-date],
		NULL AS [claim!5!last-xray-date],
		NULL AS [claim!5!disability-begin-date],
		NULL AS [claim!5!disability-end-date],
		NULL AS [claim!5!last-worked-date],
		NULL AS [claim!5!return-to-work-date],
		NULL AS [claim!5!hospitalization-begin-date],
		NULL AS [claim!5!hospitalization-end-date],
		NULL AS [claim!5!patient-paid-amount],
		NULL AS [claim!5!authorization-number],
		NULL AS [claim!5!diagnosis-1],
		NULL AS [claim!5!diagnosis-2],
		NULL AS [claim!5!diagnosis-3],
		NULL AS [claim!5!diagnosis-4],
		NULL AS [claim!5!diagnosis-5],
		NULL AS [claim!5!diagnosis-6],
		NULL AS [claim!5!diagnosis-7],
		NULL AS [claim!5!diagnosis-8],
		NULL AS [claim!5!referring-provider-flag],
		NULL AS [claim!5!referring-provider-first-name],
		NULL AS [claim!5!referring-provider-middle-name],
		NULL AS [claim!5!referring-provider-last-name],
		NULL AS [claim!5!referring-provider-suffix],
		NULL AS [claim!5!referring-provider-upin],
		NULL AS [claim!5!rendering-provider-first-name],
		NULL AS [claim!5!rendering-provider-middle-name],
		NULL AS [claim!5!rendering-provider-last-name],
		NULL AS [claim!5!rendering-provider-suffix],
		NULL AS [claim!5!rendering-provider-ssn],
		NULL AS [claim!5!rendering-provider-upin],
		NULL AS [claim!5!rendering-provider-specialty-code],
		NULL AS [claim!5!service-facility-name],
		NULL AS [claim!5!service-facility-street-1],
		NULL AS [claim!5!service-facility-street-2],
		NULL AS [claim!5!service-facility-city],
		NULL AS [claim!5!service-facility-state],
		NULL AS [claim!5!service-facility-zip],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [secondary!6!secondary-id],
		NULL AS [secondary!6!insured-different-than-patient-flag],
		NULL AS [secondary!6!subscriber-first-name],
		NULL AS [secondary!6!subscriber-middle-name],
		NULL AS [secondary!6!subscriber-last-name],
		NULL AS [secondary!6!subscriber-suffix],
		NULL AS [secondary!6!subscriber-street-1],
		NULL AS [secondary!6!subscriber-street-2],
		NULL AS [secondary!6!subscriber-city],
		NULL AS [secondary!6!subscriber-state],
		NULL AS [secondary!6!subscriber-zip],
		NULL AS [secondary!6!subscriber-birth-date],
		NULL AS [secondary!6!subscriber-gender],
		NULL AS [secondary!6!relation-to-insured-code],
		NULL AS [secondary!6!payer-responsibility-code],
		NULL AS [secondary!6!plan-name],
		NULL AS [secondary!6!group-number],
		NULL AS [secondary!6!policy-numer],
		NULL AS [secondary!6!payer-name],
		NULL AS [secondary!6!payer-identifier],
		NULL AS [secondary!6!payer-contact-name],
		NULL AS [secondary!6!payer-contact-phone],
		NULL AS [secondary!6!payer-paid-flag],
		NULL AS [secondary!6!payer-paid-amount],
		C.ClaimID AS [service!7!service-id],
		-- [service!7!control-number] no more than 20 chars. Must differ from [claim!5!control-number]:
		'S' + CONVERT(VARCHAR,RC.PatientID) + '-'
			+ CONVERT(VARCHAR,BC.ClaimID) + '-'
			-- + CONVERT(VARCHAR,B.BillBatchID) + '-' 
			+ CONVERT(VARCHAR,BC.BillID)
			AS [service!7!control-number],
		UPPER(C.ProcedureCode) AS [service!7!procedure-code],
		C.ServiceBeginDate AS [service!7!service-date],
		C.ServiceChargeAmount * C.ServiceUnitCount AS [service!7!service-charge-amount],
		C.ServiceUnitCount AS [service!7!service-unit-count],
		C.PlaceOfServiceCode AS [service!7!place-of-service-code],
		C.ProcedureModifier1 AS [service!7!procedure-modifier-1],
		C.ProcedureModifier2 AS [service!7!procedure-modifier-2],
		C.ProcedureModifier3 AS [service!7!procedure-modifier-3],
		C.ProcedureModifier4 AS [service!7!procedure-modifier-4],
		(CASE WHEN (RC.DiagnosisCode1 <> '') THEN C.DiagnosisPointer1 ELSE NULL END) AS [service!7!diagnosis-pointer-1],
		(CASE WHEN (RC.DiagnosisCode2 <> '') THEN C.DiagnosisPointer2 ELSE NULL END) AS [service!7!diagnosis-pointer-2],
		(CASE WHEN (RC.DiagnosisCode3 <> '') THEN C.DiagnosisPointer3 ELSE NULL END) AS [service!7!diagnosis-pointer-3],
		(CASE WHEN (RC.DiagnosisCode4 <> '') THEN C.DiagnosisPointer4 ELSE NULL END) AS [service!7!diagnosis-pointer-4],
		NULL AS [adjudication!8!adjudication-id],
		NULL AS [adjudication!8!payer-identifier],
		NULL AS [adjudication!8!paid-amount],
		NULL AS [adjudication!8!paid-unit-count],
		NULL AS [adjudication!8!paid-date],
		NULL AS [adjudication!8!payer-adjusted-flag],
		NULL AS [adjudication!8!adjustment-reason-1],
		NULL AS [adjudication!8!adjustment-amount-1],
		NULL AS [adjudication!8!adjustment-reason-2],
		NULL AS [adjudication!8!adjustment-amount-2],
		NULL AS [adjudication!8!adjustment-reason-3],
		NULL AS [adjudication!8!adjustment-amount-3],
		NULL AS [adjudication!8!adjustment-reason-4],
		NULL AS [adjudication!8!adjustment-amount-4],
		NULL AS [adjudication!8!adjustment-reason-5],
		NULL AS [adjudication!8!adjustment-amount-5],
		NULL AS [adjudication!8!adjustment-reason-6],
		NULL AS [adjudication!8!adjustment-amount-6]
	FROM	Bill_EDI B	
		INNER JOIN Claim RC
		ON RC.ClaimID = B.RepresentativeClaimID
		INNER JOIN BillClaim BC
		ON BC.BillID = B.BillID
		AND BC.BillBatchTypeCode = 'E'
		INNER JOIN Claim C
		ON C.ClaimID = BC.ClaimID
	WHERE	B.BillBatchID = @batch_id

	UNION ALL

	SELECT	8, 7,
		B.BillBatchID AS [transaction!1!transaction-id],
		NULL AS [transaction!1!control-number],
		NULL AS [transaction!1!created-date],
		NULL AS [transaction!1!current-date],
		RC.PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!ein],
		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],
		B.PayerPatientInsuranceID AS [subscriber!3!subscriber-id],
		B.BillID AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
		NULL AS [subscriber!3!responsible-different-than-patient-flag],
		NULL AS [subscriber!3!responsible-first-name],
		NULL AS [subscriber!3!responsible-middle-name],
		NULL AS [subscriber!3!responsible-last-name],
		NULL AS [subscriber!3!responsible-suffix],
		NULL AS [subscriber!3!responsible-street-1],
		NULL AS [subscriber!3!responsible-street-2],
		NULL AS [subscriber!3!responsible-city],
		NULL AS [subscriber!3!responsible-state],
		NULL AS [subscriber!3!responsible-zip],
		RC.PatientID AS [patient!4!patient-id],
		NULL AS [patient!4!relation-to-insured-code],
		NULL AS [patient!4!dependent-policy-number],
		NULL AS [patient!4!first-name],
		NULL AS [patient!4!middle-name],
		NULL AS [patient!4!last-name],
		NULL AS [patient!4!suffix],
		NULL AS [patient!4!street-1],
		NULL AS [patient!4!street-2],
		NULL AS [patient!4!city],
		NULL AS [patient!4!state],
		NULL AS [patient!4!zip],
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		B.BillID AS [claim!5!claim-id],
		NULL AS [claim!5!control-number],
		NULL AS [claim!5!total-claim-amount],
		NULL AS [claim!5!place-of-service-code],
		NULL AS [claim!5!provider-signature-flag],
		NULL AS [claim!5!medicare-assignment-code],
		NULL AS [claim!5!assignment-of-benefits-flag],
		NULL AS [claim!5!release-of-information-code],
		NULL AS [claim!5!patient-signature-source-code],
		NULL AS [claim!5!auto-accident-related-flag],
		NULL AS [claim!5!abuse-related-flag],
		NULL AS [claim!5!employment-related-flag],
		NULL AS [claim!5!other-accident-related-flag],
		NULL AS [claim!5!auto-accident-state],
		NULL AS [claim!5!special-program-code],
		NULL AS [claim!5!initial-treatment-date],
		NULL AS [claim!5!referral-date],
		NULL AS [claim!5!last-seen-date],
		NULL AS [claim!5!current-illness-date],
		NULL AS [claim!5!acute-manifestation-date],
		NULL AS [claim!5!similar-illness-date],
		NULL AS [claim!5!accident-date],
		NULL AS [claim!5!last-xray-date],
		NULL AS [claim!5!disability-begin-date],
		NULL AS [claim!5!disability-end-date],
		NULL AS [claim!5!last-worked-date],
		NULL AS [claim!5!return-to-work-date],
		NULL AS [claim!5!hospitalization-begin-date],
		NULL AS [claim!5!hospitalization-end-date],
		NULL AS [claim!5!patient-paid-amount],
		NULL AS [claim!5!authorization-number],
		NULL AS [claim!5!diagnosis-1],
		NULL AS [claim!5!diagnosis-2],
		NULL AS [claim!5!diagnosis-3],
		NULL AS [claim!5!diagnosis-4],
		NULL AS [claim!5!diagnosis-5],
		NULL AS [claim!5!diagnosis-6],
		NULL AS [claim!5!diagnosis-7],
		NULL AS [claim!5!diagnosis-8],
		NULL AS [claim!5!referring-provider-flag],
		NULL AS [claim!5!referring-provider-first-name],
		NULL AS [claim!5!referring-provider-middle-name],
		NULL AS [claim!5!referring-provider-last-name],
		NULL AS [claim!5!referring-provider-suffix],
		NULL AS [claim!5!referring-provider-upin],
		NULL AS [claim!5!rendering-provider-first-name],
		NULL AS [claim!5!rendering-provider-middle-name],
		NULL AS [claim!5!rendering-provider-last-name],
		NULL AS [claim!5!rendering-provider-suffix],
		NULL AS [claim!5!rendering-provider-ssn],
		NULL AS [claim!5!rendering-provider-upin],
		NULL AS [claim!5!rendering-provider-specialty-code],
		NULL AS [claim!5!service-facility-name],
		NULL AS [claim!5!service-facility-street-1],
		NULL AS [claim!5!service-facility-street-2],
		NULL AS [claim!5!service-facility-city],
		NULL AS [claim!5!service-facility-state],
		NULL AS [claim!5!service-facility-zip],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [secondary!6!secondary-id],
		NULL AS [secondary!6!insured-different-than-patient-flag],
		NULL AS [secondary!6!subscriber-first-name],
		NULL AS [secondary!6!subscriber-middle-name],
		NULL AS [secondary!6!subscriber-last-name],
		NULL AS [secondary!6!subscriber-suffix],
		NULL AS [secondary!6!subscriber-street-1],
		NULL AS [secondary!6!subscriber-street-2],
		NULL AS [secondary!6!subscriber-city],
		NULL AS [secondary!6!subscriber-state],
		NULL AS [secondary!6!subscriber-zip],
		NULL AS [secondary!6!subscriber-birth-date],
		NULL AS [secondary!6!subscriber-gender],
		NULL AS [secondary!6!relation-to-insured-code],
		NULL AS [secondary!6!payer-responsibility-code],
		NULL AS [secondary!6!plan-name],
		NULL AS [secondary!6!group-number],
		NULL AS [secondary!6!policy-numer],
		NULL AS [secondary!6!payer-name],
		NULL AS [secondary!6!payer-identifier],
		NULL AS [secondary!6!payer-contact-name],
		NULL AS [secondary!6!payer-contact-phone],
		NULL AS [secondary!6!payer-paid-flag],
		NULL AS [secondary!6!payer-paid-amount],
		C.ClaimID AS [service!7!service-id],
		NULL AS [service!7!control-number],
		NULL AS [service!7!procedure-code],
		NULL AS [service!7!service-date],
		NULL AS [service!7!service-charge-amount],
		NULL AS [service!7!service-unit-count],
		NULL AS [service!7!place-of-service-code],
		NULL AS [service!7!procedure-modifier-1],
		NULL AS [service!7!procedure-modifier-2],
		NULL AS [service!7!procedure-modifier-3],
		NULL AS [service!7!procedure-modifier-4],
		NULL AS [service!7!diagnosis-pointer-1],
		NULL AS [service!7!diagnosis-pointer-2],
		NULL AS [service!7!diagnosis-pointer-3],
		NULL AS [service!7!diagnosis-pointer-4],
		CT.ClaimTransactionID AS [adjudication!8!adjudication-id],
		CPL.PayerNumber AS [adjudication!8!payer-identifier],
		CT.Amount AS [adjudication!8!paid-amount],
		CT.Quantity AS [adjudication!8!paid-unit-count],
		PMT.PaymentDate AS [adjudication!8!paid-date],
		dbo.BusinessRule_EDIBillPayerAdjusted(
			B.BillID,
			ICP.InsuranceCompanyPlanID)
			AS [adjudication!8!payer-adjusted-flag],
		dbo.BusinessRule_EDIBillPayerAdjustmentCode(
			B.BillID,
			ICP.InsuranceCompanyPlanID, 
			1) 
			AS [adjudication!8!adjustment-reason-1],
		dbo.BusinessRule_EDIBillPayerAdjustmentAmount(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			1)
			AS [adjudication!8!adjustment-amount-1],
		dbo.BusinessRule_EDIBillPayerAdjustmentCode(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			1)
			AS [adjudication!8!adjustment-reason-2],
		dbo.BusinessRule_EDIBillPayerAdjustmentAmount(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			2)
			AS [adjudication!8!adjustment-amount-2],
		dbo.BusinessRule_EDIBillPayerAdjustmentCode(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			3)
			AS [adjudication!8!adjustment-reason-3],
		dbo.BusinessRule_EDIBillPayerAdjustmentAmount(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			3)
			AS [adjudication!8!adjustment-amount-3],
		dbo.BusinessRule_EDIBillPayerAdjustmentCode(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			4)
			AS [adjudication!8!adjustment-reason-4],
		dbo.BusinessRule_EDIBillPayerAdjustmentAmount(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			4)
			AS [adjudication!8!adjustment-amount-4],
		dbo.BusinessRule_EDIBillPayerAdjustmentCode(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			5)
			AS [adjudication!8!adjustment-reason-5],
		dbo.BusinessRule_EDIBillPayerAdjustmentAmount(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			5)
			AS [adjudication!8!adjustment-amount-5],
		dbo.BusinessRule_EDIBillPayerAdjustmentCode(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			6)
			AS [adjudication!8!adjustment-reason-6],
		dbo.BusinessRule_EDIBillPayerAdjustmentAmount(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			6)
			AS [adjudication!8!adjustment-amount-6]
	FROM	Bill_EDI B
		INNER JOIN Claim RC
		ON RC.ClaimID = B.RepresentativeClaimID
		INNER JOIN BillClaim BC
		ON BC.BillID = B.BillID
		AND BC.BillBatchTypeCode = 'E'
		INNER JOIN Claim C
		ON C.ClaimID = BC.ClaimID
		INNER JOIN ClaimTransaction CT
		ON CT.ClaimID = C.ClaimID
		AND CT.ClaimTransactionTypeCode = 'PAY'
		INNER JOIN Payment PMT
		ON PMT.PaymentID = CT.ReferenceID
		AND PMT.PayerTypeCode = 'I'
		INNER JOIN InsuranceCompanyPlan ICP
			LEFT OUTER JOIN ClearinghousePayersList CPL
			ON ICP.ClearinghousePayerID = CPL.ClearinghousePayerID
		ON ICP.InsuranceCompanyPlanID = PMT.PayerID
	WHERE	B.BillBatchID = @batch_id

	UNION ALL

	-- payer assigned provider IDs for the Practice, Loop 2010AA (Group Numbers):  
	SELECT	9, 2,
		BB.BillBatchID AS [transaction!1!transaction-id],
		NULL AS [transaction!1!control-number],
		NULL AS [transaction!1!created-date],
		NULL AS [transaction!1!current-date],
		PR.PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!ein],
		GNT.ANSIReferenceIdentificationQualifier AS [secondaryident!9!id-qualifier],
		PIGN.GroupNumber AS [secondaryident!9!provider-id],
		NULL AS [subscriber!3!subscriber-id],
		NULL AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
		NULL AS [subscriber!3!responsible-different-than-patient-flag],
		NULL AS [subscriber!3!responsible-first-name],
		NULL AS [subscriber!3!responsible-middle-name],
		NULL AS [subscriber!3!responsible-last-name],
		NULL AS [subscriber!3!responsible-suffix],
		NULL AS [subscriber!3!responsible-street-1],
		NULL AS [subscriber!3!responsible-street-2],
		NULL AS [subscriber!3!responsible-city],
		NULL AS [subscriber!3!responsible-state],
		NULL AS [subscriber!3!responsible-zip],
		NULL AS [patient!4!patient-id],
		NULL AS [patient!4!relation-to-insured-code],
		NULL AS [patient!4!dependent-policy-number],
		NULL AS [patient!4!first-name],
		NULL AS [patient!4!middle-name],
		NULL AS [patient!4!last-name],
		NULL AS [patient!4!suffix],
		NULL AS [patient!4!street-1],
		NULL AS [patient!4!street-2],
		NULL AS [patient!4!city],
		NULL AS [patient!4!state],
		NULL AS [patient!4!zip],
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		NULL AS [claim!5!claim-id],
		NULL AS [claim!5!control-number],
		NULL AS [claim!5!total-claim-amount],
		NULL AS [claim!5!place-of-service-code],
		NULL AS [claim!5!provider-signature-flag],
		NULL AS [claim!5!medicare-assignment-code],
		NULL AS [claim!5!assignment-of-benefits-flag],
		NULL AS [claim!5!release-of-information-code],
		NULL AS [claim!5!patient-signature-source-code],
		NULL AS [claim!5!auto-accident-related-flag],
		NULL AS [claim!5!abuse-related-flag],
		NULL AS [claim!5!employment-related-flag],
		NULL AS [claim!5!other-accident-related-flag],
		NULL AS [claim!5!auto-accident-state],
		NULL AS [claim!5!special-program-code],
		NULL AS [claim!5!initial-treatment-date],
		NULL AS [claim!5!referral-date],
		NULL AS [claim!5!last-seen-date],
		NULL AS [claim!5!current-illness-date],
		NULL AS [claim!5!acute-manifestation-date],
		NULL AS [claim!5!similar-illness-date],
		NULL AS [claim!5!accident-date],
		NULL AS [claim!5!last-xray-date],
		NULL AS [claim!5!disability-begin-date],
		NULL AS [claim!5!disability-end-date],
		NULL AS [claim!5!last-worked-date],
		NULL AS [claim!5!return-to-work-date],
		NULL AS [claim!5!hospitalization-begin-date],
		NULL AS [claim!5!hospitalization-end-date],
		NULL AS [claim!5!patient-paid-amount],
		NULL AS [claim!5!authorization-number],
		NULL AS [claim!5!diagnosis-1],
		NULL AS [claim!5!diagnosis-2],
		NULL AS [claim!5!diagnosis-3],
		NULL AS [claim!5!diagnosis-4],
		NULL AS [claim!5!diagnosis-5],
		NULL AS [claim!5!diagnosis-6],
		NULL AS [claim!5!diagnosis-7],
		NULL AS [claim!5!diagnosis-8],
		NULL AS [claim!5!referring-provider-flag],
		NULL AS [claim!5!referring-provider-first-name],
		NULL AS [claim!5!referring-provider-middle-name],
		NULL AS [claim!5!referring-provider-last-name],
		NULL AS [claim!5!referring-provider-suffix],
		NULL AS [claim!5!referring-provider-upin],
		NULL AS [claim!5!rendering-provider-first-name],
		NULL AS [claim!5!rendering-provider-middle-name],
		NULL AS [claim!5!rendering-provider-last-name],
		NULL AS [claim!5!rendering-provider-suffix],
		NULL AS [claim!5!rendering-provider-ssn],
		NULL AS [claim!5!rendering-provider-upin],
		NULL AS [claim!5!rendering-provider-specialty-code],
		NULL AS [claim!5!service-facility-name],
		NULL AS [claim!5!service-facility-street-1],
		NULL AS [claim!5!service-facility-street-2],
		NULL AS [claim!5!service-facility-city],
		NULL AS [claim!5!service-facility-state],
		NULL AS [claim!5!service-facility-zip],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [secondary!6!secondary-id],
		NULL AS [secondary!6!insured-different-than-patient-flag],
		NULL AS [secondary!6!subscriber-first-name],
		NULL AS [secondary!6!subscriber-middle-name],
		NULL AS [secondary!6!subscriber-last-name],
		NULL AS [secondary!6!subscriber-suffix],
		NULL AS [secondary!6!subscriber-street-1],
		NULL AS [secondary!6!subscriber-street-2],
		NULL AS [secondary!6!subscriber-city],
		NULL AS [secondary!6!subscriber-state],
		NULL AS [secondary!6!subscriber-zip],
		NULL AS [secondary!6!subscriber-birth-date],
		NULL AS [secondary!6!subscriber-gender],
		NULL AS [secondary!6!relation-to-insured-code],
		NULL AS [secondary!6!payer-responsibility-code],
		NULL AS [secondary!6!plan-name],
		NULL AS [secondary!6!group-number],
		NULL AS [secondary!6!policy-numer],
		NULL AS [secondary!6!payer-name],
		NULL AS [secondary!6!payer-identifier],
		NULL AS [secondary!6!payer-contact-name],
		NULL AS [secondary!6!payer-contact-phone],
		NULL AS [secondary!6!payer-paid-flag],
		NULL AS [secondary!6!payer-paid-amount],
		NULL AS [service!7!service-id],
		NULL AS [service!7!control-number],
		NULL AS [service!7!procedure-code],
		NULL AS [service!7!service-date],
		NULL AS [service!7!service-charge-amount],
		NULL AS [service!7!service-unit-count],
		NULL AS [service!7!place-of-service-code],
		NULL AS [service!7!procedure-modifier-1],
		NULL AS [service!7!procedure-modifier-2],
		NULL AS [service!7!procedure-modifier-3],
		NULL AS [service!7!procedure-modifier-4],
		NULL AS [service!7!diagnosis-pointer-1],
		NULL AS [service!7!diagnosis-pointer-2],
		NULL AS [service!7!diagnosis-pointer-3],
		NULL AS [service!7!diagnosis-pointer-4],
		NULL AS [adjudication!8!adjudication-id],
		NULL AS [adjudication!8!payer-identifier],
		NULL AS [adjudication!8!paid-amount],
		NULL AS [adjudication!8!paid-unit-count],
		NULL AS [adjudication!8!paid-date],
		NULL AS [adjudication!8!payer-adjusted-flag],
		NULL AS [adjudication!8!adjustment-reason-1],
		NULL AS [adjudication!8!adjustment-amount-1],
		NULL AS [adjudication!8!adjustment-reason-2],
		NULL AS [adjudication!8!adjustment-amount-2],
		NULL AS [adjudication!8!adjustment-reason-3],
		NULL AS [adjudication!8!adjustment-amount-3],
		NULL AS [adjudication!8!adjustment-reason-4],
		NULL AS [adjudication!8!adjustment-amount-4],
		NULL AS [adjudication!8!adjustment-reason-5],
		NULL AS [adjudication!8!adjustment-amount-5],
		NULL AS [adjudication!8!adjustment-reason-6],
		NULL AS [adjudication!8!adjustment-amount-6]

		FROM	BillBatch BB
			INNER JOIN Practice PR
			ON PR.PracticeID = BB.PracticeID
			INNER JOIN PracticeInsuranceGroupNumber PIGN
			ON PIGN.PracticeID = PR.PracticeID 
			INNER JOIN GroupNumberType GNT
			ON GNT.GroupNumberTypeID = PIGN.GroupNumberTypeID
		WHERE	BB.BillBatchID = @batch_id AND (GNT.ANSIReferenceIdentificationQualifier IN ('1A','1B','1C','1D','1G','1H')) -- '0B','1J','B3','BQ','EI','FH','G2','G5','LU','SY','U3','X5'


	ORDER BY [transaction!1!transaction-id], 
		[billing!2!billing-id], 
		[subscriber!3!subscriber-id], 
		[subscriber!3!encounter-id], 
		[patient!4!patient-id], 
		[claim!5!claim-id], 
		[secondary!6!secondary-id], 
		[service!7!service-id], 
		[adjudication!8!adjudication-id],
		[secondaryident!9!id-qualifier]
	FOR XML EXPLICIT
END


GO
PRINT N'Altering [dbo].[ClaimDataProvider_GetClaims]'
GO

--===========================================================================
-- GET CLAIMS
--===========================================================================
ALTER PROCEDURE dbo.ClaimDataProvider_GetClaims
	@practice_id INT,
	@status VARCHAR(100),
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(64) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	CREATE TABLE #t_claims(
		ClaimID int,
		DateOfService datetime,
		ProcedureCode varchar(48),
		ProcedureModifier1 char(2),
		PatientDisplayName varchar(100),
		AssignmentIndicator char(1),
		AssignedToDisplayName varchar(100),
		Charges money default(0),
		Receipts money default(0),
		Balance money default(0),
		ClearinghouseTrackingNumber varchar(64),
		PayerTrackingNumber varchar(64),
		ClearinghouseProcessingStatus varchar(1),
		PayerProcessingStatus varchar (256),
		ClearinghousePayer varchar(64),
		Editable bit,
		Status varchar(64),
		RID int IDENTITY(0,1)
	)
	
	DECLARE @sql varchar(8000)
	
	IF @status != 'ReadyForInsuranceElectronicOnly'
	BEGIN
		INSERT #t_claims
		SELECT	C.ClaimID,
			C.ServiceBeginDate AS DateOfService,
			C.ProcedureCode,
			C.ProcedureModifier1,
			COALESCE(P.LastName + ',', '')
				+ COALESCE(' ' + P.FirstName, '')
				+ COALESCE(' ' + P.MiddleName, '') 
				AS PatientDisplayName,
				C.AssignmentIndicator,
				CAST((CASE (C.AssignmentIndicator)
				WHEN NULL THEN 'Unassigned'
				WHEN 'P' THEN 'Patient'
				ELSE ICP.PlanName
				END) AS varchar(100)) AS AssignedToDisplayName,
			COALESCE(C.ServiceUnitCount,1) * COALESCE(C.ServiceChargeAmount,0) AS Charges,
			CAST(0 AS MONEY) AS Receipts,
			CAST(0 AS MONEY) AS Balance,
			C.ClearinghouseTrackingNumber,
			C.PayerTrackingNumber,
			C.ClearinghouseProcessingStatus,
			C.PayerProcessingStatus,
			C.ClearinghousePayer,
			CAST(0 AS BIT) AS Editable,
			(CASE (C.ClaimStatusCode)
				WHEN 'C' THEN 'Completed'
				WHEN 'P' THEN 'Pending'
				WHEN 'R' THEN 'Ready'
				ELSE '*** Undefined'
				END) 
			AS Status
		FROM	dbo.Claim C
			INNER JOIN dbo.Patient P
			ON P.PatientID = C.PatientID
			LEFT OUTER JOIN ClaimPayer CP
				INNER JOIN PatientInsurance PI
				ON PI.PatientInsuranceID = CP.PatientInsuranceID
				INNER JOIN InsuranceCompanyPlan ICP
				ON ICP.InsuranceCompanyPlanID = PI.InsuranceCompanyPlanID
			ON C.ClaimID = CP.ClaimID
			AND C.AssignmentIndicator = CAST(CP.Precedence AS VARCHAR)
			AND (SELECT MAX(ClaimPayerID) from dbo.ClaimPayer CP2 WHERE CP2.ClaimID = CP.ClaimID AND CP2.Precedence = CP.Precedence)
				= CP.ClaimPayerID
		WHERE	C.PracticeID = @practice_id
		AND (	(@query_domain IS NULL OR @query IS NULL)
			OR	((@query_domain = 'ClaimID' OR @query_domain = 'All')
				AND CAST(C.ClaimID AS VARCHAR(50)) LIKE '%' + @query + '%')
			OR	((@query_domain = 'ClearinghouseProcessingStatus' OR @query_domain = 'All')
				AND C.ClearinghouseProcessingStatus = @query)
			OR	((@query_domain = 'ClearinghouseTrackingNumber' OR @query_domain = 'All')
				AND C.ClearinghouseTrackingNumber LIKE '%' + @query + '%')
			OR	((@query_domain = 'PayerProcessingStatus' OR @query_domain = 'All')
				AND C.PayerProcessingStatus LIKE '%' + @query + '%')
			OR	((@query_domain = 'PayerTrackingNumber' OR @query_domain = 'All')
				AND C.PayerTrackingNumber LIKE '%' + @query + '%')
			OR	((@query_domain = 'PatientID' OR @query_domain = 'All')
				AND CAST(P.PatientID AS VARCHAR(50)) LIKE '%' + @query + '%')
			OR	((@query_domain = 'PatientName' OR @query_domain = 'All')
				AND (P.FirstName LIKE '%' + @query + '%' OR P.LastName LIKE '%' + @query + '%')
			OR	((@query_domain = 'PatientName' OR @query_domain = 'All')
				AND 	(P.FirstName LIKE '%' + @query + '%' 
					OR P.LastName LIKE '%' + @query + '%'
					OR (P.FirstName + P.LastName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%'
					OR (P.LastName + P.FirstName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%'
				))
			)
		    )
		AND	(@status = 'Any'
			OR	(@status = 'ReadyForInsurance'
				AND C.ClaimStatusCode = 'R'
				AND C.AssignmentIndicator IS NOT NULL
				AND C.AssignmentIndicator IN ('1','2','3','4','5','6','7','8','9'))
			OR	(@status = 'ReadyForPatient'
				AND C.ClaimStatusCode = 'R'
				AND C.AssignmentIndicator IS NOT NULL
				AND C.AssignmentIndicator = 'P')
			OR	(@status = 'Completed'
				AND C.ClaimStatusCode = 'C')
			OR	(@status = 'Pending'
				AND C.ClaimStatusCode = 'P')
		  	)


		ORDER BY C.ClaimID

		SET @totalRecords = @@ROWCOUNT
		
		IF @maxRecords = 0
			SET @maxRecords = @totalRecords
	
		--Get rid of the records we don't want
		DELETE #t_claims
		WHERE RID < @startRecord
			OR RID > (@startRecord + @maxRecords - 1)
			
		CREATE UNIQUE CLUSTERED INDEX #ux_t_claims_claim_id
		ON #t_claims
			(ClaimID)
		WITH
		FILLFACTOR = 100
	
		UPDATE TC
			SET AssignedToDisplayName =  ICP.PlanName
		FROM #t_claims TC
			INNER JOIN dbo.ClaimPayer CP
			ON TC.ClaimID = CP.ClaimID
					INNER JOIN PatientInsurance PI
					ON PI.PatientInsuranceID = CP.PatientInsuranceID
					INNER JOIN InsuranceCompanyPlan ICP
					ON ICP.InsuranceCompanyPlanID = PI.InsuranceCompanyPlanID
				AND TC.AssignmentIndicator = CAST(CP.Precedence AS VARCHAR)
				AND (SELECT MAX(ClaimPayerID) from dbo.ClaimPayer CP2 WHERE CP2.ClaimID = CP.ClaimID AND CP2.Precedence = CP.Precedence)
					= CP.ClaimPayerID
		WHERE TC.AssignmentIndicator IS NOT NULL
			AND TC.AssignmentIndicator <> 'P'
	END
	ELSE
	BEGIN
		--This status requires that ICP's have an EDINumber to be considered
		--thus some of the optimization will be lost in this case
		SET @sql =
		'
		DECLARE @query_domain varchar(64)
		DECLARE @query  varchar(64)

		SET @query_domain = ''' + CAST(@query_domain AS varchar(64)) + '''
		SET @query = ''' + CAST(@query AS varchar(64)) + '''

		INSERT #t_claims
		SELECT	C.ClaimID,
			C.ServiceBeginDate AS DateOfService,
			C.ProcedureCode,
			C.ProcedureModifier1,
			COALESCE(P.LastName + '','', '''')
				+ COALESCE('' '' + P.FirstName, '''')
				+ COALESCE('' '' + P.MiddleName, '''') 
				AS PatientDisplayName,
			C.AssignmentIndicator,
			(CASE (C.AssignmentIndicator)
				WHEN NULL THEN ''Unassigned''
				WHEN ''P'' THEN ''Patient''
				ELSE ICP.PlanName
				END) 
				AS AssignedToDisplayName,
			COALESCE(C.ServiceUnitCount,1) * COALESCE(C.ServiceChargeAmount,0) AS Charges,
			CAST(0 AS MONEY) AS Receipts,
			CAST(0 AS MONEY) AS Balance,
			C.ClearinghouseTrackingNumber,
			C.PayerTrackingNumber,
			C.ClearinghouseProcessingStatus,
			C.PayerProcessingStatus,
			C.ClearinghousePayer,
			CAST(0 AS BIT) AS Editable,
			(CASE (C.ClaimStatusCode)
				WHEN ''C'' THEN ''Completed''
				WHEN ''P'' THEN ''Pending''
				WHEN ''R'' THEN ''Ready''
				ELSE ''*** Undefined''
				END) 
			AS Status
		FROM	dbo.Claim C
			INNER JOIN dbo.Patient P
			ON P.PatientID = C.PatientID
			LEFT OUTER JOIN ClaimPayer CP
				INNER JOIN PatientInsurance PI
				ON PI.PatientInsuranceID = CP.PatientInsuranceID
				INNER JOIN InsuranceCompanyPlan ICP
					LEFT OUTER JOIN ClearinghousePayersList CPL
					ON ICP.ClearinghousePayerID = CPL.ClearinghousePayerID
				ON ICP.InsuranceCompanyPlanID = PI.InsuranceCompanyPlanID
			ON C.ClaimID = CP.ClaimID
			AND C.AssignmentIndicator = CAST(CP.Precedence AS VARCHAR)
			AND (SELECT MAX(ClaimPayerID) from dbo.ClaimPayer CP2 WHERE CP2.ClaimID = CP.ClaimID AND CP2.Precedence = CP.Precedence)
				= CP.ClaimPayerID
			INNER JOIN Practice PR
			ON C.PracticeID = PR.PracticeID
			LEFT OUTER JOIN PracticeToInsuranceCompanyPlan PTICP
			ON PTICP.PracticeID = PR.PracticeID AND PTICP.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
		WHERE	C.PracticeID = ' + CAST(@practice_id AS varchar(10)) +

		'AND (	(@query_domain IS NULL OR @query IS NULL)
			OR	((@query_domain = ''ClaimID'' OR @query_domain = ''All'')
				AND CAST(C.ClaimID AS VARCHAR(50)) LIKE ''%'' + @query + ''%'')
			OR	((@query_domain = ''ClearinghouseProcessingStatus'' OR @query_domain = ''All'')
				AND C.ClearinghouseProcessingStatus = @query)
			OR	((@query_domain = ''ClearinghouseTrackingNumber'' OR @query_domain = ''All'')
				AND C.ClearinghouseTrackingNumber LIKE ''%'' + @query + ''%'')
			OR	((@query_domain = ''PayerProcessingStatus'' OR @query_domain = ''All'')
				AND C.PayerProcessingStatus LIKE ''%'' + @query + ''%'')
			OR	((@query_domain = ''PayerTrackingNumber'' OR @query_domain = ''All'')
				AND C.PayerTrackingNumber LIKE ''%'' + @query + ''%'')
			OR	((@query_domain = ''PatientID'' OR @query_domain = ''All'')
				AND CAST(P.PatientID AS VARCHAR(50)) LIKE ''%'' + @query + ''%'')
			OR	((@query_domain = ''PatientName'' OR @query_domain = ''All'')
				AND (P.FirstName LIKE ''%'' + @query + ''%'' OR P.LastName LIKE ''%'' + @query + ''%'')
			OR	((@query_domain = ''PatientName'' OR @query_domain = ''All'')
				AND 	(P.FirstName LIKE ''%'' + @query + ''%'' 
					OR P.LastName LIKE ''%'' + @query + ''%''
					OR (P.FirstName + P.LastName) LIKE  ''%'' + REPLACE(REPLACE(@query,'' '',''''),'','','''') + ''%''
					OR (P.LastName + P.FirstName) LIKE  ''%'' + REPLACE(REPLACE(@query,'' '',''''),'','','''') + ''%''
				)))
			)
	-- see BillDataProvider.sql: BillDataProvider_CreateEDIBatch (and keep the code there in sync)
		AND C.ClaimStatusCode = ''R''
		AND PR.EClaimsEnrollmentStatusID > 1
		AND ICP.EClaimsAccepts = 1 AND (PTICP.EClaimsDisable IS NULL OR PTICP.EClaimsDisable = 0)
		AND CPL.PayerNumber IS NOT NULL
		AND (CPL.IsEnrollmentRequired = 0 OR PTICP.EClaimsEnrollmentStatusID > 1) 
		AND C.AssignmentIndicator IS NOT NULL
		AND C.AssignmentIndicator <> ''P''
		AND C.AutoAccidentRelatedFlag = 0
		AND C.EmploymentRelatedFlag = 0
		AND C.NonElectronicOverrideFlag <> 1
		AND CP.Precedence = 1
		AND NOT EXISTS (SELECT	CT.ClaimTransactionID
				FROM	ClaimTransaction CT
				WHERE	CT.ClaimID = CP.ClaimID AND CT.ClaimTransactionTypeCode = ''ADJ'')
		ORDER BY C.ClaimID
		'

/*		
		IF @patient_id IS NOT NULL
			SET @sql = @sql + ' AND C.PatientID = ' + CAST(@patient_id AS varchar(10))
			
		IF @doctor_id IS NOT NULL
			SET @sql = @sql + ' AND C.RenderingProviderID = ' + CAST(@doctor_id AS varchar(10))
		
		IF @service_date_from IS NOT NULL
			SET @sql = @sql + ' AND C.ServiceBeginDate >= ' + CAST(@service_date_from AS varchar(25))
		
		IF @service_date_to IS NOT NULL
			SET @sql = @sql + ' AND C.ServiceBeginDate <= ' + CAST(@service_date_to AS varchar(25))
*/
				
		EXEC(@sql)
			
		SELECT @totalRecords = COUNT(*)
		FROM #t_claims
	
		IF @maxRecords = 0
			SET @maxRecords = @totalRecords
			
		--Get rid of the records we don't want
		DELETE #t_claims
		WHERE RID < @startRecord
			OR RID > (@startRecord + @maxRecords - 1)
			
		CREATE UNIQUE CLUSTERED INDEX #ux_t_claims_claim_id
		ON #t_claims
			(ClaimID)
		WITH
		FILLFACTOR = 100
	END

	UPDATE T
		SET Charges = Charges - TAmount.Amount
	FROM #t_claims T INNER JOIN	
		(	SELECT CT.ClaimID, SUM(COALESCE(CT.Amount,0)) as Amount
			FROM #t_claims T INNER JOIN
				dbo.ClaimTransaction CT ON
					T.ClaimID = CT.ClaimID
			WHERE CT.ClaimTransactionTypeCode IN ('ADJ','END')				
			GROUP BY CT.ClaimID ) as TAmount ON
		T.ClaimID = TAmount.ClaimID

	UPDATE T
		SET Receipts = TAmount.Amount
	FROM #t_claims T INNER JOIN	
		(	SELECT CT.ClaimID, SUM(COALESCE(CT.Amount,0)) as Amount
			FROM #t_claims T INNER JOIN
				dbo.ClaimTransaction CT ON
					T.ClaimID = CT.ClaimID
			WHERE CT.ClaimTransactionTypeCode = 'PAY'				
			GROUP BY CT.ClaimID ) as TAmount ON
		T.ClaimID = TAmount.ClaimID

-- case 2809:
	UPDATE #t_claims
--		SET Balance = Charges - Receipts
		SET Balance = dbo.BusinessRule_ClaimBalanceAmount(ClaimID), 
		    Editable = dbo.BusinessRule_ClaimIsEditable(ClaimID)
	
	SELECT * 
	FROM #t_claims T
	ORDER BY T.DateOfService DESC
	
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	
	DROP TABLE #t_claims
	RETURN
END


GO
PRINT N'Adding foreign keys to [dbo].[InsuranceCompanyPlan]'
GO
ALTER TABLE [dbo].[InsuranceCompanyPlan] ADD
CONSTRAINT [FK_InsuranceCompanyPlan_ClearinghousePayersList] FOREIGN KEY ([ClearinghousePayerID]) REFERENCES [dbo].[ClearinghousePayersList] ([ClearinghousePayerID]),
CONSTRAINT [FK_InsuranceCompanyPlan_GroupNumberType] FOREIGN KEY ([GroupNumberTypeID]) REFERENCES [dbo].[GroupNumberType] ([GroupNumberTypeID]),
CONSTRAINT [FK_InsuranceCompanyPlan_ProviderNumberType] FOREIGN KEY ([ProviderNumberTypeID]) REFERENCES [dbo].[ProviderNumberType] ([ProviderNumberTypeID]),
CONSTRAINT [FK_InsuranceCompanyPlan_ProviderNumberType_LocalUse] FOREIGN KEY ([LocalUseProviderNumberTypeID]) REFERENCES [dbo].[ProviderNumberType] ([ProviderNumberTypeID])
GO
PRINT N'Adding foreign keys to [dbo].[PracticeInsuranceGroupNumber]'
GO
ALTER TABLE [dbo].[PracticeInsuranceGroupNumber] ADD
CONSTRAINT [FK_PracticeInsuranceGroupNumber_GroupNumberType] FOREIGN KEY ([GroupNumberTypeID]) REFERENCES [dbo].[GroupNumberType] ([GroupNumberTypeID])
GO
PRINT N'Adding foreign keys to [dbo].[ProviderNumber]'
GO
ALTER TABLE [dbo].[ProviderNumber] ADD
CONSTRAINT [FK_ProviderNumber_ProviderNumberType] FOREIGN KEY ([ProviderNumberTypeID]) REFERENCES [dbo].[ProviderNumberType] ([ProviderNumberTypeID])
GO
PRINT N'Adding foreign keys to [dbo].[Report]'
GO
ALTER TABLE [dbo].[Report] ADD
CONSTRAINT [FK_Report_ReportCategory] FOREIGN KEY ([ReportCategoryID]) REFERENCES [dbo].[ReportCategory] ([ReportCategoryID])
GO
UPDATE ProcedureModifier
	SET KareoProcedureModifierCode = ProcedureModifierCode
	
UPDATE InsuranceCompanyPlan
	SET KareoInsuranceCompanyPlanID = InsuranceCompanyPlanID
	
UPDATE ClearinghousePayersList
	SET KareoClearinghousePayersListID = ClearinghousePayerID

UPDATE DiagnosisCodeDictionary
	SET KareoDiagnosisCodeDictionaryID = DiagnosisCodeDictionaryID

UPDATE ProcedureCodeDictionary
	SET KareoProcedureCodeDictionaryID = ProcedureCodeDictionaryID

