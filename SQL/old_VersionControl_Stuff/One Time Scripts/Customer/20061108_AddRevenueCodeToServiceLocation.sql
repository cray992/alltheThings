-- add new field for UB-92
ALTER TABLE ServiceLocation ADD RevenueCode VARCHAR(4) DEFAULT '0521'
GO

update ServiceLocation set RevenueCode='0521'
