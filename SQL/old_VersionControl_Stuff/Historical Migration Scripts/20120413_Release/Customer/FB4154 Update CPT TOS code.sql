UPDATE dbo.ProcedureCodeDictionary
SET TypeOfServiceCode = '5'
WHERE ProcedureCode BETWEEN 'G0004' AND 'G0007'
	OR ProcedureCode BETWEEN 'G0141' and 'G0148'
	OR ProcedureCode BETWEEN 'G0256' AND 'G0257'
	OR ProcedureCode BETWEEN 'G0365' AND 'G0368'
	OR ProcedureCode BETWEEN 'G0394' AND 'G0400'
	OR ProcedureCode BETWEEN 'G0430' AND 'G0434'
	OR ProcedureCode IN ('G0015', 'G0016', 'G0026','G0027', 'G0103', 'G0107', 'G0123', 'G0124', 'G0248', 'G0249', 'G0306', 'G0307', 'G0328')
