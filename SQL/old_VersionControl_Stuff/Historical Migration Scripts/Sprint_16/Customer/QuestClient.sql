-- this is already will be in PROD by the time of the release, 
-- but we still need it in Dev in order to implement changes to Kareo Client

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
        [HL7KareoFacilityName] [varchar](180) NULL
    END
GO


-- add Quest Related Edition Types

INSERT INTO dbo.EditionType
        ( EditionTypeName ,
          SortOrder ,
          Active ,
          EditionTypeID
        )
VALUES  ( 'Level 1' ,
          10 ,
          0 ,
          8
        )
        
INSERT INTO dbo.EditionType
        ( EditionTypeName ,
          SortOrder ,
          Active ,
          EditionTypeID
        )
VALUES  ( 'Level 2' ,
          11 ,
          0 ,
          9
        )

INSERT INTO dbo.EditionType
        ( EditionTypeName ,
          SortOrder ,
          Active ,
          EditionTypeID
        )
VALUES  ( 'Level 3' ,
          12 ,
          0 ,
          10
        )
        
INSERT INTO dbo.EditionType
        ( EditionTypeName ,
          SortOrder ,
          Active ,
          EditionTypeID
        )
VALUES  ( 'Level 4' ,
          13 ,
          0 ,
          11
        )
