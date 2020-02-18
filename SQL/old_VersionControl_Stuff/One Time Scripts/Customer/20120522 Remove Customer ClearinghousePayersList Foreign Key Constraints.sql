IF EXISTS (SELECT * 
  FROM sys.foreign_keys 
   WHERE object_id = OBJECT_ID(N'dbo.FK_InsuranceCompany_ClearinghousePayersList')
   AND parent_object_id = OBJECT_ID(N'dbo.InsuranceCompany')
)
  ALTER TABLE dbo.InsuranceCompany DROP CONSTRAINT [FK_InsuranceCompany_ClearinghousePayersList]