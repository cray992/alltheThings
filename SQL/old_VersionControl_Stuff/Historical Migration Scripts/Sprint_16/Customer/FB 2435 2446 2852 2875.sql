--CUSTOMER

----------------------------------------------------------------------------
--FB 2435 & 2446 - Add IsOnline bit to Payment table
----------------------------------------------------------------------------

ALTER TABLE Payment DISABLE TRIGGER ALL 
IF NOT EXISTS (SELECT * FROM sys.columns WHERE name = 'IsOnline' AND object_id = object_id('Payment'))
BEGIN
	ALTER TABLE Payment
	ADD IsOnline BIT NOT NULL CONSTRAINT [DF_IsOnline] DEFAULT (0) WITH VALUES
END
ALTER TABLE Payment ENABLE TRIGGER ALL


----------------------------------------------------------------------------
--FB 2852 - Create and populate PatientPayment table 
----------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE xtype = 'u' AND name = 'PatientPayment')
BEGIN
	CREATE TABLE [dbo].[PatientPayment](
		[PatientPaymentID] [int] IDENTITY(1,1) NOT NULL,
		[Description] [varchar](50) NOT NULL
	 CONSTRAINT [PK_PatientPayment] PRIMARY KEY NONCLUSTERED 
	(
		[PatientPaymentID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

GO

IF NOT EXISTS (SELECT 1 FROM dbo.PatientPayment WHERE [Description] = 'No service')
	INSERT INTO dbo.PatientPayment ([Description]) VALUES ('No service')
	
IF NOT EXISTS (SELECT 1 FROM dbo.PatientPayment WHERE [Description] = 'In-office only')
	INSERT INTO dbo.PatientPayment ([Description]) VALUES ('In-office only')
	
IF NOT EXISTS (SELECT 1 FROM dbo.PatientPayment WHERE [Description] = 'In-office and online')
	INSERT INTO dbo.PatientPayment ([Description]) VALUES ('In-office and online')
	

------------------------------------------------------------------------------------
-- FB2852 - Add PatientPaymentID field to Practice table
------------------------------------------------------------------------------------	

IF NOT EXISTS (SELECT * FROM sys.columns WHERE name = 'PatientPaymentID' AND object_id = object_id('Practice'))
BEGIN
	ALTER TABLE Practice
	ADD PatientPaymentID INT NULL
END
			
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Practice_PatientPayment')
BEGIN
	ALTER TABLE [dbo].[Practice]  WITH CHECK ADD  CONSTRAINT [FK_Practice_PatientPayment] FOREIGN KEY([PatientPaymentID])
	REFERENCES [dbo].[PatientPayment] ([PatientPaymentID])
END
		

------------------------------------------------------------------------------------
-- FB2875 - Migrate MerchantAccountConfig data
------------------------------------------------------------------------------------
DECLARE @practiceID INT
DECLARE @MerchantAccountEnabled BIT
DECLARE @UserID VARCHAR(50)
DECLARE @Password VARCHAR(50)
DECLARE @MerchantID VARCHAR(50)
DECLARE @CPMerchantID VARCHAR(50)
DECLARE @CPStoreID VARCHAR(50)
DECLARE @CPTerminalID VARCHAR(50)
DECLARE @CNPMerchantID VARCHAR(50)
DECLARE @CNPStoreID VARCHAR(50)
DECLARE @CNPTerminalID VARCHAR(50)
DECLARE @MerchantAccountEnabledDate DATETIME

DECLARE @CustomerID INT
SET @CustomerID = dbo.fn_GetCustomerID()

DECLARE MAC_Cursor CURSOR
FOR SELECT p.PracticeID, p.MerchantAccountEnabled, UserID, [Password], MerchantID, CPMerchantID, CPStoreID, CPTerminalID, CNPMerchantID,
		   CNPStoreID, CNPTerminalID, p.MerchantAccountEnabledDate
	FROM Practice p
	LEFT JOIN dbo.MerchantAccountConfig m ON p.PracticeID = m.PracticeID
	WHERE p.MerchantAccountEnabledDate IS NOT NULL

OPEN MAC_Cursor

FETCH NEXT FROM MAC_Cursor
INTO @practiceID, @MerchantAccountEnabled, @UserID, @Password, @MerchantID, @CPMerchantID, @CPStoreID, @CPTerminalID, @CNPMerchantID, 
	 @CNPStoreID, @CNPTerminalID, @MerchantAccountEnabledDate
	 
WHILE @@FETCH_STATUS = 0
BEGIN

	DECLARE @PatientPaymentID INT
	SET @PatientPaymentID = CASE @MerchantAccountEnabled
							WHEN 0 THEN 1
							ELSE 2 END
							
	IF NOT EXISTS(SELECT * FROM SHAREDSERVER.Superbill_Shared.dbo.MerchantAccountConfig WHERE PracticeID = @practiceID AND CustomerID = @CustomerID) AND @CustomerID IS NOT NULL
	BEGIN
		INSERT INTO SHAREDSERVER.Superbill_Shared.dbo.MerchantAccountConfig
		        ( CustomerID,
		          PracticeID ,
		          MerchantID ,
		          UserID ,
		          Password ,
		          CPMerchantID ,
		          CPStoreID ,
		          CPTerminalID ,
		          CNPMerchantID ,
		          CNPStoreID ,
		          CNPTerminalID ,
		          PatientPaymentID,
		          PatientPaymentEnabledDate
		        )
		VALUES  ( @CustomerID, --CustomerID - int
				  @PracticeID , -- PracticeID - int
		          @MerchantID , -- MerchantID - varchar(50)
		          @UserID , -- UserID - varchar(50)
		          @Password , -- Password - varchar(50)
		          @CPMerchantID , -- CPMerchantID - varchar(50)
		          @CPStoreID , -- CPStoreID - varchar(50)
		          @CPTerminalID , -- CPTerminalID - varchar(50)
		          @CNPMerchantID , -- CNPMerchantID - varchar(50)
		          @CNPStoreID , -- CNPStoreID - varchar(50)
		          @CNPTerminalID , -- CNPTerminalID - varchar(50)
		          @PatientPaymentID , -- PatientPaymentID - int
		          @MerchantAccountEnabledDate -- PatientPaymentEnabledDate - datetime
		        )
	END
	
	UPDATE dbo.Practice
	SET PatientPaymentID = @PatientPaymentID 
	WHERE PracticeID = @practiceID

	FETCH NEXT FROM MAC_Cursor
	INTO @practiceID, @MerchantAccountEnabled, @UserID, @Password, @MerchantID, @CPMerchantID, @CPStoreID, @CPTerminalID, @CNPMerchantID, 
		 @CNPStoreID, @CNPTerminalID, @MerchantAccountEnabledDate
		 
END

CLOSE MAC_Cursor;
DEALLOCATE MAC_Cursor;

------------------------------------------------------------------------------------
-- FB2852 - Migrate MerchantAccountEnabled data
------------------------------------------------------------------------------------	

IF EXISTS (SELECT * FROM sys.columns WHERE name = 'MerchantAccountEnabled' AND object_id = object_id('Practice'))
BEGIN
	UPDATE dbo.Practice
	SET EStatementsBillingSequenceID = 3, --Print only
		EStatementsBillingDelay = 4
	WHERE MerchantAccountEnabled = 0 

	UPDATE dbo.Practice
	SET EStatementsBillingSequenceID = 1, --Email then print after delay
		EStatementsBillingDelay = 4
	WHERE MerchantAccountEnabled = 1
END

----------------------------------------------------------------						
--FB2858 - Email opt-out
----------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM sys.columns WHERE name = 'SendEmailCorrespondence' AND object_id = object_id('Patient'))
BEGIN
	ALTER TABLE dbo.Patient
	ADD SendEmailCorrespondence BIT DEFAULT(1)
END

GO 

----------------------------------------------------------------						
--FB2892 - Migrate appointment reminder data
----------------------------------------------------------------

DECLARE @pracID INT
DECLARE @remindersEnabled BIT

DECLARE AppReminder_Cursor CURSOR
FOR SELECT PracticeID, AppointmentRemindersEnabled 
	FROM dbo.Practice

OPEN AppReminder_Cursor

FETCH NEXT FROM AppReminder_Cursor
INTO @pracID, @remindersEnabled
	 
WHILE @@FETCH_STATUS = 0
BEGIN
	
	IF @remindersEnabled = 1
	BEGIN
		UPDATE dbo.Patient
		SET SendEmailCorrespondence = CASE 
			--If patient has at least one appointment in future with reminder enabled
			WHEN ((SELECT COUNT(*) 
				   FROM Appointment a
				   WHERE StartDate > GETDATE() AND a.PatientID = dbo.Patient.PatientID AND COALESCE(SendAppointmentReminder, CAST(1 AS BIT)) = 1) > 0) 
				   THEN CAST(1 AS BIT)
			--If patient has no future appointments
			WHEN ((SELECT COUNT(*)
				   FROM Appointment a2
				   WHERE StartDate > GETDATE() AND a2.PatientID = dbo.Patient.PatientID) = 0) 
				   THEN CAST(1 AS BIT)
			ELSE CAST(0 AS BIT) END	
		WHERE dbo.Patient.PracticeID = @pracID
	END
	ELSE
		UPDATE dbo.Patient
		SET SendEmailCorrespondence = 1
		WHERE dbo.Patient.PracticeID = @pracID

	FETCH NEXT FROM AppReminder_Cursor
	INTO @pracID, @remindersEnabled
		 
END

CLOSE AppReminder_Cursor;
DEALLOCATE AppReminder_Cursor;
