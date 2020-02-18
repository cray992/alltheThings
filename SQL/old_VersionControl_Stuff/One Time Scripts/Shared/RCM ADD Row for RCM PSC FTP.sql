
INSERT INTO SharedServer.Superbill_Shared.dbo.PatientStatementsTransport
([TransportName],[TransportType],[ParametersXml],[Notes])
VALUES (
      'RCM PSC Info Group FTP'
      ,'FTP'
	  ,'<Parameters>    <Out>      <FtpServer>ftp.pscinfogroup.com</FtpServer>      <FtpTransportType>SourceForge</FtpTransportType>      <FtpForceActiveMode>1</FtpForceActiveMode>   <UsesSingleAccount>0</UsesSingleAccount>   <Login>PI102226</Login>   <Password>-s9R]qU/</Password>   <FtpDirTesting>testing</FtpDirTesting>   <FtpDirProduction>incoming</FtpDirProduction>   <DoEncrypt>1</DoEncrypt>   <EncryptionOriginator>sergei@kareo.com</EncryptionOriginator>   <EncryptionRecipient>dataexpress@pscinfogroup.com</EncryptionRecipient>   <EncryptionPassphrase>the kareo software is best</EncryptionPassphrase>    </Out>    <In>      <FtpServer>ftp.pscinfogroup.com</FtpServer>      <FtpTransportType>SourceForge</FtpTransportType>      <FtpForceActiveMode>1</FtpForceActiveMode>   <UsesSingleAccount>0</UsesSingleAccount>   <Login>PI102226</Login>   <Password>-s9R]qU/</Password>   <FtpReportsFolder>outgoing</FtpReportsFolder>   <DoDecrypt>1</DoDecrypt>   <DecryptionOriginator>dataexpress@pscinfogroup.com</DecryptionOriginator>   <DecryptionRecipient>sergei@kareo.com</DecryptionRecipient>   <DecryptionPassphrase>the kareo software is best</DecryptionPassphrase>    </In>  </Parameters>'
      ,NULL)
      