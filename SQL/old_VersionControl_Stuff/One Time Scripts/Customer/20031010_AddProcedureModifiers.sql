IF NOT EXISTS (
	SELECT	*
	FROM	ProcedureModifier
	WHERE	ProcedureModifierCode = 'GP'
)
	INSERT	ProcedureModifier (ProcedureModifierCode, ModifierName)
	VALUES	('GP', 'Physical Therapy Services')


IF NOT EXISTS (
	SELECT	*
	FROM	ProcedureModifier
	WHERE	ProcedureModifierCode = 'LT'
)
	INSERT	ProcedureModifier (ProcedureModifierCode, ModifierName)
	VALUES	('LT', 'Left-Sided Procedure')


IF NOT EXISTS (
	SELECT	*
	FROM	ProcedureModifier
	WHERE	ProcedureModifierCode = 'RT'
)
	INSERT	ProcedureModifier (ProcedureModifierCode, ModifierName)
	VALUES	('RT', 'Right-Sided Procedure')


