



---------------- select * from practice
-----------------



	DECLARE @practice table (practiceID INT)
	declare @enforceTransaction bit
	SELECT @enforceTransaction = 0


	insert into @practice( practiceID )
	select 8
	

BEGIN

	IF @@TRANCOUNT = 0 AND @enforceTransaction = 1
	BEGIN
		PRINT 'Must be run within a transaction!!!'
		RETURN
		--BEGIN TRAN
	END




				-- disable referential integrity
				EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
				EXEC sp_MSForEachTable 'ALTER TABLE ? disable trigger ALL'



	DECLARE @dt datetime
	SET @dt = GETDATE()
	DECLARE @practice_name varchar(128)
	DECLARE @rows int
	DECLARE @table_name sysname
	DECLARE @err_var int
	
	SET NOCOUNT ON
	
	SELECT @practice_name = P.Name 
	FROM dbo.Practice P 
	WHERE P.PracticeID not in (select practiceID from @practice )
	
	PRINT '============================================================================='
	PRINT 'Deleting Data for Practice ' + ISNULL(@practice_name, 'NOT FOUND!!!')
	PRINT '============================================================================='
		
	DECLARE @time datetime
	SET @time = GETDATE()


	-- Clear all of the Closing Date Logic.
	SET @time = GETDATE() SET @table_name ='PracticeToClosingDate'
	DELETE PracticeToClosingDate
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 


	DELETE dbo.Practice 
	WHERE PracticeID not in (select practiceID from @practice )



	SET @time = GETDATE() SET @table_name ='ClearinghouseResponse'
	DELETE  pe
	FROM dbo.ClearinghouseResponse pe
		INNER JOIN Payment p ON p.PaymentID = pe.PaymentID
	WHERE p.PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	--Bill Batch Chain


	SET @time = GETDATE() SET @table_name ='Document_HCFA'
	DELETE  dr
	FROM DocumentReprint dr
		INNER JOIN document d ON d.DocumentID = dr.documentID
	WHERE d.practiceID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='Document_HCFA'
	
	DELETE DHC
	FROM DocumentBatch DB INNER JOIN Document D
	ON DB.DocumentBatchID=D.DocumentBatchID
	INNER JOIN Document_HCFA DH
	ON D.DocumentID=DH.DocumentID
	INNER JOIN Document_HCFAClaim DHC
	ON DH.Document_HCFAID=DHC.Document_HCFAID
	WHERE DB.PracticeID not in (select practiceID from @practice )	

	DELETE DH
	FROM DocumentBatch DB INNER JOIN Document D
	ON DB.DocumentBatchID=D.DocumentBatchID
	INNER JOIN Document_HCFA DH
	ON D.DocumentID=DH.DocumentID
	WHERE DB.PracticeID not in (select practiceID from @practice )	

	DELETE DBR
	FROM DocumentBatch DB INNER JOIN Document D
	ON DB.DocumentBatchID=D.DocumentBatchID
	INNER JOIN Document_BusinessRules DBR
	ON D.DocumentBatchID=DBR.DocumentBatchID AND D.DocumentID=DBR.DocumentID
	WHERE DB.PracticeID not in (select practiceID from @practice )	

	DELETE D
	FROM DocumentBatch DB INNER JOIN Document D
	ON DB.DocumentBatchID=D.DocumentBatchID
	WHERE DB.PracticeID not in (select practiceID from @practice )	

	DELETE DBRA
	FROM DocumentBatch DB INNER JOIN DocumentBatch_RuleActions DBRA
	ON DB.DocumentBatchID=DBRA.DocumentBatchID
	WHERE DB.PracticeID not in (select practiceID from @practice )

	DELETE DB
	FROM DocumentBatch DB
	WHERE DB.PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @time = GETDATE() SET @table_name ='Bill_EDI'
	
	DELETE T
	FROM dbo.BillBatch BB INNER JOIN
		dbo.Bill_EDI T ON
			BB.BillBatchID = T.BillBatchID 
	WHERE BB.PracticeID not in (select practiceID from @practice )		
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @time = GETDATE() SET @table_name ='Bill_Statement'
	
	DELETE T
	FROM dbo.BillBatch BB INNER JOIN
		dbo.Bill_Statement T ON
			BB.BillBatchID = T.BillBatchID 
	WHERE BB.PracticeID not in (select practiceID from @practice )				
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @time = GETDATE() SET @table_name ='Bill'
	
	DELETE bb
	FROM dbo.BillBatch BB 
	WHERE BB.PracticeID not in (select practiceID from @practice )				
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @time = GETDATE() SET @table_name ='BillBatch'
			
	DELETE dbo.BillBatch
	WHERE PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	
	
	
	SET @time = GETDATE() SET @table_name ='PracticeInsuranceGroupNumber'
	
	DELETE dbo.PracticeInsuranceGroupNumber
	WHERE PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	
	
	SET @time = GETDATE() SET @table_name ='BillClaim'
	
	DELETE BC
	FROM dbo.BillClaim BC INNER JOIN
		dbo.Claim C ON
			BC.ClaimID = C.ClaimID
	WHERE C.PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
--	SET @time = GETDATE() SET @table_name ='PaymentClaimTransaction'
--	
--	DELETE PCT 
--	FROM dbo.PaymentClaimTransaction PCT INNER JOIN
--		dbo.ClaimTransaction CT ON
--			PCT.ClaimTransactionID = CT.ClaimTransactionID INNER JOIN
--		dbo.Claim C ON
--			CT.ClaimID = C.ClaimID
--	WHERE C.PracticeID not in (select practiceID from @practice )
--	
--	SET @rows = @@ROWCOUNT
--	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	

	
	SET @time = GETDATE() SET @table_name ='ClaimAccounting_Errors'
	DELETE ClaimAccounting_Errors 
	WHERE PracticeID not in (select practiceID from @practice )		
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name


	

	
	SET @time = GETDATE() SET @table_name ='ClaimAccounting_Accounting'
	WHILE 1=1
	BEGIN
		DELETE TOP(10000) ClaimAccounting 
		WHERE PracticeID not in (select practiceID from @practice )	
	
		IF @@ROWCOUNT=0
			BREAK
	END	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name


	
	SET @time = GETDATE() SET @table_name ='ClaimAccounting_Billings'
	WHILE 1=1
		BEGIN
			DELETE TOP(10000) ClaimAccounting_Billings 
			WHERE PracticeID not in (select practiceID from @practice )

			IF @@ROWCOUNT=0
				BREAK		
	END
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name


	
	SET @time = GETDATE() SET @table_name ='ClaimAccounting_Assignments'
	WHILE 1=1
	BEGIN
		DELETE TOP(10000) ClaimAccounting_Assignments 
		WHERE PracticeID not in (select practiceID from @practice )
	
		IF @@ROWCOUNT=0
			BREAK		
	END
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name


	
	SET @time = GETDATE() SET @table_name ='ClaimAccounting_ClaimPeriod'
	DELETE ccp
	FROM ClaimAccounting_ClaimPeriod ccp
		INNER JOIN Claim c ON c.ClaimID = ccp.ClaimID 
	WHERE PracticeID not in (select practiceID from @practice )		
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name



	SET @time = GETDATE() SET @table_name ='ClaimTransaction'
	WHILE 1=1
	BEGIN
		DELETE TOP(10000) CT 
		FROM dbo.ClaimTransaction CT INNER JOIN
			dbo.Claim C ON
				CT.ClaimID = C.ClaimID
		WHERE C.PracticeID not in (select practiceID from @practice )	
		
		IF @@ROWCOUNT=0
			BREAK
	END

	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	SET @time = GETDATE() SET @table_name ='Claim'
	
	WHILE 1=1
	BEGIN
		DELETE TOP(10000) dbo.Claim
		WHERE PracticeID not in (select practiceID from @practice )

		IF @@ROWCOUNT=0
			BREAK
	END
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	


	

	SET @time = GETDATE() SET @table_name ='AmbulanceCertificationInformation'
	DELETE EP
	FROM dbo.AmbulanceCertificationInformation EP INNER JOIN
		dbo.Encounter E ON
			EP.EncounterID = E.EncounterID
	WHERE E.PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	



	SET @time = GETDATE() SET @table_name ='AmbulanceTransportInformation'
	DELETE EP
	FROM dbo.AmbulanceTransportInformation EP INNER JOIN
		dbo.Encounter E ON
			EP.EncounterID = E.EncounterID
	WHERE E.PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	

	
	SET @time = GETDATE() SET @table_name ='EncounterProcedure'
	
	DELETE EP
	FROM dbo.EncounterProcedure EP INNER JOIN
		dbo.Encounter E ON
			EP.EncounterID = E.EncounterID
	WHERE E.PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	SET @time = GETDATE() SET @table_name ='EncounterDiagnosis'
	
	DELETE ED
	FROM dbo.EncounterDiagnosis ED INNER JOIN
		dbo.Encounter E ON
			ED.EncounterID = E.EncounterID
	WHERE E.PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	--Patient Chain
	SET @time = GETDATE() SET @table_name ='PaymentPatient'
	
	DELETE PP 
	FROM dbo.PaymentPatient PP INNER JOIN
		dbo.Payment PMT ON
			PP.PaymentID = PMT.PaymentID
	WHERE PMT.PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	SET @time = GETDATE() SET @table_name ='PaymentPatient'
	
	DELETE PP 
	FROM dbo.PaymentPatient PP INNER JOIN
		dbo.Patient P ON
			PP.PatientID = P.PatientID
	WHERE P.PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
		
	SET @time = GETDATE() SET @table_name ='RefundToPayments'
	
	DELETE RTP
	FROM dbo.RefundToPayments RTP
		INNER JOIN dbo.Payment P
		ON RTP.PaymentID = P.PaymentID
	WHERE P.PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @time = GETDATE() SET @table_name ='Refund'
	
	DELETE RFD
	FROM dbo.Refund RFD
	WHERE RFD.PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
		





	SET @time = GETDATE() SET @table_name ='PaymentEncounter'
	DELETE  pe
	FROM dbo.PaymentEncounter pe
		INNER JOIN Payment p ON p.PaymentID = pe.PaymentID
	WHERE p.PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='PaymentClaim'
	WHILE 1=1
	BEGIN
		DELETE TOP(10000) pe
		FROM dbo.PaymentClaim pe
			INNER JOIN Payment p ON p.PaymentID = pe.PaymentID
		WHERE p.PracticeID not in (select practiceID from @practice )

		IF @@ROWCOUNT=0
			BREAK
	END
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 


	SET @time = GETDATE() SET @table_name ='PaymentPatient'
	DELETE  pe
	FROM dbo.PaymentPatient pe
		INNER JOIN Payment p ON p.PaymentID = pe.PaymentID
	WHERE p.PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 





	SET @time = GETDATE() SET @table_name ='CapitatedAccountToPayment'
	DELETE  pe
	FROM dbo.CapitatedAccountToPayment pe
		INNER JOIN Payment p ON p.PaymentID = pe.PaymentID
	WHERE p.PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='CapitatedAccountToPayment'
	DELETE  pe
	FROM dbo.CapitatedAccountToPayment pe
		INNER JOIN Payment p ON p.PaymentID = pe.PaymentID
	WHERE p.PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 


	SET @time = GETDATE() SET @table_name ='CapitatedAccount'
	DELETE  pe
	FROM dbo.CapitatedAccount pe
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 




	SET @time = GETDATE() SET @table_name ='Payment'
	
	DELETE dbo.Payment
	WHERE PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	

	SET @time = GETDATE() SET @table_name ='Encounter'
	DELETE dbo.Encounter
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 





	SET @time = GETDATE() SET @table_name ='InsurancePolicyAuthorization'
	DELETE ipa
	FROM  InsurancePolicy ip
		INNER JOIN InsurancePolicyAuthorization ipa ON ip.InsurancePolicyID = ipa.InsurancePolicyID
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='EligibilityHistory'
	DELETE eh
	FROM  InsurancePolicy ip
		INNER JOIN EligibilityHistory eh ON ip.[InsurancePolicyID] = eh.[InsurancePolicyID]
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='InsurancePolicy'
	DELETE ip
	FROM  InsurancePolicy ip
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 





	SET @time = GETDATE() SET @table_name ='PatientJournalNote'
	DELETE pjn
	FROM  dbo.PatientJournalNote pjn
		INNER JOIN Patient p ON p.PatientID = pjn.PatientID
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 


	

	SET @time = GETDATE() SET @table_name ='AppointmentToAppointmentReason'
	DELETE aar
	FROM  AppointmentToAppointmentReason aar
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='AppointmentToResource'
	DELETE aar
	FROM  AppointmentToResource aar
		INNER JOIN appointment a ON a.AppointmentID = aar.AppointmentID
	WHERE a.PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='AppointmentRecurrence'
	DELETE aar
	FROM  AppointmentRecurrence aar
		INNER JOIN appointment a ON a.AppointmentID = aar.AppointmentID
	WHERE a.PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 




	SET @time = GETDATE() SET @table_name ='AppointmentRecurrenceException'
	DELETE aar
	FROM  AppointmentRecurrenceException aar
		INNER JOIN appointment a ON a.AppointmentID = aar.AppointmentID
	WHERE a.PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 


	SET @time = GETDATE() SET @table_name ='Appointment'
	DELETE pjn
	FROM  dbo.Appointment pjn
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='PatientCaseDate'
	DELETE pjn
	FROM  dbo.PatientCaseDate pjn
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='PatientCaseToAttorney'
	DELETE pca
	FROM  dbo.PatientCase pc
		INNER JOIN PatientCaseToAttorney pca ON pc.patientCaseID = pca.PatientCaseID
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='PatientCase'
	DELETE pjn
	FROM  dbo.PatientCase pjn
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='PatientAlert'
	DELETE pa
	FROM  dbo.PatientAlert pa
		INNER JOIN patient p ON p.PatientID = pa.PatientID
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='Patient'
	
	DELETE dbo.Patient
	WHERE PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	--Doctor Chain
	SET @time = GETDATE() SET @table_name ='PracticeToInsuranceCompany'
	
	DELETE dbo.PracticeToInsuranceCompany 
	WHERE PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
--	SET @time = GETDATE() SET @table_name ='InsuranceCompanyPlan'
--	
--	DELETE ICPN
--	FROM dbo.InsuranceCompanyPlan ICPN INNER JOIN
--		dbo.ProviderNumber PN ON
--			ICPN.LocalUseProviderNumberTypeID = PN.ProviderNumberID INNER JOIN
--		dbo.Doctor D ON
--			PN.DoctorID = D.DoctorID
--	WHERE D.PracticeID not in (select practiceID from @practice )
--	
--	SET @rows = @@ROWCOUNT
--	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	SET @time = GETDATE() SET @table_name ='ProviderNumber'
	
	DELETE PN
	FROM dbo.ProviderNumber PN INNER JOIN
		dbo.Doctor D ON
			PN.DoctorID = D.DoctorID
	WHERE D.PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 

	SET @time = GETDATE() SET @table_name ='AppointmentToAppointmentReason'
	
	DELETE ATAR
	FROM [dbo].[AppointmentToAppointmentReason] ATAR
		INNER JOIN dbo.Appointment A
		ON ATAR.AppointmentID = A.AppointmentID
	WHERE A.PracticeID not in (select practiceID from @practice )

	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 

	SET @time = GETDATE() SET @table_name ='AppointmentReasonDefaultResource'
	
	DELETE ARDR
	FROM [dbo].[AppointmentReason] AR
		INNER JOIN dbo.AppointmentReasonDefaultResource ARDR
		ON AR.AppointmentReasonID = ARDR.AppointmentReasonID
	WHERE AR.PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	


	SET @time = GETDATE() SET @table_name ='TimeblockToAppointmentReason'
	DELETE tr
	FROM Timeblock t
		INNER JOIN TimeblockToAppointmentReason tr ON tr.TimeBlockID = t.TimeBlockID
	WHERE t.PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='AppointmentReason'
	
	DELETE [dbo].[AppointmentReason]
	WHERE PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @time = GETDATE() SET @table_name ='AppointmentToResource'
	
	DELETE ATR
	FROM [dbo].[AppointmentToResource] ATR
		INNER JOIN dbo.Appointment A
		ON ATR.AppointmentID = A.AppointmentID
	WHERE A.PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	


	SET @time = GETDATE() SET @table_name ='Appointment'
	
	DELETE A 
	FROM dbo.Appointment A 
	WHERE A.PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	SET @time = GETDATE() SET @table_name ='ContractToServiceLocation'
	DELETE csl
	FROM ContractToServiceLocation csl
		INNER JOIN CONTRACT c ON c.ContractID = csl.ContractID 
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 


	
	SET @time = GETDATE() SET @table_name ='ContractToInsurancePlan'
	DELETE csl
	FROM ContractToInsurancePlan csl
		INNER JOIN CONTRACT c ON c.ContractID = csl.ContractID 
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 


	SET @time = GETDATE() SET @table_name ='ContractToDoctor'
	DELETE csl
	FROM ContractToDoctor csl
		INNER JOIN CONTRACT c ON c.ContractID = csl.ContractID 
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	SET @time = GETDATE() SET @table_name ='ContractFeeSchedule'
	DELETE csl
	FROM ContractFeeSchedule csl
		INNER JOIN CONTRACT c ON c.ContractID = csl.ContractID 
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	SET @time = GETDATE() SET @table_name ='Contract'
	DELETE [CONTRACT]
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	




	--Standalone Deletes
	SET @time = GETDATE() SET @table_name ='HandheldEncounterDetail'
	DELETE i
	FROM dbo.HandheldEncounterDetail i 
		INNER JOIN HandheldEncounter he ON he.HandheldEncounterID = i.HandheldEncounterID
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name



	--Standalone Deletes
	SET @time = GETDATE() SET @table_name ='HandheldEncounter'
	
	DELETE dbo.HandheldEncounter
	WHERE PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @time = GETDATE() SET @table_name ='PracticeResource'
	
	DELETE dbo.PracticeResource 
	WHERE PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @time = GETDATE() SET @table_name ='ReportEdition'
	
	DELETE dbo.ReportEdition 
	WHERE PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @time = GETDATE() SET @table_name ='UserPractices'
	
	DELETE dbo.UserPractices
	WHERE PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	SET @time = GETDATE() SET @table_name ='DashboardKeyIndicatorDisplay'
	
	DELETE [dbo].[DashboardKeyIndicatorDisplay]
	WHERE PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	SET @time = GETDATE() SET @table_name ='DashboardKeyIndicatorVolatile'
	
	DELETE [dbo].[DashboardKeyIndicatorVolatile]
	WHERE PracticeID not in (select practiceID from @practice )
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='BusinessRule'
	DELETE [dbo].BusinessRule
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 




	SET @time = GETDATE() SET @table_name ='DMSFileInfo'
	DELETE d2
	FROM DMSFileInfo d2
		INNER JOIN DMSDocument d ON d.DMSDocumentID = d2.DMSDocumentID
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='DMSDocumentToRecordAssociation'
	DELETE d2
	FROM DMSDocumentToRecordAssociation d2
		INNER JOIN DMSDocument d ON d.DMSDocumentID = d2.DMSDocumentID
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 


	SET @time = GETDATE() SET @table_name ='DMSDocument'
	DELETE d2
	FROM DMSDocument d2
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 




	SET @time = GETDATE() SET @table_name ='UnappliedPayments'
	DELETE UnappliedPayments
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 





	SET @time = GETDATE() SET @table_name ='TimeblockRecurrence'
	DELETE tr
	FROM Timeblock t
		INNER JOIN TimeblockRecurrence tr ON tr.TimeBlockID = t.TimeBlockID
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='TimeblockRecurrenceException'
	DELETE tr
	FROM Timeblock t
		INNER JOIN TimeblockRecurrenceException tr ON tr.TimeBlockID = t.TimeBlockID
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 




	SET @time = GETDATE() SET @table_name ='TimeblockToAppointmentReason'
	DELETE tr
	FROM Timeblock t
		INNER JOIN TimeblockToAppointmentReason tr ON tr.TimeBlockID = t.TimeBlockID
	WHERE t.PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 


	SET @time = GETDATE() SET @table_name ='TimeblockToServiceLocation'
	DELETE tr
	FROM Timeblock t
		INNER JOIN TimeblockToServiceLocation tr ON tr.TimeBlockID = t.TimeBlockID
	WHERE t.PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 




	SET @time = GETDATE() SET @table_name ='Timeblock'
	DELETE Timeblock
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='CT_Deletions'
	DELETE CT_Deletions
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='DateKeyToPractice'
	DELETE DateKeyToPractice
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='ClearinghouseResponse'
	DELETE ClearinghouseResponse
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='BillTransmission'
	DELETE BillTransmission
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='AppointmentToResource'
	DELETE AppointmentToResource
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 


	SET @time = GETDATE() SET @table_name ='Category'
	DELETE Category
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='PaymentBusinessRuleLog'
	DELETE PaymentBusinessRuleLog
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 


	SET @time = GETDATE() SET @table_name ='PaymentRawEOB'
	DELETE PaymentRawEOB
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 

	SET @time = GETDATE() SET @table_name ='PracticeSettingsLog'
	DELETE PracticeSettingsLog
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='Encounter ReferringPhysicianID'	
	UPDATE e
	SET ReferringPhysicianID = NULL
	FROM dbo.Doctor d
		INNER JOIN [Encounter] e ON e.ReferringPhysicianID = d.doctorID
	WHERE d.PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'Updated ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 

	SET @time = GETDATE() SET @table_name ='Encounter DoctorID'	
	UPDATE e
	SET DoctorID = NULL
	FROM dbo.Doctor d
		INNER JOIN [Encounter] e ON e.DoctorID = d.doctorID
	WHERE d.PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'Updated ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 

	SET @time = GETDATE() SET @table_name ='PatientCase ReferringPhysicianID'	
	UPDATE e
	SET ReferringPhysicianID = NULL
	FROM dbo.Doctor d
		INNER JOIN PatientCase e ON e.ReferringPhysicianID = d.doctorID
	WHERE d.PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'Updated ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 



	SET @time = GETDATE() SET @table_name ='Patient ReferringPhysicianID'	
	UPDATE e
	SET ReferringPhysicianID = NULL
	FROM dbo.Doctor d
		INNER JOIN Patient e ON e.ReferringPhysicianID = d.doctorID
	WHERE d.PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'Updated ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 


	SET @time = GETDATE() SET @table_name ='Patient PrimaryProviderID'	
	UPDATE e
	SET PrimaryProviderID = NULL
	FROM dbo.Doctor d
		INNER JOIN Patient e ON e.PrimaryProviderID = d.doctorID
	WHERE d.PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'Updated ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 


	SET @time = GETDATE() SET @table_name ='Practice EOSupervisingProviderID'	
	UPDATE p
	SET EOSupervisingProviderID = NULL
	FROM Practice p
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'Updated ' + CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 





	ALTER TABLE dbo.Practice NOCHECK CONSTRAINT FK_Practice_EligibilityDefaultProviderID
	ALTER TABLE dbo.Practice NOCHECK CONSTRAINT FK_Practice_SchedulingDoctor
	ALTER TABLE dbo.Practice NOCHECK CONSTRAINT FK_Practice_RenderingDoctor
	ALTER TABLE dbo.Practice NOCHECK CONSTRAINT FK_Practice_ServiceLocation


	SET @time = GETDATE() SET @table_name ='Doctor'	
	DELETE dbo.Doctor
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 


	SET @time = GETDATE() SET @table_name ='ServiceLocation'
	DELETE dbo.ServiceLocation 
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	



	SET @time = GETDATE() SET @table_name ='Department'
	DELETE dbo.Department 
	WHERE PracticeID not in (select practiceID from @practice )
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
	
	
	ALTER TABLE dbo.Practice CHECK CONSTRAINT FK_Practice_EligibilityDefaultProviderID
	ALTER TABLE dbo.Practice CHECK CONSTRAINT FK_Practice_SchedulingDoctor
	ALTER TABLE dbo.Practice CHECK CONSTRAINT FK_Practice_RenderingDoctor
	ALTER TABLE dbo.Practice CHECK CONSTRAINT FK_Practice_ServiceLocation
	
			
	--Final Delete
	SET @time = GETDATE() SET @table_name ='Practice'
	
	DELETE dbo.Practice 
	WHERE PracticeID not in (select practiceID from @practice )
	
	SET @err_var = @@ERROR 
	
	SET @rows = @@ROWCOUNT
	PRINT 'elapse time: ' + CAST( DATEDIFF(s, @time, GETDATE()) AS VARCHAR ) + ' Deleted '+ CAST(ISNULL(@rows,0) AS varchar) + ' rows FROM table ' + @table_name 
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



				-- Trigger
				EXEC sp_MSForEachTable 'ALTER TABLE ? enable trigger ALL'

				-- enable referential integrity again
				EXEC sp_MSForEachTable 'ALTER TABLE ? CHECK CONSTRAINT ALL'




	
END
--SELECT @@TRANCOUNT
--rollback

