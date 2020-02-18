ALTER TABLE AdjustmentReason ALTER COLUMN Description VARCHAR(255)


INSERT INTO AdjustmentReason
		(AdjustmentReasonCode
		,Description
				)

SELECT cu.code,cu.Description
FROM SHAREDSERVER.superbill_shared.dbo.CarcUpdate AS cu WITH (NOLOCK)
Left JOIN AdjustmentReason AS ar ON  cu.code=ar.AdjustmentReasonCode
WHERE ar.AdjustmentReasonCode IS NULL




UPDATE ar
SET Description=cu.Description
FROM SHAREDSERVER.superbill_shared.dbo.CarcUpdate AS cu WITH (NOLOCK)
Left JOIN AdjustmentReason AS ar ON  cu.code=ar.AdjustmentReasonCode
WHERE ar.Description<>cu.Description





