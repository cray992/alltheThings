
IF NOT EXISTS
(
	SELECT * FROM dbo.ServiceTypeCodePayerNumber AS STCPN
	WHERE STCPN.PayerNumber = 'BS021' AND 
	STCPN.ClearinghouseID = 1 AND 
	STCPN.ServiceTypeCode = 'AD'
)
BEGIN
/****BS021 AD Service Type Code Number*/
INSERT INTO dbo.ServiceTypeCodePayerNumber
        ( ServiceTypeCode ,
          ClearinghouseID ,
          PayerNumber ,
          KareoServiceTypeCodePayerNumberID ,
          KareoLastModifiedDate ,
          CreatedDate ,
          ModifiedDate ,
          Timestamp
        )
VALUES  ( 'AD' , -- ServiceTypeCode - varchar(2)
          1 , -- ClearinghouseID - int
          'BS021' , -- PayerNumber - varchar(32)
          0 , -- KareoServiceTypeCodePayerNumberID - int
          '2011-08-09 01:52:38' , -- KareoLastModifiedDate - datetime
          '2011-08-09 01:52:38' , -- CreatedDate - datetime
          '2011-08-09 01:52:38' , -- ModifiedDate - datetime
          NULL  -- Timestamp - timestamp
        )
        
        DECLARE @ServiceTypeCodePayerNumberID1 INT
        
        SELECT @ServiceTypeCodePayerNumberID1 = SCOPE_IDENTITY()
        
        UPDATE dbo.ServiceTypeCodePayerNumber
        SET KareoServiceTypeCodePayerNumberID = @ServiceTypeCodePayerNumberID1
        WHERE ServiceTypeCodePayerNumberID = @ServiceTypeCodePayerNumberID1
 
 END
 /****BS021 AE Service Type Code Number*/
 
IF NOT EXISTS
(
	SELECT * FROM dbo.ServiceTypeCodePayerNumber AS STCPN
	WHERE STCPN.PayerNumber = 'BS021' AND 
	STCPN.ClearinghouseID = 1 AND 
	STCPN.ServiceTypeCode = 'AE'
)
BEGIN
INSERT INTO dbo.ServiceTypeCodePayerNumber
        ( ServiceTypeCode ,
          ClearinghouseID ,
          PayerNumber ,
          KareoServiceTypeCodePayerNumberID ,
          KareoLastModifiedDate ,
          CreatedDate ,
          ModifiedDate ,
          Timestamp
        )
VALUES  ( 'AE' , -- ServiceTypeCode - varchar(2)
          1 , -- ClearinghouseID - int
          'BS021' , -- PayerNumber - varchar(32)
          0 , -- KareoServiceTypeCodePayerNumberID - int
          '2011-08-09 01:52:38' , -- KareoLastModifiedDate - datetime
          '2011-08-09 01:52:38' , -- CreatedDate - datetime
          '2011-08-09 01:52:38' , -- ModifiedDate - datetime
          NULL  -- Timestamp - timestamp
        )
        
        DECLARE @ServiceTypeCodePayerNumberID2 INT
        
        SELECT @ServiceTypeCodePayerNumberID2 = SCOPE_IDENTITY()
        
        UPDATE dbo.ServiceTypeCodePayerNumber
        SET KareoServiceTypeCodePayerNumberID = @ServiceTypeCodePayerNumberID2
        WHERE ServiceTypeCodePayerNumberID = @ServiceTypeCodePayerNumberID2
END


 /****BS021 AE Service Type Code Number*/
 
IF NOT EXISTS
(
	SELECT * FROM dbo.ServiceTypeCodePayerNumber AS STCPN
	WHERE STCPN.PayerNumber = 'BS021' AND 
	STCPN.ClearinghouseID = 1 AND 
	STCPN.ServiceTypeCode = '30'
)
BEGIN
INSERT INTO dbo.ServiceTypeCodePayerNumber
        ( ServiceTypeCode ,
          ClearinghouseID ,
          PayerNumber ,
          KareoServiceTypeCodePayerNumberID ,
          KareoLastModifiedDate ,
          CreatedDate ,
          ModifiedDate ,
          Timestamp
        )
VALUES  ( '30' , -- ServiceTypeCode - varchar(2)
          1 , -- ClearinghouseID - int
          'BS021' , -- PayerNumber - varchar(32)
          0 , -- KareoServiceTypeCodePayerNumberID - int
          '2011-08-09 01:52:38' , -- KareoLastModifiedDate - datetime
          '2011-08-09 01:52:38' , -- CreatedDate - datetime
          '2011-08-09 01:52:38' , -- ModifiedDate - datetime
          NULL  -- Timestamp - timestamp
        )
        
        DECLARE @ServiceTypeCodePayerNumberID3 INT
        
        SELECT @ServiceTypeCodePayerNumberID3 = SCOPE_IDENTITY()
        
        UPDATE dbo.ServiceTypeCodePayerNumber
        SET KareoServiceTypeCodePayerNumberID = @ServiceTypeCodePayerNumberID3
        WHERE ServiceTypeCodePayerNumberID = @ServiceTypeCodePayerNumberID3
END