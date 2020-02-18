IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'GeneralDataProvider_GetEditionTypes'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.GeneralDataProvider_GetEditionTypes
GO

IF EXISTS (
	SELECT	*
	FROM	sys.foreign_keys
	WHERE	Name = 'FK_Practice_EditionType'
)
ALTER TABLE dbo.Practice
DROP CONSTRAINT FK_Practice_EditionType
GO

IF EXISTS(SELECT * FROM sys.tables AS t WHERE name='EditionType')
BEGIN
EXEC sp_rename 'EditionType', 'obs_Editiontype'
END
GO
