
	DECLARE @QuestUserSecurityGroupID INT
	SET @QuestUserSecurityGroupID = 21334

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SecurityGroupPermissions_RemovedDeniesFromKareoUser]') AND type in (N'U'))
	BEGIN

		CREATE TABLE SecurityGroupPermissions_RemovedDeniesFromKareoUser
		(
			RefDate DATETIME NOT NULL,
			SecurityGroupID INT NOT NULL,
			PermissionID INT NOT NULL,
			Allowed BIT NOT NULL,
			CreatedDate DATETIME NOT NULL,
			CreatedUserID INT NOT NULL,
			ModifiedDate DATETIME NOT NULL,
			ModifiedUserID INT NOT NULL,
			RecordTimeStamp TIMESTAMP NOT NULL,
			Denied BIT NOT NULL
		)

	END

	IF OBJECT_ID('tempdb..#PermissionsToDelete') IS NOT NULL
	BEGIN
		DROP TABLE #PermissionsToDelete
	END

	CREATE TABLE #PermissionsToDelete(PermissionID INT NOT NULL)

	-- Get list of permisions that need removed
	INSERT INTO #PermissionsToDelete
		(PermissionID)
	SELECT SGP.PermissionID
	FROM SecurityGroupPermissions SGP
	JOIN [Permissions] p 
	ON p.[PermissionID] = sgp.[PermissionID] 
	WHERE (sgp.[SecurityGroupID] = @QuestUserSecurityGroupID) AND Denied = 1 

	
	/*  NOTE - Changed to DELETE ALL Permissions even if they are not denied (but based on the denied groups above)  */
	
	-- Log all permissions that will be removed from all quest security groups
	INSERT INTO dbo.SecurityGroupPermissions_RemovedDeniesFromKareoUser
		(RefDate, SecurityGroupID, PermissionID, Allowed, CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, Denied)
	SELECT 
		GETDATE(), SGP.SecurityGroupID, SGP.PermissionID, SGP.Allowed, SGP.CreatedDate, SGP.CreatedUserID, SGP.ModifiedDate, SGP.ModifiedUserID, SGP.Denied	
	FROM SecurityGroupPermissions AS SGP
	JOIN dbo.SecurityGroup SG
	ON SG.SecurityGroupID = SGP.SecurityGroupID
	JOIN dbo.Customer CUST
	ON CUST.CustomerID = SG.CustomerID
	INNER JOIN #PermissionsToDelete PTD
	ON PTD.PermissionID = SGP.PermissionID
	WHERE PartnerID = 2 
	
	-- Remove!
	DELETE SGP
	FROM SecurityGroupPermissions AS SGP
	JOIN dbo.SecurityGroup SG
	ON SG.SecurityGroupID = SGP.SecurityGroupID
	JOIN dbo.Customer CUST
	ON CUST.CustomerID = SG.CustomerID
	INNER JOIN #PermissionsToDelete PTD
	ON PTD.PermissionID = SGP.PermissionID
	WHERE PartnerID = 2 		
	