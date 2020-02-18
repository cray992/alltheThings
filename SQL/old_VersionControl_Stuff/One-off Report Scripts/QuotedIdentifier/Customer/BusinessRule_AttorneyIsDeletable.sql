SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BusinessRule_AttorneyIsDeletable]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[BusinessRule_AttorneyIsDeletable]
GO

--===========================================================================
-- WORKERS COMP CONTACT IS DELETABLE
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_AttorneyIsDeletable (@AttorneyID int)
RETURNS BIT
AS
BEGIN
	--Not deletable if patient cases are associated with it.
	IF EXISTS (
		SELECT	*
		FROM	PatientCaseToAttorney PCA
		WHERE	PCA.AttorneyID = @AttorneyID
	)
		RETURN 0

	RETURN 1
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

