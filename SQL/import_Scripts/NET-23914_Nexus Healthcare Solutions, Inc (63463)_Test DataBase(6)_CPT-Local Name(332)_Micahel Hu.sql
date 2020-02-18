USE superbill_63463_dev
GO
UPDATE d SET
d.OfficialDescription = cpt.description
--SELECT *
FROM dbo.ProcedureCodeDictionary d
INNER JOIN dbo._import_332_6_CPT cpt ON
cpt.cptcode = d.ProcedureCode

INSERT INTO dbo.ProcedureCodeCategory
(
    ProcedureCodeCategoryName,
    Description,
    Notes,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID
)
SELECT DISTINCT 
    a.department,        -- ProcedureCodeCategoryName - varchar(128)
    null,        -- Description - varchar(500)
    null,        -- Notes - text
    null, -- CreatedDate - datetime
    null,         -- CreatedUserID - int
    null, -- ModifiedDate - datetime
    null          -- ModifiedUserID - int
FROM dbo._import_332_6_CPT a 
	LEFT JOIN dbo.ProcedureCodeCategory b ON 
		b.ProcedureCodeCategoryName = a.department
WHERE b.ProcedureCodeCategoryName IS NULL AND 
		a.department<>''

--SELECT * FROM dbo.ProcedureCodeCategory

--SELECT DISTINCT department FROM dbo._import_332_6_CPT

