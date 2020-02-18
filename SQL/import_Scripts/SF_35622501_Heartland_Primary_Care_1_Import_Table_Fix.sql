use superbill_4267_dev
--use superbill_4267_prod
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'provider_Fname' 
	AND Object_ID = Object_ID(N'_import_1_1_HPC_export2012_csvformat'))
BEGIN
	ALTER TABLE [_import_1_1_HPC_export2012_csvformat] ADD provider_Fname VARCHAR(64) NULL
END

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'provider_Lname' 
	AND Object_ID = Object_ID(N'_import_1_1_HPC_export2012_csvformat'))
BEGIN
	ALTER TABLE [_import_1_1_HPC_export2012_csvformat] ADD provider_Lname VARCHAR(64) NULL
END

-- Add a column for the doctorid
IF NOT EXISTS(select * from sys.columns where Name = N'renderingDoctorID' 
	AND Object_ID = Object_ID(N'_import_1_1_HPC_export2012_csvformat'))
BEGIN
    -- Column doesn't exist
    ALTER TABLE [_import_1_1_HPC_export2012_csvformat] ADD renderingDoctorID INT NULL
END


UPDATE dbo.[_import_1_1_HPC_export2012_csvformat]
      SET 
		provider_Lname = LastName,
		provider_Fname = FirstName
  FROM (
         SELECT ID, FirstName,
				SUBSTRING(FirstNameStart,1,ISNULL(NULLIF(CHARINDEX('   ',FirstNameStart),0),254))  AS LastName, 
                REPLACE(LTRIM(SUBSTRING(FirstNameStart,NULLIF(CHARINDEX(' ',FirstNameStart),0),254)),' ','') AS MiStart
           FROM (
                 SELECT ID, SUBSTRING(rendering_provider,1,CHARINDEX(' ',rendering_provider)) AS FirstName,
                        LTRIM(SUBSTRING(rendering_provider,CHARINDEX(' ',rendering_provider)+1,254)) AS FirstNameStart
                   FROM dbo.[_import_1_1_HPC_export2012_csvformat]
                ) dtStart
        ) dtFullName
   WHERE dtFullName.ID = dbo.[_import_1_1_HPC_export2012_csvformat].ID AND
	dbo.[_import_1_1_HPC_export2012_csvformat].provider_Lname is NULL 


UPDATE 
	dbo.[_import_1_1_HPC_export2012_csvformat] 
SET	
	renderingDoctorID = (
		SELECT 
			DoctorID
		FROM	
			dbo.Doctor
		WHERE
			(VendorImportID IS NULL OR VendorImportID = 1) AND
			[External]= 0 AND
			CHARINDEX(UPPER(LTRIM(FirstName)), UPPER(provider_Fname)) > 0 AND
			CHARINDEX(UPPER(LTRIM(LastName)), UPPER(provider_Lname)) > 0
		)
WHERE dbo.[_import_1_1_HPC_export2012_csvformat].renderingDoctorID IS NULL 
