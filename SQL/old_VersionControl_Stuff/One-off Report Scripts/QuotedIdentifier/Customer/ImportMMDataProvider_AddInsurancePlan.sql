SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'ImportMMDataProvider_AddInsurancePlan'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.ImportMMDataProvider_AddInsurancePlan
GO


--===========================================================================
-- MM -- APA -- ADD INSURANCE PLAN
--===========================================================================
CREATE PROCEDURE ImportMMDataProvider_AddInsurancePlan
	@PlanName VARCHAR(128),
	@AddressLine1 VARCHAR(64),
	@City VARCHAR(32),
	@State VARCHAR(2),
	@ZipCode VARCHAR(9),
	@Phone VARCHAR(10),
	@PhoneExt VARCHAR(10),
	@CoPay MONEY,
	@PracticeID INT
AS
BEGIN
	DECLARE @NewInsuranceCompanyPlanID int;
	DECLARE @CoPayBit bit
	
	--Find out IF the insurance company already exists, IF it does, then
	--just get the id for it
	SET @AddressLine1 = REPLACE(@AddressLine1,'P.O.BOX','P.O. BOX')
	
	SELECT @NewInsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
	FROM dbo.InsuranceCompanyPlan ICP
	WHERE ICP.AddressLine1 = @AddressLine1
		AND LEFT(ICP.ZipCode,5) = LEFT(@ZipCode,5)
		AND (ICP.ReviewCode = 'R' OR ICP.CreatedPracticeID = @PracticeID)
	
	IF @NewInsuranceCompanyPlanID > 0
		GOTO COMPLETE_LABEL
		
	IF @CoPay > 0
		SET @CoPayBit = 1 
	ELSE
		SET @CoPayBit = 0
		
	--Some parameters don't have values
	EXEC @NewInsuranceCompanyPlanID = dbo.InsurancePlanDataProvider_CreateInsurancePlan
		@name = @PlanName,
		@street_1 = @AddressLine1,
		@street_2 = NULL,
		@city = @City,
		@state = @State,
		@country = 'US',
		@zip = @ZipCode,
		@contact_prefix = NULL,
		@contact_first_name = NULL,
		@contact_middle_name = NULL,
		@contact_last_name = NULL,
		@contact_suffix = NULL,
		@phone = @Phone,
		@phone_x = @PhoneExt,
		@fax = NULL,
		@fax_x = NULL,
		@copay_flag = @CoPayBit,
		--@program_code CHAR(1) = 'O',
		--@provider_number_type_id INT = NULL,
		--@group_number_type_id INT = NULL,
		--@local_use_provider_number_type_id INT = NULL,
		--@hcfa_diag_code CHAR(1) = 'C',
		--@hcfa_same_code CHAR(1) = 'D',
		--@review_code CHAR(1) = '',
		--@EClaimsAccepts BIT = 0,
		--@ClearinghousePayerID INT = NULL,
		@notes = NULL,
		@practice_id = @PracticeID
		--,
		--@eclaims_enrollment_status_id INT = NULL,
		--@eclaims_disable BIT = NULL


--	IF NOT EXISTS (SELECT COUNT(*)
--		FROM dbo.PracticeToInsuranceCompanyPlan
--		WHERE PracticeID = @PracticeID
--		AND InsuranceCompanyPlanID = @NewInsuranceCompanyPlanID) = 0
--	BEGIN
--		INSERT dbo.PracticeToInsuranceCompanyPlan(PracticeID, InsuranceCompanyPlanID)
--		VALUES (@PracticeID, @NewInsuranceCompanyPlanID)
--	END
COMPLETE_LABEL:
	
	RETURN @NewInsuranceCompanyPlanID
END

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON 
GO
