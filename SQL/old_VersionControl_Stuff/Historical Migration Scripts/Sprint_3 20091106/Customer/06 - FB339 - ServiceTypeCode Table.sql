/*
	ALTER TABLE EligibilityHistory
	DROP CONSTRAINT FK_EligibilityHistory_ServiceTypeCode
*/

IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.TABLES
            WHERE   TABLE_NAME = 'ServiceTypeCodePayerNumber' ) 
    BEGIN
        DROP TABLE dbo.ServiceTypeCodePayerNumber
    END

GO
/*This does seem like a good check, the table shouldn't exist.
Since after this script runs once, the table will exist and thus will get dropped
IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.TABLES
            WHERE   TABLE_NAME = 'ServiceTypeCode' ) 
    BEGIN
        DROP TABLE dbo.ServiceTypeCode
    END

GO
*/
IF NOT EXISTS ( SELECT  *
                FROM    sys.tables t
                WHERE   t.name = 'ServiceTypeCode' ) 
    BEGIN

        CREATE TABLE dbo.ServiceTypeCode
            (
              ServiceTypeCode VARCHAR(2) NOT NULL ,
              Description VARCHAR(100) NOT NULL ,
              DefaultDisplay BIT NOT NULL ,
              SortOrder INT NOT NULL ,
              KareoLastModifiedDate DATETIME NULL ,
              CreatedDate DATETIME NOT NULL ,
              ModifiedDate DATETIME NOT NULL ,
              Timestamp TIMESTAMP NOT NULL
            )
    END

GO

IF NOT EXISTS ( SELECT  *
                FROM    sys.key_constraints k
                WHERE   name = 'PK_ServiceTypeCode' ) 
    BEGIN
        ALTER TABLE dbo.ServiceTypeCode
        ADD CONSTRAINT PK_ServiceTypeCode PRIMARY KEY CLUSTERED ( ServiceTypeCode ASC )
    END
GO

IF NOT EXISTS ( SELECT  *
                FROM    sys.default_constraints d
                WHERE   name = 'DF_ServiceTypeCode_CreatedDate' ) 
    BEGIN
        ALTER TABLE dbo.ServiceTypeCode
        ADD  CONSTRAINT DF_ServiceTypeCode_CreatedDate  DEFAULT (GETDATE()) FOR CreatedDate
    END
GO

IF NOT EXISTS ( SELECT  *
                FROM    sys.default_constraints d
                WHERE   d.name = 'DF_ServiceTypeCode_ModifiedDate' ) 
    BEGIN
        ALTER TABLE [dbo].[ServiceTypeCode] 
        ADD  CONSTRAINT [DF_ServiceTypeCode_ModifiedDate]  DEFAULT (GETDATE()) FOR [ModifiedDate]
    END
GO

IF NOT EXISTS ( SELECT  *
                FROM    sys.tables t
                WHERE   name = 'ServiceTypeCodePayerNumber' ) 
    BEGIN
        CREATE TABLE dbo.ServiceTypeCodePayerNumber
            (
              ServiceTypeCodePayerNumberID INT NOT NULL
                                               IDENTITY(1, 1) ,
              ServiceTypeCode VARCHAR(2) NOT NULL ,
              ClearinghouseID INT NOT NULL ,
              PayerNumber VARCHAR(32) NOT NULL ,
              KareoServiceTypeCodePayerNumberID INT NULL ,
              KareoLastModifiedDate DATETIME NULL ,
              CreatedDate DATETIME NOT NULL ,
              ModifiedDate DATETIME NOT NULL ,
              Timestamp TIMESTAMP NOT NULL
            )
    END
GO

IF NOT EXISTS ( SELECT  *
                FROM    sys.foreign_keys f
                WHERE   f.name = 'FK_ServiceTypeCodePayerNumber_ServiceTypeCode' ) 
    BEGIN
        ALTER TABLE dbo.ServiceTypeCodePayerNumber WITH CHECK 
        ADD CONSTRAINT FK_ServiceTypeCodePayerNumber_ServiceTypeCode FOREIGN KEY(ServiceTypeCode)
        REFERENCES dbo.ServiceTypeCode (ServiceTypeCode)
    END
GO

IF NOT EXISTS ( SELECT  *
                FROM    sys.default_constraints d
                WHERE   d.name = 'DF_ServiceTypeCodePayerNumber_CreatedDate' ) 
    BEGIN
        ALTER TABLE dbo.ServiceTypeCodePayerNumber
        ADD  CONSTRAINT [DF_ServiceTypeCodePayerNumber_CreatedDate]  DEFAULT (GETDATE()) FOR [CreatedDate]
    END
GO

IF NOT EXISTS ( SELECT  *
                FROM    sys.default_constraints d
                WHERE   d.name = 'DF_ServiceTypeCodePayerNumber_ModifiedDate' ) 
    BEGIN
        ALTER TABLE dbo.ServiceTypeCodePayerNumber
        ADD  CONSTRAINT [DF_ServiceTypeCodePayerNumber_ModifiedDate]  DEFAULT (GETDATE()) FOR [ModifiedDate]
    END
GO

IF NOT EXISTS ( SELECT  *
                FROM    sys.columns c
                        INNER JOIN sys.tables t ON c.object_id = t.object_id
                WHERE   t.name = 'EligibilityHistory'
                        AND c.name = 'DoctorID' ) 
    BEGIN
        ALTER TABLE EligibilityHistory ADD DoctorID INT NULL
    END
GO

IF NOT EXISTS ( SELECT  *
                FROM    sys.columns c
                        INNER JOIN sys.tables t ON c.object_id = t.object_id
                WHERE   t.name = 'EligibilityHistory'
                        AND c.name = 'ServiceTypeCode' ) 
    BEGIN
        ALTER TABLE EligibilityHistory ADD ServiceTypeCode VARCHAR(2) NULL
    END
GO

IF NOT EXISTS ( SELECT  *
                FROM    sys.foreign_keys f
                WHERE   f.name = 'FK_EligibilityHistory_ServiceTypeCode' ) 
    BEGIN
        ALTER TABLE [dbo].[EligibilityHistory]  WITH CHECK ADD CONSTRAINT [FK_EligibilityHistory_ServiceTypeCode] FOREIGN KEY([ServiceTypeCode])
        REFERENCES [dbo].[ServiceTypeCode] ([ServiceTypeCode])
    END
GO

--ALTER TABLE [dbo].[EncounterProcedure] CHECK CONSTRAINT [FK_EncounterProcedure_TypeOfServiceCode]
--GO
IF NOT EXISTS ( SELECT  *
                FROM    sys.foreign_keys f
                WHERE   f.name = 'FK_EligibilityHistoryToDoctor' ) 
    BEGIN
        ALTER TABLE [dbo].[EligibilityHistory]  WITH CHECK ADD  CONSTRAINT [FK_EligibilityHistoryToDoctor] FOREIGN KEY([DoctorID])
        REFERENCES [dbo].[Doctor] ([DoctorID])
    END
GO
