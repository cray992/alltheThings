IF NOT EXISTS(SELECT * FROM sys.columns 
            WHERE Name = N'SyncWithEHR' and Object_ID = Object_ID(N'InsurancePolicy'))    
BEGIN
	ALTER TABLE InsurancePolicy
	ADD SyncWithEHR bit NOT NULL
	DEFAULT 0
END

IF NOT EXISTS(SELECT * FROM sys.columns 
            WHERE Name = N'InsurancePolicyGuid' and Object_ID = Object_ID(N'InsurancePolicy'))    
BEGIN
	ALTER TABLE InsurancePolicy
	ADD InsurancePolicyGuid UNIQUEIDENTIFIER NOT NULL
	DEFAULT NewID()
END

IF NOT EXISTS(SELECT * FROM sys.indexes AS i WHERE i.name='UX_InsurancePolicy_InsurancePolicyGuid')
CREATE UNIQUE NONCLUSTERED INDEX [UX_InsurancePolicy_InsurancePolicyGuid] ON [dbo].[InsurancePolicy] 
(
	[InsurancePolicyGuid] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO