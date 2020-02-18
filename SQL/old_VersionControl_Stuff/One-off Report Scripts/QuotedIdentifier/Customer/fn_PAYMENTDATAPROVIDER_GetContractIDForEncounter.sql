IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  Name = N'fn_PAYMENTDATAPROVIDER_GetContractIDForEncounter')
	DROP FUNCTION dbo.fn_PAYMENTDATAPROVIDER_GetContractIDForEncounter
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION dbo.fn_PAYMENTDATAPROVIDER_GetContractIDForEncounter(
	@EncounterID int
)

RETURNS INT
AS
BEGIN
	DECLARE 
		@ContractID INT,
		@InsuranceCompanyPlanID INT,
		@PatientCaseID INT,
		@DateOfService DATETIME,
		@ServiceLocationID INT,
		@DoctorID INT

	SET @ContractID=null
	
	SELECT	
			@PatientCaseID=PatientCaseID, 
			@DateOfService=DateOfService,
			@ServiceLocationID=LocationID,
			@DoctorID=DoctorID 
	FROM Encounter WHERE EncounterID=@EncounterID

	IF @PatientCaseID IS NOT NULL
	BEGIN

		SELECT @InsuranceCompanyPlanID=InsuranceCompanyPlanID FROM InsurancePolicy 
		WHERE PatientCaseID=@PatientCaseID 
			AND Precedence=dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence (@PatientCaseID, @DateOfService, 0)

	
		SELECT TOP 1 @ContractID=[Contract].ContractID FROM [CONTRACT]
		WHERE
			@DateOfService BETWEEN EffectiveStartDate AND EffectiveEndDate 
			AND CASE	WHEN Contract.ContractType='S' THEN 1 
						WHEN Contract.ContractType='P' AND 
						EXISTS(SELECT * FROM ContractToInsurancePlan WHERE ContractID=[Contract].ContractID and PlanID=@InsuranceCompanyPlanID) THEN 1 ELSE 0 END = 1 

			AND EXISTS (SELECT * FROM ContractToServiceLocation WHERE ContractID=[Contract].ContractID and ServiceLocationID=@ServiceLocationID)
			AND EXISTS (SELECT * FROM ContractToDoctor WHERE ContractID=[Contract].ContractID and DoctorID=@DoctorID)
		ORDER BY [Contract].ContractType -- first P, than S
	END

	RETURN @ContractID
END


GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON 
GO