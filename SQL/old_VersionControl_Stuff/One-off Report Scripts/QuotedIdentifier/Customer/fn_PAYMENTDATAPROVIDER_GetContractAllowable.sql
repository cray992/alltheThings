IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  Name = N'fn_PAYMENTDATAPROVIDER_GetContractAllowable')
	DROP FUNCTION fn_PAYMENTDATAPROVIDER_GetContractAllowable
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  FUNCTION dbo.fn_PAYMENTDATAPROVIDER_GetContractAllowable(
	@InsuranceCompanyPlanID int, 
	@ServiceDate datetime,
	@ProcedureCodeDictionaryID int,
	@ProcedureModifier varchar(16),
	@Gender char(1),
	@ServiceLocationID int
)
RETURNS money
AS
BEGIN
	declare @Allowable money
	if @ProcedureModifier='' set @ProcedureModifier=null

	select top 1 @Allowable=Allowable 
	from ContractFeeSchedule, Contract 
	where
		Contract.ContractID=ContractFeeSchedule.ContractID and
		ProcedureCodeDictionaryID=@ProcedureCodeDictionaryID and 
		@ServiceDate between EffectiveStartDate and EffectiveEndDate and
		-- check for contract for payer specific contract
		case	when Contract.ContractType='S' then 1 
			when Contract.ContractType='P' and 
				exists(select * from ContractToInsurancePlan where 
					ContractID=Contract.ContractID and 
					PlanID=@InsuranceCompanyPlanID) then 1 else 0 end = 1 and
		exists (select * from ContractToServiceLocation where ContractID=Contract.ContractID and ServiceLocationID=@ServiceLocationID) and
		(ContractFeeSchedule.Gender=@Gender or ContractFeeSchedule.Gender='B') and
		(IsNull(@ProcedureModifier, '') = IsNull(ContractFeeSchedule.Modifier, '') or (@ProcedureModifier is not null and ContractFeeSchedule.Modifier= @ProcedureModifier))
	order by Contract.ContractType, -- first P, than S
		 ContractFeeSchedule.Modifier desc -- first with value, last - null 		

	if @Allowable is null 
		set @Allowable=0
	return @Allowable
END


GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON 
GO

