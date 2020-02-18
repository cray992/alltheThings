USE Superbill_Shared
UPDATE C
SET SignupEdition = ES.DefaultEditionTypeID
FROM dbo.Customer AS C
INNER JOIN dbo.EditionSet AS ES ON C.EditionSetID = ES.EditionSetID
WHERE DBActive = 1
AND NOT EXISTS
(
SELECT * FROM dbo.EditionSetEditionType AS ESET
WHERE ESET.EditionSetID = c.EditionSetID AND ESET.EditionTypeID = c.SignupEdition
)