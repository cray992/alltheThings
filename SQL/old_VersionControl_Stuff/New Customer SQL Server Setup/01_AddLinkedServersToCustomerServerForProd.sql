/* Add linked server SHAREDSERVER ... */
IF  EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'SHAREDSERVER')EXEC master.dbo.sp_dropserver @server=N'SHAREDSERVER', @droplogins='droplogins'
GO
EXEC master.dbo.sp_addlinkedserver @server = N'SHAREDSERVER', @srvproduct=N'kprod-db06.kareoprod.ent', @provider=N'SQLNCLI', @datasrc=N'kprod-db06.kareoprod.ent'
GO
EXEC master.dbo.sp_serveroption @server=N'SHAREDSERVER', @optname=N'collation compatible', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'SHAREDSERVER', @optname=N'data access', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'SHAREDSERVER', @optname=N'dist', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'SHAREDSERVER', @optname=N'pub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'SHAREDSERVER', @optname=N'rpc', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'SHAREDSERVER', @optname=N'rpc out', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'SHAREDSERVER', @optname=N'sub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'SHAREDSERVER', @optname=N'connect timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'SHAREDSERVER', @optname=N'collation name', @optvalue=null
GO
EXEC master.dbo.sp_serveroption @server=N'SHAREDSERVER', @optname=N'lazy schema validation', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'SHAREDSERVER', @optname=N'query timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'SHAREDSERVER', @optname=N'use remote collation', @optvalue=N'true'
GO
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'SHAREDSERVER', @locallogin = NULL , @useself = N'False', @rmtuser = N'dev', @rmtpassword = N'Never!'
GO

/* Add linked server BIZCLAIMSDBSERVER ... */
IF  EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'BIZCLAIMSDBSERVER') 
EXEC master.dbo.sp_dropserver @server=N'BIZCLAIMSDBSERVER', @droplogins='droplogins'
Go
EXEC master.dbo.sp_addlinkedserver @server = N'BIZCLAIMSDBSERVER', @srvproduct='kprod-db03.kareoprod.ent', @provider=N'SQLNCLI', @datasrc=N'kprod-db03.kareoprod.ent', @provstr=N'server=kprod-db03.kareoprod.ent;Application Name=RTBizClaims;UID=DEVBIZCLAIMS;PWD=biz4talk;', @catalog=N'KareoBizclaims'
GO
EXEC master.dbo.sp_serveroption @server=N'BIZCLAIMSDBSERVER', @optname=N'collation compatible', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'BIZCLAIMSDBSERVER', @optname=N'data access', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'BIZCLAIMSDBSERVER', @optname=N'dist', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'BIZCLAIMSDBSERVER', @optname=N'pub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'BIZCLAIMSDBSERVER', @optname=N'rpc', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'BIZCLAIMSDBSERVER', @optname=N'rpc out', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'BIZCLAIMSDBSERVER', @optname=N'sub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'BIZCLAIMSDBSERVER', @optname=N'connect timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'BIZCLAIMSDBSERVER', @optname=N'collation name', @optvalue=null
GO
EXEC master.dbo.sp_serveroption @server=N'BIZCLAIMSDBSERVER', @optname=N'lazy schema validation', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'BIZCLAIMSDBSERVER', @optname=N'query timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'BIZCLAIMSDBSERVER', @optname=N'use remote collation', @optvalue=N'true'
GO
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'BIZCLAIMSDBSERVER', @locallogin = NULL , @useself = N'False', @rmtuser = N'DEVBIZCLAIMS', @rmtpassword = N'biz4talk'
GO