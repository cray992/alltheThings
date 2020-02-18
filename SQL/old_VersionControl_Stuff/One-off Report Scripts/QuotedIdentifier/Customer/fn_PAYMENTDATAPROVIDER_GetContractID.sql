IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  Name = N'fn_PAYMENTDATAPROVIDER_GetContractID')
	DROP FUNCTION fn_PAYMENTDATAPROVIDER_GetContractID
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  FUNCTION dbo.fn_PAYMENTDATAPROVIDER_GetContractID(
	@InsuranceCompanyPlanID int, 
	@ServiceDate datetime,
	@ServiceLocationID int
)
RETURNS int
AS
BEGIN
	declare @ContractID int

	select top 1 @ContractID=Contract.ContractID 
	from ContractFeeSchedule, Contract 
	where
		Contract.ContractID=ContractFeeSchedule.ContractID and
		@ServiceDate between EffectiveStartDate and EffectiveEndDate and
		case	when Contract.ContractType='S' then 1 
			when Contract.ContractType='P' and 
				exists(select * from ContractToInsurancePlan where ContractID=Contract.ContractID and PlanID=@InsuranceCompanyPlanID) then 1 else 0 end = 1 and
		exists (select * from ContractToServiceLocation where ContractID=Contract.ContractID and ServiceLocationID=@ServiceLocationID)
	order by Contract.ContractType -- first P, than S

	return @ContractID
END


GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON 
GO

