
-- Clean Dr_Pat_Ins_Data
-- CHANGE DATABASE AND SET VARIABLES

USE ImportSpec -- %%%%%%%%%%%%%%%%%   CHANGE DATABASE   %%%%%%%%%%%%%%%%%

SET NOCOUNT ON

IF OBJECT_ID('tempdb..#Vars') IS NOT NULL
	DROP TABLE [#Vars]

CREATE TABLE #Vars(VarName varchar(50), VarValue varchar(200))

-- %%%%%%%%%%%  SET VARIABLES    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
INSERT INTO #Vars (VarName, VarValue) VALUES ('x_Appt', 'ZZZZ_AdamsWood')

-- ==================================================================
	IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'x_Appt')
		DROP SYNONYM [dbo].[x_Appt]
    GO
-- ==================================================================
	DECLARE @x_Appt varchar(50)
	SELECT @x_Appt = VarValue FROM #Vars WHERE VarName = 'x_Appt'
    EXEC ('Create Synonym x_Appt For ' + @x_Appt)

--===================================================================

	IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@x_Appt) and name='InsuranceProgramCode')
		EXEC ('ALTER TABLE ' + @x_Appt + ' ADD InsuranceProgramCode varchar(50)')

-- ==================================================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetNumberImport]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fn_GetNumberImport]
BEGIN
	execute dbo.sp_executesql @statement = N'
	CREATE FUNCTION [dbo].[fn_GetNumberImport]( @string Varchar(255) )
	RETURNS Varchar(20)
	AS
	BEGIN
		DECLARE @number Varchar(20)
		DECLARE @OldString VARCHAR(255)

		SET @OldString = @string + ''a''
		WHILE LEN(@OldString) > LEN(@String)
			BEGIN
				SET @OldString = @string
				SET	@string = REPLACE(@string, SUBSTRING(@string, PATINDEX(''%[^0-9]%'', @string), 1), '''')
			END

		SET @string = Replace( @string , ''('' , '''' )
		SET @string = Replace( @string , '')'' , '''' )
		SET @string = Replace( @string , ''-'' , '''' )
		SET @string = Replace( @string , '' '' , '''' )
		SET @string = Replace( @string , '','' , '''' )
		SET @string = Replace( @string , ''.'' , '''' )
		SET @string = Replace( @string , ''$'' , '''' )
		SET @string = Replace( @string , ''%'' , '''' )
		SET @string = Replace( @string , ''_'' , '''' )
		SET @string = Replace( @string , ''*'' , '''' )
		SET @string = Replace( @string , ''CHAR(39)'' , '''' )

		If LTrim( RTrim( @string ) ) = ''''
			Select @string = Null

		SET @number = LEFT( @string , 20 )

		RETURN @number
	END
	' 
END
GO
--===================================================================














