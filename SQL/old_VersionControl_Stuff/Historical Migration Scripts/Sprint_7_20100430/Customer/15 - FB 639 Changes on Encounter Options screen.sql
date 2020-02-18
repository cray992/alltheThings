-- create new fields for encounter options (ClaimTypes)

-- **********************************************************************************************
-- Practice
-- **********************************************************************************************

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Practice' AND COLUMN_NAME = 'EOClaimTypes')
BEGIN
	ALTER TABLE dbo.Practice ADD EOClaimTypes tinyint not null
	CONSTRAINT [CK_Practice_EOClaimTypes] CHECK (EOClaimTypes > 0)
	CONSTRAINT [DF_Practice_EOClaimTypes] DEFAULT(1) WITH VALUES
	
	ALTER TABLE dbo.Practice ADD EOClaimTypeDefaultID int not null
	CONSTRAINT [DF_Practice_EOClaimTypeDefaultID] DEFAULT(0) WITH VALUES
	
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Practice' AND COLUMN_NAME = 'EOShowAllEncounters')
BEGIN
	if db_name() like 'superbill_1266_%'
	begin
		-- 1266 is the only customer who wants to default to not show all
		ALTER TABLE dbo.Practice ADD EOShowAllEncounters bit not null
		CONSTRAINT [DF_Practice_EOShowAllEncounters] DEFAULT(0) WITH VALUES
	end
	else
	begin
		ALTER TABLE dbo.Practice ADD EOShowAllEncounters bit not null
		CONSTRAINT [DF_Practice_EOShowAllEncounters] DEFAULT(1) WITH VALUES	
	end
END