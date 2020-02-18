IF EXISTS (
	SELECT	*
	FROM	sysobjects
	WHERE	Name = 'tr_IU_Contract_ChangeTime'
	AND	type = 'TR'
)
	DROP TRIGGER dbo.tr_IU_Contract_ChangeTime
GO

--===========================================================================
-- TR -- IU -- CONTRACT -- CHANGE TIME
--===========================================================================
CREATE TRIGGER tr_IU_Contract_ChangeTime ON dbo.Contract
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

	IF UPDATE(EffectiveStartDate) OR UPDATE(EffectiveEndDate)
	BEGIN
		UPDATE C SET
			EffectiveStartDate =  dbo.fn_ReplaceTimeInDate(i.EffectiveStartDate),
			EffectiveEndDate =  dbo.fn_ReplaceTimeInDate(i.EffectiveEndDate)
		FROM dbo.[Contract] C INNER JOIN
			inserted i ON
				C.ContractID = i.ContractID

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
