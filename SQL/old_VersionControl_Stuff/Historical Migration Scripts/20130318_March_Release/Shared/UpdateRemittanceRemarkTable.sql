
INSERT INTO RemittanceRemark
		(RemittanceCode
		,RemittanceDescription
		,RemittanceNotes
		,CreatedDate
		,CreatedUserID
		,ModifiedDate
		,ModifiedUserID
		,KareoLastModifiedDate
		)

SELECT Code, description,'',GETDATE(),40936, GETDATE(),40936,GETDATE()
FROM RARCUpdate AS ru
LEFT JOIN RemittanceRemark AS rr ON ru.Code=rr.RemittanceCode
WHERE rr.RemittanceCode IS NULL AND ru.code <>'NULL'





UPDATE RR
SET RemittanceDescription=ru.DESCRIPTION, rr.modifiedDate=GETDATE(), rr.ModifiedUserID=40936
FROM RARCUpdate AS ru
FULL JOIN RemittanceRemark AS rr ON ru.Code=rr.RemittanceCode
WHERE rr.RemittanceDescription <>ru.Description


UPDATE RR
SET RemittanceNotes=ru.RemittanceNotes, rr.modifiedDate=GETDATE(), rr.ModifiedUserID=40936
FROM RARCUpdate AS ru
FULL JOIN RemittanceRemark AS rr ON ru.Code=rr.RemittanceCode
WHERE rr.RemittanceNotes <>ru.remittancenotes

