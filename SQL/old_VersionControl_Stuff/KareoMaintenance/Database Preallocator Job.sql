
DECLARE @normalAvailable INT, @prepopulatedAvailable INT
DECLARE @normalToAllocate INT, @prepopulatedToAllocate INT
DECLARE @replenishNormalThreshold FLOAT, @replenishPrepopulatedThreshold FLOAT

SET @normalToAllocate = 100
SET @prepopulatedToAllocate = 10

SET @replenishNormalThreshold = 15
SET @replenishPrepopulatedThreshold = 3

SELECT 
	@normalAvailable = SUM(CASE WHEN Prepopulated = 0 THEN 1 ELSE 0 END),
	@prepopulatedAvailable = SUM(CASE WHEN Prepopulated = 1 THEN 1 ELSE 0 END)
FROM Customer
WHERE DBAllocated = 0

IF @normalAvailable IS NULL
	SET @normalAvailable = 0
IF @prepopulatedAvailable IS NULL
	SET @prepopulatedAvailable = 0

PRINT 'Normal Available: ' + CAST(@normalAvailable AS VARCHAR(100))
PRINT 'Prepopulated Available: ' + CAST(@prepopulatedAvailable AS VARCHAR(100))

IF @normalAvailable < @replenishNormalThreshold OR @prepopulatedAvailable < @replenishPrepopulatedThreshold
BEGIN

	PRINT 'Allocating more databases...'
	
	EXEC dbo.Shared_CustomerDataProvider_PreAllocateCustomerDatabase @maxPreAllocated = @normalToAllocate, -- int
	    @maxPreAllocatedPrePopulated = @prepopulatedToAllocate -- int
	    
	PRINT 'Done allocating'
END
ELSE
BEGIN

	PRINT 'Allocation threshold not met. Nothing to do.'

END
