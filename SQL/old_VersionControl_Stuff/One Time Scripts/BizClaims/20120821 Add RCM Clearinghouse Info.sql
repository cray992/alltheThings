-- Set up new ClearinghouseConnections in SHARED

DECLARE @NewGatewayID INT
DECLARE @NewCaparioID INT

-- GatewayEDI RCM
-- For gateway, we're re-using a previously assigned account.
-- We'll disable the old one, and create a new entry for RCM.

-- Disable Old
UPDATE SHAREDSERVER.Superbill_Shared.dbo.ClearinghouseConnection
SET ClaimLogin = '0073922N-RECLAIMED'
WHERE ClearinghouseConnectionID = 16

INSERT INTO SHAREDSERVER.Superbill_Shared.dbo.ClearinghouseConnection
		(ProductionFlag,
		 ClearinghouseConnectionName,
		 SubmitterName,
		 SubmitterEtin,
		 SubmitterContactName,
		 SubmitterContactPhone,
		 SubmitterContactEmail,
		 SubmitterContactFax,
		 ReceiverName,
		 ReceiverEtin,
		 ClaimLogin,
		 ClaimPassword,
		 Notes,
		 CreatedDate,
		 CreatedUserID,
		 ModifiedDate,
		 ModifiedUserID,
		 FtpServerImplementation,
		 FtpForceActiveMode,
		 FtpServer,
		 FtpDirectories,
		 FtpFileExtensions)
VALUES	(0, -- ProductionFlag - bit
		 'Kareo - GatewayEDI - RCM', -- ClearinghouseConnectionName - varchar(100)
		 'KAREO', -- SubmitterName - varchar(100)
		 '200739220', -- SubmitterEtin - varchar(50)
		 'Gateway EDI', -- SubmitterContactName - varchar(100)
		 '9492093473', -- SubmitterContactPhone - varchar(100)
		 'edigatewayedi@kareo.com', -- SubmitterContactEmail - varchar(100)
		 '9492093473', -- SubmitterContactFax - varchar(100)
		 'GATEWAYEDI', -- ReceiverName - varchar(100)
		 '999999999', -- ReceiverEtin - varchar(50)
		 '2EM5', -- ClaimLogin - varchar(50)
'********' -- ClaimPassword - varchar(50)
		 '', -- Notes - text
		 '2012-08-21 22:44:37', -- CreatedDate - datetime
		 0, -- CreatedUserID - int
		 '2012-08-21 22:44:37', -- ModifiedDate - datetime
		 0, -- ModifiedUserID - int
		 'Kareo', -- FtpServerImplementation - varchar(50)
		 0, -- FtpForceActiveMode - bit
		 'ftp.gatewayedi.com', -- FtpServer - varchar(250)
		 'reports;csrreports;remits;997', -- FtpDirectories - varchar(500)
		 NULL  -- FtpFileExtensions - varchar(100)
		 )

SELECT @NewGatewayID=SCOPE_IDENTITY()


-- Capario RCM
INSERT INTO SHAREDSERVER.Superbill_Shared.dbo.ClearinghouseConnection
		(ProductionFlag,
		 ClearinghouseConnectionName,
		 SubmitterName,
		 SubmitterEtin,
		 SubmitterContactName,
		 SubmitterContactPhone,
		 SubmitterContactEmail,
		 SubmitterContactFax,
		 ReceiverName,
		 ReceiverEtin,
		 ClaimLogin,
		 ClaimPassword,
		 Notes,
		 CreatedDate,
		 CreatedUserID,
		 ModifiedDate,
		 ModifiedUserID,
		 FtpServerImplementation,
		 FtpForceActiveMode,
		 FtpServer,
		 FtpDirectories,
		 FtpFileExtensions)
VALUES	(0, -- ProductionFlag - bit
		 'Kareo - Capario/Uniform - RCM', -- ClearinghouseConnectionName - varchar(100)
		 'KAREO', -- SubmitterName - varchar(100)
		 '200739220', -- SubmitterEtin - varchar(50)
		 'KAREO Contact', -- SubmitterContactName - varchar(100)
		 '8887752736', -- SubmitterContactPhone - varchar(100)
		 'ediproxymed@kareo.com', -- SubmitterContactEmail - varchar(100)
		 '9492093473', -- SubmitterContactFax - varchar(100)
		 'PROXYMED', -- ReceiverName - varchar(100)
		 '650202059', -- ReceiverEtin - varchar(50)
		 '0073922N', -- ClaimLogin - varchar(50)
'********' -- ClaimPassword - varchar(50)
		 '', -- Notes - text
		 '2012-08-21 22:44:37', -- CreatedDate - datetime
		 0, -- CreatedUserID - int
		 '2012-08-21 22:44:37', -- ModifiedDate - datetime
		 0, -- ModifiedUserID - int
		 'Kareo', -- FtpServerImplementation - varchar(50)
		 0, -- FtpForceActiveMode - bit
		 'claimsftp.capario.com', -- FtpServer - varchar(250)
		 'reports/0073922N', -- FtpDirectories - varchar(500)
		 NULL  -- FtpFileExtensions - varchar(100)
		 )

SELECT @NewCaparioID=SCOPE_IDENTITY()


--SELECT *
--  FROM [KareoBizclaims].[dbo].[PayerGateway]
--  WHERE ClearinghouseConnectionID = 46

-- Set up new PayerGateways in KareoBizclaims

-- GatewayEDI RCM

-- 'OUT'
INSERT INTO BIZCLAIMSDBSERVER.KareoBizclaims.dbo.PayerGateway
		(ClearinghouseConnectionID,
		 Active,
		 GatewayName,
		 GatewayClass,
		 GatewayScope,
		 TransportTypeCode,
		 TransportDirectionCode,
		 EncryptionOriginatorEmail,
		 EncryptionRecepientEmail,
		 EncryptionPassphrase,
		 data,
		 CreatedDate,
		 CreatedUserID,
		 ModifiedDate,
		 ModifiedUserID,
		 DefaultGatewayClass)
VALUES	(@NewGatewayID, -- ClearinghouseConnectionID - int
		 0, -- Active - bit
		 'Kareo-RCM-GatewayEDI-Claims-OUT', -- GatewayName - varchar(128)
		 'GATEWAYEDI', -- GatewayClass - varchar(32)
		 'CLAIMS', -- GatewayScope - varchar(32)
		 'FTP', -- TransportTypeCode - varchar(64)
		 'OUT', -- TransportDirectionCode - varchar(10)
		 'sergei@kareo.com', -- EncryptionOriginatorEmail - varchar(64)
		 'ops@gatewayedi.com', -- EncryptionRecepientEmail - varchar(64)
		 'the kareo software is best', -- EncryptionPassphrase - ntext
		 NULL, -- data - ntext
		 '2012-08-21 22:53:16', -- CreatedDate - datetime
		 0, -- CreatedUserID - int
		 '2012-08-21 22:53:16', -- ModifiedDate - datetime
		 0, -- ModifiedUserID - int
		 0  -- DefaultGatewayClass - bit
		 )

-- 'IN'
INSERT INTO BIZCLAIMSDBSERVER.KareoBizclaims.dbo.PayerGateway
		(ClearinghouseConnectionID,
		 Active,
		 GatewayName,
		 GatewayClass,
		 GatewayScope,
		 TransportTypeCode,
		 TransportDirectionCode,
		 EncryptionOriginatorEmail,
		 EncryptionRecepientEmail,
		 EncryptionPassphrase,
		 data,
		 CreatedDate,
		 CreatedUserID,
		 ModifiedDate,
		 ModifiedUserID,
		 DefaultGatewayClass)
VALUES	(@NewGatewayID, -- ClearinghouseConnectionID - int
		 0, -- Active - bit
		 'Kareo-RCM-GatewayEDI-Claims-IN', -- GatewayName - varchar(128)
		 'GATEWAYEDI', -- GatewayClass - varchar(32)
		 'CLAIMS', -- GatewayScope - varchar(32)
		 'FTP', -- TransportTypeCode - varchar(64)
		 'IN', -- TransportDirectionCode - varchar(10)
		 'ops@gatewayedi.com', -- EncryptionOriginatorEmail - varchar(64)
		 'sergei@kareo.com', -- EncryptionRecepientEmail - varchar(64)
		 'the kareo software is best', -- EncryptionPassphrase - ntext
		 NULL, -- data - ntext
		 '2012-08-21 22:53:16', -- CreatedDate - datetime
		 0, -- CreatedUserID - int
		 '2012-08-21 22:53:16', -- ModifiedDate - datetime
		 0, -- ModifiedUserID - int
		 0  -- DefaultGatewayClass - bit
		 )

-- Capario RCM


---- 'OUT'
INSERT INTO BIZCLAIMSDBSERVER.KareoBizclaims.dbo.PayerGateway
		(ClearinghouseConnectionID,
		 Active,
		 GatewayName,
		 GatewayClass,
		 GatewayScope,
		 TransportTypeCode,
		 TransportDirectionCode,
		 EncryptionOriginatorEmail,
		 EncryptionRecepientEmail,
		 EncryptionPassphrase,
		 data,
		 CreatedDate,
		 CreatedUserID,
		 ModifiedDate,
		 ModifiedUserID,
		 DefaultGatewayClass)
VALUES	(@NewCaparioID, -- ClearinghouseConnectionID - int
		 0, -- Active - bit
		 'Kareo-RCM-0073922N-PCO', -- GatewayName - varchar(128)
		 'PROXYMED', -- GatewayClass - varchar(32)
		 'CLAIMS', -- GatewayScope - varchar(32)
		 'FTP', -- TransportTypeCode - varchar(64)
		 'OUT', -- TransportDirectionCode - varchar(10)
		 'sergei@kareo.com', -- EncryptionOriginatorEmail - varchar(64)
		 'claims@imsedi.com', -- EncryptionRecepientEmail - varchar(64)
		 'the kareo software is best', -- EncryptionPassphrase - ntext
		 NULL, -- data - ntext
		 '2012-08-21 22:53:16', -- CreatedDate - datetime
		 0, -- CreatedUserID - int
		 '2012-08-21 22:53:16', -- ModifiedDate - datetime
		 0, -- ModifiedUserID - int
		 0  -- DefaultGatewayClass - bit
		 )

-- 'IN'
INSERT INTO BIZCLAIMSDBSERVER.KareoBizclaims.dbo.PayerGateway
		(ClearinghouseConnectionID,
		 Active,
		 GatewayName,
		 GatewayClass,
		 GatewayScope,
		 TransportTypeCode,
		 TransportDirectionCode,
		 EncryptionOriginatorEmail,
		 EncryptionRecepientEmail,
		 EncryptionPassphrase,
		 data,
		 CreatedDate,
		 CreatedUserID,
		 ModifiedDate,
		 ModifiedUserID,
		 DefaultGatewayClass)
VALUES	(@NewCaparioID, -- ClearinghouseConnectionID - int
		 0, -- Active - bit
		 'Kareo-RCM-0073922N-PCI', -- GatewayName - varchar(128)
		 'PROXYMED', -- GatewayClass - varchar(32)
		 'CLAIMS', -- GatewayScope - varchar(32)
		 'FTP', -- TransportTypeCode - varchar(64)
		 'IN', -- TransportDirectionCode - varchar(10)
		 'claims@imsedi.com', -- EncryptionOriginatorEmail - varchar(64)
		 'sergei@kareo.com', -- EncryptionRecepientEmail - varchar(64)
		 'the kareo software is best', -- EncryptionPassphrase - ntext
		 NULL, -- data - ntext
		 '2012-08-21 22:53:16', -- CreatedDate - datetime
		 0, -- CreatedUserID - int
		 '2012-08-21 22:53:16', -- ModifiedDate - datetime
		 0, -- ModifiedUserID - int
		 0  -- DefaultGatewayClass - bit
		 )


USE KareoBizclaims
CREATE TABLE PayerGatewayRCM
(
	FromPayerGatewayID INT,
	ToPayerGatewayID INT
)

CREATE UNIQUE CLUSTERED INDEX CI_PayerGatewayRCM ON dbo.PayerGatewayRCM ( FromPayerGatewayID )

INSERT INTO dbo.PayerGatewayRCM
		(FromPayerGatewayID,
		 ToPayerGatewayID)
VALUES	(89, -- GatewayEDI - 11QZ
		 93  -- GatewayEDI - 2EM5
		 )

INSERT INTO dbo.PayerGatewayRCM
		(FromPayerGatewayID,
		 ToPayerGatewayID)
VALUES	(57, -- Capario - 0073922U
		 95  -- Capario - 0073922N
		 )