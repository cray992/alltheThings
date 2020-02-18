-- Modify Plus edition to Exclude and Hide Eligibility (instead of Included)
UPDATE	EditionTypeSoftwareFeature
SET		SoftwareFeatureUsageID = 3
WHERE	EditionTypeID = 2
AND		SoftwareFeatureID = 4
