USE Superbill_Shared

IF NOT EXISTS ( SELECT * FROM information_schema.tables WHERE table_name='JobRunList' )
BEGIN

CREATE TABLE JobRunList
(
    Id INT IDENTITY(1,1),
    RunDate datetime,
    JobName VARCHAR(255)
    CONSTRAINT PK_JobRunList PRIMARY KEY (Id)
)

END
