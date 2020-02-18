-- Get Edition Type
DECLARE @EditionTypeID INT
SELECT @EditionTypeID=(SELECT EditionTypeID FROM dbo.EditionType AS ET WHERE EditionTypeCaption='Flex Plan')

IF (SELECT COUNT(*) FROM dbo.EditionTypeSoftwareFeature WHERE EditionTypeID = @EditionTypeID) = 0
BEGIN
	INSERT INTO EditionTypeSoftwareFeature
	SELECT @EditionTypeID AS EditionTypeID, SoftwareFeatureID AS SoftwareFeatureID, 1 AS SoftwareFeatureUsageID
	FROM dbo.SoftwareFeature
END

