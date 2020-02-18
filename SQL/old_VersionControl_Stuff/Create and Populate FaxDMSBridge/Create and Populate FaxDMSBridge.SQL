/*==============================================================*/
/* Table: FaxDNISCustomerPractice                               */
/*==============================================================*/
create table dbo.FaxDNISCustomerPractice (
   DNIS                 char(10)             not null,
   CustomerID           int                  not null,
   PracticeID           int                  not null,
   CreatedDate          datetime             not null default getdate(),
   CreatedUserID        int                  not null
)
go

alter table dbo.FaxDNISCustomerPractice
   add constraint PK_FaxDNISCustomerPractice primary key (DNIS)
go

alter table dbo.FaxDNISCustomerPractice
   add constraint AK_FaxDNISCustomerPractice_CustomerPractice unique (CustomerID, PracticeID)
go

alter table dbo.FaxDNISCustomerPractice
   add constraint FK_CustomerDNIS_Customer foreign key (CustomerID)
      references dbo.Customer (CustomerID)
go


/*==============================================================*/
/* Table: FaxActivityLog                                        */
/*==============================================================*/
create table dbo.FaxActivityLog (
   FaxActivityLogID     int                  identity,
   FPJobID              int                  null,
   FaxIncomingDate      datetime             not null,
   FaxServiceProcessedDate datetime             not null default getdate(),
   NumberOfPages        int                  null,
   Status               varchar(65)          null,
   CustomerRoutedTo     int                  null,
   PracticeRoutedTo     int                  null
)
go

alter table dbo.FaxActivityLog
   add constraint PK_FaxActivityLog primary key (FaxActivityLogID)
go


/*==============================================================*/
/* Table: FaxDNISHistory                                        */
/*==============================================================*/
create table dbo.FaxDNISHistory (
   FaxDNISHistoryID     int                  identity,
   DateDeleted          datetime             not null default getdate(),
   DNIS                 char(10)             null,
   CustomerID           int                  null,
   PracticeID           int                  null
)
go

alter table dbo.FaxDNISHistory
   add constraint PK_FaxDNISHistory primary key (FaxDNISHistoryID)
go


/*==============================================================*/
/* Table: FaxDNIS                                               */
/*==============================================================*/
create table FaxDNIS (
   DNIS                 char(10)             not null,
   CreatedDate           datetime             not null default getdate(),
   AllocatedDate   datetime             null,
   GeneralAllocationPool bit                  not null default 1
)
go

alter table FaxDNIS
   add constraint PK_FaxDNIS primary key (DNIS)
go


--This will populate the first 5 DID ranges
/*
DID  949-955
7000-7099 --9/29/2006
4380-4399
5740-5759
6280-6299
4060-4079
5480-5499 
*/
declare @DNISCount int
SET @DNISCount = 0
declare @DNISStart int
declare @DNISEnd int
declare @DNIS char(10)
declare @prefix char(6)

SET @DNISStart = 7000
SET @DNISEnd = 7099
SET @prefix = '949955'

WHILE @DNISStart <= @DNISEnd
BEGIN
	SET @DNIS = @prefix + CAST(@DNISStart as varchar)
	IF NOT EXISTS(SELECT * FROM FaxDNIS WHERE DNIS = @DNIS)
	BEGIN
		SET @DNIS = @prefix + CAST(@DNISStart as varchar)
		INSERT FaxDNIS(DNIS)
		VALUES(@DNIS)
		
		SET @DNISCount = @DNISCount + 1
	END
	
	SET @DNISStart = @DNISStart + 1
END

SET @DNISStart = 4380
SET @DNISEnd = 4399
SET @prefix = '949955'


WHILE @DNISStart <= @DNISEnd
BEGIN
	SET @DNIS = @prefix + CAST(@DNISStart as varchar)
	IF NOT EXISTS(SELECT * FROM FaxDNIS WHERE DNIS = @DNIS)
	BEGIN
		SET @DNIS = @prefix + CAST(@DNISStart as varchar)
		INSERT FaxDNIS(DNIS)
		VALUES(@DNIS)
		
		SET @DNISCount = @DNISCount + 1
	END
	
	SET @DNISStart = @DNISStart + 1
END

SET @DNISStart = 5740
SET @DNISEnd = 5759
SET @prefix = '949955'

WHILE @DNISStart <= @DNISEnd
BEGIN
	SET @DNIS = @prefix + CAST(@DNISStart as varchar)
	IF NOT EXISTS(SELECT * FROM FaxDNIS WHERE DNIS = @DNIS)
	BEGIN
		SET @DNIS = @prefix + CAST(@DNISStart as varchar)
		INSERT FaxDNIS(DNIS)
		VALUES(@DNIS)
		
		SET @DNISCount = @DNISCount + 1
	END
	
	SET @DNISStart = @DNISStart + 1
END

SET @DNISStart = 6280
SET @DNISEnd = 6299
SET @prefix = '949955'

WHILE @DNISStart <= @DNISEnd
BEGIN
	SET @DNIS = @prefix + CAST(@DNISStart as varchar)
	IF NOT EXISTS(SELECT * FROM FaxDNIS WHERE DNIS = @DNIS)
	BEGIN
		INSERT FaxDNIS(DNIS)
		VALUES(@DNIS)
		
		SET @DNISCount = @DNISCount + 1
	END	

	SET @DNISStart = @DNISStart + 1
END

SET @DNISStart = 4060
SET @DNISEnd = 4079
SET @prefix = '949955'

WHILE @DNISStart <= @DNISEnd
BEGIN
	SET @DNIS = @prefix + CAST(@DNISStart as varchar)
	IF NOT EXISTS(SELECT * FROM FaxDNIS WHERE DNIS = @DNIS)
	BEGIN
		INSERT FaxDNIS(DNIS)
		VALUES(@DNIS)
		
		SET @DNISCount = @DNISCount + 1
	END	

	SET @DNISStart = @DNISStart + 1
END


SET @DNISStart = 5480
SET @DNISEnd = 5499
SET @prefix = '949955'

WHILE @DNISStart <= @DNISEnd
BEGIN
	SET @DNIS = @prefix + CAST(@DNISStart as varchar)
	IF NOT EXISTS(SELECT * FROM FaxDNIS WHERE DNIS = @DNIS)
	BEGIN
		INSERT FaxDNIS(DNIS)
		VALUES(@DNIS)
		
		SET @DNISCount = @DNISCount + 1
	END	

	SET @DNISStart = @DNISStart + 1
END

PRINT 'Added ' + CAST(@DNISCount as varchar) +
	' DNIS Numbers in the range ' + 
	CAST(@DNISStart as varchar) + '-' + 
	CAST(@DNISEnd as varchar)

--Remove the dev DID's from circulation
--UPDATE dbo.FaxDNIS
--	SET GeneralAllocationPool = 0
--WHERE DNIS BETWEEN '9499556290' and '9499556299'

--This is the second DNIS block/it's disjointed from the previous groups

declare @DNISCount int
SET @DNISCount = 0
declare @DNISStart int
declare @DNISEnd int
declare @DNIS char(10)
declare @prefix char(6)
--862-2800 - 2999
SET @DNISStart = 2800
SET @DNISEnd = 2999
SET @prefix = '949862'

WHILE @DNISStart <= @DNISEnd
BEGIN
	SET @DNIS = @prefix + CAST(@DNISStart as varchar)
	IF NOT EXISTS(SELECT * FROM FaxDNIS WHERE DNIS = @DNIS)
	BEGIN
		SET @DNIS = @prefix + CAST(@DNISStart as varchar)
		INSERT FaxDNIS(DNIS)
		VALUES(@DNIS)
		
		SET @DNISCount = @DNISCount + 1
	END
	
	SET @DNISStart = @DNISStart + 1
END

select *
from dbo.FaxDNIS
where GeneralAllocationPool= 0


IF NOT EXISTS(SELECT * FROM [Superbill_Shared].[dbo].[SharedSystemPropertiesAndValues] WHERE PropertyName = 'KFaxUserName')
	INSERT INTO [Superbill_Shared].[dbo].[SharedSystemPropertiesAndValues]
	(
		[PropertyName],
		[Value],
		[PropertyDescription]
	)
	VALUES
	(
		'KFaxUserName',
		'kfax@kareo.com',
		'The administrative user that has permissions to move faxes into the DMS'
	)

/* This should be added to each customer db
alter table Practice
add DNIS char(10)
*/


USE [Superbill_Shared]
-- BEGINNING TRANSACTION b
BEGIN TRANSACTION _b_

GO
INSERT INTO [dbo].[PermissionGroup] ([Name], [Description]) VALUES ('Operating Internal Systems', 'kFax, bizclaims, etc')
GO

/* Insert scripts for table: [dbo].[Permissions] */
PRINT 'Inserting rows into table: [dbo].[Permissions]'

INSERT INTO [dbo].[Permissions] ([Name], [ViewInMedicalOffice], [ViewInBusinessManager], [ViewInAdministrator], [ViewInServiceManager], [PermissionGroupID], 
[PermissionValue]) VALUES ('Sign On To Fax DMSBridge', 1, 1, 1, 1, 24, 'SignOnToFaxDMSBridge')
GO
INSERT INTO [dbo].[Permissions] ([Name], [ViewInMedicalOffice], [ViewInBusinessManager], [ViewInAdministrator], [ViewInServiceManager], [PermissionGroupID], 
[PermissionValue]) VALUES ('New KFax # for Practice', 1, 1, 1, 1, 12, 'NewKFaxDNIS')
GO
INSERT INTO [dbo].[Permissions] ([Name], [ViewInMedicalOffice], [ViewInBusinessManager], [ViewInAdministrator], [ViewInServiceManager], [PermissionGroupID], 
[PermissionValue]) VALUES ('Delete KFax # for Practice', 1, 1, 1, 1, 12, 'DeleteKFaxDNIS')
GO
INSERT INTO [dbo].[Permissions] ([Name], [ViewInMedicalOffice], [ViewInBusinessManager], [ViewInAdministrator], [ViewInServiceManager], [PermissionGroupID], 
[PermissionValue]) VALUES ('OperateFaxDMSBridge', 1, 1, 1, 1, 24, 'OperateFaxDMSBridge')
GO


-- COMMITTING TRANSACTION b
PRINT 'Script successfully completed'
COMMIT TRANSACTION _b_
GO





