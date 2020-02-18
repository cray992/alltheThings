IF NOT EXISTS ( SELECT  *
                FROM    sys.tables
                WHERE   name = 'HL7_ProcessingLogEntry' ) 
    BEGIN
    
        CREATE TABLE HL7_ProcessingLogEntry ([ProcessingLogID] BIGINT IDENTITY(1, 1)
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
            WHERE   object_id = OBJECT_ID(N'[dbo].[HL7_ProcessingLogEntry]')
                    AND name = N'IX_HL7_ProcessingLogEntry_ProcessingLogID' ) 
    BEGIN
        DROP INDEX [IX_HL7_ProcessingLogEntry_ProcessingLogID] ON [dbo].[HL7_ProcessingLogEntry]
    END

CREATE UNIQUE CLUSTERED INDEX [IX_HL7_ProcessingLogEntry_ProcessingLogID] ON [dbo].[HL7_ProcessingLogEntry] 
(
[ProcessingLogID] ASC
)
GO