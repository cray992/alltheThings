BEGIN TRAN

INSERT INTO dbo.ProcedureModifier
        ( ProcedureModifierCode ,
          ModifierName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT
		modifier, 
		LEFT([long description], 250),
		GETDATE(), 
		0, 
		GETDATE(), 
		0
FROM proceduremodifiers2014
WHERE modifier NOT IN (SELECT proceduremodifiercode FROM dbo.ProcedureModifier AS PM)

ROLLBACK TRAN
