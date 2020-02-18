USE [hl7_shard]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS ( SELECT  *
                FROM    sys.tables
                WHERE   name = 'ProcessingLogEntry' ) 
    BEGIN

        CREATE TABLE ProcessingLogEntry ([ProcessingLogID] BIGINT IDENTITY(1, 1)
                                                                  NOT NULL,
                                         [EventNotificationID] BIGINT NOT NULL,
                                         [ShardName] VARCHAR(20) NOT NULL,
                                         [Sent] BIT NOT NULL,
                                         [Accepted] BIT NOT NULL,
                                         [GaveUp] BIT NOT NULL,
                                         [AttemptNumber] TINYINT NOT NULL,
                                         [StartTimeUtc] DATETIME NOT NULL,
                                         [EndTimeUtc] DATETIME NOT NULL,
                                         [CustomerID] INT NOT NULL,
                                         [PracticeID] INT NOT NULL,
                                         [UserID] INT NOT NULL,
                                         [ReferenceID] INT NOT NULL,
                                         [HL7PartnerApplicationName] VARCHAR(180) NOT NULL,
                                         [HL7PartnerFacilityName] VARCHAR(180) NOT NULL,
                                         [HL7KareoApplicationName] VARCHAR(180) NOT NULL,
                                         [HL7KareoFacilityName] VARCHAR(180) NOT NULL,
                                         [MessageTypeCode] CHAR(3) NOT NULL,
                                         [EventTypeCode] CHAR(3) NOT NULL,
                                         [EventSource] VARCHAR(30) NOT NULL,
                                         [ContextData] VARCHAR(MAX) NULL,
                                         [MessageGenerationElapsedMS] INT NOT NULL,
                                         [MessageTransmissionElapsedMS] INT NOT NULL,
                                         [TotalElapsedMS] INT NOT NULL,
                                         [Message] VARCHAR(MAX) NOT NULL,
                                         [Exception] VARCHAR(MAX) NULL,
                                         [ResponseData] XML NULL)

    END
ELSE 
    BEGIN
        PRINT 'ProcessingLog exists. Skipping creation.'
    END
GO    


IF EXISTS ( SELECT  *
            FROM    sys.indexes
            WHERE   object_id = OBJECT_ID(N'[dbo].[ProcessingLogEntry]')
                    AND name = N'IX_ProcessingLogEntry_ProcessingLogID' ) 
    BEGIN
        DROP INDEX [IX_ProcessingLogEntry_ProcessingLogID] ON [dbo].[ProcessingLogEntry]
    END

CREATE UNIQUE CLUSTERED INDEX [IX_ProcessingLogEntry_ProcessingLogID] ON [dbo].[ProcessingLogEntry] 
(
[ProcessingLogID] ASC
)
GO