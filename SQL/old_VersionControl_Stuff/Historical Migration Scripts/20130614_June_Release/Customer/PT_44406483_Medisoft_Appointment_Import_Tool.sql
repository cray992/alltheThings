


IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'VendorImport' AND COLUMN_NAME = 'PracticeTimeZone')
BEGIN

  ALTER TABLE [dbo].[VendorImport]  ADD PracticeTimeZone varchar(128) NULL
END