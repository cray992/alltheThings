-- RVU related changes

alter table ContractFeeSchedule add PracticeRVU decimal(18, 3) not null default 0
GO
alter table ContractFeeSchedule add MalpracticeRVU decimal(18, 3) not null default 0
GO

update ContractFeeSchedule set RVU=0 where RVU is NULL
alter table ContractFeeSchedule alter column RVU decimal(18, 3) not null
GO


