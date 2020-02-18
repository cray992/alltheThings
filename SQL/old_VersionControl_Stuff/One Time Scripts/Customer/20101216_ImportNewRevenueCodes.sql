IF DB_NAME()='superbill_4525_prod'	-- for this customer codes already imported
RETURN

	-- create Revenue Categories
	INSERT INTO dbo.RevenueCodeCategory
	        ( Name, Description, Code )
	VALUES  ( '', -- Name - varchar(255)
	          NULL, -- Description - varchar(255)
	          '00'  -- Code - varchar(4)
	          )	

	INSERT INTO dbo.RevenueCodeCategory
	        ( Name, Description, Code )
	VALUES  ( '', -- Name - varchar(255)
	          NULL, -- Description - varchar(255)
	          '02'  -- Code - varchar(4)
	          )	

	INSERT INTO dbo.RevenueCodeCategory
	        ( Name, Description, Code )
	VALUES  ( '', -- Name - varchar(255)
	          NULL, -- Description - varchar(255)
	          '10'  -- Code - varchar(4)
	          )	

	INSERT INTO dbo.RevenueCodeCategory
	        ( Name, Description, Code )
	VALUES  ( '', -- Name - varchar(255)
	          NULL, -- Description - varchar(255)
	          '100'  -- Code - varchar(4)
	          )	


	INSERT INTO dbo.RevenueCodeCategory
	        ( Name, Description, Code )
	VALUES  ( '', -- Name - varchar(255)
	          NULL, -- Description - varchar(255)
	          '210'  -- Code - varchar(4)
	          )	

	INSERT INTO dbo.RevenueCodeCategory
	        ( Name, Description, Code )
	VALUES  ( '', -- Name - varchar(255)
	          NULL, -- Description - varchar(255)
	          '310'  -- Code - varchar(4)
	          )	
	          
	INSERT INTO dbo.RevenueCodeCategory
	        ( Name, Description, Code )
	VALUES  ( '', -- Name - varchar(255)
	          NULL, -- Description - varchar(255)
	          '68'  -- Code - varchar(4)
	          )	

	INSERT INTO dbo.RevenueCodeCategory
	        ( Name, Description, Code )
	VALUES  ( '', -- Name - varchar(255)
	          NULL, -- Description - varchar(255)
	          '78'  -- Code - varchar(4)
	          )	

	INSERT INTO dbo.RevenueCodeCategory
	        ( Name, Description, Code )
	VALUES  ( '', -- Name - varchar(255)
	          NULL, -- Description - varchar(255)
	          '88'  -- Code - varchar(4)
	          )	


insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('001', 'Total Charge', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('022', 'HIPPS', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('023', 'HIPPS', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('024', 'HIPPS', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('100', 'All Inclusive Rate', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('101', 'All Inclusive Rate', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('220', 'Special charges', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('241', 'Basic', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('242', 'Comprehensive', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('243', 'Specialty', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('609', 'Other oxygen', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('614', 'Magnetic Resonance Tech. (MRT): MRI - Other', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('615', 'Magnetic Resonance Tech. (MRT): MRA - Head and Neck', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('616', 'Magnetic Resonance Tech. (MRT): MRA - Lower Ext', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('618', 'Magnetic Resonance Tech. (MRT): MRA - Other', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('637', 'Drugs Require Specific ID: Self admin drugs (insulin admin in emergency-diabetes coma)', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('658', 'Hospice Room & Board-Nursing facility', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('681', 'Trauma Response: Level I', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('682', 'Trauma Response: Level II', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('683', 'Trauma Response: Level III', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('684', 'Trauma Response: Level IV', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('689', 'Trauma Response: Other', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('780', 'Telemedicine', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('789', 'Other telemedicine', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('880', 'Miscellaneous Dialysis', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('881', 'Miscellaneous Dialysis: Ultrafiltration', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('882', 'Home dialysis aid visit', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('889', 'Miscellaneous Dialysis: Other misc dialysis', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('905', 'Psychiatric/Psychological Trt: Intensive Outpatient serv-sych', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('906', 'Psychiatric/Psychological Trt: Intensive out serv - chem dep', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('907', 'Psychiatric/Psychological Trt: Comm behavioral program', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('913', 'Psychiatric/Psychological Svcs: Partial Hosp - Intensive', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('1000', 'Behavioral health accomodations', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('1001', 'Residential treatment-psychiatric', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('1002', 'residential treatment-chemical dependency', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('1003', 'Supervised living', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('1004', 'halfway house', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('1005', 'group home', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('2100', 'Alternative therapy services', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('2101', 'acupuncture', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('2102', 'acupressure', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('2103', 'massage', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('2104', 'reflexology', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('2105', 'biofeedback', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('2106', 'hypnosis', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('2109', 'another alternative therapy services', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('3101', 'Adult day care, Medical and social, hourly', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('3102', 'Adult day care, social, hourly', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('3103', 'Adult day care, medical and social, daily', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('3104', 'Adult day care, social, daily', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('3105', 'Adult foster care, daily', 1, 0)
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, HCPCS) values ('3109', 'Other adult care', 1, 0)


UPDATE dbo.RevenueCode 
	SET RevenueCategoryID=RCA.RevenueCodeCategoryID
FROM RevenueCode RC
	JOIN dbo.RevenueCodeCategory RCA ON RCA.Code=SUBSTRING(RC.Code, 1, CASE LEN(RC.Code) WHEN 3 THEN 2 ELSE 3 end)
WHERE RC.RevenueCategoryID IS NULL

if exists(select * from sys.procedures where name='EncounterDataProvider_GetRevenueCodes')
	drop procedure dbo.EncounterDataProvider_GetRevenueCodes
GO

create procedure dbo.EncounterDataProvider_GetRevenueCodes
as
begin
	select 
		RevenueCodeID, 
		RC.Code, 
		--SubcategoryDefinition, 
		RCC.Name+CASE RCC.Name WHEN '' THEN '' else ': ' END + StandardAbbrevation StandardAbbrevation
		--, 
		--RevenueCodeUnitID, 
		--HCPCS, 
		--RevenueCategoryID 
	from dbo.RevenueCode RC
		join RevenueCodeCategory RCC on RCC.RevenueCodeCategoryID=RC.RevenueCategoryID
	order by CAST(RC.Code AS INT)
end
GO
