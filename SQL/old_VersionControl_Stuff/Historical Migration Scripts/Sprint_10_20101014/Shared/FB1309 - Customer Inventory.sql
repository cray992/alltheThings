if exists(select * from sys.tables where Name='CustomerInventory')
	drop table CustomerInventory
	GO

create table dbo.CustomerInventory (
	CustomerInventoryID int not null identity(1, 1),
	CreatedDate DateTime not null default GetDate(),
	CreatedUserID int,
	[Tag] varchar(64),
	
	
	[Platform] varchar(128) null,
	ServicePack varchar(256) null,
	
	VerBuild int,
	VerMajor int,
	VerMajorRevision int,
	VerMinor int,
	VerMinorRevision int,
	VerRevision int,
	VerString varchar(256),
	
	DotNet20 bit default 0,
	DotNet30 bit default 0,
	DotNet35 bit default 0,
	DotNet40F bit default 0,
	DotNet40C bit default 0,
	
	-- Screen sizes
	ScreenCount int default 0,
	Screen1W int default 0,
	Screen1H int default 0,
	Screen2W int default 0,
	Screen2H int default 0,
	Screen3W int default 0,
	Screen3H int default 0,
	Screen4W int default 0,
	Screen4H int default 0,
	
	CPUCount int default 0
)
GO

create clustered index CI_CustomerInventory on CustomerInventory (CustomerInventoryID)
GO
