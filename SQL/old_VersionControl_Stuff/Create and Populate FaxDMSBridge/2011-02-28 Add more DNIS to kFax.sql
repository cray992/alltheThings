/*
BTN: (949) 250-8944 Order #: C97697024 Due Date: 02/22/2011 

I have completed your request to issue 10 change orders to add 1000 DID numbers to existing PRI 949-250-8944, 
effective 02-22-11, please see all order numbers as follows. 

C97697024 -8623400-3499 
C69542075 -8623500-3599 
C69542105 -8623600-3699 
C83013269 -8623700-3799 
C98386105 -8628200-8299 
C84115793 -8628300-8399 
C98386372 -8628700-8799 
C69542525 -8628800-8899 
C98386426 -8633200-3298,6300 
C73778538 -8636400-6499 
*/
--Backup current table first
SELECT  *
INTO    _20110228_FaxDNIS
FROM    dbo.FaxDNIS ;

DECLARE @areaCode CHAR(3)
SET @areaCode = '949'

DECLARE @tdnis TABLE
    (
      Prefix CHAR(3) NOT NULL ,
      StartRange INT NOT NULL ,
      EndRange INT NOT NULL
    )

INSERT  INTO @tdnis
        ( Prefix ,
          StartRange ,
          EndRange 
        )
        SELECT  '862' ,
                3400 ,
                3499
        UNION
        SELECT  '862' ,
                3500 ,
                3599
        UNION
        SELECT  '862' ,
                3600 ,
                3699
        UNION
        SELECT  '862' ,
                3700 ,
                3799
        UNION
        SELECT  '862' ,
                8200 ,
                8299
        UNION
        SELECT  '862' ,
                8300 ,
                8399
        UNION
        SELECT  '862' ,
                8700 ,
                8799
        UNION
        SELECT  '862' ,
                8800 ,
                8899
        UNION
        SELECT  '863' ,
                3200 ,
                3298
        UNION
        SELECT  '863' ,
                6300 ,
                6300
        UNION
        SELECT  '863' ,
                6400 ,
                6499 


DECLARE @DNISCount INT
SET @DNISCount = 0
DECLARE @DNISStart INT
DECLARE @DNISEnd INT
DECLARE @DNIS CHAR(10)
DECLARE @prefix CHAR(3)

DECLARE dnis_cur CURSOR FAST_FORWARD READ_ONLY FOR
SELECT Prefix, StartRange, EndRange  FROM @tdnis ORDER BY Prefix, StartRange

OPEN dnis_cur

FETCH NEXT FROM dnis_cur INTO @Prefix, @DNISStart, @DNISEnd

WHILE @@FETCH_STATUS = 0
BEGIN

WHILE @DNISStart <= @DNISEnd 
    BEGIN
        SET @DNIS = @areaCode + @prefix + dbo.fn_LPad(CAST(@DNISStart AS VARCHAR),'0',4)
        IF NOT EXISTS ( SELECT  *
                        FROM    FaxDNIS
                        WHERE   DNIS = @DNIS ) 
            BEGIN
                --SET @DNIS = @prefix + CAST(@DNISStart AS VARCHAR)
                INSERT  FaxDNIS
                        ( DNIS )
                VALUES  ( @DNIS )
		
                SET @DNISCount = @DNISCount + 1
            END
	
        SET @DNISStart = @DNISStart + 1
    END


FETCH NEXT FROM dnis_cur INTO @Prefix, @DNISStart, @DNISEnd

END

CLOSE dnis_cur
DEALLOCATE dnis_cur

