
update  superbill_shared.dbo.Customer
SET Metrics = 1
WHERE Metrics IS NULL


IF NOT EXISTS
(
	SELECT * FROM superbill_shared.sys.columns c
		INNER JOIN superbill_shared.sys.objects o ON o.OBJECT_ID = c.OBJECT_ID
	WHERE c.NAME = 'Metrics'
	AND o.NAME = 'Customer'
)
BEGIN

	alter table superbill_shared.dbo.customer alter column Metrics bit NOT NULL
END

