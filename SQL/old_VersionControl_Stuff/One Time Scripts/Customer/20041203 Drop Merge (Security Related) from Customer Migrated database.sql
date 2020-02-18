/*==============================================================*/
/* Database name:  Database                                     */
/* DBMS name:      Microsoft SQL Server 2000                    */
/* Created on:     12/3/2004 10:56:32                           */
/*==============================================================*/


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_UpdateUser')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_UpdateUser
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_UpdateSecuritySettings')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_UpdateSecuritySettings
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_UpdateGroupPermission')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_UpdateGroupPermission
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_UpdateGroup')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_UpdateGroup
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_UnsetUserGroup')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_UnsetUserGroup
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_UnsetGroupUser')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_UnsetGroupUser
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_SetUserGroup')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_SetUserGroup
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_SetPasswordWithOldSecretAnswer')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_SetPasswordWithOldSecretAnswer
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_SetPasswordWithOldPassword')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_SetPasswordWithOldPassword
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_SetPassword')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_SetPassword
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_SetGroupUser')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_SetGroupUser
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_GetUsers')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_GetUsers
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_GetUserGroups')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_GetUserGroups
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_GetUser')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_GetUser
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_GetSecuritySettings')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_GetSecuritySettings
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_GetSecretQuestion')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_GetSecretQuestion
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_GetPermissionsByUser')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_GetPermissionsByUser
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_GetPermissions')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_GetPermissions
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_GetPermissionGroups')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_GetPermissionGroups
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_GetPermissionDetailsByUser')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_GetPermissionDetailsByUser
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_GetPermissionDetailsByGroups')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_GetPermissionDetailsByGroups
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_GetGroups')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_GetGroups
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_GetGroupUsers')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_GetGroupUsers
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_GetGroupPermissions')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_GetGroupPermissions
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_GetGroup')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_GetGroup
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_DeleteUser')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_DeleteUser
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_DeleteGroup')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_DeleteGroup
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_CreateUser')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_CreateUser
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_CreateGroup')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_CreateGroup
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_AuthenticateSecretAnswer')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_AuthenticateSecretAnswer
go


if exists (select 1
          from sysobjects
          where  id = object_id('dbo.AuthenticationDataProvider_Authenticate')
          and type = 'P')
   drop procedure dbo.AuthenticationDataProvider_Authenticate
go


alter table dbo.GroupPermissions
   drop constraint FK_GroupPermissions_Groups
go


alter table dbo.GroupPermissions
   drop constraint FK_GroupPermissions_Permissions
go


alter table dbo.Permissions
   drop constraint FK_Permission_PermissionGroup
go


alter table dbo.UserGroups
   drop constraint FK_UserGroups_Groups
go


alter table dbo.UserGroups
   drop constraint FK_UserGroups_Users
go


alter table dbo.UserPractices
   drop constraint FK_UserPractices_Users
go


alter table dbo.Users
   drop constraint FK_Users_UserPassword
go


if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.GroupPermissions')
            and   type = 'U')
   drop table dbo.GroupPermissions
go


if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.Groups')
            and   type = 'U')
   drop table dbo.Groups
go


if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.PermissionGroup')
            and   type = 'U')
   drop table dbo.PermissionGroup
go


if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.Permissions')
            and   type = 'U')
   drop table dbo.Permissions
go


if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.SecurityGroup')
            and   type = 'U')
   drop table dbo.SecurityGroup
go


if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.SecuritySetting')
            and   type = 'U')
   drop table dbo.SecuritySetting
go


if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.SubApplications')
            and   type = 'U')
   drop table dbo.SubApplications
go


if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.Tokens')
            and   type = 'U')
   drop table dbo.Tokens
go


if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.UserGroups')
            and   type = 'U')
   drop table dbo.UserGroups
go


if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.UserPassword')
            and   type = 'U')
   drop table dbo.UserPassword
go


if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.Users')
            and   type = 'U')
   drop table dbo.Users
go

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetPermissionsForUser]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GetPermissionsForUser]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetSubApplicationsForUser]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GetSubApplicationsForUser]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetToken]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GetToken]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetUserForNtlmName]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GetUserForNtlmName]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SetTokenExpires]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SetTokenExpires]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SetTokenForToken]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SetTokenForToken]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[StoredProcedure2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[StoredProcedure2]
GO
IF EXISTS (
	SELECT	*
	FROM	dbo.sysobjects
	WHERE	id = object_id(N'[dbo].[apD_User]')
	AND	OBJECTPROPERTY(id, N'IsProcedure') = 1)

DROP PROCEDURE [dbo].[apD_User]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[apD_Group]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[apD_Group]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[apD_GroupPermission]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[apD_GroupPermission]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[apD_Permission]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[apD_Permission]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[apD_UserGroup]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[apD_UserGroup]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[apL_AuthenticateUser]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[apL_AuthenticateUser]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[apL_GetGroupsForUser]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[apL_GetGroupsForUser]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[apL_GetPermissionsForGroup]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[apL_GetPermissionsForGroup]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[apL_GetPermissionsForUser]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[apL_GetPermissionsForUser]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[apL_GetPracticesForUser]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[apL_GetPracticesForUser]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[apL_GetUserByName]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[apL_GetUserByName]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[apL_GetUserSecurityInformation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[apL_GetUserSecurityInformation]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CreateSecurityToken]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[CreateSecurityToken]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DeleteToken]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DeleteToken]
GO

