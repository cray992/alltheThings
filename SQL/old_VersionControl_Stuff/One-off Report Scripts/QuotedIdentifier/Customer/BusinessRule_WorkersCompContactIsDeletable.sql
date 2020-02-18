SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BusinessRule_WorkersCompContactIsDeletable]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[BusinessRule_WorkersCompContactIsDeletable]
GO

--===========================================================================
-- WORKERS COMP CONTACT IS DELETABLE
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_WorkersCompContactIsDeletable (@WorkersCompContactInfoID int)
RETURNS BIT
AS
BEGIN
	--Not deletable if patient cases are associated with it.
	IF EXISTS (
		SELECT	TOP 1 *
		FROM	PatientCase PC
		WHERE	PC.WorkersCompContactInfoID = @WorkersCompContactInfoID
	)
		RETURN 0

	RETURN 1
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

