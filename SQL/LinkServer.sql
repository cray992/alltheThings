-- link server
INSERT INTO [las-pdw-d027].superbill_69422_prod.dbo.AdjustmentReason (AdjustmentReasonCode,Description)
SELECT AdjustmentReasonCode, Description
FROM [LAS-PDW-D022\D022].superbill_47932_prod.dbo.AdjustmentReason as a
WHERE not exists
(select NULL
from [las-pdw-d027].superbill_69422_prod.dbo.AdjustmentReason b
where a.AdjustmentReasonCode = b.AdjustmentReasonCode
)
