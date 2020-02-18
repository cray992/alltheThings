DECLARE @t TABLE (SecurityGroupID int)
INSERT INTO @t (SecurityGroupID)
SELECT TrialSecurityGroupID FROM TrialSecurityGroup

DELETE
	UsersSecurityGroup
WHERE
	SecurityGroupID IN (SELECT SecurityGroupID FROM @t)

DELETE
	SecurityGroupPermissions
WHERE
	SecurityGroupID IN (SELECT SecurityGroupID FROM @t)

DELETE
	TrialSecurityGroup

DELETE
	SecurityGroup
WHERE
	SecurityGroupID IN (SELECT SecurityGroupID FROM @t)

DROP TABLE TrialSecurityGroup
GO