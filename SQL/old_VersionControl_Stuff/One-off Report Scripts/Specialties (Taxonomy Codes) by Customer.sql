use superbill_shared

declare 
        @i INT,
        @countOfDbs INT,
        @sql Varchar(max),
        @eSql Varchar(max),
        @dbName Varchar(80),
        @dbServer Varchar(80),
        @CustomerID INT
                
create Table #TaxonomyCodes ( 
        rowID int identity(1, 1), 
        CustomerID int, 
        PracticeID int, 
        FirstName varchar(512),
        LastName varchar(512),
        TaxonomyCode varchar(512)
        )        


-- Get set of customer databases to loop through                
select 
        identity(int, 1,1) as rowID,
        cast(CustomerID as INT) as CustomerID,
        DatabaseServerName,
        DatabaseName
INTO #DBs
FROM sharedserver.superbill_shared.dbo.Customer
where DBActive = 1
        AND AccountLocked = 0
		AND Metrics = 1
order by         
        DatabaseServerName,
        DatabaseName
        
SET @countOfDbs = @@Rowcount

-- Create the sql to call on each customer's database
SET @i = 1
SET @sql = 'select {customerID}, PracticeID, FirstName, LastName, TaxonomyCode from [{dbServer}].{dbName}.dbo.doctor where [External]=0 and ActiveDoctor=1'
                                               

while @i <= @countOfDbs
BEGIN
        select @dbName = DatabaseName, @dbServer = DatabaseServerName, @CustomerID = customerID FROM #dbs where rowID = @i
        
        SET @eSql = replace( @sql, '{dbName}', @dbName)
        SET @eSql = replace( @eSql, '{dbServer}', @dbServer)
        SET @eSql = replace( @eSql, '{customerID}', @CustomerID)

		--print @eSql

        insert into #TaxonomyCodes( CustomerID, PracticeID, FirstName, LastName, TaxonomyCode )
        exec ( @eSql )
        
        SET @i = @i + 1
END

select	*
from	#TaxonomyCodes

drop Table #TaxonomyCodes, #DBs

