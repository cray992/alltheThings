ALTER TABLE InsurancePolicy ADD CONSTRAINT FK_InsurancePolicy_InsuranceCompanyPlanID
FOREIGN KEY (InsuranceCompanyPlanID) REFERENCES InsuranceCompanyPlan (InsuranceCompanyPlanID)
GO
