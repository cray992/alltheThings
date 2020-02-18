-- customer 1539
SET ANSI_WARNINGS OFF
/*

set ANSI_NULLS ON
GO


select * into tempdb.dbo.Prasad_PatientDemoImport
from tempdb.dbo.Prasad_PatientDemoImport
*/

begin tran myTran

BEGIN TRY

	declare @vendorImportID int

	insert into vendorImport (VendorName,VendorFormat, DateCreated,Notes)
	values(  'Custom Excel', 'Excel', getdate(), 'by Phong Le' )
	set @vendorImportID = @@identity


	INSERT INTO [dbo].[Patient]
		(
		prefix,
		Suffix,
		MiddleName,
		[PracticeID],
		[FirstName],
		[LastName],
		[AddressLine1],
		[AddressLine2],
		[City],
		[State],
		[ZipCode],
		[HomePhone],
		[DOB],
		[Gender],
		[ResponsibleDifferentThanPatient],
		[ResponsibleFirstName],
		[ResponsibleLastName],
		[ResponsibleAddressLine1],
		[ResponsibleAddressLine2],
		[ResponsibleCity],
		[ResponsibleState],
		[ResponsibleZipCode],
		[VendorID],
		MedicalRecordNumber,
		VendorImportID,
		CollectionCategoryID 
		)
	    

	       
	SELECT distinct
		   '',
		   '',
		   '',
			1,
		   [FirstName],
		   [LastName],
		   [Address1],
		   [Address2],
		   [City],
		   [State],
		   [Zip],
		   [Phone],
		   [DOB],
		   [Gender],  
		   0,
		   GuarFirstName = case when charindex(',', [GuarName]) > 0 then RIGHT(guarName, len(GuarName) - charindex(',', [GuarName])) else NULL END,
		   GuarLastName = case when charindex(',', [GuarName]) > 0 then left(guarName, charindex(',', [GuarName])-1) else NULL END,
		   [GuarAddr1],
		   [GuarAddr2],
		   [GuarCity],
		   [GuarState],
		   [GuarZip],
		   [MRN],
		   [MRN],
		   @vendorImportID,
			1
	from tempdb.dbo.Prasad_PatientDemoImport



	update Patient
	set ResponsibleDifferentThanPatient = 1
	where VendorID is not null
			and NOT (firstName = ResponsibleFirstName or ResponsibleLastName = LastName )




	-- Self Pay
	INSERT INTO [PatientCase]
			   ([PatientID]
			   ,[Name]
			   ,[Active]
			   ,[PayerScenarioID]
			   ,[CreatedUserID]
			   ,[ModifiedUserID]
			   ,[PracticeID]
				,VendorImportID
				   )
	               
	select
	patientID,	
	'DEFAULT CASE',
	1,
	11,
	951,
	951,
	1,
	@VendorImportID
	from Patient
	where VendorID is not null







	select distinct
			identity(int,1,1) as rowid,
			planName
	INTO #planName
	FROM tempdb.dbo.Prasad_PatientDemoImport
	where planName <> ''


	declare @planName VARCHAR(max), @rowID INT, @maxRowID INT, @sqlStr VARCHAR(max), @insuranceCompanyID int
	select @maxRowID = count(*) FROM #planName
	SELECT @rowID = 1
	while @rowID<=@maxRowID
	BEGIN

			 select @planName = planName from #planName where rowID = @rowID
	         
	         
			set @sqlStr = 
					'exec InsurancePlanDataProvider_CreateInsuranceCompany @zip=N'''',@AcceptAssignment=1,@review_code=N''R'',@notes=NULL,@ClearinghousePayerID=NULL,@phone=NULL,@eclaims_disable=0,@SecondaryPrecedenceBillingFormID=13,
							@provider_number_type_id=NULL,@name=N''{planName}'',@fax_x=NULL,@local_use_provider_number_type_id=NULL,@ExcludePatientPayment=0,
							@bill_secondary_insurance=0,@EClaimsAccepts=0,@contact_suffix=NULL,@street_1=N'''',@street_2=N'''',@DefaultAdjustmentCode=NULL,
							@phone_x=NULL,@contact_first_name=NULL,@eclaims_enrollment_status_id=NULL,@UseCoordinationOfBenefits=1,@UseSecondaryElectronicBilling=0,
							@referring_provider_number_type_id=NULL,@program_code=N''CI'',@state=N'''',@UseFacilityID=1,@practice_id=1,@contact_middle_name=NULL,@group_number_type_id=NULL,@fax=NULL,
							@contact_last_name=NULL,@hcfa_diag_code=N''C'',@contact_prefix=NULL,@city=N'''',
							@AnesthesiaType=N''U'',@hcfa_same_code=N''D'',@country=N'''',@BillingFormID=13
							'
			set @sqlStr = replace(@sqlStr, '{planName}', @planName)
			exec( @sqlStr )
	        
			select @insuranceCompanyID = InsuranceCompanyID from InsuranceCompany where InsuranceCompanyName = @planName
	        
			set @sqlStr = 
			'exec InsurancePlanDataProvider_CreateInsurancePlan @company_id={insuranceCompanyID},
					@street_1=N'''',@program_code=N''CI'',@street_2=N'''',@deductible=0,@fax_x=NULL,
					@phone=NULL,@contact_suffix=NULL,@review_code=N'''',@phone_x=NULL,@contact_last_name=NULL,@city=N'''',
					@fax=NULL,@state=N'''',@notes=NULL,@contact_prefix=NULL,@name=N''{planName}'',@country=N'''',@contact_first_name=NULL,
					@copay=0,@zip=N'''',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL'
			set @sqlStr = replace(@sqlStr, '{planName}', @planName)
			set @sqlStr = replace(@sqlStr, '{insuranceCompanyID}', @insuranceCompanyID)
			exec( @sqlStr )
	        
	        
			set @rowID = @rowID + 1
	END

	drop TABLE #planName

	INSERT INTO [InsurancePolicy]
			   (
			   [PatientCaseID]
			   ,[InsuranceCompanyPlanID]
			   ,[Precedence]
			   ,[PolicyNumber]
			   ,[GroupNumber]
			   ,[CreatedUserID]
			   ,[ModifiedUserID]
			   ,[Active]
			   ,[PracticeID]
			   ,[VendorID]
			   ,PatientRelationshipToInsured
				,VendorImportID
			   )

	select  pc.PatientCaseID,
			icp.InsuranceCompanyPlanID,
			isnull( (select count(rowid) from tempdb.dbo.Prasad_PatientDemoImport ip2 where ip2.MRN = d.MRN and ip2.rowid <= d.rowid ),0),
			PolicyNumber,
			GroupNumber,
			951,
			951,
			1,
			1,
			p.VendorID,
			'S',
			3
	From PatientCase pc
			inner join Patient p on p.PatientID = pc.PatientID
			inner join tempdb.dbo.Prasad_PatientDemoImport d on d.MRN = p.VendorID
			inner join InsuranceCompanyPlan icp on icp.PlanName = d.PlanName
	where p.VendorID is not null
	and d.PlanName <> ''


	commit transaction myTran
END TRY
BEGIN Catch
	rollback transaction myTran
select 'error'

				DECLARE @ErrorMessage NVARCHAR(4000);
				DECLARE @ErrorSeverity INT;
				DECLARE @ErrorState INT;

				SELECT @ErrorMessage = ERROR_MESSAGE(),
					   @ErrorSeverity = ERROR_SEVERITY(),
					   @ErrorState = ERROR_STATE();

				-- Use RAISERROR inside the CATCH block to return 
				-- error information about the original error that 
				-- caused execution to jump to the CATCH block.
				RAISERROR (@ErrorMessage, -- Message text.
						   @ErrorSeverity, -- Severity.
						   @ErrorState -- State.
						   );

END catch





/*

select * from practice


select  pc.PatientCaseID, p.VendorID, count(*)
From PatientCase pc
        inner join Patient p on p.PatientID = pc.PatientID
        inner join dataimport_staging.dbo.Prasad_PatientDemo d on d.MRN = p.VendorID
--        inner join InsuranceCompanyPlan icp on icp.PlanName = d.PlanName
where p.VendorID is not null
and d.PlanName <> ''
group by pc.PatientCaseID, p.VendorID
having Count(*) > 1        




select * from tempdb.dbo.Prasad_PatientDemoImport
where firstName = '0000'


delete dataimport_staging.dbo.Prasad_PatientDemo
where rowid in (5036
)

select * from Patient
where VendorID = 'PRS00153'









return



select * from dataimport_staging.dbo.Prasad_PatientDemoImport where mrn = 'PRS00165'

select * from Patient

select top 5 * from PatientCase


select * from InsuranceCompany
select * from InsuranceCompanyPlan
select * from InsurancePolicy

select * from practice

*/


