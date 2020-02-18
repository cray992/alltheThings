IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[backupset]') AND name = N'ix_backupset_databaseName')
DROP INDEX [ix_backupset_databaseName] ON [dbo].[backupset] WITH ( ONLINE = OFF )
GO


CREATE NONCLUSTERED INDEX [ix_backupset_databaseName] ON [dbo].[backupset] 
(
	[database_name] ASC,
	[backup_finish_date] DESC
)
INCLUDE ( [type]) 
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DashboardDataProvider_GetToDoDataForBusinessManagerDisplay]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DashboardDataProvider_GetToDoDataForBusinessManagerDisplay]
GO

-- DashboardDataProvider_GetToDoDataForBusinessManagerDisplay @PracticeID=1
CREATE PROCEDURE [dbo].[DashboardDataProvider_GetToDoDataForBusinessManagerDisplay]
	@PracticeID int = 34,
	@UserID int = 309
AS


--DECLARE @PracticeID INT, @userId int
--SELECT @PracticeID = 40, @userId=309


BEGIN

	SET NOCOUNT ON


	------- Retrieves DB Backup info ---------
	declare 
		@LastBackupDate Datetime,
		@Last_FULL_BackupDate Datetime,
		@Last_FULL_BackupFileLocation varchar(Max),
		@Last_LOG_BackupDate Datetime,
		@Last_LOG_BackupFileLocation varchar(Max)

	declare
		@rjt_count int,
		@den_count int,
		@bll_count int
		
	declare
		@today DateTime
			
	declare @db table( [database] sysname, type char(1), [LastBackupDate] datetime, LastBackupFileLocation varchar(500) )
	
	DECLARE @CountPatientStatementsToSend INT
		
	SELECT 
		@bll_count=sum(case CE.ClaimTransactionTypeCode	when 'BLL' then 1 else 0 end),
		@rjt_count=sum(case CE.ClaimTransactionTypeCode	when 'RJT' then 1 else 0 end),
		@den_count=sum(case CE.ClaimTransactionTypeCode	when 'DEN' then 1 else 0 end)
	FROM ClaimAccounting_Errors (nolock) CE
		INNER JOIN Claim C (nolock) 
			ON ce.practiceID=c.practiceID
			and ce.CLaimID = c.CLaimID			
		INNER JOIN ClaimAccounting_Assignments CA  (nolock) 
			ON ca.practiceId=ce.practiceID
			and ca.ClaimID=ce.ClaimID		
		WHERE	CE.PracticeID = @PracticeID
			AND C.ClaimStatusCode IN ('P', 'R')
			AND CE.ClaimTransactionTypeCode in ('BLL', 'RJT', 'DEN')
			AND CA.InsuranceCompanyPlanID IS NOT NULL
			and CA.LastAssignment=1 

	insert into @db( [database], type, lastBackupDate, LastBackupFileLocation )
	SELECT db_Name() AS [Database],
		bs.Type, 
		max(bs.backup_finish_date) AS [LastBackupDate],
		Cast( NULL AS varchar(MAX) ) as LastBackupFileLocation
	FROM  [msdb].[dbo].[backupset] bs (nolock)
	WHERE bs.database_name = db_Name()
	GROUP BY bs.Type


	Update h
	SET LastBackupFileLocation = bmf.Physical_device_Name
	From @db h 
		INNER JOIN [msdb].[dbo].backupset bs  (nolock) ON bs.database_name = h.[Database] AND bs.backup_finish_date = h.[LastBackupDate] AND bs.type = h.Type
		INNER JOIN [msdb].[dbo].BackupMediaSet bms  (nolock) ON bs.Media_set_id = bms.Media_set_id
		INNER JOIN [msdb].[dbo].BackupMediaFamily bmf  (nolock) ON bmf.Media_set_id = bms.Media_set_id

	select
		@LastBackupDate = max( LastBackupDate ),

		@Last_FULL_BackupDate = MAX(case when type = 'D' THEN LastBackupDate ELSE NULL END),
		@Last_FULL_BackupFileLocation = MAX(case when type = 'D' THEN LastBackupFileLocation ELSE NULL END),

		@Last_LOG_BackupDate = MAX(case when type = 'L' THEN LastBackupDate ELSE NULL END), 
		@Last_LOG_BackupFileLocation = MAX(case when type = 'L' THEN LastBackupFileLocation ELSE NULL END)
	from @db
	GROUP BY [Database]



	-----------------------------------------------


	DECLARE @CountClearingHouseReportsToReview INT,
			@CountERAToProcess INT,
			@EClaimsEnrollmentStatusID INT,
			@EStatementsMinimumAllowableBalance MONEY,
			@EStatementsDaysBetweenStatements INT

	SELECT	@EClaimsEnrollmentStatusID = EClaimsEnrollmentStatusID,
			@EStatementsMinimumAllowableBalance = EStatementsMinimumAllowableBalance,
			@EStatementsDaysBetweenStatements = EStatementsDaysBetweenStatements
	FROM	Practice (nolock)
	WHERE	PracticeID = @PracticeID

	IF ( @EClaimsEnrollmentStatusID > 1)
	BEGIN
		    SELECT @CountClearingHouseReportsToReview = COUNT(*)
				FROM dbo.ClearinghouseResponse CR (nolock) 
				WHERE CR.PracticeID = @PracticeID
				AND CR.ReviewedFlag = 0

			SELECT @CountERAToProcess = COUNT(*) 
				FROM dbo.ClearinghouseResponse CR (nolock) 
				WHERE CR.PracticeID = @PracticeID 
				AND CR.ResponseType IN (33,34)
				AND CR.ReviewedFlag = 0
	END

	--Retrieve ready, patient-assigned claims.
	exec @CountPatientStatementsToSend=BillDataProvider_PopulatePatientClaimsForStatement @PracticeID, @EStatementsDaysBetweenStatements, @EStatementsMinimumAllowableBalance, 1

select @CountPatientStatementsToSend

	-- get today date with no time portion
	set @today=dbo.fn_DateOnly(getdate())

select	[PracticeID] = @PracticeID,
		NeedContactInfo = CAST( CASE WHEN EXISTS(	SELECT * FROM dbo.Practice P (nolock) WHERE P.PracticeID = @PracticeID AND (isnull(LEN(P.AddressLine1), 0) = 0 OR isnull(LEN(P.City), 0) = 0	OR isnull(LEN(P.State), 0) = 0 OR isnull(LEN(P.ZipCode), 0) = 0 OR isnull(LEN(P.Phone), 0) < 10 OR isnull(LEN(P.Fax), 0) < 10 OR isnull(LEN(P.EIN), 0) < 9 	))
							THEN 1 ELSE 0 END AS BIT ),
		NeedProviders = CAST( case when EXISTS( SELECT * FROM dbo.Doctor D (nolock) WHERE D.PracticeID = @PracticeID AND D.[External] = 0 AND D.ActiveDoctor = 1 )
							THEN 0 ELSE 1 END AS BIT),
		NeedServiceLocations = CAST( case when EXISTS( SELECT * FROM dbo.ServiceLocation SL (nolock) WHERE SL.PracticeID = @PracticeID)
							THEN 0 ELSE 1 END AS BIT),
		NeedProviderNumbers = CAST( case when EXISTS(SELECT * FROM dbo.Doctor D (nolock) WHERE D.PracticeID = @PracticeID AND D.[External] = 0 AND D.ActiveDoctor = 1 AND NOT EXISTS (SELECT * FROM dbo.ProviderNumber PN WHERE PN.DoctorID = D.DoctorID))
							THEN 1 ELSE 0 END AS BIT),
		NeedGroupNumber = CAST( case when dbo.ClaimDataProvider_GetClaimSettingMode() = 2 or EXISTS(SELECT * FROM dbo.PracticeInsuranceGroupNumber PIGN (nolock) WHERE PIGN.PracticeID = @PracticeID )
							THEN 0 ELSE 1 END AS BIT),
		NeedEncounterForm = CAST( case when EXISTS(SELECT * FROM dbo.EncounterTemplate CTMP (nolock) WHERE CTMP.PracticeID = @PracticeID)
							THEN 0 ELSE 1 END AS BIT),
		NeedElectronicClaimConfigure = CAST( case when EXISTS(SELECT * FROM dbo.Practice P (nolock) WHERE P.PracticeID = @PracticeID AND ISNULL(P.EClaimsEnrollmentStatusID,0) =0 )
							THEN 1 ELSE 0 END AS BIT),
		NeedPatientStatmentConfigure = CAST( case when EXISTS( SELECT * FROM dbo.Practice P (nolock) WHERE P.PracticeID = @PracticeID AND ISNULL(P.EnrolledForEStatements,0) =0 )
							THEN 1 ELSE 0 END AS BIT),
		CountReviewEncounters = (SELECT COUNT(*) FROM dbo.Encounter E (nolock) WHERE E.PracticeID = @PracticeID AND E.EncounterStatusID = 2),

		CountClaimsToSend = ( SELECT COUNT(C.ClaimID) FROM ClaimAccounting_Assignments CA  (nolock) INNER JOIN Claim C (nolock) ON CA.PracticeID=C.PracticeID AND CA.ClaimID=C.ClaimID WHERE CA.PracticeID=@PracticeID AND Status=0 AND LastAssignment=1 AND InsurancePolicyID IS NOT NULL AND ClaimStatusCode='R' ),
		
		CountClaimsNoResponse = COALESCE(@bll_count, 0),
				
		CountClaimsRejected = COALESCE(@rjt_count, 0),
				
		CountClaimsDenied = COALESCE(@den_count, 0),
		
		CountClearingHouseReportsToReview = ISNULL(@CountClearingHouseReportsToReview, 0),

		CountERAToProcess = ISNULL(@CountERAToProcess, 0),

		CountPaymentsToApply = 0,

		CountPatientStatementsToSend = isnull(@CountPatientStatementsToSend, 0),

		NeedReviewReports = CAST( 1 AS BIT),

		NeedAdjustClosingDate = CAST( case when DateDiff(d, (SELECT MedicalOfficeReportMaxDate from Practice (nolock) where PracticeID=@PracticeID), GetDate())>31
				then 1 else 0 end  AS BIT),
		KFaxDnis = (SELECT DNIS FROM Practice PT WHERE PT.PracticeID = @PracticeID AND PT.DNIS IS NOT NULL),

		CountOverdueTasks = (select count(*) from dbo.Task where PracticeID=@PracticeID and IsNull(AssignedUserID, @UserID)=@UserID and dbo.fn_DateOnly(DueDate)<@today and TaskStatusID<>3),
		CountTodayTasks = (select count(*) from dbo.Task where PracticeID=@PracticeID and IsNull(AssignedUserID, @UserID)=@UserID and dbo.fn_DateOnly(DueDate)=@today and TaskStatusID<>3),

		@LastBackupDate as LastBackupDate,
		@Last_FULL_BackupDate as Last_FULL_BackupDate,
		@Last_FULL_BackupFileLocation as Last_FULL_BackupFileLocation,
		@Last_LOG_BackupDate as Last_LOG_BackupDate,
		@Last_LOG_BackupFileLocation as Last_LOG_BackupFileLocation
		
END
