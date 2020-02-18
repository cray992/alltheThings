-- Give Sames Access as Max
--Then Restrict Usage from there
INSERT INTO dbo.EditionTypeSoftwareFeature
        ( EditionTypeID ,
          SoftwareFeatureID ,
          SoftwareFeatureUsageID
        )
SELECT et.EditionTypeId, SoftwareFeatureID,
CASE
WHEN SoftwareFeatureID = 6 AND ET.EditionTypeID IN ( 8,9) THEN 3 --Restrict Documents
WHEN SoftwareFeatureID = 2 AND ET.EditionTypeID IN ( 8,9,10) THEN 3 --Restrict Code Scrubbing
WHEN SoftwareFeatureID = 3 AND ET.EditionTypeID IN ( 8,9) THEN 3 --Restrict Electronic Claims
WHEN SoftwareFeatureID = 5 AND ET.EditionTypeID IN ( 8,9) THEN 3 --Restrict PatientStatements
WHEN SoftwareFeatureID = 7 AND ET.EditionTypeID IN ( 8,9) THEN 3 --Restrict Faxing
ELSE SoftwareFeatureUsageID END AS SoftwareFeatureUsageID
FROM
dbo.EditionType AS ET,dbo.EditionTypeSoftwareFeature AS ETSF
WHERE ET.EditionTypeId IN ( 8,9,10,11) -- Quest
AND ETSF.EditionTypeID = 7 -- Copy from Max then we will restrict


INSERT INTO dbo.SoftwareFeature
        ( FeatureName ,
          FeatureValue ,
          Description ,
          UpsellUrl
        )
VALUES  ( 'Encounters' , -- FeatureName - varchar(100)
          'Encounters' , -- FeatureValue - varchar(100)
          NULL , -- Description - varchar(1024)
          NULL  -- UpsellUrl - varchar(1024)
        )
        
        DECLARE @EncountersFeatureID INT
        SELECT @EncountersFeatureID = @@IDENTITY
        
        INSERT INTO dbo.EditionTypeSoftwareFeature
                ( EditionTypeID ,
                  SoftwareFeatureID ,
                  SoftwareFeatureUsageID
                )
		SELECT
		EditionTypeID, @EncountersFeatureID, CASE WHEN ET.EditionTypeId IN ( 8,9) THEN 3 ELSE 1 END AS SoftwareFeatureUsageID--Restrict Level 1,Level2
        FROM dbo.EditionType AS ET