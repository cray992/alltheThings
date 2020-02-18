UPDATE PMD
SET PMD.TypeOfServiceCode = 7
FROM dbo.ProcedureMacroDetail AS PMD
WHERE PMD.ProcedureMacroID IN (SELECT ProcedureMacroID FROM dbo.ProcedureMacro AS PM WHERE Name LIKE '%-AA' AND Active = 1)