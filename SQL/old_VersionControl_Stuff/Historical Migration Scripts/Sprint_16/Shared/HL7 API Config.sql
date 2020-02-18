
	  DECLARE @SendHL7PermissionID INT, @CreateEncounterPermissionGroupID INT, @SearchPatientPermissionID INT
	  
	  SELECT @CreateEncounterPermissionGroupID = PermissionGroupID
	  FROM dbo.Permissions WHERE PermissionValue = 'WebServiceCreateEncounter'
	  
	  /* Send HL7 Message */
	  IF NOT EXISTS(SELECT * FROM PERMISSIONS WHERE PermissionValue = 'SendHL7Message')
	  BEGIN
		  EXEC @SendHL7PermissionID=Shared_AuthenticationDataProvider_CreatePermission 
		  @Name='Send HL7 Message',
		  @Description= 'Allow users to send HL7 message using our API', 
		  @ViewInKareo=1,
		  @ViewInServiceManager=1,
		  @PermissionGroupID=@CreateEncounterPermissionGroupID,
		  @PermissionValue='SendHL7Message'

		  /* Anybody having WebServiceCreateEncounter permission should also have SearchPatient permission*/
		  EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
		  @CheckPermissionValue='WebServiceCreateEncounter',
		  @PermissionToApplyID=@SendHL7PermissionID
	  END
	  
	  /* Search Patients */
	  IF NOT EXISTS(SELECT * FROM PERMISSIONS WHERE PermissionValue = 'WebServiceSearchPatient')
	  BEGIN
		  EXEC @SearchPatientPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
		  @Name='Search Patient',
		  @Description= 'Allow users to search patients by first name , last name, patient ID, practice ID and date of birth.', 
		  @ViewInKareo=1,
		  @ViewInServiceManager=1,
		  @PermissionGroupID=@CreateEncounterPermissionGroupID,
		  @PermissionValue='WebServiceSearchPatient'

		  /* Anybody having WebServiceCreateEncounter permission should also have SearchPatient permission*/
		  EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
		  @CheckPermissionValue='WebServiceCreateEncounter',
		  @PermissionToApplyID=@SearchPatientPermissionID
	  END
	  
	  
	  	  