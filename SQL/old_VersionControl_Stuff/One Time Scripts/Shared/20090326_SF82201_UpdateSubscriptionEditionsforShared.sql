-- SF 82201 - Create new EditionType and EditionTypeSoftwareFeature for Max plan

-- Update existing editions
UPDATE	EditionType SET EditionTypeCaption = 'Complete' WHERE EditionTypeID = 1
UPDATE	EditionType SET EditionTypeCaption = 'Plus' WHERE EditionTypeID = 2

-- Add new edition
INSERT INTO EditionType (EditionTypeCaption, Active, ShowToAllCustomers)
VALUES ('Max', 1, 1)

-- Copy the EditionTypeSoftwareFeature for the Complete version for the new Max version
DECLARE @MaxID INT
SELECT	@MaxID = EditionTypeID
FROM	EditionType
WHERE	EditionTypeCaption = 'Max'

INSERT INTO EditionTypeSoftwareFeature (EditionTypeID, SoftwareFeatureID, SoftwareFeatureUsageID)
SELECT	@MaxID, SoftwareFeatureID, SoftwareFeatureUsageID
FROM	EditionTypeSoftwareFeature
WHERE	EditionTypeID = 1

-- Update internal support database captions
INSERT INTO SupportType (SupportTypeCaption, Sort, ProductCaptionAndPrice)
VALUES ('Phone', 6, 'Phone Support (Max Edition)')
