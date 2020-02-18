USE Superbill_Shared

DECLARE @hackname AS NVARCHAR(100)
SET @hackname = 'PopulateOtherInsInfoInPWK06'





IF NOT EXISTS (SELECT * FROM dbo.EdiHack WHERE Name = @hackname)
BEGIN 
	INSERT INTO dbo.EdiHack
			( Name ,
			  Description ,
			  Comments ,
			  EdiBillXMLV1 ,
			  EdiBillXmlV2 ,
			  EdiBillXmlV2i ,
			  EdiBillXml5010 ,
			  EdiBillXml5010i ,
			  Example ,
			  ReferencedCases ,
			  LoopSegment ,
			  LastModifiedDate ,
			  LastModifiedUser
			)
	VALUES  ( 'PopulateOtherInsInfoInPWK06' , -- Name - nvarchar(100)
			  'Populate primary''s info in PWK06 in 2300 loop if submitting to secondary payer' , -- Description - nvarchar(500)
			  'Update of PopulatePrimaryInsInfoInPWK06' , -- Comments - nvarchar(500)
			  0 , -- EdiBillXMLV1 - bit
			  0 , -- EdiBillXmlV2 - bit
			  0 , -- EdiBillXmlV2i - bit
			  1 , -- EdiBillXml5010 - bit
			  0 , -- EdiBillXml5010i - bit
			  'PWK******A5Q17145556532PO Box 200735 A5R1Austin     TX787200735 ' , -- Example - varchar(256)
			  'PT38358857, 39566171' , -- ReferencedCases - varchar(256)
			  '2300 PWK' , -- LoopSegment - varchar(128)
			  GETDATE() , -- LastModifiedDate - datetime
			  'douglas.ginther'  -- LastModifiedUser - varchar(100)
			)
END 


       
DECLARE @ediHackId AS INT
DECLARE @customerID AS INT 
DECLARE @payernumber AS NVARCHAR(20)

SET @ediHackId = (SELECT ediHackId FROM edihack WHERE name = 'PopulateOtherInsInfoInPWK06')
SET @customerID = 11301
SET @payernumber = '00024'
IF NOT EXISTS (SELECT * FROM dbo.EdiHackPayer WHERE CustomerID = @customerID AND EdiHackID = @ediHackId AND PayerNumber = @payernumber)
BEGIN 
	INSERT INTO dbo.EdiHackPayer
			( EdiHackID ,
			  PayerNumber ,
			  CustomerID ,
			  EdiBillXmlV1 ,
			  EdiBillXmlV2 ,
			  EdiBillXmlV2i ,
			  EdiBillXml5010 ,
			  EdiBillXml5010i ,
			  LastModifiedDate ,
			  LastModifiedUser
			)
	VALUES  ( @ediHackId , -- EdiHackID - int
			  @payernumber , -- PayerNumber - nvarchar(64)
			  @customerID , -- CustomerID - int
			  0 , -- EdiBillXmlV1 - bit
			  0 , -- EdiBillXmlV2 - bit
			  0 , -- EdiBillXmlV2i - bit
			  1 , -- EdiBillXml5010 - bit
			  0 , -- EdiBillXml5010i - bit
			  GETDATE() , -- LastModifiedDate - datetime
			  'douglas.ginther'  -- LastModifiedUser - varchar(100)
			) 
END

SET @customerID = 7039
SET @payernumber = 'MC005'
IF NOT EXISTS (SELECT * FROM dbo.EdiHackPayer WHERE CustomerID = @customerID AND EdiHackID = @ediHackId AND PayerNumber = @payernumber)
BEGIN 
	INSERT INTO dbo.EdiHackPayer
			( EdiHackID ,
			  PayerNumber ,
			  CustomerID ,
			  EdiBillXmlV1 ,
			  EdiBillXmlV2 ,
			  EdiBillXmlV2i ,
			  EdiBillXml5010 ,
			  EdiBillXml5010i ,
			  LastModifiedDate ,
			  LastModifiedUser
			)
	VALUES  ( @ediHackId , -- EdiHackID - int
			  @payernumber , -- PayerNumber - nvarchar(64)
			  @customerID , -- CustomerID - int
			  0 , -- EdiBillXmlV1 - bit
			  0 , -- EdiBillXmlV2 - bit
			  0 , -- EdiBillXmlV2i - bit
			  1 , -- EdiBillXml5010 - bit
			  0 , -- EdiBillXml5010i - bit
			  GETDATE() , -- LastModifiedDate - datetime
			  'douglas.ginther'  -- LastModifiedUser - varchar(100)
			) 
END  