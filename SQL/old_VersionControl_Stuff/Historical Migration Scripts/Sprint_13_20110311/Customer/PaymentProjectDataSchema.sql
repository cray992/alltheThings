--Add new Payment Method and rearrange methods based on Dan's spec



ALTER TABLE dbo.PaymentMethodCode ADD SortOrder INT NOT NULL DEFAULT 0
GO


/*

	Commented in order to disable Electronic Check mode

INSERT INTO dbo.PaymentMethodCode
        ( PaymentMethodCode ,
          Description ,
          SortOrder
        )
VALUES  ( 'A' , -- PaymentMethodCode - char(1)
          'Electronic Check' , -- Description - varchar(50)
          20
        )

*/

UPDATE dbo.PaymentMethodCode SET SortOrder=10 WHERE PaymentMethodCode='K'
UPDATE dbo.PaymentMethodCode SET SortOrder=30 WHERE PaymentMethodCode='R'
UPDATE dbo.PaymentMethodCode SET SortOrder=40 WHERE PaymentMethodCode='E'
UPDATE dbo.PaymentMethodCode SET SortOrder=50 WHERE PaymentMethodCode='C'
UPDATE dbo.PaymentMethodCode SET SortOrder=60 WHERE PaymentMethodCode='O'
UPDATE dbo.PaymentMethodCode SET SortOrder=70 WHERE PaymentMethodCode='U'
---------------------------------------------------------------------------


ALTER TABLE dbo.Practice ADD MerchantAccountEnabled BIT NOT NULL DEFAULT 0
GO

IF EXISTS(SELECT * FROM sys.tables WHERE name = 'MerchantAccountConfig')
	DROP TABLE dbo.MerchantAccountConfig
GO

CREATE TABLE MerchantAccountConfig (
	MerchantAccountConfigID INT NOT NULL IDENTITY (1, 1),
	PracticeID INT NOT NULL,

	MerchantID VARCHAR(50),
	InstamedAccountID VARCHAR(50)
	 
	)
GO



ALTER TABLE dbo.MerchantAccountConfig ADD CONSTRAINT PK_MerchantAccountConfig PRIMARY KEY (MerchantAccountConfigID)
GO

ALTER TABLE dbo.MerchantAccountConfig ADD CONSTRAINT FK_MerchantAccountConfigPractice FOREIGN KEY (PracticeID) REFERENCES dbo.Practice (PracticeID)
GO

-- enable cardiovascular practice / AMA
IF dbo.fn_GetCustomerID()=14
BEGIN
	UPDATE dbo.Practice SET MerchantAccountEnabled=1 WHERE PracticeID=1

	INSERT INTO dbo.MerchantAccountConfig
			( PracticeID, MerchantID, InstamedAccountID )
	VALUES  ( 1, -- PracticeID - int
			  '1017500001001',  -- MerchantID - varchar(50)
			  '102563')
END

IF EXISTS(SELECT * FROM sys.tables WHERE name = 'PaymentAuthorization')
	DROP TABLE PaymentAuthorization
GO

CREATE TABLE dbo.PaymentAuthorization (
	PaymentAuthorizationID INT NOT NULL IDENTITY(1, 1),
	CreatedDateTime DATETIME NOT NULL DEFAULT GETDATE(),
	CreatedUserID INT NOT NULL DEFAULT 0,
	
	PaymentID INT NOT NULL,
	Amount money NOT NULL DEFAULT 0,
	Success BIT NOT NULL DEFAULT 0,
	IsCheck BIT NOT NULL DEFAULT 0,
	TransactionStatus VARCHAR(10),
	
	[AuthorizationNumber] VARCHAR(50),
	ResponseCode VARCHAR(10),
	TransactionID VARCHAR(50),
	AddressVerificationResponseCode VARCHAR(50),
	CardVerificationResponseCode VARCHAR(10),
	Comment VARCHAR(128),
	
	HolderName VARCHAR(128),
	CreditCardAccount VARCHAR(10),
	CheckNumber VARCHAR(32),
	AccountType VARCHAR(10)
)
GO

CREATE CLUSTERED INDEX CI_PaymemtAuthorization ON dbo.PaymentAuthorization (PaymentAuthorizationID)
GO

-- to make it faster to search by payment id
CREATE INDEX IX_PaymentAuthorization ON dbo.PaymentAuthorization (PaymentID)
GO


IF EXISTS (SELECT * FROM sys.tables WHERE NAME = 'PaymentResponseCode')
	DROP TABLE PaymentResponseCode
GO

CREATE TABLE dbo.PaymentResponseCode (
	Code VARCHAR(10),
	[Description] VARCHAR(128)
)
GO

INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('000', 'APPROVAL Approved')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('001', 'CALL Refer to card issuer')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('002', 'CALL Call')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('003', 'TERM ID ERROR Invalid merchant')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('004', 'HOLD-CALL Pickup card')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('005', 'DECLINE Do not honor')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('006', 'Error Error')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('007', 'HOLD-CALL Pickup card, special condition')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('008', 'HONOR WITH ID Honor with ID')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('010', 'APPROVED Approved for partial amount')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('011', 'APPROVED Approved')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('012', 'INVALID TRANS Invalid transaction')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('013', 'AMOUNT ERROR Invalid amount')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('014', 'CARD NO. ERROR Invalid account number')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('015', 'NO SUCH ISSUER No such issuer')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('019', 'RE ENTER Re-enter transaction')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('021', 'NO ACTION TAKEN No action taken')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('025', 'UNABLE TO LOCATE Unable to locate')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('028', 'NO REPLY No reply')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('030', 'CALL Format error')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('031', 'CALL Bank not supported by switch')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('033', 'EXPIRED CARD Expired card')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('034', 'CALL Suspected fraud')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('035', 'CALL Card acceptor contact acquirer')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('036', 'CALL Restricted card')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('037', 'CALL Call card acceptor acquirer security')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('038', 'PIN EXCEEDED Allowable pin tries exceeded')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('039', 'NO CREDIT ACCT No credit account')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('040', 'CALL Requested function not supported')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('041', 'HOLD-CALL Pickup card (lost card)')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('043', 'HOLD-CALL Pickup card (stolen card)')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('051', 'DECLINE Decline')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('052', 'NO CHECK ACCOUNT No checking account')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('053', 'NO SAVE ACCOUNT No savings account')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('054', 'EXPIRED CARD Expired card')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('055', 'WRONG PIN Invalid PIN')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('056', 'NO CARD RECORD No card record')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('057', 'SEVR NOT ALLOWED Service not allowed')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('058', 'SERV NOT ALLOWED Transaction not allowed at terminal')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('059', 'DECLINE Suspected fraud')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('060', 'CALL Card acceptor contact acquirer')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('061', 'DECLINE Activity amount limit exceeded')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('062', 'DECLINE Restricted card')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('063', 'SEC VIOLATION Security violation')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('064', 'CALL Original amount incorrect')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('065', 'DECLINE Activity count limit exceeded')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('066', 'CALL Card acceptor call acquirer’s security dept')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('067', 'HOLD-CALL Hard capture (requires ATM pickup)')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('068', 'CALL Response received too late')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('075', 'PIN EXCEEDED Allowable number of PIN tries exceeded')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('076', 'NO ACTION TAKEN No action taken')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('078', 'NO ACCOUNT Invalid account')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('079', 'ALREADY REVERSED Already reversed')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('080', 'DATE ERROR Invalid date')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('081', 'ENCRYPTOIKN ERROR Encryption error')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('083', 'CANT VERIFY PIN Unable to verify PIN')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('085', 'CARD OK No reason to decline a request for account number verification of AVS')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('086', 'CANT VERIFY PIN Cannot verify PIN')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('087', 'NO REPLY Network unavailable')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('091', 'NO REPLY Issuer unavailable or switch inoperative')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('092', 'INVALID ROUTING Invalid routing number')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('093', 'DECLINE Transaction cannot be completed, violation of law')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('094', 'CALL Duplicate transmission detected')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('096', 'SYSTEM ERROR System error')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('0EA', 'ACCT LENGHT ERR Account length error')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('0EB', 'CHECK DIGIT ERR Check digit error')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('0EC', 'CID FORMAT ERROR CID Format error')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('0N3', 'CASHBACK NOT AVL Cash service not available')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('0N4', 'DECLINE Decline')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('0N7', 'CVV2 MISMATCH CVV2 Mismatch')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('0Q1', 'DECLINE Card authentication failed')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('0RR', 'Invalid field')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('0ER', 'Error')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('077', 'NO ACTION TAKEN No match on original message')
INSERT INTO PaymentResponseCode (Code, [Description]) VALUES ('2', 'CVV ERROR')

CREATE INDEX CI_PaymentResponseCode ON PaymentResponseCode (Code)
GO


IF EXISTS (SELECT * FROM sys.tables WHERE NAME = 'PaymentAVRCode')
	DROP TABLE PaymentAVRCode
GO

CREATE TABLE dbo.PaymentAVRCode (
	Code VARCHAR(10),
	[Description] VARCHAR(128)
)
GO

INSERT INTO PaymentAVRCode (Code, [Description]) VALUES ('0A', 'ADDRESS MATCH Address match.')
INSERT INTO PaymentAVRCode (Code, [Description]) VALUES ('0B', 'ADDRESS MATCH Approved AVS (street address match postal codes, not verified due to Inc. FMT)')
INSERT INTO PaymentAVRCode (Code, [Description]) VALUES ('0C', 'NO MATCH Approved AVS (street address and postal do not match codes, not verified)')
INSERT INTO PaymentAVRCode (Code, [Description]) VALUES ('0D', 'EXACT MATCH Approved AVS (street address and postal codes match international)')
INSERT INTO PaymentAVRCode (Code, [Description]) VALUES ('0E', 'Not a mail/phone order')
INSERT INTO PaymentAVRCode (Code, [Description]) VALUES ('0F', 'EXACT MATCH Approved AVS (street address and postal codes match applies to U.K. only)')
INSERT INTO PaymentAVRCode (Code, [Description]) VALUES ('0G', 'VER UNAVAILABLE Address verification unavailable')
INSERT INTO PaymentAVRCode (Code, [Description]) VALUES ('0I', 'NO MATCH Approved AVS (address information not verified international)')
INSERT INTO PaymentAVRCode (Code, [Description]) VALUES ('0M', 'EXACT MATCH Approved AVS (street address and postal code match international)')
INSERT INTO PaymentAVRCode (Code, [Description]) VALUES ('0N', 'NO MATCH No match.')
INSERT INTO PaymentAVRCode (Code, [Description]) VALUES ('0P', 'ZIP MATCH Approved AVS (postal code match international)')
INSERT INTO PaymentAVRCode (Code, [Description]) VALUES ('0R', 'RETRY Retry.')
INSERT INTO PaymentAVRCode (Code, [Description]) VALUES ('0S', 'SERV UNAVAILABLE Server unavailable.')
INSERT INTO PaymentAVRCode (Code, [Description]) VALUES ('0T', 'Zip Match')
INSERT INTO PaymentAVRCode (Code, [Description]) VALUES ('0U', 'VER UNAVAILABLE Address verification unavailable')
INSERT INTO PaymentAVRCode (Code, [Description]) VALUES ('0W', 'ZIP MATCH Zip code match')
INSERT INTO PaymentAVRCode (Code, [Description]) VALUES ('0X', 'EXACT MATCH Exact match')
INSERT INTO PaymentAVRCode (Code, [Description]) VALUES ('0Y', 'EXACT MATCH Exact match')
INSERT INTO PaymentAVRCode (Code, [Description]) VALUES ('0Z', 'ZIP MATCH Zip code match')


IF EXISTS (SELECT * FROM sys.tables WHERE NAME = 'PaymentCVRCode')
	DROP TABLE PaymentCVRCode
GO

CREATE TABLE dbo.PaymentCVRCode (
	Code VARCHAR(10),
	[Description] VARCHAR(128)
)
GO

INSERT INTO PaymentCVRCode (Code, [Description]) VALUES ('0M', 'CVV2 MATCH')
INSERT INTO PaymentCVRCode (Code, [Description]) VALUES ('0N', 'CVV2 Does not match')
INSERT INTO PaymentCVRCode (Code, [Description]) VALUES ('0P', 'Not processed')
INSERT INTO PaymentCVRCode (Code, [Description]) VALUES ('0S', 'Merchant indicated CVV2 not present')
INSERT INTO PaymentCVRCode (Code, [Description]) VALUES ('0U', 'Issuer not certified')
INSERT INTO PaymentCVRCode (Code, [Description]) VALUES ('0X', 'Reserved')
INSERT INTO PaymentCVRCode (Code, [Description]) VALUES ('0Y', 'Invalid CVC1')
INSERT INTO PaymentCVRCode (Code, [Description]) VALUES ('0Z', 'Reserved')




-- this file was modified is in BusinessRuleProvider.sql
-- and we don'n want to update the whole file

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PaymentIsDeletable'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PaymentIsDeletable
GO

--===========================================================================
-- PAYMENT IS DELETABLE
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PaymentIsDeletable (@payment_id INT)
RETURNS BIT
AS
BEGIN
	--Not deletable if it has been applied to any claims.
	IF EXISTS (
		SELECT	PC.PaymentID, SUM(Amount) Amount
		FROM PaymentClaim PC
		INNER JOIN ClaimTransaction CT
		ON		PC.PracticeID = CT.PracticeID 
		AND		PC.ClaimID = CT.ClaimID 
		AND		PC.PaymentID = CT.PaymentID
		AND		CT.ClaimTransactionTypeCode IN ('ADJ', 'PAY')
		WHERE PC.PaymentID = @payment_id
		GROUP BY PC.PaymentID
		HAVING SUM(Amount) <> 0
	)
		RETURN 0

	--Not deletable if any refunds have been applied to it.
	IF EXISTS (
		SELECT	RefundToPaymentsID
		FROM	RefundToPayments
		WHERE	PaymentID = @payment_id
	)
		RETURN 0
		
	-- not deletable if any payment authorizations exist
	IF EXISTS(SELECT * FROM dbo.PaymentAuthorization WHERE PaymentID=@payment_id)
	RETURN 0

	RETURN 1
END
GO
