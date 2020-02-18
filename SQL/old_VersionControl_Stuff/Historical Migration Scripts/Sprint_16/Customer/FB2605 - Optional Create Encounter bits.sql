
IF NOT EXISTS ( SELECT  1
                FROM    INFORMATION_SCHEMA.COLUMNS
                WHERE   TABLE_NAME = 'PracticeIntegration'
                        AND COLUMN_NAME = 'DiagnosisCodeOptional' ) 
    BEGIN
        ALTER TABLE dbo.PracticeIntegration
        ADD 
        [DiagnosisCodeOptional] [bit] NULL,
        [ProcedureCodeOptional] [bit] NULL,
        [ServiceLocationOptional] [bit] NULL,
        [RenderingProviderOptional] [bit] NULL
    END
GO