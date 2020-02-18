SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

IF EXISTS (
	SELECT * 
	FROM   sysobjects 
	WHERE  Name = N'fn_InsuranceDataProvider_GetPrevInsurancePolicyPrecedence'
)
	DROP FUNCTION dbo.fn_InsuranceDataProvider_GetPrevInsurancePolicyPrecedence
GO
--===========================================================================
-- GET PREV INSURANCE POLICY PRECEDENCE
--===========================================================================
CREATE FUNCTION dbo.fn_InsuranceDataProvider_GetPrevInsurancePolicyPrecedence 
	(@PatientCaseID int,
	 @DateOfService datetime, 
	 @CurrentPrecedence int = 0)
RETURNS INT
AS
BEGIN

	RETURN(

	SELECT	MAX(Precedence) as Precedence
	FROM	InsurancePolicy
	WHERE	PatientCaseID = @PatientCaseID
	AND	Active = 1
	AND	(PolicyStartDate <= @DateOfService OR PolicyStartDate IS NULL)
	AND	(PolicyEndDate >= @DateOfService OR PolicyEndDate IS NULL)
	AND	Precedence < @CurrentPrecedence

	)
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

