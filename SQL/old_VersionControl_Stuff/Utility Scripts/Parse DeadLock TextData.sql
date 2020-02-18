
/*

-	New Trace
	o	Blank Template
	o	Save to Table (remember Table name)
	o	Select Events Selection tab
		- Locks -> Deadlock graph
	o	Run... for a week or whatever.

- Repoint this script to the table that you're using. 
- Run this script to review the dead lock.

*/


DECLARE @DL TABLE(DeadID INT IDENTITY(1,1), DLXML XML)
INSERT @DL(DLXML)
SELECT TextData
FROM deadlocks_sprint15
WHERE TextData IS NOT NULL
--WHERE RowNumber=3

SELECT CONVERT(XML,CAST(TextData AS VARCHAR(MAX)))
FROM deadlocks_sprint15
WHERE TextData IS NOT NULL

DECLARE @Victim TABLE(DeadID INT, TransTime VARCHAR(128), CurrentDB INT, SPID INT, ProcName VARCHAR(128), Line INT, TransType VARCHAR(50), WaitResource VARCHAR(128), LockMode VARCHAR(4), 
					  IsolationLevel VARCHAR(128), Priority INT, TransCount INT, ClientApp VARCHAR(128), HostName VARCHAR(128), LoginName VARCHAR(128))
INSERT @Victim
SELECT DeadID,
DLP.Process.value('@lasttranstarted','VARCHAR(128)') TranTime,
DLP.Process.value('@currentdb','INT') CurrentDb,
DLP.Process.value('@spid','INT') SPID,
DLP.Process.value('(./executionStack/frame/@procname)[1]','VARCHAR(128)') ProcName, 
DLP.Process.value('(./executionStack/frame/@line)[1]','INT') Line,
DLP.Process.value('@transactionname','VARCHAR(50)') TransType,
DLP.Process.value('@waitresource','VARCHAR(128)') WaitResource,
DLP.Process.value('@lockMode','VARCHAR(4)') LockMode,
DLP.Process.value('@isolationlevel','VARCHAR(128)') IsolationLevel,
DLP.Process.value('@priority','INT') Priority,
DLP.Process.value('@transcount','INT') TransCount,
DLP.Process.value('@clientapp','VARCHAR(128)') ClientApp,
DLP.Process.value('@hostname','VARCHAR(128)') HostName,
DLP.Process.value('@loginname','VARCHAR(128)') LoginName
FROM @DL CROSS APPLY DLXML.nodes('/deadlock-list/deadlock/process-list/process') AS DLP(Process)
WHERE DLP.Process.value('@id','VARCHAR(50)')=DLXML.value('(/deadlock-list/deadlock/@victim)[1]','VARCHAR(50)') AND
DLP.Process.value('(./executionStack/frame/@procname)[1]','VARCHAR(500)')<>'adhoc'

DECLARE @ExecProcess TABLE(DeadID INT, TransTime VARCHAR(128), CurrentDB INT, SPID INT, ProcName VARCHAR(128), Line INT, TransType VARCHAR(50), WaitResource VARCHAR(128), LockMode VARCHAR(4), 
					  IsolationLevel VARCHAR(128), Priority INT, TransCount INT, ClientApp VARCHAR(128), HostName VARCHAR(128), LoginName VARCHAR(128))
INSERT @ExecProcess
SELECT DeadID,
DLP.Process.value('@lasttranstarted','VARCHAR(128)') TranTime,
DLP.Process.value('@currentdb','INT') CurrentDb,
DLP.Process.value('@spid','INT') SPID,
DLP.Process.value('(./executionStack/frame/@procname)[1]','VARCHAR(128)') ProcName, 
DLP.Process.value('(./executionStack/frame/@line)[1]','INT') Line,
DLP.Process.value('@transactionname','VARCHAR(50)') TransType,
DLP.Process.value('@waitresource','VARCHAR(128)') WaitResource,
DLP.Process.value('@lockMode','VARCHAR(4)') LockMode,
DLP.Process.value('@isolationlevel','VARCHAR(128)') IsolationLevel,
DLP.Process.value('@priority','INT') Priority,
DLP.Process.value('@transcount','INT') TransCount,
DLP.Process.value('@clientapp','VARCHAR(128)') ClientApp,
DLP.Process.value('@hostname','VARCHAR(128)') HostName,
DLP.Process.value('@loginname','VARCHAR(128)') LoginName
FROM @DL CROSS APPLY DLXML.nodes('/deadlock-list/deadlock/process-list/process') AS DLP(Process)
WHERE DLP.Process.value('@id','VARCHAR(50)')<>DLXML.value('(/deadlock-list/deadlock/@victim)[1]','VARCHAR(50)') AND
DLP.Process.value('(./executionStack/frame/@procname)[1]','VARCHAR(500)')<>'adhoc' AND
DLP.Process.exist('@transactionname')=1

SELECT V.TransTime, V.DeadID, V.ProcName, V.Line, V.TransType, V.WaitResource, V.LockMode, E.ProcName EProcName, E.Line ELine, E.TransType ETransType, E.WaitResource EWaitResource, E.LockMode ELockMode
FROM @Victim V LEFT JOIN @ExecProcess E
ON V.DeadID=E.DeadID AND V.SPID<>E.SPID AND V.LockMode<>E.LockMode
ORDER BY V.TransTime, V.ProcName, E.ProcName

--SELECT DLXML
--FROM @DL
--WHERE DeadID=585