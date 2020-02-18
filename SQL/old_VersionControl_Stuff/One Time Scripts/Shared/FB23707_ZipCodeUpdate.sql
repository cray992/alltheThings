UPDATE [kdev-db03].dataimport_staging.dbo.zips
      SET ["ZIP_CODE"] = REPLACE(["ZIP_CODE"],'"',''),
      ["CITY"] = REPLACE(["CITY"],'"',''),
      ["STATE"] = REPLACE(["STATE"],'"',''),
      ["AREA_CODE"] = REPLACE(["AREA_CODE"],'"','')

/*
-- Look at the differences…
-- New Zip Codes From source
      SELECT * FROM [kdev-db03].dataimport_staging.dbo.zips nz
            LEFT JOIN Superbill_Shared.dbo.USZipCodes oz
            ON nz.["ZIP_CODE"] = oz.ZipCode
            WHERE oz.ZipCode IS NULL

-- Depricated Zip Codes 
      SELECT * FROM [kdev-db03].dataimport_staging.dbo.zips nz
            RIGHT JOIN Superbill_Shared.dbo.USZipCodes oz
            ON nz.["ZIP_CODE"] = oz.ZipCode
            WHERE nz.["ZIP_CODE"] IS NULL
*/

-- Empty out the USZipCodes table
DELETE FROM sharedserver.superbill_shared.dbo.USZipCodes

INSERT sharedserver.superbill_shared.dbo.USZipCodes
      SELECT * FROM [kdev-db03].dataimport_staging.dbo.zips
      ORDER BY ["ZIP_CODE"] ASC

-- SELECT * FROM USZipCodes WHERE ZipCode='80122'  -- should say LITTLETON, CO
