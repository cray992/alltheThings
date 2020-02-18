

CREATE PROCEDURE [dbo].[SalesDemoAccounts_CreateInsurancePayment]

AS 


DECLARE @date DATETIME
DECLARE @night DATETIME
DECLARE @Midday DATETIME
DECLARE @Day DATETIME
DECLARE @Maxrows INT
DECLARE @rowNum INT
DECLARE @Patient INT 
DECLARE @PatientCase INT
DECLARE @Practice INT
DECLARE @Doctor INT
DECLARE @EncounterProcedure VARCHAR(16)
DECLARE @Payment INT 
DECLARE @PatientPayment MONEY
DECLARE @CurrentPayments MONEY
DECLARE @Claim INT
DECLARE @Batch VARCHAR(MAX)
DECLARE @Adjustment MONEY
DECLARE @INSPayment MONEY
DECLARE @ProcedureCode VARCHAR(16)
DECLARE @ProcedureCode1 VARCHAR(16)
DECLARE @ProcedureCode2 VARCHAR(16)
DECLARE @ProcedureCode3 VARCHAR(16)
DECLARE @INSPMT MONEY
DECLARE @INSAllowed MONEY
DECLARE @InsuranceCompanyPlan INT
DECLARE @ClaimCharge MONEY
DECLARE @BillBatch INT 

SET @Practice = 9

SET @date = DATEADD(d, -14, CAST(GETDATE() AS DATE))
SET @night = DATEADD(d, 1,DATEADD(mi, -1, @Date))
SET @midday = DATEADD(hh, 12, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
SET @day = CAST(GETDATE() AS DATE)

SELECT ClaimID
INTO #Claims
FROM dbo.Claim WHERE CreatedDate BETWEEN @date AND @night AND PracticeID = @Practice

SET @BillBatch = (SELECT CONVERT(numeric(4,0), RAND() * 8999)+1000) 
SET @Maxrows = (SELECT COUNT(*) FROM #Claims)
SET @rowNum = 0

SET @Claim = (SELECT TOP 1 ClaimID FROM #Claims ORDER BY ClaimID)

WHILE @rowNum < @MaxRows
BEGIN
	SET @rowNum = @RowNum + 1

	--Generate Variables used
	
	SET @Patient = (SELECT PatientID FROM dbo.Claim WHERE ClaimID = @Claim AND PracticeID = @Practice)
	SET @Doctor = (SELECT TOP 1 Claim_ProviderID FROM dbo.ClaimTransaction WHERE ClaimID = @Claim AND PracticeID = @Practice)
	SET @InsuranceCompanyPlan = (SELECT InsuranceCompanyPlanID FROM dbo.InsurancePolicy ip
															INNER JOIN dbo.PatientCase pc ON
																	ip.PatientCaseID = pc.PatientCaseID AND
																	pc.PracticeID = @Practice                                                                  
															INNER JOIN [KareoMaintenance].dbo.DemoAccountEncounters dae ON
																dae.PatientID = pc.PatientID AND
																dae.PatientCaseID = pc.PatientCaseID
															WHERE dae.PatientID = @Patient and ip.Precedence = 1)	
	SET @ClaimCharge = (SELECT AMOUNT FROM dbo.ClaimTransaction WHERE ClaimTransactionTypeCode = 'CST' AND ClaimID = @Claim AND PracticeID = @Practice)  
	SET @ProcedureCode = (SELECT ProcedureCode FROM dbo.ProcedureCodeDictionary pcd
											INNER JOIN dbo.EncounterProcedure ep ON
													pcd.ProcedureCodeDictionaryID = ep.ProcedureCodeDictionaryID AND
													ep.PracticeID = @Practice                                                  
											INNER JOIN dbo.Claim c ON
													ep.EncounterProcedureID = c.EncounterProcedureID and
													c.PracticeID = @Practice
											WHERE ClaimID = @Claim)
	SET @ProcedureCode1 = (SELECT ProcedureCode1 FROM [KareoMaintenance].dbo.DemoAccountEncounters WHERE PatientID = @Patient)
	SET @ProcedureCode2 = (SELECT ProcedureCode2 FROM [KareoMaintenance].dbo.DemoAccountEncounters WHERE PatientID = @Patient)
	SET @ProcedureCode3 = (SELECT ProcedureCode3 FROM [KareoMaintenance].dbo.DemoAccountEncounters WHERE PatientID = @Patient)
					
	IF(@ProcedureCode = @ProcedureCode1)
	BEGIN
		SET @INSPMT = (SELECT InsurancePMT1 FROM [KareoMaintenance].dbo.DemoAccountEncounters WHERE PatientID = @Patient)
		SET @INSAllowed = (SELECT PlanAllowed1 FROM [KareoMaintenance].dbo.DemoAccountEncounters WHERE PatientID = @Patient)
	END	
	IF(@ProcedureCode = @ProcedureCode2)
	BEGIN
		SET @INSPMT = (SELECT InsurancePMT2 FROM [KareoMaintenance].dbo.DemoAccountEncounters WHERE PatientID = @Patient)
		SET @INSAllowed = (SELECT PlanAllowed2 FROM [KareoMaintenance].dbo.DemoAccountEncounters WHERE PatientID = @Patient)
	END	
	IF(@ProcedureCode = @ProcedureCode3)
	BEGIN
		SET @INSPMT = (SELECT InsurancePMT3 FROM [KareoMaintenance].dbo.DemoAccountEncounters WHERE PatientID = @Patient)
		SET @INSAllowed = (SELECT PlanAllowed3 FROM [KareoMaintenance].dbo.DemoAccountEncounters WHERE PatientID = @Patient)
	END			
	SET @CurrentPayments = (SELECT SUM(AMOUNT) FROM dbo.ClaimTransaction WHERE ClaimTransactionTypeCode IN ('PAY', 'ADJ') AND ClaimID = @Claim)
	SET @PatientPayment = @ClaimCharge - @CurrentPayments

	SET @Batch = (SELECT CONVERT(numeric(8,0), RAND() * 89999999)+10000000)
	--Create Ins Payment
	INSERT INTO dbo.Payment
	        ( PracticeID , PaymentAmount , PaymentMethodCode ,
	          PayerTypeCode , PayerID , CreatedDate ,
	          ModifiedDate ,  PostingDate , BatchID ,
	          CreatedUserID , ModifiedUserID , EOBEditable ,  
			  overrideClosingDate , IsOnline
	        )
	VALUES  ( @Practice , @INSPMT , 'K' , 
	          'I' , @InsuranceCompanyPlan , GETDATE() , 
	          GETDATE() , @midday , @Batch ,
	          0 , 0 , 1 , 
			  0 , 0  )
	
	SET @Payment = (SELECT TOP 1 PaymentID FROM dbo.Payment WHERE Practiceid = @Practice ORDER BY PaymentID DESC)
	SET @Adjustment = @ClaimCharge - @INSAllowed

	
	
	--Post Response
	INSERT INTO dbo.ClaimTransaction
        ( ClaimTransactionTypeCode ,  ClaimID ,
          CreatedDate ,  ModifiedDate ,
          PatientID ,  PracticeID ,
          Claim_ProviderID ,  IsFirstBill ,
          PostingDate ,  PaymentID ,
          Reversible ,  overrideClosingDate )
	VALUES  ( 'RES' ,  @Claim ,  
			  GETDATE() ,  GETDATE() ,  
			  @Patient ,  @Practice ,  
			  @Doctor ,  0 ,  
			  @Day ,  @Payment , 
			  0 ,  0)
	--POST Adjustment w/payment
	EXEC dbo.ClaimDataProvider_AdjustClaim @claim_id = @Claim,
	    @posting_date = @midday, @adjustment_amount = @Adjustment, 
	    @adjusted_units = 1 , @adjustment_code = N'01', 
	    @reason_code = N'45',  @payment_reference_id = @Payment, 
	    @user_id = 0, @overrideClosingDate = 1, @Notes = ''
	--Post Payment on Claim
	INSERT INTO dbo.ClaimTransaction
        ( ClaimTransactionTypeCode , ClaimID ,
          Amount , Quantity , CreatedDate ,
          ModifiedDate , PatientID , PracticeID ,
          Claim_ProviderID , IsFirstBill , PostingDate ,
          PaymentID , Reversible , overrideClosingDate 
        )
	VALUES  ( 'PAY' , @Claim , 
			  @INSPMT , 1.0000 , GETDATE() , 
			  GETDATE() , @Patient , @Practice , 
			  @Doctor , 0 , @day , 
			  @Payment , 0 , 0  
			)
	--Transfer to Patient
	INSERT INTO dbo.ClaimTransaction
	        ( ClaimTransactionTypeCode , ClaimID ,
	          Code , CreatedDate , ModifiedDate ,
	          PatientID , PracticeID , Claim_ProviderID ,
	          IsFirstBill , PostingDate , CreatedUserID , 
	          ModifiedUserID , PaymentID , Reversible , overrideClosingDate )
	VALUES  ( 'ASN' ,  @Claim ,
	          'O', GETDATE() , GETDATE() , 
	          @Patient , @Practice , @Doctor , 
	          0, @Day , 0 , 
	          0 , @Payment , 0 , 0 )
	--UPDATE Claim to Pending 	  
	UPDATE DBO.Claim 
		SET ClaimStatusCode = 'P'
		WHERE ClaimID = @Claim
	--Bill Patient
	INSERT INTO dbo.ClaimTransaction
	        ( ClaimTransactionTypeCode , ClaimID ,
	          Code , Notes ,
			  CreatedDate , ModifiedDate ,
	          PatientID , PracticeID , Claim_ProviderID ,
	          IsFirstBill , PostingDate , Reversible , overrideClosingDate )
	VALUES  ( 'BLL' ,  @Claim ,
	          'S','PAPER STATEMENT GENERATED WITH BATCH ' + CAST(@BillBatch AS VARCHAR),
			  GETDATE() , GETDATE() , 
	          @Patient , @Practice , @Doctor , 
	          0, @Day , 0 , 0 )


	 SET @Claim = (SELECT TOP 1 ClaimID FROM #Claims WHERE ClaimID > @Claim ORDER BY ClaimID)
END

DROP TABLE #Claims


GO


