
USE Superbill_Shared
UPDATE PatientStatementsTransport SET ParametersXml = 
'<Parameters>
  <Out>
    <FtpServer>www.bfis.com</FtpServer>
    <FtpTransportType>SourceForge</FtpTransportType>
    <FtpForceActiveMode>1</FtpForceActiveMode>
	<UsesSingleAccount>1</UsesSingleAccount>
	<UsesSequenceNumbers>1</UsesSequenceNumbers>
	<Login>ironfist</Login>
	<Password>)Qf6Nmp</Password>
	<FtpDirTesting>testing</FtpDirTesting>
	<FtpDirProduction>incoming</FtpDirProduction>
	<DoEncrypt>1</DoEncrypt>
	<EncryptionOriginator>sergei@kareo.com</EncryptionOriginator>
	<EncryptionRecipient>bfisservice@bfusa.com</EncryptionRecipient>
	<EncryptionPassphrase>the kareo software is best</EncryptionPassphrase>
  </Out>
  <In>
    <FtpServer>www.bfis.com</FtpServer>
    <FtpTransportType>SourceForge</FtpTransportType>
    <FtpForceActiveMode>1</FtpForceActiveMode>
	<UsesSingleAccount>1</UsesSingleAccount>
	<Login>ironfist</Login>
	<Password>)Qf6Nmp</Password>
	<FtpReportsFolder>outgoing</FtpReportsFolder>
	<DoDecrypt>1</DoDecrypt>
	<DecryptionOriginator>bfisservice@bfusa.com</DecryptionOriginator>
	<DecryptionRecipient>sergei@kareo.com</DecryptionRecipient>
	<DecryptionPassphrase>the kareo software is best</DecryptionPassphrase>
  </In>
</Parameters>'
WHERE TransportName = 'Bridgestone FTP'
GO

-- the "ironfist" account is used for single login, so we need internal account IDs to be used for the practice:
USE superbill_0235_dev
UPDATE Practice
SET EStatementsLogin = '0235-1-RJH', EStatementsPassword = 'jg765kjdt6' WHERE PracticeID = 1
GO

-- run C:\svn\Superbill\Software\Data\StoredProcedure\BizclaimsUsefulScripts\patient-statement-password-table-update.sql to sync passwords

