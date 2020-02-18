
					----------------------------------
					-- Addes the VendorID column if it doesn't already exist ----
					IF not exists( select Object_Name(id), * from sys.syscolumns where id = Object_ID('InsuranceCompany') and name = 'VendorID' )
						ALTER TABLE InsuranceCompany ADD VendorID varchar(50)

					IF not exists( select Object_Name(id), * from sys.syscolumns where id = Object_ID('InsuranceCompany') and name = 'VendorImportID' )
						ALTER TABLE InsuranceCompany ADD VendorImportID INT

					IF not exists( select Object_Name(id), * from sys.syscolumns where id = Object_ID('InsuranceCompanyPlan') and name = 'VendorID' )
						ALTER TABLE InsuranceCompanyPlan ADD VendorID varchar(50)

					IF not exists( select Object_Name(id), * from sys.syscolumns where id = Object_ID('InsuranceCompanyPlan') and name = 'VendorImportID' )
						ALTER TABLE InsuranceCompanyPlan ADD VendorImportID INT

					IF not exists( select Object_Name(id), * from sys.syscolumns where id = Object_ID('providerNumberType') and name = 'VendorID' )
						ALTER TABLE providerNumberType ADD VendorID varchar(50)

					IF not exists( select Object_Name(id), * from sys.syscolumns where id = Object_ID('providerNumberType') and name = 'VendorImportID' )
						ALTER TABLE providerNumberType ADD VendorImportID INT
					GO
					----------------------------------

--       Required Parameters
---------------------------------
DECLARE
	@SourceDBName varchar(200),
	@TargetDBName varchar(200),
	@ListOfStates	varchar(8000),
	@ImportSessionNote VARCHAR(8000)

 
SET	@SourceDBName =  'superbill_0001_prod' 
SET	@TargetDBName =  'superbill_0000_prod'
SET	@ListOfStates  =  '(  ''MA'', ''UT'' )'
SET @ImportSessionNote = 'Case ______ by developer: _____ '

	-- exmaple: @SourceDBName ='superbill_0001_dev' 
	-- example: @TargetDBName ='superbill_0108_dev'
	-- exmaple: @ListOfStates ='(  ''MA'', ''UT'' )'
----------------------------------



-- ********  Start of Process ********* --


Declare 
	@TableName varchar(200),
	@colSQLIC varchar(8000),
	@colSQLICP varchar(8000),
	@UniqueIndexCol varchar(8000),
	@SQLFrom varchar(8000),
	@SQLWhere varchar(8000),
	@Cnt INT, 
	@errorMsg INT,
	@ImportVendorName VARCHAR(8000)
	
SET @ImportVendorName = 'Import from ' + @SourceDBName + ' to ' + @TargetDBName

			-- Gets a list of columns from the InsuranceCompany Table and inserts into a temp table
			CREATE TABLE #TargetICColumnInfo  ( Name varchar(8000), xtype int)
			INSERT #TargetICColumnInfo(Name, xtype)
			EXEC( 'SELECT c.name, c.xtype 
					FROM ' + @TargetDBName + '.sys.sysobjects s inner join ' + 
					@TargetDBName + '.sys.syscolumns c on s.id = c.id
					WHERE
						c.name not in (''DefaultAdjustmentCode'', ''InsuranceCompanyID'', ''VendorImportID'', ''VendorID'', ''CreatedPracticeID'', ''ReviewCode'') and
						s.type = ''U'' and 
						c.xtype <> 189 and c.status <> 128 AND
						s.id = Object_ID( ''' + @TargetDBName + '.dbo.InsuranceCompany'')'
				)
			SELECT @colSQLIC =  isnull(@colSQLIC + ', ' + t.name, t.name)	
			FROM #TargetICColumnInfo  t 



			-- Gets a list of columns from the InsuranceCompanyPlan Table and inserts into a temp table
			CREATE TABLE #TargetICPColumnInfo  ( Name varchar(8000), xtype int)
			INSERT #TargetICPColumnInfo(Name, xtype)
			EXEC( 'SELECT c.name, c.xtype 
					FROM ' + @TargetDBName + '.sys.sysobjects s inner join ' + 
					@TargetDBName + '.sys.syscolumns c on s.id = c.id
					WHERE
						c.name not in (''DefaultAdjustmentCode'', ''InsuranceCompanyID'', ''ReviewCode'', ''VendorImportID'') and
						s.type = ''U'' and 
						c.xtype <> 189 and c.status <> 128 and 
						s.id = Object_ID( ''' + @TargetDBName + '.dbo.InsuranceCompanyPlan'')'
				)
			SELECT @colSQLICP =  isnull(@colSQLICP + ', ' + t.name, t.name)	
			FROM #TargetICPColumnInfo  t 


DECLARE @whereState_IC VARCHAR(8000)
DECLARE @whereState_ICP VARCHAR(8000)

SET @whereState_IC = ISNULL( 'where InsuranceCompanyID IN ( SELECT InsuranceCompanyID as icpState FROM ' + @SourceDBName + '.dbo.InsuranceCompanyPlan WHERE state in ' + @ListOfStates + ')', '')
SET @whereState_ICP = ISNULL( 'AND icp.state in ' + @ListOfStates, '')



-- Script to insert
exec (
		'
BEGIN TRAN MyTran
BEGIN TRY


DECLARE @VendorImportID INT

			INSERT INTO ' + @TargetDBName + '.dbo.VendorImport(VendorName, DateCreated, Notes, VendorFormat)
			VALUES(''' + @ImportVendorName + ''',GETDATE(),''' + @ImportSessionNote + ''', ''KAREO'')
			SET @VendorImportID=@@IDENTITY	

			INSERT INTO ' + @TargetDBName + '.dbo.providerNumberType ( ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder,VendorImportID)
			SELECT s.ProviderNumberTypeID, s.TypeName, s.ANSIReferenceIdentificationQualifier, s.SortOrder, @VendorImportID	
			from  ' + @SourceDBName + '.dbo.providerNumberType s
				LEFT OUTER JOIN  ' + @TargetDBName + '.dbo.providerNumberType t on s.providerNumberTypeID = t.providerNumberTypeID
			WHERE t.providerNumberTypeID is null


			INSERT into ' + @TargetDBName + '.dbo.InsuranceCompany  ( VendorImportID, VendorID, CreatedPracticeID, ReviewCode, ' + @colSQLIC + ' )
			SELECT @VendorImportID, InsuranceCompanyID, NULL, ''R'', ' + @colSQLIC + '
			FROM ' + @SourceDBName + '.dbo.InsuranceCompany 
				' + @whereState_IC + '


			
			INSERT into ' + @TargetDBName + '.dbo.InsuranceCompanyPlan ( InsuranceCompanyID, ReviewCode, VendorImportID, '+ @colSQLICP +' )
			SELECT IC_InsuranceCompanyID, ''R'', @VendorImportID, ' + @colSQLICP +'
			FROM ' + @SourceDBName + '.dbo.InsuranceCompanyPlan icp INNER JOIN 
				(SELECT VendorID as ic_VendorID, VendorImportID as ic_VendorImportID, InsuranceCompanyID AS IC_InsuranceCompanyID FROM ' + @TargetDBName + '.dbo.InsuranceCompany ) AS ic ON ic.IC_VendorID = icp.InsuranceCompanyID
			WHERE ic.IC_VendorImportID = @VendorImportID
				' + @whereState_ICP + '

			commit Tran MyTran
End Try

BEGIN Catch

	PRINT ''rolling back. Error log....''
    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_PROCEDURE() AS ErrorProcedure,
        ERROR_LINE() AS ErrorLine,
        ERROR_MESSAGE() AS ErrorMessage;

	Rollback Tran MyTran
End Catch'
)

		drop table #TargetICColumnInfo, #TargetICPColumnInfo
	
