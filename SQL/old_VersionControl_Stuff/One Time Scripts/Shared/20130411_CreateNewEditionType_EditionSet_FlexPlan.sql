IF NOT EXISTS(SELECT * FROM EditionType WHERE EditionTypeCaption='Flex Plan')
BEGIN
INSERT INTO dbo.EditionType
        ( EditionTypeCaption ,
          Active ,
          ShowToAllCustomers ,
          EditionRank ,
          SortOrder
        )
VALUES  (  'Flex Plan',-- EditionTypeCaption - varchar(65)
 -- Description - varchar(512)
 1,-- Active - bit
 1,-- ShowToAllCustomers - bit
 149,-- EditionRank - int
 0-- SortOrder - int
        )
END

