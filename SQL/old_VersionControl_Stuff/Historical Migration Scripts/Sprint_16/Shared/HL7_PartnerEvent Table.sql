

IF NOT EXISTS ( SELECT  *
                FROM    sys.tables
                WHERE   name = 'PartnerHL7Event' ) 
    BEGIN

        CREATE TABLE [PartnerHL7Event] ([PartnerHL7EventID] [int] IDENTITY(1, 1)
                                                               NOT NULL,
                                        [PartnerID] [int] NOT NULL,
                                        [MessageTypeCode] [char](3) NOT NULL,
                                        [EventTypeCode] [char](3)
                                            NOT NULL
                                            CONSTRAINT [PK_PartnerHL7EventID] PRIMARY KEY CLUSTERED ([PartnerHL7EventID] ASC))

        ALTER TABLE [PartnerHL7Event]  WITH CHECK ADD  CONSTRAINT [FK_PartnerHL7Event_Partner] FOREIGN KEY([PartnerID])
        REFERENCES [Partner] ([PartnerID])

        ALTER TABLE [PartnerHL7Event] CHECK CONSTRAINT [FK_PartnerHL7Event_Partner]

        CREATE UNIQUE NONCLUSTERED INDEX [UQ_PartnerHL7Event_EventTypeCode_PartnerID_MessageTypeCode] ON [PartnerHL7Event]
        (
        [EventTypeCode] ASC,
        [PartnerID] ASC,
        [MessageTypeCode] ASC
        )
        
        INSERT INTO dbo.PartnerHL7Event ( [PartnerID],[MessageTypeCode],[EventTypeCode] )
        SELECT 2 as [PartnerID], 'ADT' AS [MessageTypeCode], 'A28' AS [EventTypeCode]
				UNION ALL
				SELECT  2, 'ADT', 'A31'
				UNION ALL
				SELECT  2, 'SIU', 'S12'
				UNION ALL
				SELECT  2, 'SIU', 'S14'
				UNION ALL
				SELECT  2, 'SIU', 'S15'
				UNION ALL
				SELECT  2, 'SIU', 'S17'

    END
    