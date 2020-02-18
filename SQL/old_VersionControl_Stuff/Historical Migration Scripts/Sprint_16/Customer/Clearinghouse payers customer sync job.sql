INSERT INTO dbo.SyncJob
        ( Name ,
          StoredProcedure ,
          StartTime ,
          EndTime ,
          Status ,
          Active
        )
VALUES  ( 'Sync. ClearinghousePayersList data from shared' , -- Name - varchar(50)
          'SyncJob_ClearinghousePayersList' , -- StoredProcedure - varchar(150)
          '2011-03-31 11:00:00' , -- StartTime - datetime
          '2011-03-31 11:00:00' , -- EndTime - datetime
          '' , -- Status - char(1)
          1  -- Active - bit
         )