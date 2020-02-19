----DacPac Creation

"C:\Program Files\Microsoft SQL Server\150\DAC\bin\SqlPackage.exe" /a:Extract /ssn:LAS-PDW-SHR01\SHR01  /tf:\\las-prod-sqlbackups\sql_backup_las_pdw_sq06\LAS-PDW-D043\DATA\PTNetwork_DailyDeltas.dacpac /sdn:PTNetwork_DailyDeltas /p:ExtractAllTableData=True /p:IgnoreExtendedProperties=True /p:IgnorePermissions=True /p:IgnoreUserLoginMappings=True


"C:\Program Files\Microsoft SQL Server\150\DAC\bin\SqlPackage.exe" /a:Publish /tsn:PDW-DBC01-SHR01\SHR01  /sf:\\las-san-sqlbackups\SQL_BACKUPS\D043\DATA\PTNetwork_DailyDeltas.dacpac /tdn:PTNetwork_DailyDeltas_VERIFY /p:AllowIncompatiblePlatform=True
