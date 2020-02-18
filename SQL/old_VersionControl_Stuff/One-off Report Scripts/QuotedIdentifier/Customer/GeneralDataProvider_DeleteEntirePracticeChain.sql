IF EXISTS (
	SELECT	*
	FROM	dbo.sysobjects
	WHERE	id = object_id(N'[dbo].[GeneralDataProvider_DeleteEntirePracticeChain]')
	AND	OBJECTPROPERTY(id, N'IsProcedure') = 1)

DROP PROCEDURE [dbo].[GeneralDataProvider_DeleteEntirePracticeChain]

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE GeneralDataProvider_DeleteEntirePracticeChain
	@practice_id int
AS
BEGIN

	IF @@TRANCOUNT = 0
	BEGIN
		PRINT 'Must be run within a transaction!!!'
		RETURN
		--BEGIN TRAN
	END
	DECLARE @dt datetime
	SET @dt = GETDATE()
	DECLARE @practice_name varchar(128)
	DECLARE @rows int
	DECLARE @table_name sysname
	DECLARE @err_var int
	
	SET NOCOUNT ON
	
	SELECT @practice_name = P.Name 
	FROM dbo.Practice P 
	WHERE P.PracticeID = @practice_id 
	
	PRINT '============================================================================='
	PRINT 'Deleting Data for Practice ' + ISNULL(@practice_name, 'NOT FOUND!!!')
	PRINT '============================================================================='
		
	--Bill Batch Chain
	SET @table_name = 'Document_HCFA'
	
	DELETE DHC
	FROM DocumentBatch DB INNER JOIN Document D
	ON DB.DocumentBatchID=D.DocumentBatchID
	INNER JOIN Document_HCFA DH
	ON D.DocumentID=DH.DocumentID
	INNER JOIN Document_HCFAClaim DHC
	ON DH.Document_HCFAID=DHC.Document_HCFAID
	WHERE DB.PracticeID = @practice_id	

	DELETE DH
	FROM DocumentBatch DB INNER JOIN Document D
	ON DB.DocumentBatchID=D.DocumentBatchID
	INNER JOIN Document_HCFA DH
	ON D.DocumentID=DH.DocumentID
	WHERE DB.PracticeID = @practice_id	

	DELETE DBR
	FROM DocumentBatch DB INNER JOIN Document D
	ON DB.DocumentBatchID=D.DocumentBatchID
	INNER JOIN Document_BusinessRules DBR
	ON D.DocumentBatchID=DBR.DocumentBatchID AND D.DocumentID=DBR.DocumentID
	WHERE DB.PracticeID = @practice_id	

	DELETE D
	FROM DocumentBatch DB INNER JOIN Document D
	ON DB.DocumentBatchID=D.DocumentBatchID
	WHERE DB.PracticeID = @practice_id	

	DELETE DBRA
	FROM DocumentBatch DB INNER JOIN DocumentBatch_RuleActions DBRA
	ON DB.DocumentBatchID=DBRA.DocumentBatchID
	WHERE DB.PracticeID = @practice_id

	DELETE DB
	FROM DocumentBatch DB
	WHERE DB.PracticeID = @practice_id
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @table_name = 'Bill_EDI'
	
	DELETE T
	FROM dbo.BillBatch BB INNER JOIN
		dbo.Bill_EDI T ON
			BB.BillBatchID = T.BillBatchID 
	WHERE BB.PracticeID = @practice_id		
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @table_name = 'Bill_Statement'
	
	DELETE T
	FROM dbo.BillBatch BB INNER JOIN
		dbo.Bill_Statement T ON
			BB.BillBatchID = T.BillBatchID 
	WHERE BB.PracticeID = @practice_id				
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @table_name = 'Bill'
	
	DELETE T
	FROM dbo.BillBatch BB INNER JOIN
		dbo.Bill T ON
			BB.BillBatchID = T.BillBatchID 
	WHERE BB.PracticeID = @practice_id				
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @table_name = 'BillBatch'
			
	DELETE dbo.BillBatch
	WHERE PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	--ServiceLocation Chain
	SET @table_name = 'ServiceLocationFeeSchedule'
	
	DELETE SLFS
	FROM	dbo.ServiceLocationFeeSchedule SLFS INNER JOIN
		dbo.PracticeFeeSchedule PFS ON
			SLFS.PracticeFeeScheduleID = PFS.PracticeFeeScheduleID
	WHERE PFS.PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	SET @table_name = 'PracticeFee'
	
	DELETE PF
	FROM dbo.PracticeFee PF INNER JOIN
		dbo.PracticeFeeSchedule PFS ON
			PF.PracticeFeeScheduleID = PFS.PracticeFeeScheduleID
	WHERE PFS.PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	SET @table_name = 'PracticeFeeSchedule'
	
	DELETE dbo.PracticeFeeSchedule
	WHERE PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	SET @table_name = 'PracticeInsuranceGroupNumber'
	
	DELETE dbo.PracticeInsuranceGroupNumber
	WHERE PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	--Claim Chain
	SET @table_name = 'ClaimPayer'
	
	DELETE CP
	FROM dbo.ClaimPayer CP INNER JOIN
		dbo.Claim C ON
			CP.ClaimID = C.ClaimID
	WHERE C.PracticeID = @practice_id
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	SET @table_name = 'BillClaim'
	
	DELETE BC
	FROM dbo.BillClaim BC INNER JOIN
		dbo.Claim C ON
			BC.ClaimID = C.ClaimID
	WHERE C.PracticeID = @practice_id
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	SET @table_name = 'PaymentClaimTransaction'
	
	DELETE PCT 
	FROM dbo.PaymentClaimTransaction PCT INNER JOIN
		dbo.ClaimTransaction CT ON
			PCT.ClaimTransactionID = CT.ClaimTransactionID INNER JOIN
		dbo.Claim C ON
			CT.ClaimID = C.ClaimID
	WHERE C.PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	SET @table_name = 'ClaimTransaction'
	
	DELETE CT 
	FROM dbo.ClaimTransaction CT INNER JOIN
		dbo.Claim C ON
			CT.ClaimID = C.ClaimID
	WHERE C.PracticeID = @practice_id 	
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	SET @table_name = 'Claim'
	
	DELETE dbo.Claim
	WHERE PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	--Encounter Chain
	SET @table_name = 'EncounterToInsurancePolicy'
	
	DELETE ETPI
	FROM dbo.EncounterToInsurancePolicy ETPI INNER JOIN
		dbo.Encounter E ON
			ETPI.EncounterID = E.EncounterID
	WHERE E.PracticeID = @practice_id
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	SET @table_name = 'EncounterProcedure'
	
	DELETE EP
	FROM dbo.EncounterProcedure EP INNER JOIN
		dbo.Encounter E ON
			EP.EncounterID = E.EncounterID
	WHERE E.PracticeID = @practice_id
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	SET @table_name = 'EncounterDiagnosis'
	
	DELETE ED
	FROM dbo.EncounterDiagnosis ED INNER JOIN
		dbo.Encounter E ON
			ED.EncounterID = E.EncounterID
	WHERE E.PracticeID = @practice_id
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	--Patient Chain
	SET @table_name = 'PaymentPatient'
	
	DELETE PP 
	FROM dbo.PaymentPatient PP INNER JOIN
		dbo.Payment PMT ON
			PP.PaymentID = PMT.PaymentID
	WHERE PMT.PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	SET @table_name = 'PaymentPatient'
	
	DELETE PP 
	FROM dbo.PaymentPatient PP INNER JOIN
		dbo.Patient P ON
			PP.PatientID = P.PatientID
	WHERE P.PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
		
	SET @table_name = 'RefundToPayments'
	
	DELETE RTP
	FROM dbo.RefundToPayments RTP
		INNER JOIN dbo.Payment P
		ON RTP.PaymentID = P.PaymentID
	WHERE P.PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @table_name = 'Refund'
	
	DELETE RFD
	FROM dbo.Refund RFD
	WHERE RFD.PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
		
	SET @table_name = 'Payment'
	
	DELETE dbo.Payment
	WHERE PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @table_name = 'Encounter'
	
	DELETE dbo.Encounter
	WHERE PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @table_name = 'PatientAuthorization'
	
	DELETE PA
	FROM dbo.PatientAuthorization PA INNER JOIN
		dbo.Patient P ON 
			PA.PatientID = P.PatientID 
	WHERE P.PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @table_name = 'InsurancePolicy'
	
-- 	DELETE PI
-- 	FROM dbo.InsurancePolicy PI INNER JOIN
-- 		dbo.Patient P ON
-- 			PI.PatientID = P.PatientID 
-- 	WHERE P.PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @table_name = 'Patient'
	
	DELETE dbo.Patient
	WHERE PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	--Doctor Chain
	SET @table_name = 'PracticeToInsuranceCompany'
	
	DELETE dbo.PracticeToInsuranceCompany 
	WHERE PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
--	SET @table_name = 'InsuranceCompanyPlan'
--	
--	DELETE ICPN
--	FROM dbo.InsuranceCompanyPlan ICPN INNER JOIN
--		dbo.ProviderNumber PN ON
--			ICPN.LocalUseProviderNumberTypeID = PN.ProviderNumberID INNER JOIN
--		dbo.Doctor D ON
--			PN.DoctorID = D.DoctorID
--	WHERE D.PracticeID = @practice_id 
--	
--	SET @rows = @@ROWCOUNT
--	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	SET @table_name = 'ProviderNumber'
	
	DELETE PN
	FROM dbo.ProviderNumber PN INNER JOIN
		dbo.Doctor D ON
			PN.DoctorID = D.DoctorID
	WHERE D.PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 

	SET @table_name = 'AppointmentToAppointmentReason'
	
	DELETE ATAR
	FROM [dbo].[AppointmentToAppointmentReason] ATAR
		INNER JOIN dbo.Appointment A
		ON ATAR.AppointmentID = A.AppointmentID
	WHERE A.PracticeID = @practice_id

	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 

	SET @table_name = 'AppointmentReasonDefaultResource'
	
	DELETE ARDR
	FROM [dbo].[AppointmentReason] AR
		INNER JOIN dbo.AppointmentReasonDefaultResource ARDR
		ON AR.AppointmentReasonID = ARDR.AppointmentReasonID
	WHERE AR.PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @table_name = 'AppointmentReason'
	
	DELETE [dbo].[AppointmentReason]
	WHERE PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @table_name = 'AppointmentToResource'
	
	DELETE ATR
	FROM [dbo].[AppointmentToResource] ATR
		INNER JOIN dbo.Appointment A
		ON ATR.AppointmentID = A.AppointmentID
	WHERE A.PracticeID = @practice_id
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	SET @table_name = 'Appointment'
	
	DELETE A 
	FROM dbo.Appointment A 
	WHERE A.PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	SET @table_name = 'ServiceLocation'
	
	DELETE dbo.ServiceLocation 
	WHERE PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @table_name = 'Doctor'
	
	DELETE dbo.Doctor
	WHERE PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	--Standalone Deletes
	SET @table_name = 'HandheldEncounter'
	
	DELETE dbo.HandheldEncounter
	WHERE PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @table_name = 'PracticeResource'
	
	DELETE dbo.PracticeResource 
	WHERE PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @table_name = 'ReportEdition'
	
	DELETE dbo.ReportEdition 
	WHERE PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @table_name = 'UserPractices'
	
	DELETE dbo.UserPractices
	WHERE PracticeID = @practice_id 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @table_name = 'DashboardARAgingDisplay'
	
	DELETE [dbo].[DashboardARAgingDisplay]
	WHERE PracticeID = @practice_id
		
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @table_name = 'DashboardARAgingVolatile'
	
	DELETE [dbo].[DashboardARAgingVolatile]
	WHERE PracticeID = @practice_id
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @table_name = 'DashboardKeyIndicatorDisplay'
	
	DELETE [dbo].[DashboardKeyIndicatorDisplay]
	WHERE PracticeID = @practice_id
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @table_name = 'DashboardKeyIndicatorVolatile'
	
	DELETE [dbo].[DashboardKeyIndicatorVolatile]
	WHERE PracticeID = @practice_id
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @table_name = 'DashboardReceiptsDisplay'
	
	DELETE [dbo].[DashboardReceiptsDisplay]
	WHERE PracticeID = @practice_id
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @table_name = 'DashboardReceiptsVolatile'
	
	DELETE [dbo].[DashboardReceiptsVolatile]
	WHERE PracticeID = @practice_id
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
		
	--Final Delete
	SET @table_name = 'Practice'
	
	DELETE dbo.Practice 
	WHERE PracticeID = @practice_id 
	
	SET @err_var = @@ERROR 
	
	SET @rows = @@ROWCOUNT
	PRINT 'Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	PRINT ''
	PRINT 'Duration: ' + CAST(DATEDIFF(ms,@dt, GETDATE()) as varchar) + ' ms'
	PRINT ''
	PRINT '============================================================================='
	PRINT ' END of batch for ' + @practice_name
	PRINT '============================================================================='	
	/*
	IF @err_var = 0
		COMMIT
	ELSE
	BEGIN
		IF @@TRANCOUNT > 0
			ROLLBACK
	END
	*/	
END
--SELECT @@TRANCOUNT
--rollback

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON 
GO


