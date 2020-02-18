
IF NOT EXISTS ( SELECT * FROM dbo.ClaimResponseStatus AS crs
WHERE crs.ClaimResponseStatus = 'Rejected at Kareo')
BEGIN
INSERT INTO dbo.ClaimResponseStatus
        ( ClaimResponseStatus )
VALUES  ( 'Rejected at Kareo'  -- ClaimResponseStatus - varchar(64)
          )
END

IF NOT EXISTS ( SELECT * FROM dbo.ClaimResponseStatus AS crs
WHERE crs.ClaimResponseStatus = 'Sent to Clearinghouse')
INSERT INTO dbo.ClaimResponseStatus
        ( ClaimResponseStatus )
VALUES  ( 'Sent to Clearinghouse'  -- ClaimResponseStatus - varchar(64)
          )

IF NOT EXISTS ( SELECT * FROM dbo.ClaimResponseStatus AS crs
WHERE crs.ClaimResponseStatus = 'Acknowledged by Clearinghouse')
INSERT INTO dbo.ClaimResponseStatus
        ( ClaimResponseStatus )
VALUES  ( 'Acknowledged by Clearinghouse'  -- ClaimResponseStatus - varchar(64)
          )

IF NOT EXISTS ( SELECT * FROM dbo.ClaimResponseStatus AS crs
WHERE crs.ClaimResponseStatus = 'Rejected at Clearinghouse')
INSERT INTO dbo.ClaimResponseStatus
        ( ClaimResponseStatus )
VALUES  ( 'Rejected at Clearinghouse'  -- ClaimResponseStatus - varchar(64)
          )


IF NOT EXISTS ( SELECT * FROM dbo.ClaimResponseStatus AS crs
WHERE crs.ClaimResponseStatus = 'Rejected at Payer')
INSERT INTO dbo.ClaimResponseStatus
        ( ClaimResponseStatus )
VALUES  ( 'Rejected at Payer'  -- ClaimResponseStatus - varchar(64)
          )


IF NOT EXISTS ( SELECT * FROM dbo.ClaimResponseStatus AS crs
WHERE crs.ClaimResponseStatus = 'Acknowledged by Payer')
INSERT INTO dbo.ClaimResponseStatus
        ( ClaimResponseStatus )
VALUES  ( 'Acknowledged by Payer'  -- ClaimResponseStatus - varchar(64)
          )

IF NOT EXISTS ( SELECT * FROM dbo.ClaimResponseStatus AS crs
WHERE crs.ClaimResponseStatus = 'Paid')

INSERT INTO dbo.ClaimResponseStatus
        ( ClaimResponseStatus )
VALUES  ( 'Paid'  -- ClaimResponseStatus - varchar(64)
          )


IF NOT EXISTS ( SELECT * FROM dbo.ClaimResponseStatus AS crs
WHERE crs.ClaimResponseStatus = 'Denied')
INSERT INTO dbo.ClaimResponseStatus
        ( ClaimResponseStatus )
VALUES  ( 'Denied'  -- ClaimResponseStatus - varchar(64)
          )
          
		  
IF NOT EXISTS ( SELECT * FROM dbo.ClaimResponseStatus AS crs
WHERE crs.ClaimResponseStatus = 'UnknownByClearinghouse')
INSERT INTO dbo.ClaimResponseStatus
        ( ClaimResponseStatus )
VALUES  ( 'UnknownByClearinghouse'  -- ClaimResponseStatus - varchar(64)
          )

		  
IF NOT EXISTS ( SELECT * FROM dbo.ClaimResponseStatus AS crs
WHERE crs.ClaimResponseStatus = 'UnknownByPayer')
INSERT INTO dbo.ClaimResponseStatus
        ( ClaimResponseStatus )
VALUES  ( 'UnknownByPayer'  -- ClaimResponseStatus - varchar(64)
          )