
-- This script:  Creates New Permission, Creates Old Permission, Creates mapping between old/new permission
-- This is necessary for the way that reports work
IF (SELECT COUNT(*) FROM dbo.UserAccount_Permissions WHERE PermissionValue = 'view_KeyIndicatorsReportingDashboard') = 0
BEGIN

  DECLARE @NewPermissionID INT
  DECLARE @OldPermissionID INT
  
	INSERT INTO dbo.UserAccount_Permissions
		  ( Name ,
			Description ,
			CreatedDate ,
			PermissionValue ,
			ViewInKareo ,
			PermissionType ,
			HierarchyInfo ,
			Deleted ,
			DateDeleted ,
			QuestUserDenied
		  )
	VALUES  ( 'Key Indicators Reports Dashboard' ,
			'Can view reporting dashboard' ,
			'2013-03-18 23:06:17' ,
			'view_KeyIndicatorsReportingDashboard' ,
			1 , -- ViewInKareo - bit
			2 , -- PermissionType - int
			'Reports>Key Indicators' , -- HierarchyInfo - varchar(100)
			0 , -- Deleted - bit
			NULL , -- DateDeleted - datetime
			0  -- QuestUserDenied - bit
		  )
	SET @NewPermissionID = SCOPE_IDENTITY()
          

	INSERT INTO dbo.Permissions
			( Name ,
			  Description ,
			  CreatedDate ,
			  CreatedUserID ,
			  ModifiedDate ,
			  ModifiedUserID ,
			  RecordTimeStamp ,
			  ViewInServiceManager ,
			  PermissionGroupID ,
			  PermissionValue ,
			  ViewInKareo
			)
	VALUES  ( 'Key Indicators Reports Dashboard' , -- Name - varchar(128)
			  'Can view reporting dashboard' , -- Description - varchar(500)
			  '2013-03-21 21:57:43' , -- CreatedDate - datetime
			  0 , -- CreatedUserID - int
			  '2013-03-21 21:57:43' , -- ModifiedDate - datetime
			  0 , -- ModifiedUserID - int
			  NULL , -- RecordTimeStamp - timestamp
			  0 , -- ViewInServiceManager - bit
			  10 , -- PermissionGroupID - int
			  'KeyIndicatorsReportingDashboard' , -- PermissionValue - varchar(128)
			  1  -- ViewInKareo - bit
			)
	SET @OldPermissionID = SCOPE_IDENTITY()

	-- TODO - add the adding new/old/mapping to this doc, need to get newly created id's for mapping
	INSERT INTO dbo.UserAccount_NewOldPermissionMap
			( NewPermissionID ,
			  OldPermissionID
			)
	VALUES  ( @NewPermissionID , -- NewPermissionID - int
			  @OldPermissionID  -- OldPermissionID - int
			)
END




        