
alter proc BackupDB_CleanAndPrepForFTP
	@CustomerID INT,
	@BackupDriveDestination varchar(50) = 'G:\Migration_Backups',
	@ftpDestination varchar(8000) = '\\kprod-ops01.kareoprod.ent\d$\customers'

AS

--declare @CustomerID INT,
--	@BackupDriveDestination varchar(50),
--	@ftpDestination varchar(8000)
--select @CustomerID = 940,
--	@BackupDriveDestination = 'G:\Migration_Backups',
--	@ftpDestination = '\\kprod-ops01.kareoprod.ent\d$\customers'



-------------------------
-- Need to add the last '\' to the backup path
IF RIGHT( @BackupDriveDestination, 1 ) <> '\'
	SET @BackupDriveDestination = @BackupDriveDestination + '\'

IF RIGHT( @ftpDestination, 1 ) <> '\'
	SET @ftpDestination = @ftpDestination + '\'



declare 
	@newDBName varchar(128),
	@sourceDBServerName varchar(128),
	@sourceDBName varchar(128),
	@BackupName varchar(128),
	@currentDate datetime

SET @currentDate = getdate()
SET @BackupName = 'kareobackup_' 
	+ cast(@CustomerID as varchar) 
	+ '_' + cast( year( @currentDate ) as varchar )
	+ right( '00' + cast( month( @currentDate ) as varchar), 2)
	+ right( '00' + cast( day( @currentDate ) as varchar ), 2)
	+ '_' + right( '00' + cast( datepart( hh, @currentDate ) as varchar ), 2)
	+ right( '00' + cast( datepart( mi, @currentDate ) as varchar ), 2)
	+ '.bak'

SET @newDBName = 'kareobackup_' 
	+ cast(@CustomerID as varchar) 
	+ '_' + cast( year( @currentDate ) as varchar )
	+ right( '00' + cast( month( @currentDate ) as varchar), 2)
	+ right( '00' + cast( day( @currentDate ) as varchar ), 2)
	+ '_' + right( '00' + cast( datepart( hh, @currentDate ) as varchar ), 2)
	+ right( '00' + cast( datepart( mi, @currentDate ) as varchar ), 2)

select @sourceDBServerName = '['+DatabaseServerName+']',
	@sourceDBName = DatabaseName
from sharedserver.superbill_shared.dbo.customer
where customerID = @CustomerID

-- check to see if the DB is online and valid
create table #DBStatus( state_desc varchar(128) )

exec( ' INSERT INTO #DBStatus
		select state_desc 
		from '+@sourceDBServerName+'.master.sys.databases 
		where name = ''' + @sourceDBName + ''''
	)


if NOT exists( select * from #DBStatus where state_desc = 'ONLINE' )
	OR DB_ID ( @newDBName ) IS NOT NULL
BEGIN
	drop table #DBStatus
	return 
END


-- execute the CREATE DATABASE statement 
EXECUTE ('CREATE DATABASE ' + @newDBName )


create table #Tables (rowid int identity(1, 1), TableName varchar(8000) )

exec(	'insert into #tables( tableName )
		select name from ' + @sourceDBServerName + '.' + @sourceDBName + '.sys.tables where type_desc = ''User_Table'' order by Name'
	)


-- loop to make a copy of the table to the new DB
declare @rowID INT, @tableName varchar(8000)
SET @rowID = 0

while 1=1
begin

	select @rowID = min(rowID)
	FROM #Tables
	where rowID > @rowID

	if @@rowcount = 0 or @rowID is null
		break

	select @TableName = '[' + TableName + ']'
	FROM #Tables
	where rowID = @rowID

	begin try
		exec( '
				begin try
					select * INTO ' + @newDBName + '.dbo.' + @TableName + ' 
					from ' + @sourceDBServerName + '.' + @sourceDBName + '.dbo.' + @TableName + '
				end try
				begin catch
					print ''Failed to process: ' + @TableName + '''
				end catch'
			)
	end try 
	begin catch
		print 'can not create table: ' + @TableName
	end catch 
			
end




-- backup the damn thing
declare @backlocation varchar(8000)

-- SET @backlocation = @BackupDriveDestination + @newDBName 
SET @backlocation = @ftpDestination + cast( @customerID as varchar) + '\outgoing\'+@newDBName

exec (
		'BACKUP DATABASE ' + @newDBName + '
		TO DISK=''' + @backlocation+ '.bak'''
	)


select @BackupName as BackupName, 
	@newDBName as newDBName, 
	@sourceDBServerName as sourceDBServerName, 
	@sourceDBName as sourceDBName, 
	@BackupDriveDestination as backupDriveDestination


drop table #DBStatus, #tables

exec( 'drop database ' + @newDBName )



