alter table CustomerPracticesAggregation add
	AddedProvider bit not null default 0
GO

alter table CustomerPracticesAggregation add
	AddedProviderDT datetime null
GO

alter table CustomerPracticesAggregation add
	SubmittedClaim bit not null default 0
GO

alter table CustomerPracticesAggregation add
	SubmittedClaimDT datetime null
GO


-- create a new table to have 
create table CustomerPracticesAggregationProcess (
	CustomerPracticesAggregationProcessID uniqueidentifier not null default NewID(),
	CustomerID int)
GO
