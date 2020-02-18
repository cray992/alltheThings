-- Only continue if the constraint doesn't exist
IF  NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_InsurancePolicy_InsuranceCompanyPlan]') AND parent_object_id = OBJECT_ID(N'[dbo].[InsurancePolicy]'))
BEGIN
	-- Make a backup copy of the insurance policy table
	IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_20100629_InsurancePolicy]') AND type in (N'U'))
	BEGIN
		select * 
		into _20100629_InsurancePolicy
		from InsurancePolicy
	END

	-- Delete invalid data
	delete from InsurancePolicy
	where InsurancePolicyID in
	(select InsurancePolicyID
	from InsurancePolicy 
	where InsuranceCompanyPlanID not in 
	(select InsuranceCompanyPlanID from InsuranceCompanyPlan))

	-- Add constraint
	ALTER TABLE [dbo].[InsurancePolicy]  WITH CHECK ADD  CONSTRAINT [FK_InsurancePolicy_InsuranceCompanyPlan] FOREIGN KEY([InsuranceCompanyPlanID])
	REFERENCES [dbo].[InsuranceCompanyPlan] ([InsuranceCompanyPlanID])

	ALTER TABLE [dbo].[InsurancePolicy] CHECK CONSTRAINT [FK_InsurancePolicy_InsuranceCompanyPlan]
END

