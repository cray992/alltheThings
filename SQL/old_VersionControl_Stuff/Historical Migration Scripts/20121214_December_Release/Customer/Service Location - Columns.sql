
--Service Location GUID

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'ServiceLocation' 
           AND  COLUMN_NAME = 'ServiceLocationGuid')
BEGIN

ALTER TABLE dbo.ServiceLocation
ADD ServiceLocationGuid UNIQUEIDENTIFIER NOT NULL
CONSTRAINT [DF_ServiceLocationGuid] DEFAULT(NEWID()) WITH VALUES

END

