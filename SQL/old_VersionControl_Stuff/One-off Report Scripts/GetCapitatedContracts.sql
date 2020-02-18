Insert Into SharedServer.superbill_shared.dbo.Reporting_CapitatedContracts(PracticeName, ContractCPACNt, ContractCnt, DatabaseName)
SELECT  ISNULL(Cap.PracticeName,Prac.PracticeName) AS PracticeName
,       Cap.ContractCapCnt
,       Prac.ContractCnt
,		db_name()
FROM (

SELECT p.Name AS PracticeName,COUNT(ContractId)ContractCapCnt
FROM CONTRACT
INNER JOIN Practice AS p ON Contract.PracticeID = p.PracticeID
WHERE Contract.Capitated=1
GROUP BY P.Name)Cap
RIGHT  JOIN (

SELECT P.Name AS PracticeName,COUNT(ContractId)ContractCnt
FROM CONTRACT
INNER JOIN Practice AS p ON Contract.PracticeID = p.PracticeID
GROUP BY p.Name)Prac ON cap.practiceName=prac.PracticeName
