IF object_id('dbo.maint_MONTHLY_UPDATE_SCRIPT_NEW') is not null
	DROP PROCEDURE dbo.maint_MONTHLY_UPDATE_SCRIPT_NEW
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[maint_MONTHLY_UPDATE_SCRIPT_NEW]
(
	@CSVPATH VARCHAR(255)
)
AS
BEGIN
	-- ---
	-- create a temporary table for the entire delta
	CREATE TABLE #ZIPCODEDELTATABLE
	(
		ZipCode CHAR(5),
		UpdateKey VARCHAR(10) NOT NULL PRIMARY KEY,
		ActionType CHAR(1),
		RecordType CHAR(1),
		CarrierRouteID CHAR(4),
		StPreDirAbbr CHAR(2),
		StName VARCHAR(28),
		StSuffixAbbr VARCHAR(4),
		StPostDirAbbr CHAR(2),
		AddressPrimaryLowNumber VARCHAR(10),
		AddressPrimaryHighNumber VARCHAR(10),
		AddressPrimaryOddEven CHAR(1),
		BuildingFirmName VARCHAR(40),
		AddressSecondaryAbbr VARCHAR(4),
		AddressSecondaryLowNumber VARCHAR(10),
		AddressSecondaryHighNumber VARCHAR(10),
		AddressSecondaryOddEven CHAR(1),
		Plus4Low CHAR(4),
		Plus4High CHAR(4),
		BaseAlternateCode CHAR(1),
		LACSStatus CHAR(1),
		GovernmentBuilding CHAR(1),
		FinanceNumber VARCHAR(6),
		[State] CHAR(2),
		CountyFIPS CHAR(3),
		CongressionalDistrict CHAR(2),
		MunicipalityKey VARCHAR(6),
		UrbanizationKey VARCHAR(6),
		PreferredLastLineCityStateKey VARCHAR(6),
		ToLatitude DECIMAL(11, 8),
		FromLatitude DECIMAL(11, 8),
		ToLongitude DECIMAL(11, 8),
		FromLongitude DECIMAL(11, 8),
		CensusTract CHAR(6),
		CensusBlock CHAR(4),
		TLID CHAR(10),
		LatLonMultiMatch CHAR(1)
	)

	-- ---
	-- Create a table for delete keys
	CREATE TABLE #ZIPDELETEKEYTABLE
	(
		UpdateKey VARCHAR(10),
		ActionType CHAR(1)
	)

	-- ---
	-- Execute some dynamic sql to pull the .csv file
	DECLARE @SQL varchar(max)
	set @SQL = '
	BULK 
	INSERT #ZIPCODEDELTATABLE
	FROM ''' + @CSVPATH + '''
	WITH
	(
		FIRSTROW = 2,
		FIELDTERMINATOR = '','',
		ROWTERMINATOR = ''\n''
	)
	'
	exec(@SQL)

	-- ---
	-- Extract the delete keys
	INSERT INTO 
		#ZIPDELETEKEYTABLE
	SELECT
		UpdateKey,
		ActionType
	FROM 
		#ZIPCODEDELTATABLE
	WHERE
		ActionType = 'D'
		
	-- ---
	-- Delete each entry that needs deletion
	DELETE [ZIP4].[dbo].[ZIP4]
	FROM [ZIP4].[dbo].[ZIP4] a
		INNER JOIN #ZIPDELETEKEYTABLE b on a.UpdateKey = b.UpdateKey

	-- ---
	-- Add each key that needs to be added
	INSERT INTO [ZIP4].[dbo].[ZIP4]
	(
		ZipCode,
		UpdateKey,
		Action,
		RecordType,
		CarrierRouteID,
		StPreDirAbbr,
		StName,
		StSuffixAbbr,
		StPostDirAbbr,
		AddressPrimaryLowNumber,
		AddressPrimaryHighNumber,
		AddressPrimaryOddEven,
		BuildingFirmName,
		AddressSecondaryAbbr,
		AddressSecondaryLowNumber,
		AddressSecondaryHighNumber,
		AddressSecondaryOddEven,
		Plus4Low,
		Plus4High,
		BaseAlternateCode,
		LACSStatus,
		GovernmentBuilding,
		FinanceNumber,
		[State],
		CountyFIPS,
		CongressionalDistrict,
		MunicipalityKey,
		UrbanizationKey,
		PreferredLastLineCityStateKey,
		ToLatitude,
		FromLatitude,
		ToLongitude,
		FromLongitude,
		CensusTract,
		CensusBlock,
		TLID,
		LatLonMultiMatch
	)
	SELECT
		ZipCode,
		UpdateKey,
		ActionType,
		RecordType,
		CarrierRouteID,
		StPreDirAbbr,
		StName,
		StSuffixAbbr,
		StPostDirAbbr,
		AddressPrimaryLowNumber,
		AddressPrimaryHighNumber,
		AddressPrimaryOddEven,
		BuildingFirmName,
		AddressSecondaryAbbr,
		AddressSecondaryLowNumber,
		AddressSecondaryHighNumber,
		AddressSecondaryOddEven,
		Plus4Low,
		Plus4High,
		BaseAlternateCode,
		LACSStatus,
		GovernmentBuilding,
		FinanceNumber,
		[State],
		CountyFIPS,
		CongressionalDistrict,
		MunicipalityKey,
		UrbanizationKey,
		PreferredLastLineCityStateKey,
		ToLatitude,
		FromLatitude,
		ToLongitude,
		FromLongitude,
		CensusTract,
		CensusBlock,
		TLID,
		LatLonMultiMatch
	FROM #ZIPCODEDELTATABLE
	WHERE
		ActionType = 'A'

	-- ---
	-- Drop the temporary tables
	DROP TABLE #ZIPCODEDELTATABLE
	DROP TABLE #ZIPDELETEKEYTABLE
END
GO
