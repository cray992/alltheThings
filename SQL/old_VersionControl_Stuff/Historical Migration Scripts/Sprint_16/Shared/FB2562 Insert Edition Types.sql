INSERT INTO dbo.EditionType
        ( EditionTypeCaption ,
          Description ,
          Active ,
          ShowToAllCustomers
        )
SELECT 'Level 1' AS EditionTypeCaption, 'Level 1 Quest', 0 AS ACTIVE, 0 AS ShowToAllCustomers
UNION ALL
SELECT 'Level 2' AS EditionTypeCaption, 'Level 2 Quest', 0 AS ACTIVE, 0 AS ShowToAllCustomers
UNION ALL
SELECT 'Level 3' AS EditionTypeCaption, 'Level 3 Quest', 0 AS ACTIVE, 0 AS ShowToAllCustomers
UNION ALL
SELECT 'Level 4' AS EditionTypeCaption, 'Level 4 Quest', 0 AS ACTIVE, 0 AS ShowToAllCustomers


SELECT * FROM dbo.EditionType AS ET