-- Creates an insurance program for MA if it doesn't already exist
IF NOT EXISTS (SELECT * FROM dbo.InsuranceProgram WHERE InsuranceProgramCode = 'MA')
BEGIN
	INSERT INTO dbo.InsuranceProgram
			( InsuranceProgramCode ,
			  ProgramName ,
			  Comment ,
			  SortOrder
			)
	VALUES  ( 'MA' , -- InsuranceProgramCode - char(2)
			  'Medicare Part A (UB04 Only)' , -- ProgramName - varchar(150)
			  '' , -- Comment - varchar(150)
			  165  -- SortOrder - int
			)
END