UPDATE ContractsAndFees_ContractRateSchedule
SET EffectiveEndDate = CONVERT(DATETIME, CONVERT(VARCHAR(10), EffectiveEndDate, 101) + ' 23:59:59.000')
WHERE CONVERT(VARCHAR(12), EffectiveEndDate, 114) = '00:00:00:000'
