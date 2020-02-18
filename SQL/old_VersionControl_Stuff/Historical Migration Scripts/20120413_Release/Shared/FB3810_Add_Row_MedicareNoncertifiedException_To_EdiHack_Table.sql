-- Use IS NULL and IS NOT NULL.
SET ANSI_NULLS ON
GO
-- Identifiers double quote. Strings single quote.
SET QUOTED_IDENTIFIER ON
GO
-- Prevent DONE_IN_PROC messages for each statement 
SET NOCOUNT ON
GO

IF NOT EXISTS (SELECT * FROM dbo.EdiHack AS EH WHERE [Name] = 'MedicareNoncertifiedException')
BEGIN
	INSERT  INTO [Superbill_Shared].[dbo].[EdiHack]
			( [Name] ,
			  [Description] ,
			  [Comments] ,
			  [EdiBillXmlV1] ,
			  [EdiBillXmlV2] ,
			  [EdiBillXmlV2i] ,
			  [EdiBillXml5010] ,
			  [EdiBillXml5010i] ,
			  [Example] ,
			  [ReferencedCases] ,
			  [LoopSegment] ,
			  [LastModifiedDate] ,
			  [LastModifiedUser]
			)
	VALUES  ( 'MedicareNoncertifiedException' ,
			  'Use total billed amount in AMT*A8 and carrier code 0085000 in NM1*PR' ,
			  '@MedicareNoncertifiedException = 1' ,
			  0 ,
			  0 ,
			  0 ,
			  1 ,
			  0 ,
			  'AMT*A8*105.00~; NM1*PR*2*MEDICARE OF MASSACHUSETTS J14*****PI*0085000~' ,
			  'SF00221636 FB3810' ,
			  '2320 & 2330B' ,
			  GETDATE() ,
			  'joe.somoza'
			);
END			

DECLARE @edi_hack_id AS INT;
SELECT TOP 1
        @edi_hack_id = EH.EdiHackID
FROM    [Superbill_Shared].dbo.EdiHack AS EH WITH ( NOLOCK )
WHERE   EH.NAME = 'MedicareNoncertifiedException';

IF NOT EXISTS (SELECT * FROM dbo.EdiHackPayer AS EHP WHERE PayerNumber = '00643' AND EdiHackID = @edi_hack_id)
BEGIN
	INSERT  INTO [Superbill_Shared].[dbo].[EdiHackPayer]
			( [EdiHackID] ,
			  [PayerNumber] ,
			  [CustomerID] ,
			  [EdiBillXmlV1] ,
			  [EdiBillXmlV2] ,
			  [EdiBillXmlV2i] ,
			  [EdiBillXml5010] ,
			  [EdiBillXml5010i] ,
			  [LastModifiedDate] ,
			  [LastModifiedUser]
			)
	VALUES  ( @edi_hack_id ,
			  '00643' ,
			  1621 ,
			  0 ,
			  0 ,
			  0 ,
			  1 ,
			  0 ,
			  GETDATE() ,
			  'joe.somoza'
			);
END 			