USE superbill_30102_dev
--USE superbill_30102_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
SET IDENTITY_INSERT dbo.PayerScenario ON
INSERT INTO dbo.PayerScenario
        ( PayerScenarioID ,
		  Name ,
          Description ,
          PayerScenarioTypeID ,
          StatementActive
        )
VALUES  ( 5 , 
		  'Commercial' , -- Name - varchar(128)
          '' , -- Description - varchar(256)
          1 , -- PayerScenarioTypeID - int
          0  -- StatementActive - bit
        )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
SET IDENTITY_INSERT dbo.PayerScenario OFF



--COMMIT
--ROLLBACK



