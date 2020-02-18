-- script for enabling electronic submission in batch mode

declare
	@PracticeID int,
	@PayerID varchar(20),	-- electronic payer ID for example BC001
	@ClrHse int				-- clearing house ID

set @PracticeID=4
set @PayerId='BC001'
set @ClrHse=1			-- Medavant

insert into PracticeToInsuranceCompany (PracticeID, InsuranceCompanyID, EclaimsEnrollmentStatusID, AcceptAssignment)
select @PracticeID, IC.InsuranceCompanyID, 2, 1
from InsuranceCompany IC
where IC.ClearingHousePayerID in (select ClearingHousePayerID from SHAREDSERVER.Superbill_Shared.dbo.ClearinghousePayersList where  PayerNumber=@PayerID and @ClrHse=1)
and not exists (select * from PracticeToInsuranceCompany where PracticeID=@PracticeID and InsuranceCompanyID=IC.InsuranceCompanyID)
