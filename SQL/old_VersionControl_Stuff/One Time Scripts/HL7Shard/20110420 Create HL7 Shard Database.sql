IF DB_ID('hl7_shard') IS NULL 
    RETURN
    
USE [hl7_shard]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- PARTNER


--IF NOT EXISTS ( SELECT  *
--                FROM    sys.tables
--                WHERE   name = 'Partner' ) 
--    BEGIN
    
--        CREATE TABLE [Partner] ([PartnerID] [int] IDENTITY(1, 1)
--                                                  NOT NULL,
--                                [Name] [varchar](255) NOT NULL,
--                                [Active] [bit] NOT NULL,
--                                [Created] [datetime] NOT NULL,
--                                [Modified] [datetime]
--                                    NOT NULL CONSTRAINT [PK_Partner] PRIMARY KEY CLUSTERED ([PartnerID] ASC))
--    END
--ELSE 
--    BEGIN
--        PRINT 'The [Partner] table already exists'
--    END
--GO

---- PARTNEREVENTS


--IF NOT EXISTS ( SELECT  *
--                FROM    sys.tables
--                WHERE   name = 'PartnerEvent' ) 
--    BEGIN
--        CREATE TABLE [PartnerEvent] ([PartnerEventID] [int] IDENTITY(1, 1)
--                                                            NOT NULL,
--                                     [PartnerID] [int] NOT NULL,
--                                     [MessageTypeCode] [char](3) NOT NULL,
--                                     [EventTypeCode] [char](3) NOT NULL,
--                                     [Active] [bit]
--                                        NOT NULL CONSTRAINT [PK_PartnerEventID] PRIMARY KEY CLUSTERED ([PartnerEventID]))
--    END
--ELSE 
--    BEGIN
--        PRINT 'The [PartnerEvent] table already exists'
--    END
--GO



-- EVENTNOTIFCATION

IF NOT EXISTS ( SELECT  *
                FROM    sys.tables
                WHERE   name = 'EventNotification' ) 
    BEGIN

        CREATE TABLE EventNotification ([EventNotificationID] [bigint] IDENTITY(1, 1)
                                                                       NOT NULL,
                                        [CustomerID] [int] NOT NULL,
                                        [PracticeID] [int] NOT NULL,
                                        [UserID] [int] NOT NULL,
                                        [ReferenceID] [int] NOT NULL,
                                        [MessageTypeCode] [char](3) NOT NULL,
                                        [EventTypeCode] [char](3) NOT NULL,
                                        [EventSource] [varchar](30) NOT NULL,
										[Processed] [bit] NOT NULL,
										[Duplicate] [bit] NOT NULL,
										[GaveUp] [bit] NOT NULL,
                                        [HL7PartnerApplicationName] [varchar](180) NOT NULL,
										[HL7PartnerFacilityName] [varchar](180) NOT NULL,
										[HL7KareoApplicationName] [varchar](180) NOT NULL,
										[HL7KareoFacilityName] [varchar](180) NOT NULL,
                                        [CreatedDateUtc] [datetime] NOT NULL,
                                        [PickupDateUtc] [datetime] NULL,
                                        [PickupCount] INT NOT NULL
                                                          DEFAULT (0),
                                        [ContextData] [varchar](MAX) NULL)
                                
        ALTER TABLE [EventNotification] ADD  CONSTRAINT [DF_EventNotification_CreatedDateUtc]  DEFAULT (GETUTCDATE()) FOR [CreatedDateUtc]

        ALTER TABLE [EventNotification] ADD  CONSTRAINT [DF_EventNotification_Duplicate]  DEFAULT ((0)) FOR [Duplicate]

        ALTER TABLE [EventNotification] ADD  CONSTRAINT [DF_EventNotification_Processed]  DEFAULT ((0)) FOR [Processed]
        
        ALTER TABLE [EventNotification] ADD  CONSTRAINT [DF_EventNotification_GaveUp]  DEFAULT ((0)) FOR [GaveUp]


        CREATE CLUSTERED INDEX [IX_EventNotification_Processed_EventNotificationID_ReferenceID_CreatedDateUtc] ON [dbo].[EventNotification] 
        (
        [Processed] ASC,
        [EventNotificationID] ASC,
        [ReferenceID] ASC,
        [CreatedDateUtc] ASC
        )

    END
ELSE 
    BEGIN
        PRINT 'EventNotification already exists'
    END
GO
