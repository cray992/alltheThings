-- add time zone hack flag
alter table dbo.customer add EnforceTimeZone bit default 0 not null
