
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ClaimEventTransaction_EventTransactionType_eventTransactionTypeCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClaimEventTransaction]'))
ALTER TABLE [dbo].[ClaimEventTransaction] DROP CONSTRAINT [FK_ClaimEventTransaction_EventTransactionType_eventTransactionTypeCode]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ClaimEventTransaction_ClaimStateTransition_claimStateTransitionID]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClaimEventTransaction]'))
ALTER TABLE [dbo].[ClaimEventTransaction] DROP CONSTRAINT [FK_ClaimEventTransaction_ClaimStateTransition_claimStateTransitionID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ClaimEventTransaction_EventTransactionType_eventTransactionTypeCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClaimEventTransaction]'))
ALTER TABLE [dbo].[ClaimEventTransaction] DROP CONSTRAINT [FK_ClaimEventTransaction_EventTransactionType_eventTransactionTypeCode]
GO


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ClaimStateTransition_ClaimEventTransaction_claimEventTransactionID]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClaimStateTransition]'))
ALTER TABLE [dbo].[ClaimStateTransition] DROP CONSTRAINT [FK_ClaimStateTransition_ClaimEventTransaction_claimEventTransactionID]

GO
/****** Object:  Index [PK_EventTransactionType]    Script Date: 12/13/2007 16:50:41 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EventTransactionType]') AND name = N'PK_EventTransactionType')
ALTER TABLE [dbo].[EventTransactionType] DROP CONSTRAINT [PK_EventTransactionType]
GO

/****** Object:  Table [dbo].[EventTransactionType]    Script Date: 12/13/2007 16:50:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EventTransactionType]') AND type in (N'U'))
DROP TABLE [dbo].[EventTransactionType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ClaimStateTransition_ObjectState_objectStateID]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClaimStateTransition]'))
ALTER TABLE [dbo].[ClaimStateTransition] DROP CONSTRAINT [FK_ClaimStateTransition_ObjectState_objectStateID]
GO

/****** Object:  Table [dbo].[ObjectState]    Script Date: 12/13/2007 16:58:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ObjectState]') AND type in (N'U'))
DROP TABLE [dbo].[ObjectState]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ClaimStateTransition_ClaimEventTransaction_claimEventTransactionID]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClaimStateTransition]'))
ALTER TABLE [dbo].[ClaimStateTransition] DROP CONSTRAINT [FK_ClaimStateTransition_ClaimEventTransaction_claimEventTransactionID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ClaimStateTransition_ObjectState_objectStateID]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClaimStateTransition]'))
ALTER TABLE [dbo].[ClaimStateTransition] DROP CONSTRAINT [FK_ClaimStateTransition_ObjectState_objectStateID]
GO
/****** Object:  Table [dbo].[ClaimStateTransition]    Script Date: 12/13/2007 17:00:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClaimStateTransition]') AND type in (N'U'))
DROP TABLE [dbo].[ClaimStateTransition]
GO


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ClaimEventTransaction_ClaimStateTransition_claimStateTransitionID]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClaimEventTransaction]'))
ALTER TABLE [dbo].[ClaimEventTransaction] DROP CONSTRAINT [FK_ClaimEventTransaction_ClaimStateTransition_claimStateTransitionID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ClaimEventTransaction_EventTransactionType_eventTransactionTypeCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClaimEventTransaction]'))
ALTER TABLE [dbo].[ClaimEventTransaction] DROP CONSTRAINT [FK_ClaimEventTransaction_EventTransactionType_eventTransactionTypeCode]
GO

/****** Object:  Table [dbo].[ClaimEventTransaction]    Script Date: 12/13/2007 17:01:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClaimEventTransaction]') AND type in (N'U'))
DROP TABLE [dbo].[ClaimEventTransaction]
GO

/****** Object:  Table [dbo].[ClaimEventTransaction]    Script Date: 12/13/2007 16:54:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClaimEventTransaction]') AND type in (N'U'))
DROP TABLE [dbo].[ClaimEventTransaction]
GO

CREATE TABLE [dbo].[ObjectState](
	[objectStateID] [int] identity(1,1) NOT NULL,
	[name] [varchar](50) NULL,
	[assignedToUserRoleID] [int] NULL,
	[KareoSharedID] [int] NULL,
        SortOrder Int                
 CONSTRAINT [PK_ObjectState] PRIMARY KEY CLUSTERED 
(
	[objectStateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]



CREATE TABLE [dbo].[EventTransactionType](
	[eventTransactionTypeCode] [varchar](10) NOT NULL,
	[name] [varchar](50) NULL,
	[description] [varchar](50) NULL,
	[KareoSharedID] [int] NULL,
 CONSTRAINT [PK_EventTransactionType] PRIMARY KEY CLUSTERED 
(
	[eventTransactionTypeCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]






CREATE TABLE [dbo].[ClaimStateTransition](
	[claimStateTransitionID] [int] identity(1,1) NOT NULL,
	[practiceID] [int] NOT NULL,
	[claimID] [int] NOT NULL,
	[objectStateID] [int] NOT NULL,
	[triggeringReferenceID] [int] NULL,
	[triggeringTableName] varchar(50) NULL,
	transactionStartDate datetime,
	transactionEndDate datetime,
	[claimStateTransitionLoopCount] [int],
	[postingDate] datetime NULL,
	[assignedToPayerID] [int] NOT NULL,
	[assignedToPayerType] char(1) NOT NULL,
        amount Money,
 CONSTRAINT [PK_ClaimStateTransition] PRIMARY KEY CLUSTERED 
(
	[claimStateTransitionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]




CREATE TABLE [dbo].[ClaimEventTransaction](
	[claimEventTransactionID] [int] identity(1,1) NOT NULL,
	[practiceID] [int] NOT NULL,
	[claimID] [int] NOT NULL,
	[eventTransactionTypeCode] [varchar](10) NOT NULL,
	[objectStateID] [int] NOT NULL,
	[postingDate] [datetime] NOT NULL,
	[amount] [money] NULL,
	[units] [decimal](14, 4) NULL,
 CONSTRAINT [PK_ClaimEventTransaction] PRIMARY KEY CLUSTERED 
(
	[claimEventTransactionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

GO

ALTER TABLE [dbo].[ClaimStateTransition]  WITH CHECK ADD  CONSTRAINT [FK_ClaimStateTransition_ObjectState_objectStateID] FOREIGN KEY([objectStateID])
REFERENCES [dbo].[ObjectState] ([objectStateID])
GO
ALTER TABLE [dbo].[ClaimStateTransition] CHECK CONSTRAINT [FK_ClaimStateTransition_ObjectState_objectStateID]


SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[ClaimEventTransaction]  WITH CHECK ADD  CONSTRAINT [FK_ClaimEventTransaction_ClaimStateTransition_claimStateTransitionID] FOREIGN KEY([objectStateID])
REFERENCES [dbo].[ClaimStateTransition] ([claimStateTransitionID])
GO
ALTER TABLE [dbo].[ClaimEventTransaction] CHECK CONSTRAINT [FK_ClaimEventTransaction_ClaimStateTransition_claimStateTransitionID]
GO
ALTER TABLE [dbo].[ClaimEventTransaction]  WITH CHECK ADD  CONSTRAINT [FK_ClaimEventTransaction_EventTransactionType_eventTransactionTypeCode] FOREIGN KEY([eventTransactionTypeCode])
REFERENCES [dbo].[EventTransactionType] ([eventTransactionTypeCode])
GO
ALTER TABLE [dbo].[ClaimEventTransaction] CHECK CONSTRAINT [FK_ClaimEventTransaction_EventTransactionType_eventTransactionTypeCode]



GO




INSERT INTO [ObjectState]
           (
           [name]
           ,[KareoSharedID]
           ,SortOrder)
     VALUES
           (
           'Appointment'
           ,1
	,10)





INSERT INTO [ObjectState]
           (
           [name]
           ,[KareoSharedID]
           ,SortOrder)

     VALUES
           (
			'Date of Service'
           ,2
	,15	)

INSERT INTO [ObjectState]
           (
           [name]
           ,[KareoSharedID]
           ,SortOrder)
     VALUES
           (
			'Encounter Created'
           ,3
	,20	)



INSERT INTO [ObjectState]
           (
           [name]
           ,[KareoSharedID]
           ,SortOrder)

     VALUES
           (
			'Encounter Submitted for Review'
           ,4
	,25	)




INSERT INTO [ObjectState]
           (
           [name]
           ,[KareoSharedID]
           ,SortOrder)

     VALUES
           (
			'Encounter Approved'
           ,5
	,30	)

INSERT INTO [ObjectState]
           (
           [name]
           ,[KareoSharedID]
           ,SortOrder)
     VALUES
           (
			'Encounter ASN'
           ,6
	,35	)
        
        
INSERT INTO [ObjectState]
           (
           [name]
           ,[KareoSharedID]
           ,SortOrder)

     VALUES
           (
			'Encounter Bill via Electronic'
           ,7
	,40	)



INSERT INTO [ObjectState]
           (
           [name]
           ,[KareoSharedID]
           ,SortOrder)

     VALUES
           (
			'Encounter Bill via Paper'
           ,19
	,45
        )


INSERT INTO [ObjectState]
           (
           [name]
           ,[KareoSharedID]
           ,SortOrder)

     VALUES
           (
			'Encounter Bill to patient'
           ,21
	,50	)

INSERT INTO [ObjectState]
           (
           [name]
           ,[KareoSharedID]
           ,SortOrder)

     VALUES
           (
			'Encounter rebilled'
           ,20
	,55	)




INSERT INTO [ObjectState]
           (
           [name]
           ,[KareoSharedID]
           ,SortOrder)

     VALUES
           (
			'Encounter Submitted'
           ,8
	,60	)

INSERT INTO [ObjectState]
           (
           [name]
           ,[KareoSharedID]
           ,SortOrder)

     VALUES
           (
			'Encounter Pending'
           ,9
	,65	)


INSERT INTO [ObjectState]
           (
           [name]
           ,[KareoSharedID]
           ,SortOrder)

     VALUES
           (
			'Encounter Pending on Clearinghouse'
           ,10
	,70	)

INSERT INTO [ObjectState]
           (
           [name]
           ,[KareoSharedID]
           ,SortOrder)

     VALUES
           (
			'Encounter Pending on Payer'
           ,11
	,75	)

INSERT INTO [ObjectState]
           (
           [name]
           ,[KareoSharedID]
           ,SortOrder)

     VALUES
           (
			'Encounter Error at BizClaims'
           ,12
	,80	)

INSERT INTO [ObjectState]
           (
           [name]
           ,[KareoSharedID]
           ,SortOrder)

     VALUES
           (
			'Encounter Error at Clearinghouse'
           ,13
	,85	)

INSERT INTO [ObjectState]
           (
           [name]
           ,[KareoSharedID]
           ,SortOrder)

     VALUES
           (
			'Encounter Error at Payer'
           ,14
	,90	)

INSERT INTO [ObjectState]
           (
           [name]
           ,[KareoSharedID]
           ,SortOrder)

     VALUES
           (
			'Encounter ERA/EOB Received'
           ,15
	,95	)

INSERT INTO [ObjectState]
           (
           [name]
           ,[KareoSharedID]
           ,SortOrder)

     VALUES
           (
			'Encounter Denied'
           ,16
	,100	)
        
        
INSERT INTO [ObjectState]
           (
           [name]
           ,[KareoSharedID]
           ,SortOrder)

     VALUES
           (
			'Days Revenue Outstanding (Encounter Paid)'
           ,18
	,105	)



INSERT INTO [ObjectState]
           (
           [name]
           ,[KareoSharedID]
           ,SortOrder)

     VALUES
           (
			'Encounter Settled'
           ,17
           ,1000
		)







INSERT INTO [EventTransactionType]
           ([eventTransactionTypeCode]
           ,[name])
SELECT ClaimTransactionTypeCode, TypeName FROM ClaimTransactionType order by ClaimTransactionTypeCode




RETURN

INSERT INTO [EventTransactionType]
           ([eventTransactionTypeCode]
           ,[name]
           ,[KareoSharedID])
     VALUES
           (
			'APPT'
           ,'Appointment'
           ,1
		)


INSERT INTO [EventTransactionType]
           ([eventTransactionTypeCode]
           ,[name]
           ,[KareoSharedID])
     VALUES
           (
			'DOS'
           ,'Date of Service'
           ,2
		)

INSERT INTO [EventTransactionType]
           ([eventTransactionTypeCode]
           ,[name]
           ,[KareoSharedID])
     VALUES
           (
			'ENC-CR'
           ,'Encounter Created'
           ,3
		)



INSERT INTO [EventTransactionType]
           ([eventTransactionTypeCode]
           ,[name]
           ,[KareoSharedID])
     VALUES
           (
			'ENC-SUB'
           ,'Encounter Submitted for Review'
           ,4
		)




INSERT INTO [EventTransactionType]
           ([eventTransactionTypeCode]
           ,[name]
           ,[KareoSharedID])
     VALUES
           (
			'ENC-APR'
           ,'Encounter Approved'
           ,5
		)

INSERT INTO [EventTransactionType]
           ([eventTransactionTypeCode]
           ,[name]
           ,[KareoSharedID])
     VALUES
           (
			'ASN'
           ,'Encounter ASN'
           ,6
		)

INSERT INTO [EventTransactionType]
           ([eventTransactionTypeCode]
           ,[name]
           ,[KareoSharedID])
     VALUES
           (
			'BLL'
           ,'Encounter Bill '
           ,7
		)




INSERT INTO [EventTransactionType]
           ([eventTransactionTypeCode]
           ,[name]
           ,[KareoSharedID])
     VALUES
           (
			'BLL-SUB'
           ,'Encounter Submitted'
           ,8
		)

INSERT INTO [EventTransactionType]
           ([eventTransactionTypeCode]
           ,[name]
           ,[KareoSharedID])
     VALUES
           (
			'BLL-PEN'
           ,'Encounter Pending'
           ,9
		)


INSERT INTO [EventTransactionType]
           ([eventTransactionTypeCode]
           ,[name]
           ,[KareoSharedID])
     VALUES
           (
			'BLL-CH'
           ,'Encounter Pending on Clearinghouse'
           ,10
		)

INSERT INTO [EventTransactionType]
           ([eventTransactionTypeCode]
           ,[name]
           ,[KareoSharedID])
     VALUES
           (
			'BLL-PAY'
           ,'Encounter Pending on Payer'
           ,11
		)

INSERT INTO [EventTransactionType]
           ([eventTransactionTypeCode]
           ,[name]
           ,[KareoSharedID])
     VALUES
           (
			'ERR-BZ'
           ,'Encounter Error at BizClaims'
           ,12
		)

INSERT INTO [EventTransactionType]
           ([eventTransactionTypeCode]
           ,[name]
           ,[KareoSharedID])
     VALUES
           (
			'ERR-CH'
           ,'Encounter Error at Clearinghouse'
           ,13
		)

INSERT INTO [EventTransactionType]
           ([eventTransactionTypeCode]
           ,[name]
           ,[KareoSharedID])
     VALUES
           (
			'ERR-PAY'
           ,'Encounter Error at Payer'
           ,14
		)

INSERT INTO [EventTransactionType]
           ([eventTransactionTypeCode]
           ,[name]
           ,[KareoSharedID])
     VALUES
           (
			'ERA-RCV'
           ,'Encounter ERA/EOB Received'
           ,15
		)

INSERT INTO [EventTransactionType]
           ([eventTransactionTypeCode]
           ,[name]
           ,[KareoSharedID])
     VALUES
           (
			'DEN'
           ,'Encounter Denied'
           ,16
		)

INSERT INTO [EventTransactionType]
           ([eventTransactionTypeCode]
           ,[name]
           ,[KareoSharedID])
     VALUES
           (
			'END'
           ,'Encounter Settled'
           ,17
		)







/*	------ generates the date key table

set nocount on

	declare @date Datetime

	SET @date = '1/1/1753'
	delete DimDate

	SET IDENTITY_INSERT DimDate ON 

	while @date <= '12/31/9999'
	BEGIN
			insert into DimDate(
					dateKey,    
					fullDateAlternateKey,   calendarQuarter ,       calendarYear ,
					dayNameOfWeek,
					dayNumberOfMonth,dayNumberOfWeek,
					monthName, monthNumberOfYear)
			select replace(left(convert(varchar, @date, 126), 10), '-', ''),
					@date,                  datepart(Quarter,@date), year(@date), 
					dateName(WeekDay, @date), 
					daY(@date), datepart(WeekDay, @date), 
					datename(Month, @date), month(@date)
	        
			set @date = dateadd(Day, 1, @date)
	END
*/


/*
delete DimDate


*/