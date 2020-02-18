IF EXISTS (
	SELECT	*
	FROM	sysobjects
	WHERE	Name = 'tr_IU_InsurancePolicy_ChangeTime'
	AND	type = 'TR'
)
	DROP TRIGGER dbo.tr_IU_InsurancePolicy_ChangeTime
GO

--===========================================================================
-- TR -- IU -- InsurancePolicy -- CHANGE TIME
--===========================================================================
CREATE TRIGGER tr_IU_InsurancePolicy_ChangeTime ON InsurancePolicy
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @error_var int
	SET @error_var = 0
	DECLARE @proc_name sysname
    	SET @proc_name = (SELECT name FROM sysobjects WHERE id = @@PROCID)
	DECLARE @CRLF char(2)
    	SET @CRLF = CHAR(13) + CHAR(10)
    
	DECLARE @err_message nvarchar(255)

	IF UPDATE(PolicyStartDate)
	BEGIN
		UPDATE IP
			SET PolicyStartDate =  dbo.fn_ReplaceTimeInDate(i.PolicyStartDate)
		FROM InsurancePolicy IP INNER JOIN
			inserted i ON
				IP.InsurancePolicyID = i.InsurancePolicyID

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	IF UPDATE(PolicyEndDate)
	BEGIN
		UPDATE IP
			SET PolicyEndDate =  dbo.fn_ReplaceTimeInDate(i.PolicyEndDate)
		FROM InsurancePolicy IP INNER JOIN
			inserted i ON
				IP.InsurancePolicyID = i.InsurancePolicyID

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	RETURN
	
rollback_tran:
	IF @err_message IS NULL
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)
	ELSE
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)  + @CRLF + @CRLF + @err_message

	IF @@TRANCOUNT > 0
    		ROLLBACK TRANSACTION

	RAISERROR(@err_message, 16,1)

	RETURN
END
GO

UPDATE InsurancePolicy SET PolicyStartDate=PolicyStartDate, PolicyEndDate=PolicyEndDate