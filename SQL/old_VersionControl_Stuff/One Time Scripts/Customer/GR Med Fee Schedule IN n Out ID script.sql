DECLARE @PM TABLE(ProcedureCode VARCHAR(16), Modifier VARCHAR(10), Items INT)
INSERT @PM
SELECT ProcedureCode, Modifier, COUNT(ProcedureCode) Items
FROM CF_FrontLine$
WHERE Modifier IS NOT NULL
GROUP BY ProcedureCode, Modifier
ORDER BY COUNT(ProcedureCode) DESC

DECLARE @P TABLE(ProcedureCode VARCHAR(16), Items INT)
INSERT @P
SELECT ProcedureCode, COUNT(ProcedureCode) Items
FROM CF_FrontLine$
WHERE Modifier IS NULL
GROUP BY ProcedureCode
ORDER BY COUNT(ProcedureCode) DESC

UPDATE CF SET CID=0
FROM CF_FrontLine$ CF INNER JOIN @PM PM
ON CF.ProcedureCode=PM.ProcedureCode
WHERE CF.Modifier IS NOT NULL AND Items=1

UPDATE CF SET CID=0
FROM CF_FrontLine$ CF INNER JOIN @P P
ON CF.ProcedureCode=P.ProcedureCode
WHERE CF.Modifier IS NULL AND Items=1

DECLARE @PMMin TABLE(ProcedureCode VARCHAR(16), MinID INT)
INSERT @PMMin
SELECT CF.ProcedureCode, MIN(CID) MinID
FROM CF_FrontLine$ CF INNER JOIN @PM PM
ON CF.ProcedureCode=PM.ProcedureCode
WHERE CF.Modifier IS NOT NULL AND Items=2
GROUP BY CF.ProcedureCode

DECLARE @PMMax TABLE(ProcedureCode VARCHAR(16), MaxID INT)
INSERT @PMMax
SELECT CF.ProcedureCode, MAX(CID) MaxID
FROM CF_FrontLine$ CF INNER JOIN @PM PM
ON CF.ProcedureCode=PM.ProcedureCode
WHERE CF.Modifier IS NOT NULL AND Items=2
GROUP BY CF.ProcedureCode

UPDATE CF SET CID=1
FROM CF_FrontLine$ CF INNER JOIN @PMMin P
ON CF.CID=P.MinID

UPDATE CF SET CID=2
FROM CF_FrontLine$ CF INNER JOIN @PMMax P
ON CF.CID=P.MaxID

DECLARE @PMin TABLE(ProcedureCode VARCHAR(16), MinID INT)
INSERT @PMin
SELECT CF.ProcedureCode, MIN(CID) MinID
FROM CF_FrontLine$ CF INNER JOIN @P P
ON CF.ProcedureCode=P.ProcedureCode
WHERE CF.Modifier IS NULL AND Items=2
GROUP BY CF.ProcedureCode

DECLARE @PMax TABLE(ProcedureCode VARCHAR(16), MaxID INT)
INSERT @PMax
SELECT CF.ProcedureCode, MAX(CID) MaxID
FROM CF_FrontLine$ CF INNER JOIN @P P
ON CF.ProcedureCode=P.ProcedureCode
WHERE CF.Modifier IS NULL AND Items=2
GROUP BY CF.ProcedureCode

UPDATE CF SET CID=1
FROM CF_FrontLine$ CF INNER JOIN @PMin P
ON CF.CID=P.MinID

UPDATE CF SET CID=2
FROM CF_FrontLine$ CF INNER JOIN @PMax P
ON CF.CID=P.MaxID

-- SELECT * FROM CF_Phillips$
-- WHERE ProcedureCode='70015'
