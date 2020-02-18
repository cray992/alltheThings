IF  EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'KPROD-DB04')EXEC master.dbo.sp_dropserver @server=N'KPROD-DB04', @droplogins='droplogins'
GO
EXEC master.dbo.sp_addlinkedserver @server = N'KPROD-DB04', @srvproduct=N'kprod-db04.kareoprod.ent', @provider=N'SQLNCLI', @datasrc=N'kprod-db04.kareoprod.ent'
GO
EXEC master.dbo.sp_serveroption @server=N'KPROD-DB04', @optname=N'collation compatible', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'KPROD-DB04', @optname=N'data access', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'KPROD-DB04', @optname=N'dist', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'KPROD-DB04', @optname=N'pub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'KPROD-DB04', @optname=N'rpc', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'KPROD-DB04', @optname=N'rpc out', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'KPROD-DB04', @optname=N'sub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'KPROD-DB04', @optname=N'connect timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'KPROD-DB04', @optname=N'collation name', @optvalue=null
GO
EXEC master.dbo.sp_serveroption @server=N'KPROD-DB04', @optname=N'lazy schema validation', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'KPROD-DB04', @optname=N'query timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'KPROD-DB04', @optname=N'use remote collation', @optvalue=N'true'
GO
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'KPROD-DB04', @locallogin = NULL , @useself = N'False', @rmtuser = N'dev', @rmtpassword = N'Never!'
GO