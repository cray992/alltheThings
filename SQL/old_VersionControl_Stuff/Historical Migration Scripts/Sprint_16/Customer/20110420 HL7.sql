SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- PracticeIntegration

IF NOT EXISTS ( SELECT  1
                FROM    INFORMATION_SCHEMA.COLUMNS
                WHERE   TABLE_NAME = 'PracticeIntegration'
                        AND COLUMN_NAME = 'HL7PartnerID' ) 
    BEGIN
        ALTER TABLE dbo.PracticeIntegration
        ADD [HL7PartnerID] [int] NULL,
        [HL7PartnerActive] [bit] NULL,
        [HL7PartnerApplicationName] [varchar](180) NULL,
        [HL7PartnerFacilityName] [varchar](180) NULL,
        [HL7KareoApplicationName] [varchar](180) NULL,
        [HL7KareoFacilityName] [varchar](180) NULL,
        [HL7_ADVICE__CREATE_NEW_TABLE_FOR_MULTIPLE_PARTNERS] [bit] NULL
    END
GO


IF EXISTS ( SELECT  *
            FROM    sys.indexes
            WHERE   object_id = OBJECT_ID(N'[dbo].[PracticeIntegration]')
                    AND name = N'IX_PracticeIntegration_HL7PartnerID' ) 
    DROP INDEX [IX_PracticeIntegration_HL7PartnerID] ON [dbo].PracticeIntegration
	
CREATE NONCLUSTERED INDEX [IX_PracticeIntegration_HL7PartnerID] ON dbo.PracticeIntegration
(
[HL7PartnerID] ASC
)
INCLUDE ([HL7PartnerActive], [HL7PartnerApplicationName], [HL7PartnerFacilityName], [HL7KareoApplicationName], [HL7KareoFacilityName])
GO


IF NOT EXISTS ( SELECT  *
            FROM    sys.indexes
            WHERE   object_id = OBJECT_ID(N'[dbo].[PracticeIntegration]')
                    AND name = N'UQ_PracticeIntegration_HL7PartnerID_PracticeID' ) 
BEGIN

	CREATE UNIQUE INDEX [UQ_PracticeIntegration_HL7PartnerID_PracticeID] ON dbo.PracticeIntegration
	(
	[HL7PartnerID] ASC,
	[PracticeID] ASC
	)

END

-- PartnerEvent


IF NOT EXISTS ( SELECT  *
                FROM    sys.tables
                WHERE   name = 'HL7_PartnerEvent' ) 
    BEGIN

        CREATE TABLE [HL7_PartnerEvent] ([PartnerEventID] [int] IDENTITY(1, 1)
                                                               NOT NULL,
                                        [PracticeID] [int] NOT NULL,
                                        [HL7PartnerID] [int] NOT NULL,
                                        [MessageTypeCode] [char](3) NOT NULL,
                                        [EventTypeCode] [char](3)
                                            NOT NULL
                                            CONSTRAINT [PK_PartnerEventID] PRIMARY KEY CLUSTERED ([PartnerEventID] ASC))

        ALTER TABLE [HL7_PartnerEvent]  WITH CHECK ADD  CONSTRAINT [FK_HL7_PartnerEvent_PracticeIntegration] FOREIGN KEY([HL7PartnerID], [PracticeID])
        REFERENCES [PracticeIntegration] ([HL7PartnerID], [PracticeID])

        ALTER TABLE [HL7_PartnerEvent] CHECK CONSTRAINT [FK_HL7_PartnerEvent_PracticeIntegration]

        CREATE UNIQUE NONCLUSTERED INDEX [UQ_HL7_PartnerEvent_EventTypeCode_PartnerID_MessageTypeCode] ON [HL7_PartnerEvent]
        (
        [EventTypeCode] ASC,
        [HL7PartnerID] ASC,
        [PracticeID] ASC,
        [MessageTypeCode] ASC
        )
    END
ELSE 
    BEGIN
        PRINT 'HL7_PartnerEvent already exists'
    END



/*
-- HL7 Error log

CREATE TABLE HL7_ErrorLogEntry
(
	[ErrorLogEntryID] INT IDENTITY(1, 1) NOT NULL,
	[PracticeID] INT NOT NULL,
	[ReferenceID] INT NOT NULL,
	[ErrorMessage] VARCHAR(MAX) NOT NULL,
	[PartnerApplicationName] [nvarchar](180) NOT NULL,
	[PartnerFacilityName] [nvarchar](180) NOT NULL,		
	[KareoApplicationName] [nvarchar](180) NOT NULL,		
    [KareoFacilityName] [nvarchar](180) NOT NULL,
    [ContextData] VARCHAR(MAX),
    [MessageTypeCode] CHAR(3) NOT NULL,
	[EventTypeCode] CHAR(3) NOT NULL,
    [EventType] VARCHAR(10) NOT NULL,
    [EventSource] VARCHAR(30) NOT NULL,
    [EventCreatedDateUtc] DATETIME NOT NULL,
    [ErrorTimestamp] DATETIME NOT NULL
    
    PRIMARY KEY CLUSTERED ([ErrorLogEntryID] ASC)
)

GO

CREATE PROCEDURE HL7DataProvder_CreateErrorLogEntry
	@ErrorLogEntryID INT,
	@PracticeID INT,
	@ReferenceID INT,
	@ErrorMessage VARCHAR(MAX),
	@PartnerApplicationName [nvarchar](180),
	@PartnerFacilityName [nvarchar](180),		
	@KareoApplicationName [nvarchar](180),		
    @KareoFacilityName [nvarchar](180),
    @ContextData VARCHAR(MAX) = NULL,
    @MessageTypeCode CHAR(3),
	@EventTypeCode CHAR(3),
    @EventType VARCHAR(10),
    @EventSource VARCHAR(30),
    @EventCreatedDateUtc DATETIME,
    @ErrorTimestamp DATETIME
    
    AS
    BEGIN
    
		INSERT INTO dbo.HL7_ErrorLogEntry (PracticeID, ReferenceID, ErrorMessage, PartnerApplicationName,
		                               PartnerFacilityName, KareoApplicationName, KareoFacilityName, ContextData,
		                               MessageTypeCode, EventTypeCode, EventType, EventSource, EventCreatedDateUtc,
		                               ErrorTimestamp)
		VALUES  (@PracticeID,
		         @ReferenceID,
		         @ErrorMessage,
		         @PartnerApplicationName,
		         @PartnerFacilityName,
		         @KareoApplicationName,
		         @KareoFacilityName,
		         @ContextData,
		         @MessageTypeCode,
		         @EventTypeCode,
		         @EventType,
		         @EventSource,
		         @EventCreatedDateUtc,
		         @ErrorTimestamp
		         )
		
    END
    
GO


CREATE PROCEDURE HL7DataProvider_GetErrorLogEntry @ErrorLogEntryID INT
AS 
    BEGIN
	
        SELECT  E.ErrorLogEntryID, E.PracticeID, E.ReferenceID, E.ErrorMessage, E.PartnerApplicationName,
                E.PartnerFacilityName, E.KareoApplicationName, E.KareoFacilityName, E.ContextData, E.MessageTypeCode,
                E.EventTypeCode, E.EventType, E.EventSource, E.EventCreatedDateUtc, E.ErrorTimestamp
        FROM    dbo.HL7_ErrorLogEntry E
        WHERE   E.ErrorLogEntryID = @ErrorLogEntryID
	
    END
	

GO
*/

DROP PROCEDURE dbo.HL7DataProvider_CreateA04A08Message
DROP PROCEDURE dbo.HL7DataProvider_CreateEncounterFromP03
DROP PROCEDURE dbo.HL7DataProvider_CreatePatientFromA04
DROP PROCEDURE dbo.HL7DataProvider_UpdatePatientFromA08
GO

