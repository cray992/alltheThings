IF NOT EXISTS( SELECT * FROM dbo.SubmitReason WHERE Code='6')
    INSERT INTO dbo.SubmitReason
            ( Code ,
              InstitutionalName ,
              Description ,
              ProfessionalName
            )
    VALUES  ( '6' , -- Code - char(1)
              'Corrected' , -- InstitutionalName - varchar(255)
              null , -- Description - varchar(255)
              'Corrected'  -- ProfessionalName - varchar(255)
            )
