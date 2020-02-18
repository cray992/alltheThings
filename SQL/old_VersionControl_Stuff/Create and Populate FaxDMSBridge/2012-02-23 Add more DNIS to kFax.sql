/*
BDate: 2/20/2012
Re Account Number: 949-250-8944
KAREO DID'S
Dear Rolland:

Thank you for choosing AT&T as your communication service provider. It is our responsibility and our goal to exceed the expectations of our customers by providing quality customer service at all times. This notice is to confirm that your order request was completed on 02/17/2012.

1000 DID's have been added to PRI 
C61303986 - 6605000 - 5099 
C90650819 - 6605800-5899 
	949-660-5830 failed
	949-660-5850 - failed
	949-660-5851 - failed
	
C88823201 - 7243300-7399 
C88823416 - 7564768-4799,4800-4867 
C80764568 - 7983000-3099 
C90651102 - 8621600-1699 
C77724007 - 8624400-4499 
C61304729 - 8636500-6599 
C90651232 - 8638500-8599 
C77724113 - 9554600-4699 


Test numbers in each range
949-660-5000
949-660-5050
949-660-5099
949-660-5800 <<This is the start of this block
--949-660-5850 FAILED
949-660-5899 <<This is the end of this block
949-724-3300
949-724-3350
949-724-3399
949-756-4768
949-756-4780
949-756-4799
949-756-4800
949-756-4830
949-756-4867
949-798-3000
949-798-3050
949-798-3099
949-862-1600
949-862-1650
949-862-1699
949-862-4400
949-862-4450
949-862-4499
949-863-6500
949-863-6550
949-863-6599
949-863-8500
949-863-8550
949-863-8599
949-955-4600
949-955-4650
949-955-4699

*/
--Backup current table first
SELECT  *
INTO    _20120223_FaxDNIS
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
        SELECT  '660' ,
                5000 ,
                5099
        UNION
        --SELECT  '660' ,
        --        5800 ,
        --        5899
        --UNION
        SELECT  '724' ,
                3300 ,
                3399
        UNION
        SELECT  '756' ,
                4768 ,
                4799
        UNION
        SELECT  '756' ,
                4800 ,
                4867
        UNION
        SELECT  '798' ,
                3000 ,
                3099
        UNION
        SELECT  '862' ,
                1600 ,
                1699
        UNION
        SELECT  '862' ,
                4400 ,
                4499
        UNION
        SELECT  '863' ,
                6500 ,
                6599
        UNION
        SELECT  '863' ,
                8500 ,
                8599
        UNION
        SELECT  '955' ,
                4600 ,
                4699 


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

