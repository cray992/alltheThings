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
                FROM    sys.foreign_keys k
                WHERE   k.name = 'FK_EligibilityHistory_ServiceTypeCode' ) 
    BEGIN
        ALTER TABLE [dbo].[EligibilityHistory]  WITH CHECK ADD CONSTRAINT [FK_EligibilityHistory_ServiceTypeCode] FOREIGN KEY([ServiceTypeCode])
        REFERENCES [dbo].[ServiceTypeCode] ([ServiceTypeCode])
    END
GO

--ALTER TABLE [dbo].[EncounterProcedure] CHECK CONSTRAINT [FK_EncounterProcedure_TypeOfServiceCode]
--GO
IF NOT EXISTS ( SELECT  *
                FROM    sys.foreign_keys k
                WHERE   k.name = 'FK_EligibilityHistoryToDoctor' ) 
    BEGIN
        ALTER TABLE [dbo].[EligibilityHistory]  WITH CHECK ADD  CONSTRAINT [FK_EligibilityHistoryToDoctor] FOREIGN KEY([DoctorID])
        REFERENCES [dbo].[Doctor] ([DoctorID])
    END
GO
