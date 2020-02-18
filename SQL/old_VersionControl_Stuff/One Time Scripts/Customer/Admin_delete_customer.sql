BEGIN TRAN

DECLARE @CustomerID int
DECLARE @ContactUserID int
DECLARE @UserCustomerLinks int

--set this
--SET @CustomerID = 24

--get the contact's user acct
SET @ContactUserID = (
	SELECT 
		U.UserID 
	FROM 
		Users U 
		INNER JOIN Customer C ON U.EmailAddress = C.ContactEmail 
	WHERE 
		C.CustomerID = @CustomerID)

--eq 1 if user belongs only to this customer; >1 otherwise
SET @UserCustomerLinks = (SELECT COUNT(0) FROM CustomerUsers WHERE UserID = @ContactUserID)

--remove customer-user links for this customer and user
DELETE
	CustomerUsers 
WHERE 
	UserID = @ContactUserID 
	AND CustomerID = @CustomerID

--remove securitygroup-user links for this customer and user
DELETE
	UsersSecurityGroup
FROM
	UsersSecurityGroup USG
	INNER JOIN SecurityGroup SG ON SG.SecurityGroupID = USG.SecurityGroupID
WHERE
	USG.UserID = @ContactUserID
	AND (SG.CustomerID = @CustomerID OR SG.CustomerID IS NULL)

--remove securitygrouppermissions for the customer's security groups
DELETE
	SecurityGroupPermissions
FROM 
	SecurityGroupPermissions SGP 
	INNER JOIN SecurityGroup SG ON SG.SecurityGroupID = SGP.SecurityGroupID
WHERE
	SG.CustomerID = @CustomerID

--remove security groups for this customer
DELETE
	SecurityGroup 
WHERE
	CustomerID = @CustomerID

--remove the contact user
IF @UserCustomerLinks = 1
BEGIN
	UPDATE
		Users
	SET
		UserPasswordID = NULL
	WHERE
		UserID = @ContactUserID
	
	DELETE
		UserPassword
	WHERE
		UserID = @ContactUserID
	
	DELETE
		Users
	WHERE
		UserID = @ContactUserID
END

--remove the security settings
DELETE
	SecuritySetting
WHERE
	CustomerID = @CustomerID

--remove the customer record
DELETE
	Customer
WHERE
	CustomerID = @CustomerID



--don't forget to commit or rollback

ROLLBACK

-- COMMIT