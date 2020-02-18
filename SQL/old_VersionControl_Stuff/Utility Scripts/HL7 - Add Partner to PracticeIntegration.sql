PRINT 'Set up the partner names and then change ROLLBACK to COMMIT at end of script'

BEGIN TRAN

DECLARE @PracticeID INT,
    @HL7PartnerID INT

DECLARE @HL7KareoApplicationName VARCHAR(180),
    @HL7KareoFacilityName VARCHAR(180),
    @HL7PartnerApplicationName VARCHAR(180),
    @HL7PartnerFacilityName VARCHAR(180)

SET @PracticeID = 1
SET @HL7PartnerID = 1

SET @HL7KareoApplicationName = 'Kareo'
SET @HL7KareoFacilityName = 'KAREO'
SET @HL7PartnerApplicationName = 'Care360'
SET @HL7PartnerFacilityName = 'Kareo_12345'

IF NOT EXISTS ( SELECT  *
                FROM    dbo.PracticeIntegration
                WHERE   PracticeID = @PracticeID ) 
    BEGIN
        INSERT  dbo.PracticeIntegration (PracticeID, CreatedDate, ModifiedDate, CreatedUserID, ModifiedUserID)
        VALUES  (@PracticeID, GETDATE(), GETDATE(), 122, 122)

    END

UPDATE  dbo.PracticeIntegration
SET     HL7KareoApplicationName = @HL7KareoApplicationName, HL7KareoFacilityName = @HL7KareoFacilityName,
        HL7PartnerActive = 1, HL7PartnerApplicationName = @HL7PartnerApplicationName,
        HL7PartnerFacilityName = @HL7PartnerFacilityName, HL7PartnerID = 1
WHERE   PracticeID = @PracticeID


DECLARE @events TABLE (MsgCode CHAR(3),
                       EventCode CHAR(3))

DECLARE @MsgTypeCode CHAR(3)
DECLARE @EventTypeCode CHAR(3)

INSERT  INTO @events
        SELECT  'ADT', 'A28'
        UNION
        SELECT  'ADT', 'A31'
        UNION
        SELECT  'SIU', 'S12'
        UNION
        SELECT  'SIU', 'S14'
        UNION
        SELECT  'SIU', 'S15'
        UNION
        SELECT  'SIU', 'S17'

DECLARE event_cursor CURSOR FAST_FORWARD
FOR
    SELECT  MsgCode, EventCode
    FROM    @events

OPEN event_cursor

FETCH NEXT FROM event_cursor INTO @MsgTypeCode, @EventTypeCode

WHILE @@FETCH_STATUS = 0 
    BEGIN
    
        IF NOT EXISTS ( SELECT  *
                        FROM    dbo.HL7_PartnerEvent
                        WHERE   PracticeID = @PracticeID
                                AND HL7PartnerID = @HL7PartnerID
                                AND EventTypeCode = @EventTypeCOde
                                AND MessageTypeCode = @MsgTypeCode ) 
			EXEC dbo.HL7DataProvider_CreatePartnerEvent @PracticeID = @PracticeID, -- int
			    @HL7PartnerID = @HL7PartnerID, -- int
			    @MessageTypeCode = @MsgTypeCode, -- char(3)
			    @EventTypeCode = @EventTypeCode -- char(3)

			 
        FETCH NEXT FROM event_cursor INTO @MsgTypeCode, @EventTypeCode
    END

CLOSE event_cursor
DEALLOCATE event_cursor


--COMMIT
ROLLBACK
