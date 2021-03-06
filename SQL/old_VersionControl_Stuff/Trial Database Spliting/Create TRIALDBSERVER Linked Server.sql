/****** Object:  LinkedServer [TRIALDBSERVER]    Script Date: 02/16/2007 20:46:56 ******/
--Create the Alias first in order for this LinkedServer would work.

EXEC master.dbo.sp_addlinkedserver @server = N'TRIALDBSERVER', @srvproduct=N'SQL Server'
GO
EXEC master.dbo.sp_serveroption @server=N'TRIALDBSERVER', @optname=N'collation compatible', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'TRIALDBSERVER', @optname=N'data access', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'TRIALDBSERVER', @optname=N'dist', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'TRIALDBSERVER', @optname=N'pub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'TRIALDBSERVER', @optname=N'rpc', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'TRIALDBSERVER', @optname=N'rpc out', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'TRIALDBSERVER', @optname=N'sub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'TRIALDBSERVER', @optname=N'connect timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'TRIALDBSERVER', @optname=N'collation name', @optvalue=null
GO
EXEC master.dbo.sp_serveroption @server=N'TRIALDBSERVER', @optname=N'lazy schema validation', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'TRIALDBSERVER', @optname=N'query timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'TRIALDBSERVER', @optname=N'use remote collation', @optvalue=N'true'

GO

--Run this on KPROD-DB04 or whatever the TrialDB server is.
/****** Object:  Login [trialdb_user]    Script Date: 02/16/2007 21:11:35 ******/
/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [trialdb_user]    Script Date: 02/16/2007 21:11:35 ******/
CREATE LOGIN [trialdb_user] WITH PASSWORD=N'AÒ8~{XæH×fDÎ¹¥nÃa½¹ÿ0t[ô*o', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sys.sp_addsrvrolemember @loginame = N'trialdb_user', @rolename = N'sysadmin'
GO
EXEC sys.sp_addsrvrolemember @loginame = N'trialdb_user', @rolename = N'securityadmin'
GO
EXEC sys.sp_addsrvrolemember @loginame = N'trialdb_user', @rolename = N'dbcreator'
GO
--ALTER LOGIN [trialdb_user] ENABLE