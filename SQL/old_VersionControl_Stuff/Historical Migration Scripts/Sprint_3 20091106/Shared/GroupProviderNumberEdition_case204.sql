
alter table dbo.customer add ClaimSettingEdition int default 2 not null
go

alter table dbo.customer add ClaimSettingVisible bit default 0 not null
go


-- mark all existing customers as classic 
update Customer set ClaimSettingEdition =1

-- create new permissions

EXEC Shared_AuthenticationDataProvider_CreatePermission 
      @Name='Read Claim Settings Mode',
      @Description='Read Claim Settings Mode', 
      @ViewInKareo=1,
      @ViewInServiceManager=1,
      @PermissionGroupID=9,
      @PermissionValue='ReadClaimSettingsMode'

EXEC Shared_AuthenticationDataProvider_CreatePermission 
      @Name='Edit Claim Settings Mode',
      @Description='Edit Claim Settings Mode', 
      @ViewInKareo=1,
      @ViewInServiceManager=1,
      @PermissionGroupID=9,
      @PermissionValue='EditClaimSettingsMode'

--TODO: use Shared_AuthenticationDataProvider_CreateSecurityGroupPermission for the default assignments


