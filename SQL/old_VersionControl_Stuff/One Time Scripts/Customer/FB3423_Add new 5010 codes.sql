/*********New 5010 codes ***********/

/***** NEW Ambulance CRC codes*****/
IF NOT EXISTS (SELECT * FROM AmbulanceCertificationCode WHERE Code = N'12')

INSERT INTO dbo.AmbulanceCertificationCode
        ( Code, Definition, NSFReference )
VALUES  ( N'12', -- Code - nchar(2)
          N'Patient is confined to a bed or chair', -- Definition - nchar(1024)
          NULL  -- NSFReference - nchar(15)
          )

/***** NEW SBR09 codes (Claim Filing Indicator Codes) *****/
DECLARE @currentSortOrder INT

SELECT @currentSortOrder = MAX(sortorder)
FROM dbo.InsuranceProgram AS IP

IF NOT EXISTS (SELECT * FROM InsuranceProgram WHERE InsuranceProgramCode = '17')
INSERT INTO dbo.InsuranceProgram
        ( InsuranceProgramCode ,
          ProgramName ,
          TIMESTAMP ,
          Comment ,
          SortOrder
        )
VALUES  ( '17' , -- InsuranceProgramCode - char(2)
          'Dental Maintenance Organization' , -- ProgramName - varchar(150)
          NULL , -- TIMESTAMP - timestamp
          'New 5010 code' , -- Comment - varchar(150)
          @currentSortOrder + 10  -- SortOrder - int
        )
        

IF NOT EXISTS (SELECT * FROM InsuranceProgram WHERE InsuranceProgramCode = 'FI')
INSERT INTO dbo.InsuranceProgram
        ( InsuranceProgramCode ,
          ProgramName ,
          TIMESTAMP ,
          Comment ,
          SortOrder
        )
VALUES  ( 'FI' , -- InsuranceProgramCode - char(2)
          'Federal Employees Program' , -- ProgramName - varchar(150)
          NULL , -- TIMESTAMP - timestamp
          'New 5010 code' , -- Comment - varchar(150)
          @currentSortOrder + 20  -- SortOrder - int
        )
        

IF NOT EXISTS (SELECT * FROM InsuranceProgram WHERE InsuranceProgramCode = 'MA')
INSERT INTO dbo.InsuranceProgram
        ( InsuranceProgramCode ,
          ProgramName ,
          TIMESTAMP ,
          Comment ,
          SortOrder
        )
VALUES  ( 'MA' , -- InsuranceProgramCode - char(2)
          'Medicare Part A' , -- ProgramName - varchar(150)
          NULL , -- TIMESTAMP - timestamp
          'New 5010 code' , -- Comment - varchar(150)
          @currentSortOrder + 30  -- SortOrder - int
        )


/*************** Related to Drug Codes *****************/        

IF NOT EXISTS (SELECT * FROM dbo.EDINoteReferenceCode AS ENRC WHERE ENRC.Code = 'RX')
INSERT INTO dbo.EDINoteReferenceCode
        ( Code ,
          Definition ,
          ClaimOnly ,
          DisplayCMS1500 ,
          DisplayUB04
        )
VALUES  ( 'RX' , -- Code - char(3)
          'Prescription Number for Service Line' , -- Definition - varchar(64)
          0 , -- ClaimOnly - bit
          1 , -- DisplayCMS1500 - bit
          0  -- DisplayUB04 - bit
        )
ELSE
	UPDATE dbo.EDINoteReferenceCode
	SET DisplayCMS1500 = 1
	WHERE Code = 'RX'

  
IF NOT EXISTS (SELECT * FROM dbo.EDINoteReferenceCode AS ENRC WHERE ENRC.Code = 'VY')
INSERT INTO dbo.EDINoteReferenceCode
        ( Code ,
          Definition ,
          ClaimOnly ,
          DisplayCMS1500 ,
          DisplayUB04
        )
VALUES  ( 'VY' , -- Code - char(3)
          'Link Sequence Number' , -- Definition - varchar(64)
          0 , -- ClaimOnly - bit
          1 , -- DisplayCMS1500 - bit
          0  -- DisplayUB04 - bit
        )
ELSE
	UPDATE dbo.EDINoteReferenceCode
	SET DisplayCMS1500 = 1
	WHERE Code = 'VY'
