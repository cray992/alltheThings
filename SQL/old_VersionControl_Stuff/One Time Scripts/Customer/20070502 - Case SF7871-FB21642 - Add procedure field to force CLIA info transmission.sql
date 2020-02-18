ALTER TABLE ProcedureCodeDictionary
ADD AlwaysSendCLIAInformation bit NOT NULL
CONSTRAINT DF_ProcedureCodeDictionary_AlwaysSendCLIAInformation DEFAULT 0 
GO



UPDATE ProcedureCodeDictionary
SET AlwaysSendCLIAInformation = 1
WHERE ProcedureCode IN 
(
    '17311',
    '17312',
    '17313',
    '17314',
    '17315',
    '82107',
    '83698',
    '83913',
    '86788',
    '86789',
    '87305',
    '87498',
    '87640',
    '87641',
    '87653',
    '87808'
)

GO


