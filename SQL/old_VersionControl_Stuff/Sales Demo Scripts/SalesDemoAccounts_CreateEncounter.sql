

CREATE PROCEDURE [dbo].[SalesDemoAccounts_CreateEncounter]

AS 

DECLARE @date DATETIME
DECLARE @night DATETIME
DECLARE @Midday DATETIME
DECLARE @Maxrows INT
DECLARE @rowNum INT
DECLARE @Appointment INT
DECLARE @StartDate DATETIME
DECLARE @Patient INT 
DECLARE @PatientCase INT
DECLARE @ServiceLocation INT 
DECLARE @Practice INT
DECLARE @Doctor INT
DECLARE @Encounter INT
DECLARE @EncounterProcedure1 VARCHAR(16)
DECLARE @ProcedureUnits1 INT 
DECLARE @ProcedureCharge1 MONEY
DECLARE @EncounterProcedure2 VARCHAR(16)
DECLARE @ProcedureUnits2 INT 
DECLARE @ProcedureCharge2 MONEY
DECLARE @EncounterProcedure3 VARCHAR(16)
DECLARE @ProcedureUnits3 INT 
DECLARE @ProcedureCharge3 MONEY
DECLARE @EncounterDiagnosis1 VARCHAR(16)
DECLARE @EncounterDiagnosis2 VARCHAR(16)
DECLARE @Diagnosis1 VARCHAR(16)
DECLARE @Diagnosis2 VARCHAR(16)
DECLARE @Contract INT 
DECLARE @Concurrent INT  
DECLARE @PrimaryEncounterProcedure INT
DECLARE @SecondaryEncounterProcedure INT
DECLARE @TertiaryEncounterProcedure INT 
DECLARE @Payment INT 
DECLARE @PrimaryClaim INT
DECLARE @SecondaryClaim INT
DECLARE @TertiaryClaim INT
DECLARE @ClearinghouseTracking VARCHAR(MAX)
DECLARE @Batch VARCHAR(MAX)
DECLARE @BatchTransaction VARCHAR(MAX)

SET @Practice = 9


SET @date = DATEADD(d, -1, CAST(GETDATE() AS DATE))
SET @night = DATEADD(d, 1,DATEADD(mi, -1, @Date))
SET @midday = DATEADD(d, 1,DATEADD(hh, -12, @Date))

--Grab all appointments from the day before
CREATE TABLE #Appointments
		(TicketNumber varchar(100),
		AppointmentID int,
		ServicelocationID int,
		ServiceLocationName VARCHAR(45),
		Subject varchar(64),
		StartDate datetime, 
		EndDate datetime, 
		AppointmentType varchar(1), 
		AppointmentTypeDescription varchar(1),
		AppointmentConfirmationStatusCode varchar(1), 
		AppointmentConfirmationStatusDescription varchar(30) ,
		PatientPrefix varchar(30) ,
		PatientFirstName varchar(MAX) ,
		PatientMiddleName varchar(MAX) ,
		PatientLastName varchar(MAX) ,
		PatientSuffix VARCHAR(30) ,
		PrimaryReasonName VARCHAR(30) ,
		Resources VARCHAR(50) ,
		Deletable BIT,
		IsRecurring BIT,
		UniqueID VARCHAR(32),
		PatientID INT,
		ResourceIds VARCHAR(512))
INSERT INTO #Appointments 
EXEC dbo.AppointmentDataProvider_GetAppointments @practice_id = @Practice, 
    @start_date = @date, @end_date = @night 
	
 

--GET the number of appointments that we will be creating encounters for
Set @Maxrows = (SELECT COUNT(*) FROM #Appointments app INNER JOIN [KareoMaintenance].dbo.DemoAccountENcounters dae
												ON app.PatientID = dae.patientid AND LEFT(app.ResourceIDs, LEN (App.ResourceIDs)-2) = dae.RenderingProviderID)
												
--Populate the first set of variables
SELECT TOP 1 @Appointment = app.AppointmentID,
			 @Patient = app.PatientID,
			 @StartDate = app.StartDate,
			 @ServiceLocation = app.ServiceLocationID,
			 @Doctor = (LEFT(app.ResourceIds, LEN(app.ResourceIds)-2)),
			 @EncounterProcedure1 = PCD1.ProcedureCodeDictionaryID,
			 @ProcedureUnits1 = dae.ProcedureUnits1, 
			 @ProcedureCharge1 = dae.ProcedureCharges1,
			 @EncounterProcedure2 = PCD2.ProcedureCodeDictionaryID,
			 @ProcedureUnits2 = dae.ProcedureUnits2, 
			 @ProcedureCharge2 = dae.ProcedureCharges2,
			 @EncounterProcedure3 = PCD3.ProcedureCodeDictionaryID,
			 @ProcedureUnits3 = dae.ProcedureUnits3,
			 @ProcedureCharge3 = dae.ProcedureCharges3,
			 @Diagnosis1 = DCD1.DiagnosisCodeDictionaryID,
			 @Diagnosis2 = DCD2.DiagnosisCodeDictionaryID,
			 @PatientCase = pc.PatientCaseID 
FROM #Appointments app
INNER JOIN [KareoMaintenance].dbo.DemoAccountEncounters dae ON
	app.PatientID = dae.PatientID AND 
	left(app.ResourceIDs, LEN(app.ResourceIDs)-2) = dae.RenderingProviderID
LEFT JOIN dbo.ProcedureCodeDictionary PCD1 ON
	dae.ProcedureCode1 = PCD1.ProcedureCode
LEFT JOIN dbo.ProcedureCodeDictionary PCD2 ON
	dae.ProcedureCode2 = PCD2.ProcedureCode
LEFT JOIN dbo.ProcedureCodeDictionary PCD3 ON
	dae.ProcedureCode3 = PCD3.ProcedureCode
LEFT JOIN dbo.DiagnosisCodeDictionary DCD1 ON
	dae.DiagnosisCode1 = DCD1.DiagnosisCode
LEFT JOIN dbo.DiagnosisCodeDictionary DCD2 ON
	dae.DiagnosisCode2 = DCD2.DiagnosisCode
LEFT JOIN dbo.PatientCase pc ON
	app.PatientID = pc.PatientID
ORDER BY AppointmentID


SET @rowNum = 0

--Loop through Appointments and create Encounters
WHILE @rowNum < @maxRows
BEGIN
	SET @RowNum = @RowNum + 1


	INSERT INTO dbo.Encounter
	        ( PracticeID ,   PatientID ,  DoctorID ,
	          AppointmentID ,  LocationID ,	 DateOfService ,	
			  DateCreated ,	 Notes , EncounterStatusID ,	         
			  AdminNotes ,  AmountPaid ,  CreatedDate ,	          
			  CreatedUserID ,  ModifiedDate ,  ModifiedUserID ,		  
			  PlaceOfServiceCode ,	ConditionNotes ,  PatientCaseID ,	                 
			  PostingDate ,  PaymentMethod ,  AddOns ,
			  DoNotSendElectronic ,	PaymentTypeID ,	 AppointmentStartDate ,		
			  SchedulingProviderID ,  DoNotSendElectronicSecondary ,  overrideClosingDate ,
	          ClaimTypeID ,	 SecondaryClaimTypeID 
	        )
	VALUES  ( @Practice ,  @Patient ,  @Doctor , 
	          @Appointment,  @ServiceLocation ,  @date , 
	          @night,  '' ,  2 , 
			  '' ,  0.00 ,  @night, 
	          0 ,  @night ,  0 , 
	          '11' ,  '' ,  @PatientCase , 
	          @date ,  'U' , 0 , 
	          0 ,  0 ,  @StartDate , 
	          @Doctor ,  0 ,  0 , 
	          0 ,  0 
	        )
	--Get the encounter that was just created
	SET @Encounter = (SELECT TOP 1 encounterID FROM dbo.Encounter WHERE PracticeID = @Practice ORDER BY EncounterID DESC)
	--Get a specific contract that is in all demo accounts
	SET @Contract = (SELECT StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE name = 'Standard Fee Schedule' AND PracticeID = @Practice)
	--Sets wether if the encounter has more than 1 procedure
	SET @Concurrent = (SELECT CASE WHEN @EncounterProcedure2 IS NULL AND @EncounterProcedure3 IS NULL THEN 0 ELSE 1 END )

	--Create First Diagnosis Code
	EXEC EncounterDataProvider_CreateEncounterDiagnosis 
		@encounter_id=@Encounter, @diagnosis_dictionary_id=@Diagnosis1, @list_sequence=1
	SET @EncounterDiagnosis1 = (SELECT TOP 1 EncounterDiagnosisID FROM dbo.EncounterDiagnosis ORDER BY EncounterDiagnosisID DESC)
	
	IF(@Diagnosis2 IS NOT NULL)
	BEGIN
		  
		--Create Second Diagnosis Code  
		EXEC EncounterDataProvider_CreateEncounterDiagnosis 
			@encounter_id=@Encounter, @diagnosis_dictionary_id=@Diagnosis2, @list_sequence=2 
		SET @EncounterDiagnosis2 = (SELECT TOP 1 EncounterDiagnosisID FROM dbo.EncounterDiagnosis ORDER BY EncounterDiagnosisID DESC)
	END
	--Create first Procedure Code
	exec EncounterDataProvider_CreateEncounterProcedure 
	@procedure_dictionary_id=@EncounterProcedure1,@procedure_service_date=@StartDate,
	@EDIServiceNoteReferenceCode=NULL,@location_id=@ServiceLocation,@EDIServiceNote=NULL,
	@DoctorID=NULL,@ContractID=@Contract,@diagnosis_id_1=@Diagnosis1,@diagnosis_id_2=@Diagnosis2,
	@ApplyPayment=0,@diagnosis_id_4=NULL,@unit_count=@ProcedureUnits1,@service_charge_amount=@ProcedureCharge1,
	@PatientResp=0,@AnesthesiaTime=0,@modifier_4=NULL,@ConcurrentProcedures=@Concurrent,
	@encounter_id=@Encounter,@TypeOfServiceCode=N'1',@overrideClosingDate=1
	
	SET @PrimaryEncounterProcedure = (SELECT TOP 1 EncounterProcedureID FROM dbo.EncounterProcedure ORDER BY EncounterProcedureID DESC)
	
	--Create Procedure if there is a second procedure
	IF @EncounterProcedure2 IS NOT NULL
	BEGIN	

		--Create First Diagnosis Code for Second Procedure
		EXEC EncounterDataProvider_CreateEncounterDiagnosis 
			@encounter_id=@Encounter, @diagnosis_dictionary_id=@Diagnosis1, @list_sequence=1
		SET @EncounterDiagnosis1 = (SELECT TOP 1 EncounterDiagnosisID FROM dbo.EncounterDiagnosis ORDER BY EncounterDiagnosisID DESC)

		IF(@Diagnosis2 IS NOT NULL)
		BEGIN
			 
			--Create Second Diagnosis Code for Second Procedure      
			EXEC EncounterDataProvider_CreateEncounterDiagnosis 
				@encounter_id=@Encounter, @diagnosis_dictionary_id=@Diagnosis2, @list_sequence=2 
			SET @EncounterDiagnosis2 = (SELECT TOP 1 EncounterDiagnosisID FROM dbo.EncounterDiagnosis ORDER BY EncounterDiagnosisID DESC)
		END
		--Create Second Procedure
		exec EncounterDataProvider_CreateEncounterProcedure 
		@procedure_dictionary_id=@EncounterProcedure2,@procedure_service_date=@StartDate,
		@EDIServiceNoteReferenceCode=NULL,@location_id=@ServiceLocation,@EDIServiceNote=NULL,
		@DoctorID=NULL,@ContractID=@Contract,@diagnosis_id_1=@Diagnosis1,@diagnosis_id_2=@Diagnosis2,
		@ApplyPayment=0,@diagnosis_id_4=NULL,@unit_count=@ProcedureUnits2,@service_charge_amount=@ProcedureCharge2,
		@PatientResp=0,@AnesthesiaTime=0,@modifier_4=NULL,@ConcurrentProcedures=@Concurrent,
		@encounter_id=@Encounter,@TypeOfServiceCode=N'1',@overrideClosingDate=1

		SET @SecondaryEncounterProcedure = (SELECT TOP 1 EncounterProcedureID FROM dbo.EncounterProcedure ORDER BY EncounterProcedureID DESC)
		
	END 
	--Create Procedure if there is a third procedure
	IF @EncounterProcedure3 IS NOT NULL
	BEGIN 
		--Create First Diagnosis Code for Third Procedure
		EXEC EncounterDataProvider_CreateEncounterDiagnosis 
			@encounter_id=@Encounter, @diagnosis_dictionary_id=@Diagnosis1, @list_sequence=1
		SET @EncounterDiagnosis1 = (SELECT TOP 1 EncounterDiagnosisID FROM dbo.EncounterDiagnosis ORDER BY EncounterDiagnosisID DESC)

		IF(@Diagnosis2 IS NOT null)	
		BEGIN
			--Create Second Diagnosis Code for Third Procedure      
			EXEC EncounterDataProvider_CreateEncounterDiagnosis 
				@encounter_id=@Encounter, @diagnosis_dictionary_id=@Diagnosis2, @list_sequence=2		
			SET @EncounterDiagnosis2 = (SELECT TOP 1 EncounterDiagnosisID FROM dbo.EncounterDiagnosis ORDER BY EncounterDiagnosisID DESC)
		END
		--Create a Third Procedure
		exec EncounterDataProvider_CreateEncounterProcedure 
		@procedure_dictionary_id=@EncounterProcedure3,@procedure_service_date=@StartDate,
		@EDIServiceNoteReferenceCode=NULL,@location_id=@ServiceLocation,@EDIServiceNote=NULL,
		@DoctorID=NULL,@ContractID=@Contract,@diagnosis_id_1=@Diagnosis1,@diagnosis_id_2=@Diagnosis2,
		@ApplyPayment=0,@diagnosis_id_4=NULL,@unit_count=@ProcedureUnits2,@service_charge_amount=@ProcedureCharge3,
		@PatientResp=0,@AnesthesiaTime=0,@modifier_4=NULL,@ConcurrentProcedures=@Concurrent,
		@encounter_id=@Encounter,@TypeOfServiceCode=N'1',@overrideClosingDate=1

		SET @TertiaryEncounterProcedure = (SELECT TOP 1 EncounterProcedureID FROM dbo.EncounterProcedure ORDER BY EncounterProcedureID DESC)
		
	END 
		
	EXEC EncounterDataProvider_ApproveEncounter
	@encounter_id=@Encounter
	--Generate random number for clearinghouse tracking number
	SET @ClearinghouseTracking = (SELECT CONVERT(numeric(12,0), RAND() *899999999999)+100000000000)
	--Put ClearinghouseTracking ID in Claim 
	UPDATE dbo.Claim 
		SET ClearinghouseTrackingNumber = @ClearinghouseTracking,
			ClaimStatusCode = 'P'
		WHERE PatientID = @Patient AND EncounterProcedureID = @PrimaryEncounterProcedure AND PracticeID = @Practice
	
	SET @PrimaryClaim = (SELECT ClaimID FROM dbo.Claim WHERE EncounterProcedureID = @PrimaryEncounterProcedure AND PracticeID = @Practice)
		
	--Transfer partial responsibility to patient
	INSERT INTO dbo.ClaimTransaction
	        ( ClaimTransactionTypeCode , ClaimID ,
	          Amount , CreatedDate , ModifiedDate ,
	          PatientID , PracticeID , Claim_ProviderID ,
	          IsFirstBill , PostingDate , CreatedUserID ,
	          ModifiedUserID , Reversible , overrideClosingDate )
	VALUES  ( 'PRC' ,  @PrimaryClaim ,
	          20.00 , GETDATE() , GETDATE() , 
	          @Patient , @Practice , @Doctor , 
	          0, @Date , 0 , 
	          0 , 0 , 0 )

	--Create Co-Pay For First Procedure/Claim for all Encounters
	INSERT INTO dbo.Payment
	        ( PracticeID , PaymentAmount , PaymentMethodCode ,
	          PayerTypeCode , PayerID , CreatedDate ,
	          ModifiedDate , SourceEncounterID , PostingDate ,
	          CreatedUserID , ModifiedUserID , EOBEditable ,  
			  AppointmentID , AppointmentStartDate, overrideClosingDate , IsOnline
	        )
	VALUES  ( @Practice , 20.00 , 'K' , 
	          'P' , @Patient , GETDATE() , 
	          GETDATE() , @Encounter , @midday , 
	          0 , 0 , 1 , 
			  @Appointment , @StartDate,0 , 0  )
	
	SET @Payment = (SELECT TOP 1 PaymentID FROM dbo.Payment ORDER BY PAYMENTID DESC)
	
	--Create ClaimTransaction Line for Co-Pay
	INSERT INTO dbo.ClaimTransaction
	        ( ClaimTransactionTypeCode , ClaimID , Amount ,
	          Quantity , CreatedDate , ModifiedDate ,
	          PatientID , PracticeID , Claim_ProviderID ,
	          IsFirstBill , PostingDate , CreatedUserID ,
	          ModifiedUserID , PaymentID , Reversible ,
	          overrideClosingDate )
	VALUES  ( 'PAY' , @PrimaryClaim , 20.00 ,
	          1.000 , GETDATE() , GETDATE() ,
	          @Patient , @Practice , @Doctor ,
	          0 , @date , 0 ,
	          0 , @Payment , 0 , 
			  0 )
	--Create PaymentClaim for Co-Pay
	INSERT INTO dbo.PaymentClaim
	        ( PaymentID , PracticeID , PatientID ,
	          EncounterID , ClaimID , Reversed ,
	          Draft , HasError , ErrorMsg )
	VALUES  ( @Payment ,  @Practice , @Patient , 
	          @Encounter ,  @PrimaryClaim ,  0 ,
	          0 ,  0 , '' )
	--Create PaymentEncounter for Co-Pay
	INSERT INTO dbo.PaymentEncounter
	        ( PaymentID , PracticeID , PatientID ,
	          EncounterID , PaymentRawEOBID )
	VALUES  ( @Payment ,  @Practice , @Patient , 
	          @Encounter ,0  )
	--Create PaymentPatient for Co-Pay
	INSERT INTO dbo.PaymentPatient
	        ( PaymentID, PatientID, PracticeID )
	VALUES  ( @Payment, @Patient, @Practice )


	--Insert records into claims
	SET @Batch = (SELECT CONVERT(numeric(8,0), RAND() *89999999)+10000000)
	SET @BatchTransaction = (SELECT CONVERT(numeric(8,0), RAND() *89999999)+10000000)

	--Sent to Clearinghouse
	INSERT INTO dbo.ClaimTransaction
        ( ClaimTransactionTypeCode ,
          ClaimID , Notes , CreatedDate ,
          ModifiedDate , PatientID , PracticeID ,
          Claim_ProviderID , IsFirstBill , PostingDate ,
          Reversible , overrideClosingDate , ClaimResponseStatusID
        )
	VALUES  ( 'EDI' , @PrimaryClaim ,
          '(SNT) sent to Gateway 89 (GATEWAYEDI) Batch='+ @Batch + ' BatchTransactionId=' + @BatchTransaction ,
          GETDATE() , GETDATE() , @Patient ,
          @Practice , @Doctor , 0 ,
          @Night , 0 , 0 , 2 
        )
	--Acknowledged by Clearinghouse
	INSERT INTO dbo.ClaimTransaction
			( ClaimTransactionTypeCode ,
				ClaimID , Code , Notes ,
				CreatedDate , ModifiedDate ,
				PatientID , PracticeID ,
				Claim_ProviderID , IsFirstBill ,
				PostingDate , Reversible ,
				overrideClosingDate , ClaimResponseStatusID )
	VALUES  ( 'EDI' ,  @PrimaryClaim ,
				'A' ,
				'OK: Processed by GatewayEDI (CSR/OT01 statement came - claim processing status ACK reported) GatewayEDI Tracking #:' + @ClearinghouseTracking + ' (BLU)' ,
				GETDATE() , GETDATE() , @Patient,
				@Practice , @Doctor , 0 ,
				@Night ,  0 , 0 , 3 )
	--Acknowledged by Payer
	INSERT INTO dbo.ClaimTransaction
			( ClaimTransactionTypeCode ,
			  ClaimID , Code , Notes ,
			  CreatedDate , ModifiedDate ,
			  PatientID , PracticeID ,
			  Claim_ProviderID , IsFirstBill ,
			  PostingDate , Reversible ,
			  overrideClosingDate , ClaimResponseStatusID )
	VALUES  ( 'EDI' ,  @PrimaryClaim ,
			  'P' ,
			  'OK: Processed by GatewayEDI (CSR/AC71 statement came - claim processing status ACK reported) GatewayEDI Tracking #: ' + @ClearinghouseTracking + ' (A00) ;  Status: ACK  Accepted for processing Acknowledgement/Receipt' ,
			  GETDATE() , GETDATE() , @Patient,
			  @Practice , @Doctor , 0 ,
			  @Night ,  0 , 0 , 6 )
	--Acknowledged by Payer
	INSERT INTO dbo.ClaimTransaction
			( ClaimTransactionTypeCode ,
			  ClaimID , Code , Notes ,
			  CreatedDate , ModifiedDate ,
			  PatientID , PracticeID ,
			  Claim_ProviderID , IsFirstBill ,
			  PostingDate , Reversible ,
			  overrideClosingDate , ClaimResponseStatusID )
	VALUES  ( 'EDI' ,  @PrimaryClaim ,
			  'P' ,
			  'OK: Processed by GatewayEDI (CSR/997A statement came - claim processing status ACK reported) GatewayEDI Tracking #: ' + @ClearinghouseTracking + ' (A00) ;  Status: ACK  Payer has acknowledged initial receipt of claim file.' ,
			  GETDATE() , GETDATE() , @Patient,
			  @Practice , @Doctor , 0 ,
			  @Night ,  0 , 0 , 6 )
	--UnknownByPayer
	INSERT INTO dbo.ClaimTransaction
			( ClaimTransactionTypeCode ,
			  ClaimID , Code , Notes ,
			  CreatedDate , ModifiedDate ,
			  PatientID , PracticeID ,
			  Claim_ProviderID , IsFirstBill ,
			  PostingDate , Reversible ,
			  overrideClosingDate , ClaimResponseStatusID )
	VALUES  ( 'EDI' ,  @PrimaryClaim ,
			  'P' ,
			  'OK: Processed by GatewayEDI (CSR/AC71 statement came - claim processing status ACK reported) GatewayEDI Tracking #: ' + @ClearinghouseTracking + ' (I00)' ,
			  GETDATE() , GETDATE() , @Patient,
			  @Practice , @Doctor , 0 ,
			  @Night ,  0 , 0 , 10 )


	IF(@SecondaryEncounterProcedure IS NOT NULL)
	BEGIN
    	SET @ClearinghouseTracking = ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT))
		SET @SecondaryClaim = (SELECT ClaimID FROM dbo.CLaim WHERE EncounterProcedureID = @SecondaryEncounterProcedure)
		UPDATE dbo.Claim 
			SET ClearinghouseTrackingNumber = @ClearinghouseTracking,
				ClaimStatusCode = 'P'
			WHERE PatientID = @Patient AND EncounterProcedureID = @SecondaryEncounterProcedure AND PracticeID = @Practice
		
		INSERT INTO dbo.ClaimTransaction
        ( ClaimTransactionTypeCode ,
          ClaimID , Notes , CreatedDate ,
          ModifiedDate , PatientID , PracticeID ,
          Claim_ProviderID , IsFirstBill , PostingDate ,
          Reversible , overrideClosingDate , ClaimResponseStatusID        )
		VALUES  ( 'EDI' , @SecondaryClaim ,
          '(SNT) sent to Gateway 89 (GATEWAYEDI) Batch='+ @Batch + ' BatchTransactionId=' + @BatchTransaction ,
          GETDATE() , GETDATE() , @Patient ,
          @Practice , @Doctor , 0 ,
          @Night , 0 , 0 , 2 )
		--Acknowledged by Clearinghouse
		INSERT INTO dbo.ClaimTransaction
				( ClaimTransactionTypeCode ,
					ClaimID , Code , Notes ,
					CreatedDate , ModifiedDate ,
					PatientID , PracticeID ,
					Claim_ProviderID , IsFirstBill ,
					PostingDate , Reversible ,
					overrideClosingDate , ClaimResponseStatusID )
		VALUES  ( 'EDI' ,  @SecondaryClaim ,
					'A' ,
					'OK: Processed by GatewayEDI (CSR/OT01 statement came - claim processing status ACK reported) GatewayEDI Tracking #:' + @ClearinghouseTracking + ' (BLU)' ,
					GETDATE() , GETDATE() , @Patient,
					@Practice , @Doctor , 0 ,
					@Night ,  0 , 0 , 3 )
		--Acknowledged by Payer
		INSERT INTO dbo.ClaimTransaction
				( ClaimTransactionTypeCode ,
				  ClaimID , Code , Notes ,
				  CreatedDate , ModifiedDate ,
				  PatientID , PracticeID ,
				  Claim_ProviderID , IsFirstBill ,
				  PostingDate , Reversible ,
				  overrideClosingDate , ClaimResponseStatusID )
		VALUES  ( 'EDI' ,  @SecondaryClaim ,
				  'P' ,
				  'OK: Processed by GatewayEDI (CSR/AC71 statement came - claim processing status ACK reported) GatewayEDI Tracking #: ' + @ClearinghouseTracking + ' (A00) ;  Status: ACK  Accepted for processing Acknowledgement/Receipt' ,
				  GETDATE() , GETDATE() , @Patient,
				  @Practice , @Doctor , 0 ,
				  @Night ,  0 , 0 , 6 )
		--Acknowledged by Payer
		INSERT INTO dbo.ClaimTransaction
				( ClaimTransactionTypeCode ,
				  ClaimID , Code , Notes ,
				  CreatedDate , ModifiedDate ,
				  PatientID , PracticeID ,
				  Claim_ProviderID , IsFirstBill ,
				  PostingDate , Reversible ,
				  overrideClosingDate , ClaimResponseStatusID )
		VALUES  ( 'EDI' ,  @SecondaryClaim ,
				  'P' ,
				  'OK: Processed by GatewayEDI (CSR/997A statement came - claim processing status ACK reported) GatewayEDI Tracking #: ' + @ClearinghouseTracking + ' (A00) ;  Status: ACK  Payer has acknowledged initial receipt of claim file.' ,
				  GETDATE() , GETDATE() , @Patient,
				  @Practice , @Doctor , 0 ,
				  @Night ,  0 , 0 , 6 )
		--UnknownByPayer
		INSERT INTO dbo.ClaimTransaction
				( ClaimTransactionTypeCode ,
				  ClaimID , Code , Notes ,
				  CreatedDate , ModifiedDate ,
				  PatientID , PracticeID ,
				  Claim_ProviderID , IsFirstBill ,
				  PostingDate , Reversible ,
				  overrideClosingDate , ClaimResponseStatusID )
		VALUES  ( 'EDI' ,  @SecondaryClaim ,
				  'P' ,
				  'OK: Processed by GatewayEDI (CSR/AC71 statement came - claim processing status ACK reported) GatewayEDI Tracking #: ' + @ClearinghouseTracking + ' (I00)' ,
				  GETDATE() , GETDATE() , @Patient,
				  @Practice , @Doctor , 0 ,
				  @Night ,  0 , 0 , 10 )	
	END
    
    IF (@TertiaryEncounterProcedure IS NOT NULL)
	BEGIN
		SET @ClearinghouseTracking = ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT))
		SET @TertiaryClaim = (SELECT ClaimID FROM dbo.CLaim WHERE EncounterProcedureID = @TertiaryEncounterProcedure)
		UPDATE dbo.Claim 
			SET ClearinghouseTrackingNumber = @ClearinghouseTracking,
				ClaimStatusCode = 'P'
			WHERE PatientID = @Patient AND EncounterProcedureID = @TertiaryEncounterProcedure AND ClaimID = @TertiaryClaim AND PracticeID = @Practice
	
		
		INSERT INTO dbo.ClaimTransaction
        ( ClaimTransactionTypeCode ,
          ClaimID , Notes , CreatedDate ,
          ModifiedDate , PatientID , PracticeID ,
          Claim_ProviderID , IsFirstBill , PostingDate ,
          Reversible , overrideClosingDate , ClaimResponseStatusID        )
		VALUES  ( 'EDI' , @SecondaryClaim ,
          '(SNT) sent to Gateway 89 (GATEWAYEDI) Batch='+ @Batch + ' BatchTransactionId=' + @BatchTransaction ,
          GETDATE() , GETDATE() , @Patient ,
          @Practice , @Doctor , 0 ,
          @Night , 0 , 0 , 2 )
		--Acknowledged by Clearinghouse
		INSERT INTO dbo.ClaimTransaction
				( ClaimTransactionTypeCode ,
					ClaimID , Code , Notes ,
					CreatedDate , ModifiedDate ,
					PatientID , PracticeID ,
					Claim_ProviderID , IsFirstBill ,
					PostingDate , Reversible ,
					overrideClosingDate , ClaimResponseStatusID )
		VALUES  ( 'EDI' ,  @TertiaryClaim ,
					'A' ,
					'OK: Processed by GatewayEDI (CSR/OT01 statement came - claim processing status ACK reported) GatewayEDI Tracking #:' + @ClearinghouseTracking + ' (A00)' ,
					GETDATE() , GETDATE() , @Patient,
					@Practice , @Doctor , 0 ,
					@Night ,  0 , 0 , 3 )
		--Acknowledged by Payer
		INSERT INTO dbo.ClaimTransaction
				( ClaimTransactionTypeCode ,
				  ClaimID , Code , Notes ,
				  CreatedDate , ModifiedDate ,
				  PatientID , PracticeID ,
				  Claim_ProviderID , IsFirstBill ,
				  PostingDate , Reversible ,
				  overrideClosingDate , ClaimResponseStatusID )
		VALUES  ( 'EDI' ,  @TertiaryClaim ,
				  'P' ,
				  'OK: Processed by GatewayEDI (CSR/AC71 statement came - claim processing status ACK reported) GatewayEDI Tracking #: ' + @ClearinghouseTracking + ' (A00) ;  Status: ACK  Accepted for processing Acknowledgement/Receipt' ,
				  GETDATE() , GETDATE() , @Patient,
				  @Practice , @Doctor , 0 ,
				  @Night ,  0 , 0 , 6 )
		--Acknowledged by Payer
		INSERT INTO dbo.ClaimTransaction
				( ClaimTransactionTypeCode ,
				  ClaimID , Code , Notes ,
				  CreatedDate , ModifiedDate ,
				  PatientID , PracticeID ,
				  Claim_ProviderID , IsFirstBill ,
				  PostingDate , Reversible ,
				  overrideClosingDate , ClaimResponseStatusID )
		VALUES  ( 'EDI' ,  @TertiaryClaim ,
				  'P' ,
				  'OK: Processed by GatewayEDI (CSR/997A statement came - claim processing status ACK reported) GatewayEDI Tracking #: ' + @ClearinghouseTracking + ' (A00) ;  Status: ACK  Payer has acknowledged initial receipt of claim file.' ,
				  GETDATE() , GETDATE() , @Patient,
				  @Practice , @Doctor , 0 ,
				  @Night ,  0 , 0 , 6 )
		--UnknownByPayer
		INSERT INTO dbo.ClaimTransaction
				( ClaimTransactionTypeCode ,
				  ClaimID , Code , Notes ,
				  CreatedDate , ModifiedDate ,
				  PatientID , PracticeID ,
				  Claim_ProviderID , IsFirstBill ,
				  PostingDate , Reversible ,
				  overrideClosingDate , ClaimResponseStatusID )
		VALUES  ( 'EDI' ,  @TertiaryClaim ,
				  'P' ,
				  'OK: Processed by GatewayEDI (CSR/AC71 statement came - claim processing status ACK reported) GatewayEDI Tracking #: ' + @ClearinghouseTracking + ' (A00)' ,
				  GETDATE() , GETDATE() , @Patient,
				  @Practice , @Doctor , 0 ,
				  @Night ,  0 , 0 , 10 )	
	END

	--Populate the variables for next encounter
	SELECT TOP 1 @Appointment = app.AppointmentID,
				 @Patient = app.PatientID,
				 @StartDate = app.StartDate,
				 @ServiceLocation = app.ServiceLocationID,
				 @Doctor = (LEFT(app.ResourceIds, LEN(app.ResourceIds)-2)),
				 @EncounterProcedure1 = PCD1.ProcedureCodeDictionaryID,
				 @ProcedureUnits1 = dae.ProcedureUnits1, 
				 @ProcedureCharge1 = dae.ProcedureCharges1,
				 @EncounterProcedure2 = PCD2.ProcedureCodeDictionaryID,
				 @ProcedureUnits2 = dae.ProcedureUnits2, 
				 @ProcedureCharge2 = dae.ProcedureCharges2,
				 @EncounterProcedure3 = PCD3.ProcedureCodeDictionaryID,
				 @ProcedureUnits3 = dae.ProcedureUnits3,
				 @ProcedureCharge3 = dae.ProcedureCharges3,
				 @Diagnosis1 = DCD1.DiagnosisCodeDictionaryID,
				 @Diagnosis2 = DCD2.DiagnosisCodeDIctionaryID,
				 @PatientCase = pc.PatientCaseID,
				 @PrimaryEncounterProcedure = NULL,
				 @SecondaryEncounterProcedure = NULL,
				 @TertiaryEncounterProcedure = NULL
	FROM #Appointments app
	INNER JOIN [KareoMaintenance].dbo.DemoAccountEncounters dae ON
		app.PatientID = dae.PatientID AND 
		left(app.ResourceIDs, LEN(app.ResourceIDs)-2) = dae.RenderingProviderID
	LEFT JOIN dbo.ProcedureCodeDictionary PCD1 ON
		dae.ProcedureCode1 = PCD1.ProcedureCode
	LEFT JOIN dbo.ProcedureCodeDictionary PCD2 ON
		dae.ProcedureCode2 = PCD2.ProcedureCode
	LEFT JOIN dbo.ProcedureCodeDictionary PCD3 ON
		dae.ProcedureCode3 = PCD3.ProcedureCode
	LEFT JOIN dbo.DiagnosisCodeDictionary DCD1 ON
		dae.DiagnosisCode1 = DCD1.DiagnosisCode
	LEFT JOIN dbo.DiagnosisCodeDictionary DCD2 ON
		dae.DiagnosisCode2 = DCD2.DiagnosisCode
	LEFT JOIN dbo.PatientCase pc ON
		app.PatientID = pc.PatientID  
	WHERE AppointmentID > @Appointment
	ORDER BY AppointmentID

END 


DROP TABLE #Appointments
	

GO