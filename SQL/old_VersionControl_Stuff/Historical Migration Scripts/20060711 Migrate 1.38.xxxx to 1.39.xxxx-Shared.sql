/*----------------------------------

DATABASE UPDATE SCRIPT

v1.38.xxxx to v1.39.xxxx
----------------------------------*/

----------------------------------
--BEGIN TRAN 
----------------------------------

----------------------------------------
-- CASE 12423 - patient statements for Accro/Health with Bridgestone
---------------------------------------
IF EXISTS (SELECT * FROM sys.objects WHERE name='FK_PatientStatementsVendor_PatientStatementsTransportId' AND type='F')
	ALTER TABLE [dbo].[PatientStatementsVendor] DROP CONSTRAINT FK_PatientStatementsVendor_PatientStatementsTransportId
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name='FK_PatientStatementsFormat_PatientStatementsVendorId' AND type='F')
	ALTER TABLE [dbo].[PatientStatementsFormat] DROP CONSTRAINT FK_PatientStatementsFormat_PatientStatementsVendorId
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PatientStatementsTransport]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PatientStatementsTransport]
GO

CREATE TABLE PatientStatementsTransport (
	[PatientStatementsTransportId] INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_PatientStatementsTransport_PatientStatementsTransportID 
		PRIMARY KEY NONCLUSTERED,
	[TransportName] varchar(128), 
	[TransportType] varchar(32),		-- like 'FTP' or 'HTTP' - for factory to know what object to create

	[ParametersXml] ntext,

	[Notes] ntext
)

GO

INSERT PatientStatementsTransport (TransportName, TransportType, ParametersXml)
VALUES ('MedAvant FTP', 'FTP',
'<Parameters>
  <Out>
    <FtpServer>claimsatl.proxymed.com</FtpServer>
    <FtpTransportType>SourceForge</FtpTransportType>
    <FtpForceActiveMode>1</FtpForceActiveMode>
	<UsesSingleAccount>0</UsesSingleAccount>
	<Login></Login>
	<Password></Password>
	<FtpDirTesting>testing</FtpDirTesting>
	<FtpDirProduction>incoming</FtpDirProduction>
	<DoEncrypt>1</DoEncrypt>
	<EncryptionOriginator>sergei@kareo.com</EncryptionOriginator>
	<EncryptionRecipient>gwooden@proxymed.com</EncryptionRecipient>
	<EncryptionPassphrase>the kareo software is best</EncryptionPassphrase>
  </Out>
  <In>
    <FtpServer>claimsatl.proxymed.com</FtpServer>
    <FtpTransportType>SourceForge</FtpTransportType>
    <FtpForceActiveMode>1</FtpForceActiveMode>
	<UsesSingleAccount>0</UsesSingleAccount>
	<Login></Login>
	<Password></Password>
	<FtpReportsFolder>outgoing</FtpReportsFolder>
	<DoDecrypt>1</DoDecrypt>
	<DecryptionOriginator>gwooden@proxymed.com</DecryptionOriginator>
	<DecryptionRecipient>sergei@kareo.com</DecryptionRecipient>
	<DecryptionPassphrase>the kareo software is best</DecryptionPassphrase>
  </In>
</Parameters>')

INSERT PatientStatementsTransport (TransportName, TransportType, ParametersXml)
VALUES ('PSC Info Group FTP', 'FTP',
'<Parameters>
  <Out>
    <FtpServer>ftp.pscinfogroup.com</FtpServer>
    <FtpTransportType>SourceForge</FtpTransportType>
    <FtpForceActiveMode>1</FtpForceActiveMode>
	<UsesSingleAccount>0</UsesSingleAccount>
	<Login></Login>
	<Password></Password>
	<FtpDirTesting>testing</FtpDirTesting>
	<FtpDirProduction>incoming</FtpDirProduction>
	<DoEncrypt>1</DoEncrypt>
	<EncryptionOriginator>sergei@kareo.com</EncryptionOriginator>
	<EncryptionRecipient>dataexpress@pscinfogroup.com</EncryptionRecipient>
	<EncryptionPassphrase>the kareo software is best</EncryptionPassphrase>
  </Out>
  <In>
    <FtpServer>ftp.pscinfogroup.com</FtpServer>
    <FtpTransportType>SourceForge</FtpTransportType>
    <FtpForceActiveMode>1</FtpForceActiveMode>
	<UsesSingleAccount>0</UsesSingleAccount>
	<Login></Login>
	<Password></Password>
	<FtpReportsFolder>outgoing</FtpReportsFolder>
	<DoDecrypt>1</DoDecrypt>
	<DecryptionOriginator>dataexpress@pscinfogroup.com</DecryptionOriginator>
	<DecryptionRecipient>sergei@kareo.com</DecryptionRecipient>
	<DecryptionPassphrase>the kareo software is best</DecryptionPassphrase>
  </In>
</Parameters>')

INSERT PatientStatementsTransport (TransportName, TransportType, ParametersXml)
VALUES ('PSC Info Group FTP - Single Account', 'FTP',
'<Parameters>
  <Out>
    <FtpServer>ftp.pscinfogroup.com</FtpServer>
    <FtpTransportType>SourceForge</FtpTransportType>
    <FtpForceActiveMode>1</FtpForceActiveMode>
	<UsesSingleAccount>1</UsesSingleAccount>
	<Login>PINCMASTER</Login>
	<Password>uhsgun53</Password>
	<FtpDirTesting>Testing</FtpDirTesting>
	<FtpDirProduction>Incoming</FtpDirProduction>
	<DoEncrypt>1</DoEncrypt>
	<EncryptionOriginator>sergei@kareo.com</EncryptionOriginator>
	<EncryptionRecipient>dataexpress@pscinfogroup.com</EncryptionRecipient>
	<EncryptionPassphrase>the kareo software is best</EncryptionPassphrase>
  </Out>
  <In>
    <FtpServer>ftp.pscinfogroup.com</FtpServer>
    <FtpTransportType>SourceForge</FtpTransportType>
    <FtpForceActiveMode>1</FtpForceActiveMode>
	<UsesSingleAccount>1</UsesSingleAccount>
	<Login>PINCMASTER</Login>
	<Password>uhsgun53</Password>
	<FtpReportsFolder>Outgoing</FtpReportsFolder>
	<DoDecrypt>1</DoDecrypt>
	<DecryptionOriginator>dataexpress@pscinfogroup.com</DecryptionOriginator>
	<DecryptionRecipient>sergei@kareo.com</DecryptionRecipient>
	<DecryptionPassphrase>the kareo software is best</DecryptionPassphrase>
  </In>
</Parameters>')

INSERT PatientStatementsTransport (TransportName, TransportType, ParametersXml)
VALUES ('Bridgestone FTP', 'FTP',
'<Parameters>
  <Out>
    <FtpServer>www.bfis.com</FtpServer>
    <FtpTransportType>SourceForge</FtpTransportType>
    <FtpForceActiveMode>1</FtpForceActiveMode>
	<UsesSingleAccount>0</UsesSingleAccount>
	<Login></Login>
	<Password></Password>
	<FtpDirTesting>KareoInc/testing</FtpDirTesting>
	<FtpDirProduction>KareoInc/incoming</FtpDirProduction>
	<DoEncrypt>1</DoEncrypt>
	<EncryptionOriginator>sergei@kareo.com</EncryptionOriginator>
	<EncryptionRecipient>bfisservice@bfusa.com</EncryptionRecipient>
	<EncryptionPassphrase>the kareo software is best</EncryptionPassphrase>
  </Out>
  <In>
    <FtpServer>www.bfis.com</FtpServer>
    <FtpTransportType>SourceForge</FtpTransportType>
    <FtpForceActiveMode>1</FtpForceActiveMode>
	<UsesSingleAccount>0</UsesSingleAccount>
	<Login></Login>
	<Password></Password>
	<FtpReportsFolder>KareoInc/outgoing</FtpReportsFolder>
	<DoDecrypt>1</DoDecrypt>
	<DecryptionOriginator>bfisservice@bfusa.com</DecryptionOriginator>
	<DecryptionRecipient>sergei@kareo.com</DecryptionRecipient>
	<DecryptionPassphrase>the kareo software is best</DecryptionPassphrase>
  </In>
</Parameters>')

INSERT PatientStatementsTransport (TransportName, TransportType, ParametersXml)
VALUES ('BillFlash HTTPS', 'HTTP-XUpload-BillFlash',
'<Parameters>
  <Upload>
    <UploadServer>docsight.net</UploadServer>
	<Url>https://billflash.com/bl/statements.php</Url>
	<UploadScript>/5453/estatements_Upload2.asp?n=BL100&amp;j=002&amp;b=NX005</UploadScript>
  </Upload>
</Parameters>')

INSERT PatientStatementsTransport (TransportName, TransportType, ParametersXml)
VALUES ('KDB01 FTP for Testing', 'FTP',
'<Parameters>
  <Out>
    <FtpServer>kdb01</FtpServer>
    <FtpTransportType>SourceForge</FtpTransportType>
    <FtpForceActiveMode>1</FtpForceActiveMode>
	<UsesSingleAccount>0</UsesSingleAccount>
	<Login></Login>
	<Password></Password>
	<FtpDirTesting>testing</FtpDirTesting>
	<FtpDirProduction>incoming</FtpDirProduction>
	<DoEncrypt>1</DoEncrypt>
	<EncryptionOriginator>sergei@kareo.com</EncryptionOriginator>
	<EncryptionRecipient>dataexpress@pscinfogroup.com</EncryptionRecipient>
	<EncryptionPassphrase>the kareo software is best</EncryptionPassphrase>
  </Out>
  <In>
    <FtpServer>kdb01</FtpServer>
    <FtpTransportType>SourceForge</FtpTransportType>
    <FtpForceActiveMode>1</FtpForceActiveMode>
	<UsesSingleAccount>0</UsesSingleAccount>
	<Login></Login>
	<Password></Password>
	<FtpReportsFolder>outgoing</FtpReportsFolder>
	<DoDecrypt>1</DoDecrypt>
	<DecryptionOriginator>dataexpress@pscinfogroup.com</DecryptionOriginator>
	<DecryptionRecipient>sergei@kareo.com</DecryptionRecipient>
	<DecryptionPassphrase>the kareo software is best</DecryptionPassphrase>
  </In>
</Parameters>')

GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PatientStatementsVendor]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PatientStatementsVendor]
GO

CREATE TABLE PatientStatementsVendor (
	[PatientStatementsVendorId] INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_PatientStatementsVendor_PatientStatementsVendorID 
		PRIMARY KEY NONCLUSTERED,
	[VendorName] varchar(128), 
	[Active] bit, 
	[PatientStatementsTransportId] int,
	[Notes] ntext
)

GO

ALTER TABLE [dbo].[PatientStatementsVendor] ADD
	CONSTRAINT [FK_PatientStatementsVendor_PatientStatementsTransportId] FOREIGN KEY 
	(
		[PatientStatementsTransportId]
	) REFERENCES [PatientStatementsTransport] (
		[PatientStatementsTransportId]
	)
GO

INSERT PatientStatementsVendor (VendorName, Active, PatientStatementsTransportId)
			VALUES ('MedAvant', 1, 1)

INSERT PatientStatementsVendor (VendorName, Active, PatientStatementsTransportId)
			VALUES ('PSC Info Group', 1, 2)

INSERT PatientStatementsVendor (VendorName, Active, PatientStatementsTransportId)
			VALUES ('PSC Info Group - Single Login', 1, 3)

INSERT PatientStatementsVendor (VendorName, Active, PatientStatementsTransportId)
			VALUES ('Bridgestone', 1, 4)

INSERT PatientStatementsVendor (VendorName, Active, PatientStatementsTransportId)
			VALUES ('BillFlash', 1, 5)

INSERT PatientStatementsVendor (VendorName, Active, PatientStatementsTransportId)
			VALUES ('KDB01 for Testing', 1, 6)
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PatientStatementsFormat]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PatientStatementsFormat]
GO

CREATE TABLE PatientStatementsFormat (
	[PatientStatementsFormatId] INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_PatientStatementsFormat_PatientStatementsFormatID 
		PRIMARY KEY NONCLUSTERED,
	[FormatName] varchar(128), 
	[FormatExternalName] varchar(128),	-- to be agreed with Printing Vendor, goes into file name

	[GoodForPrinting] bit, 
	[GoodForElectronic] bit, 

	[PatientStatementsVendorId] int,

	[StoredProcedureName] varchar(256),
	[TransformXsltFileName] varchar(256),

	[LinesPerPage] int,
	[TransactionDetail] BIT NOT NULL,		-- CASE 12425 - Create a new stored procedure that will prepare data for the Accro/Health printing vendor
	[ParametersXml] ntext,

	[Notes] ntext
)
GO

ALTER TABLE [dbo].[PatientStatementsFormat] WITH NOCHECK ADD
	CONSTRAINT DF_PatientStatmentFormat_TransactionDetail DEFAULT 0 FOR [TransactionDetail]
GO

ALTER TABLE [dbo].[PatientStatementsFormat] ADD
	CONSTRAINT [FK_PatientStatementsFormat_PatientStatementsVendorId] FOREIGN KEY 
	(
		[PatientStatementsVendorId]
	) REFERENCES [PatientStatementsVendor] (
		[PatientStatementsVendorId]
	)
GO

INSERT PatientStatementsFormat (FormatName, FormatExternalName, LinesPerPage, PatientStatementsVendorId, GoodForPrinting, GoodForElectronic, StoredProcedureName, TransformXsltFileName, Notes)
VALUES ('ProxyMed Traditional Plain', 'KN', 36, 1, 1, 1, 'BillDataProvider_GetStatementBatchXML', 'ProxyMed_Statement_xml-dat.xsl', 'Legacy plain text format used to pass data to ProxyMed')

INSERT PatientStatementsFormat (FormatName, FormatExternalName, LinesPerPage, PatientStatementsVendorId, GoodForPrinting, GoodForElectronic, StoredProcedureName, TransformXsltFileName, Notes)
VALUES ('PSC Plain', 'KN', 36, 2, 1, 1, 'BillDataProvider_GetStatementBatchXML', 'PSC_Statement_xml-dat.xsl', 'Plain text format used to pass data to PSC')

INSERT PatientStatementsFormat (FormatName, FormatExternalName, LinesPerPage, PatientStatementsVendorId, GoodForPrinting, GoodForElectronic, StoredProcedureName, TransformXsltFileName, Notes)
VALUES ('PSC Plain', 'KN', 36, 3, 1, 1, 'BillDataProvider_GetStatementBatchXML', 'PSC_Statement_xml-dat.xsl', 'Plain text format used to pass data to PSC')

INSERT PatientStatementsFormat (FormatName, FormatExternalName, LinesPerPage, PatientStatementsVendorId, GoodForPrinting, GoodForElectronic, StoredProcedureName, TransformXsltFileName, Notes)
VALUES ('Bridgestone Traditional', 'KN', 36, 4, 1, 1, 'BillDataProvider_GetStatementBatchXML', 'Bridgestone_T_Statement_xml-dat.xsl', 'ProxyMed legacy format accepted by Bridgestone')

INSERT PatientStatementsFormat (FormatName, FormatExternalName, LinesPerPage, PatientStatementsVendorId, GoodForPrinting, GoodForElectronic, StoredProcedureName, TransformXsltFileName, Notes)
VALUES ('Bridgestone Accro', 'ACR', 25, 4, 0, 1, 'BillDataProvider_GetStatementBatchXML_Accro', 'Bridgestone_A_Statement_xml-dat.xsl', 'Accro/Health format accepted by Bridgestone')

INSERT PatientStatementsFormat (FormatName, FormatExternalName, LinesPerPage, PatientStatementsVendorId, GoodForPrinting, GoodForElectronic, StoredProcedureName, TransformXsltFileName, Notes)
VALUES ('BillFlash Standard', 'BFL', 36, 5, 0, 1, 'BillDataProvider_GetStatementBatchXML_BillFlash', 'BillFlash_Statement_xml-dat.xsl', 'Standard format accepted by BillFlash')

INSERT PatientStatementsFormat (FormatName, FormatExternalName, LinesPerPage, PatientStatementsVendorId, GoodForPrinting, GoodForElectronic, StoredProcedureName, TransformXsltFileName, Notes)
VALUES ('ProxyMed Traditional Plain', 'KN', 36, 5, 1, 0, 'BillDataProvider_GetStatementBatchXML', 'ProxyMed_Statement_xml-dat.xsl', 'Legacy plain text format used to print statements for ProxyMed')

INSERT PatientStatementsFormat (FormatName, FormatExternalName, LinesPerPage, PatientStatementsVendorId, GoodForPrinting, GoodForElectronic, StoredProcedureName, TransformXsltFileName, Notes)
VALUES ('PSC Plain', 'KN', 36, 6, 1, 1, 'BillDataProvider_GetStatementBatchXML', 'PSC_Statement_xml-dat.xsl', 'Plain text format used to pass data to PSC')

GO

UPDATE PSF set ParametersXML='<ParametersXML><CommentLineWidth>40</CommentLineWidth><AssignmentTypeInclusion>P</AssignmentTypeInclusion><LineSpacing>2</LineSpacing></ParametersXML>', TransactionDetail=1
FROM PatientStatementsFormat PSF
WHERE FormatName='Bridgestone Accro'
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PatientStatementsPassword]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PatientStatementsPassword]
GO

-- for IDs associated with a single-login FTP transport Practices need to supply "internal" password to make sure they cannot use 
-- each other's account ID. The transport should check that the (AccountId, Password) pair is present in the table before
-- allowing the transmission. These passwords are not under control of the practices.
CREATE TABLE PatientStatementsPassword (
	[PatientStatementsPasswordId] INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_PatientStatementsPassword_PatientStatementsPasswordID 
		PRIMARY KEY NONCLUSTERED,
	[AccountId] varchar(128), 
	[Password] varchar(128),
	[CustomerID] int,			-- info only, not to be used
	[PracticeID] int,			-- info only, not to be used
	[CreatedDate] datetime NOT NULL ,
	[ModifiedDate] datetime NOT NULL ,
	[RecordTimeStamp] TIMESTAMP NOT NULL 
)
GO

ALTER TABLE [dbo].[PatientStatementsPassword] WITH NOCHECK ADD 
	CONSTRAINT [DF_PatientStatementsPassword_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
	CONSTRAINT [DF_PatientStatementsPassword_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate]
GO

	-- ====================================================================================
	-- prepopulate the PatientStatementsPassword table with existing values:
	DECLARE @UserEmailAddress varchar(64)
	SET @UserEmailAddress = 'bizclaims@kareo.com'

	DECLARE @UserId int

	-- see what Customer DBs are within User's reach:
	SELECT @UserId = U.UserID
	FROM dbo.Users U
	WHERE U.EmailAddress = @UserEmailAddress

	DECLARE @t_customers TABLE (
		UserID int,
		CustomerID int,
		CompanyName varchar(256)
	)

	DECLARE @sqlCmd varchar(8000)
	SET @sqlCmd = 'dbo.Shared_AuthenticationDataProvider_GetUserCustomers ' + CAST(@UserId AS varchar(30))

	INSERT @t_customers --( UserID, CustomerID, CompanyName )
	exec(@sqlCmd)

	-- SELECT * FROM @t_customers ORDER BY CustomerID

	DECLARE @t_values TABLE (
		CustomerID int,
		CompanyName varchar(256)
	)

	INSERT @t_values (CustomerID, CompanyName)
		 (SELECT TC.CustomerID, TC.CompanyName FROM @t_customers TC
				 LEFT OUTER JOIN Customer C ON C.CustomerID = TC.CustomerID
				 LEFT OUTER JOIN ClearinghouseConnection CC ON C.ClearinghouseConnectionID =  CC.ClearinghouseConnectionID)

	DECLARE @DatabaseName varchar(128)
	DECLARE @DatabaseServerName varchar(128)
	DECLARE @DatabasePath varchar(256)

	DECLARE cust_cursor CURSOR READ_ONLY
	FOR	
		SELECT DISTINCT C.CustomerId, C.DatabaseServerName, C.DatabaseName
		FROM @t_customers TC
		JOIN dbo.Customer C ON C.CustomerID = TC.CustomerID
		WHERE C.DBActive = 1

	OPEN cust_cursor

	DECLARE @CustomerId int

	FETCH NEXT FROM cust_cursor INTO @CustomerId, @DatabaseServerName, @DatabaseName

	WHILE (@@FETCH_STATUS = 0)
	BEGIN	
		IF (@@fetch_status <> -2)
		BEGIN
			--SET @DatabasePath = COALESCE(@DatabaseServerName + '.','') + COALESCE(@DatabaseName + '.','')
			SET @DatabasePath = COALESCE(@DatabaseName + '.','')
			--PRINT 'Processing for database: ' + @DatabasePath

			-- get PS FTP logins and passwords for all practices for the Customer:
			SET @sqlCmd = 'SELECT CAST(' + CAST(@CustomerId AS varchar(20)) + ' AS INT) AS CustomerID, PracticeID, EStatementsLogin AS AccountId, EStatementsPassword AS [Password] FROM ' + @DatabasePath + '.Practice WHERE (EStatementsLogin IS NOT NULL AND LEN(EStatementsLogin) > 0)'
			--PRINT 'SQL: ' + @sqlCmd

			INSERT PatientStatementsPassword (  CustomerID, PracticeID, AccountId, Password )
			exec(@sqlCmd)

		END
		FETCH NEXT FROM cust_cursor INTO @CustomerId, @DatabaseServerName, @DatabaseName
	END

	CLOSE cust_cursor
	DEALLOCATE cust_cursor

	-- finished prepopulating the PatientStatementsPassword table
	-- ====================================================================================
GO


/*-----------------------------------------------------------------------------
Case 12323:   Create Patient Volume by PCP by Payer report 
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Patients Summary Report',
	@Description='Display, print, and save the patients summary report.', 
	@ViewInMedicalOffice=1,
	@ViewInBusinessManager=1,
	@ViewInAdministrator=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadPatientsSummaryReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadPatientTransactionsSummary',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID


GO

/*---------------------------------------------------------------------------------------------
Case 9414:   Implement inbound faxing system to receive and insert scans into DMS
---------------------------------------------------------------------------------------------*/

/* already deployed */


/*-----------------------------------------------------------------------------
Case 12319:   Implement a copay report showing amount of copays collected in each office  
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Payments Application Summary Report',
	@Description='Display, print, and save the payments application summary report.', 
	@ViewInMedicalOffice=1,
	@ViewInBusinessManager=1,
	@ViewInAdministrator=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadPaymentsApplicationSummaryReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadPaymentApplication',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID


GO



/*-----------------------------------------------------------------------------
Case 12738: Add permission for allowing a timeblock override
-----------------------------------------------------------------------------*/
DECLARE @SchedulingAppointmentsGroupID INT
DECLARE @OverrideTimeblockViolationPermissionID INT

SELECT	@SchedulingAppointmentsGroupID = PermissionGroupID
FROM	PermissionGroup
WHERE	Name = 'Scheduling Appointments'

EXEC @OverrideTimeblockViolationPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Override Timeblock Violation',
	@Description='Override restrictions on a timeblock violation when scheduling an appointment.', 
	@ViewInMedicalOffice=1,
	@ViewInBusinessManager=1,
	@ViewInAdministrator=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=@SchedulingAppointmentsGroupID,
	@PermissionValue='OverrideTimeblockViolation'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='EditAppointmentOptions',
	@PermissionToApplyID=@OverrideTimeblockViolationPermissionID


GO

/*-----------------------------------------------------------------------------
Case 9791: Add permission for duplicate enconter override
-----------------------------------------------------------------------------*/
DECLARE @OverrideDuplicateEncounterGroupID INT
DECLARE @OverrideDuplicateEncounterPermissionID INT

SELECT	@OverrideDuplicateEncounterGroupID = PermissionGroupID
FROM	PermissionGroup
WHERE	Name = 'Entering and Tracking Encounters'

EXEC @OverrideDuplicateEncounterPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Override Duplicate Encounter',
	@Description='Override duplicate encounter.', 
	@ViewInMedicalOffice=1,
	@ViewInBusinessManager=1,
	@ViewInAdministrator=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=@OverrideDuplicateEncounterGroupID,
	@PermissionValue='OverrideDuplicateEncounter'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='EditEncounter',
	@PermissionToApplyID=@OverrideDuplicateEncounterPermissionID

GO


/*-----------------------------------------------------------------------------
Case 11793:	Add permissions for payer scneario browser/detail
-----------------------------------------------------------------------------*/
DECLARE @PayerScenarioGroup INT
DECLARE @PayerScenarioPermission INT

SELECT	@PayerScenarioGroup = PermissionGroupID
FROM	PermissionGroup
WHERE	Name = 'Setting Up Practices'

-- Add DeletePayerScenario
EXEC @PayerScenarioPermission=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Delete Payer Scenario',
	@Description='Delete a payer scenario.', 
	@ViewInMedicalOffice=1,
	@ViewInBusinessManager=1,
	@ViewInAdministrator=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=@PayerScenarioGroup,
	@PermissionValue='DeletePayerScenario'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='DeleteContract',
	@PermissionToApplyID=@PayerScenarioPermission

-- Add EditPayerScenario
EXEC @PayerScenarioPermission=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Edit Payer Scenario',
	@Description='Modify the details of a payer scenario.', 
	@ViewInMedicalOffice=1,
	@ViewInBusinessManager=1,
	@ViewInAdministrator=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=@PayerScenarioGroup,
	@PermissionValue='EditPayerScenario'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='EditContract',
	@PermissionToApplyID=@PayerScenarioPermission

-- Add FindPayerScenario
EXEC @PayerScenarioPermission=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Find Payer Scenario',
	@Description='Display and search a list of payer scenarios.', 
	@ViewInMedicalOffice=1,
	@ViewInBusinessManager=1,
	@ViewInAdministrator=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=@PayerScenarioGroup,
	@PermissionValue='FindPayerScenario'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindContract',
	@PermissionToApplyID=@PayerScenarioPermission

-- Add NewPayerScenario
EXEC @PayerScenarioPermission=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='New Payer Scenario',
	@Description='Create a new payer scenario.', 
	@ViewInMedicalOffice=1,
	@ViewInBusinessManager=1,
	@ViewInAdministrator=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=@PayerScenarioGroup,
	@PermissionValue='NewPayerScenario'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='NewContract',
	@PermissionToApplyID=@PayerScenarioPermission

-- Add ReadPayerScenario
EXEC @PayerScenarioPermission=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Payer Scenario',
	@Description='Show the details of a payer scenario.', 
	@ViewInMedicalOffice=1,
	@ViewInBusinessManager=1,
	@ViewInAdministrator=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=@PayerScenarioGroup,
	@PermissionValue='ReadPayerScenario'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadContract',
	@PermissionToApplyID=@PayerScenarioPermission

GO

--------------------------------------------------------------------------------
-- CASE 12414 - Integrate GoToAssist launching support into applications
--------------------------------------------------------------------------------
DECLARE @UseRemoteDesktopAssistancePermission int

-- Add UseRemoteDesktopAssistance
EXEC @UseRemoteDesktopAssistancePermission=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Use Remote Desktop Assistance',
	@Description='Allow user to facilitate Kareo staff with a remote assistance connection.', 
	@ViewInMedicalOffice=0,
	@ViewInBusinessManager=0,
	@ViewInAdministrator=0,
	@ViewInServiceManager=1,
	@PermissionGroupID=5,    	--Signing On group, for lack of a better place
	@PermissionValue='UseRemoteDesktopAssistance'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadOwnUserAccount',
	@PermissionToApplyID=@UseRemoteDesktopAssistancePermission


--ROLLBACK
--COMMIT

