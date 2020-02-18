IF EXISTS (SELECT * FROM sys.servers WHERE name = 'TRIALDBSERVER')
	EXEC sp_dropserver @server = 'TRIALDBSERVER'

EXEC sp_addlinkedserver   
   @server='TRIALDBSERVER', 
   @srvproduct='',
   @provider='SQLNCLI', 
   @datasrc=@@SERVERNAME

EXEC sp_serveroption 'TRIALDBSERVER', 'RPC', 'ON' 
EXEC sp_serveroption 'TRIALDBSERVER', 'RPC OUT', 'ON' 
