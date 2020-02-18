-- Tasks implementation DB Schema change


create table dbo.Task (
	TaskID int not null identity(1, 1),
	PracticeID int not null,
	
	-- audit fields
	CreatedDate DateTime not null default GetDate(),
	CreatedUserID int not null default 0,
	ModifiedDate DateTime not null default GetDate(),
	ModifiedUserID int not null default 0,
	RecordTimeStamp timestamp,
	
	-- business specific
	[Subject] varchar(128),
	AssignedUserID int,		-- user ID
	DueDate DateTime,
	Priority int,		-- 1...10
	TaskStatusID int,
	RecordTypeID int,		-- record type to which task is attached
	RecordID int,		-- record ID to which task is attached
	TaskTypeID int null,
	Comments varchar(max) null,
	
	CONSTRAINT PK_Task PRIMARY KEY CLUSTERED 
	(
		TaskID ASC
	)
)
	
GO

create table dbo.TaskStatus(
	TaskStatusID int not null identity(1, 1),
	TaskStatusDescription varchar(20),
	SortOrder int,
	
	CONSTRAINT PK_TaskStatus PRIMARY KEY CLUSTERED 
	(
		TaskStatusID ASC
	)
)
GO

insert into TaskStatus (TaskStatusDescription, SortOrder) values ('New', 1)
insert into TaskStatus (TaskStatusDescription, SortOrder) values ('Working', 2)
insert into TaskStatus (TaskStatusDescription, SortOrder) values ('Completed', 3)

create table dbo.TaskType(
	TaskTypeID int not null identity(1, 1),
	TaskTypeDescription varchar(50),
	SortOrder int,
	
	CONSTRAINT PK_TaskType PRIMARY KEY CLUSTERED 
	(
		TaskTypeID ASC
	)
)
GO

insert into TaskType (TaskTypeDescription, SortOrder) values ('Call', 100)
insert into TaskType (TaskTypeDescription, SortOrder) values ('Email', 200)
insert into TaskType (TaskTypeDescription, SortOrder) values ('Letter', 300)
insert into TaskType (TaskTypeDescription, SortOrder) values ('Meeting', 400)
insert into TaskType (TaskTypeDescription, SortOrder) values ('Other', 500)


create table dbo.TaskPriority (
	TaskPriorityID int not null identity(1, 1),
	TaskPriorityDescription varchar(50),
	SortOrder int,
	
	CONSTRAINT PK_TaskPriority PRIMARY KEY CLUSTERED 
	(
		TaskPriorityID ASC
	)
)


insert into TaskPriority (TaskPriorityDescription, SortOrder) values ('1', 1)
insert into TaskPriority (TaskPriorityDescription, SortOrder) values ('2', 2)
insert into TaskPriority (TaskPriorityDescription, SortOrder) values ('3', 3)
insert into TaskPriority (TaskPriorityDescription, SortOrder) values ('4', 4)
insert into TaskPriority (TaskPriorityDescription, SortOrder) values ('5', 5)
insert into TaskPriority (TaskPriorityDescription, SortOrder) values ('6', 6)
insert into TaskPriority (TaskPriorityDescription, SortOrder) values ('7', 7)
insert into TaskPriority (TaskPriorityDescription, SortOrder) values ('8', 8)
insert into TaskPriority (TaskPriorityDescription, SortOrder) values ('9', 9)
insert into TaskPriority (TaskPriorityDescription, SortOrder) values ('10', 10)

-- create relationships
-- Priority
ALTER TABLE dbo.Task WITH CHECK ADD CONSTRAINT FK_Task_Priority FOREIGN KEY(Priority)
	REFERENCES dbo.TaskPriority (TaskPriorityID)
GO

-- TaskStatus
ALTER TABLE dbo.Task WITH CHECK ADD CONSTRAINT FK_Task_TaskStatus FOREIGN KEY(TaskStatusID)
	REFERENCES dbo.TaskStatus (TaskStatusID)
GO

-- RecordType
ALTER TABLE dbo.Task WITH CHECK ADD CONSTRAINT FK_Task_DMSRecordType FOREIGN KEY(RecordTypeID)
	REFERENCES dbo.DMSRecordType (RecordTypeID)
GO


-- TaskType
ALTER TABLE dbo.Task WITH CHECK ADD CONSTRAINT FK_Task_TaskType FOREIGN KEY(TaskTypeID)
	REFERENCES dbo.TaskType (TaskTypeID)
GO



-- TODO: create indexes





-- create "time offset hack" trigger
IF EXISTS (
	SELECT	*
	FROM	sysobjects
	WHERE	Name = 'tr_IU_Task_ChangeTime'
	AND	type = 'TR'
)
	DROP TRIGGER dbo.tr_IU_Task_ChangeTime
GO

--===========================================================================
-- TR -- IU -- TASK -- CHANGE TIME
--===========================================================================
CREATE TRIGGER tr_IU_Task_ChangeTime ON dbo.Task
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @error_var int
	SET @error_var = 0
	DECLARE @proc_name sysname
    	SET @proc_name = (SELECT name FROM sysobjects WHERE id = @@PROCID)
	DECLARE @CRLF char(2)
    	SET @CRLF = CHAR(13) + CHAR(10)
    
	DECLARE @err_message nvarchar(255)

	IF UPDATE(DueDate)
	BEGIN
		UPDATE T
			SET DueDate =  dbo.fn_ReplaceTimeInDate(i.DueDate)
		FROM dbo.Task T INNER JOIN
			inserted i ON
				T.TaskID = i.TaskID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	RETURN
	
rollback_tran:
	IF @err_message IS NULL
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)
	ELSE
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)  + @CRLF + @CRLF + @err_message

	IF @@TRANCOUNT > 0
    		ROLLBACK TRANSACTION

	RAISERROR(@err_message, 16,1)

	RETURN
END
GO
