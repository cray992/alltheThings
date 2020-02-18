--===========================================================================
--
-- Replicate Patients
--
--===========================================================================

IF EXISTS (
	SELECT	*
	FROM 	SYSOBJECTS
	WHERE	Name = 'PracticeDataProvider_ReplicatePatients'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.PracticeDataProvider_ReplicatePatients
GO



IF EXISTS (
	SELECT	*
	FROM 	SYSOBJECTS
	WHERE	Name = 'fn_returndoctorid'
	AND	TYPE = 'FN'
)
	DROP Function dbo.fn_returndoctorid
GO

----Function Declaration for Primary doctor

CREATE FUNCTION dbo.fn_returndoctorid
(
@strLName varchar(50) ,
@strFName varchar(50),
@strAddr varchar(50),
@strCity varchar(50),
@dest int,
@src int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	Declare @result int;
	Declare @cnt	int;	
	Declare @numPri int;
	if @strLName = null or @strFName = null
			set @result = null
	else
	Begin
		-- Add the T-SQL statements to compute the return value here
		SELECT @result = doctorid from doctor where @strLName = lastname
												and @strFname = firstname
												and isnull(@strAddr,'') = isnull(addressline1,'')
												and isnull(@strCity,'') = isnull(city,'')
												and practiceid =  @dest
												and [external] = 0


		
		
		--first ck if there is more than one in the destination
		 SELECT @cnt = count(doctorid) from doctor where @strLName = lastname
												and @strFname = firstname
												and isnull(@strAddr,'') = isnull(addressline1,'')
												and isnull(@strCity,'') = isnull(city,'')
												and practiceid =  @dest
												and [external] = 0
		if @cnt > 1 
			set @result = null
		
		--then check if more than one primary in dest
		select @numPri = count(*) from doctor 
										where  practiceid =  @dest
												and [external] = 0 
		if @numPri > 1
			set @result = null

		
	
		else
			Begin 
				if @cnt = 0 and @numPri = 1 
				--we might want to change this later to allow for copy of doctor over 
				
				set @result = null
			End									
												
	end
	-- Return the result of the function
	RETURN @result

END
GO



--===========================================================================
-- Replicate Patients
--===========================================================================

create procedure PracticeDataProvider_ReplicatePatients( 
@srcPractice int ,
@destPractice int ,
@strCriteria Varchar(8000),
@ReplicateReferring bit = 0,
@VendorImportID int = Null
)
as 
/**********************************************************************************************
**NOTE:  if all criteria string field values must be encapsulated like so... 'lastname = ''brown'''

usage : begin transaction
		exec PracticeDataProvider_ReplicatePatients 92, 125,'',1,388
		rollback
		commit

**********************************************************************************************/
declare @Primary int;

BEGIN
	IF @srcPractice is null or @srcPractice = @destPractice --if no souce we exit or if source is destination
		BEGIN
			RAISERROR (N'Critical Error Source Contract ID Must be Provided 
						 Or Source cannot be Destination... Exiting %s %d.', -- Message text.
					   10, -- Severity,
					   1, -- State,
					   N'', -- First argument.
					   10);
			RETURN 0;
		END

	drop table ##PatientTmp;

	--if there is no criteria then we just get all the patients from the source
	if @strCriteria is null or @strCriteria = ''
		exec ('select * into ##PatientTmp from Patient with (nolock) where practiceid = '+ @srcPractice);	
	
	else 
		exec ('select * into ##PatientTmp from Patient with (nolock) where '+ @strCriteria + ' and practiceid = '+ @srcPractice);
		--Get all Patients that dont exist in dest.
	
	--build referring doctor list
	Declare @Doctors Table(
			refDoctorid int
			)
	
	
		

	select * into #PatientDest from ##PatientTmp p with (nolock) where p.practiceid = @srcPractice
								and	not exists(select * from patient tmp with (nolock)
												where  p.lastname = tmp.lastname
													 and p.firstname  = tmp.firstname
													 and isnull(p.addressline1,'') = isnull(tmp.addressline1,'')
													 and tmp.practiceid = @destPractice
													  )
								
	order by lastname, firstname;

	--select * from #patientdest

	--get all referring doctors 
	insert into @Doctors select distinct referringphysicianid from #PatientDest
									--where referringphysicianid <>  primarycarephysicianid 
	
	
	select distinct refDoctorid into #srcDoctors from @Doctors ref where not exists( select  Doctorid from Doctor d
																			where isnull(d.Doctorid,'') = isnull(ref.refDoctorid,'')
																				  and d.practiceid = @destPractice)
	order by 1


					
													
																		

	--check for primary physician
	--if ( select count(*) from doctor where practiceid = @destPractice) > 1 or ( select count(*) from doctor where practiceid = @destPractice) = 0
	--set @Primary = null;
	--else
	--	Begin 
	--		select @Primary = doctorid from doctor where practiceid = @destPractice;
	--	end
	
	--update the new patients with newpractice and primary phys.
	update #PatientDest set practiceid = @destPractice
						,PrimarycarephysicianID = dbo.fn_returndoctorid(lastname,firstname,addressline1,city,@destPractice,@srcPractice)
						,vendorimportid = @vendorimportid;
	
	--select * from #PatientDest
	--order by PatientId;
						
	--get case records
	select * into #PatientCase from patientcase pc with (nolock)
										where patientid in (select patientid from #PatientDest)
										and practiceid = @srcPractice;
	

	--change the destination practice
	update #PatientCase set practiceid = @destPractice
						,Vendorimportid = @vendorimportid;
	--select * from #PatientCase
	--order by patientid,patientcaseid;
	
	--get the policy records
	
	select * into #Policy from insurancepolicy ip with (nolock)
								where patientcaseid in ( select PatientcaseId from #PatientCase )
								and practiceid = @srcPractice;

	update #Policy set practiceid = @destPractice
					,Vendorimportid = @vendorimportid;

	--select * from #Policy
	--order by Patientcaseid,Insurancepolicyid;

	--Check to see if we copy the referring phys.
	if @ReplicateReferring = 0 
	Begin
			update #PatientDest set referringphysicianid = null
			update #PatientCase set referringphysicianid = null
	End
	
	Else
	Begin
			--insert referring physicians here
			insert into Doctor(	PracticeID,
								Prefix,
								FirstName,
								MiddleName,
								LastName,
								Suffix,
								SSN,
								AddressLine1,
								AddressLine2,
								City,
								State,
								Country,
								ZipCode,
								HomePhone,
								HomePhoneExt,
								WorkPhone,
								WorkPhoneExt,
								PagerPhone,
								PagerPhoneExt,
								MobilePhone,
								MobilePhoneExt,
								DOB,
								EmailAddress,
								Notes,
								ActiveDoctor,
								CreatedDate,
								CreatedUserID,
								ModifiedDate,
								ModifiedUserID,
								UserID,
								Degree,
								DefaultEncounterTemplateID,
								TaxonomyCode,
								VendorID,
								VendorImportID,
								DepartmentID,
								FaxNumber,
								FaxNumberExt,
								OrigReferringPhysicianID,
								[External]
			)
				select		@destPractice,
							src.Prefix,
							src.FirstName,
							src.MiddleName,
							src.LastName,
							src.Suffix,
							src.SSN,
							src.AddressLine1,
							src.AddressLine2,
							src.City,
							src.State,
							src.Country,
							src.ZipCode,
							src.HomePhone,
							src.HomePhoneExt,
							src.WorkPhone,
							src.WorkPhoneExt,
							src.PagerPhone,
							src.PagerPhoneExt,
							src.MobilePhone,
							src.MobilePhoneExt,
							src.DOB,
							src.EmailAddress,
							src.Notes,
							src.ActiveDoctor,
							src.CreatedDate,
							src.CreatedUserID,
							src.ModifiedDate,
							src.ModifiedUserID,
							src.UserID,
							src.Degree,
							src.DefaultEncounterTemplateID,
							src.TaxonomyCode,
							src.DoctorId,
							@VendorImportID,
							src.DepartmentID,
							src.FaxNumber,
							src.FaxNumberExt,
							src.OrigReferringPhysicianID,
							src.[External] from Doctor src with (nolock) 
							join #srcDoctors destpatdoc with (nolock) on destpatdoc.refdoctorid = src.doctorid
							join Doctor dest with (nolock) on dest.doctorid = src.doctorid
							and not exists (select * from doctor dest with (nolock) where upper(dest.lastname) = upper(src.lastname)
																and upper(dest.firstname) = upper(src.firstname)
																and upper(dest.AddressLine1) = upper(src.AddressLine1)
																and upper(dest.City) = upper(src.City)
																and upper(dest.State) = upper(src.State)
																and dest.practiceid = @destPractice )
							where src.Practiceid = @srcPractice
			Print 'Rows Added in Destination Doctor Table ' + Replicate( '.' , 75 - Len( 'Rows Added in Destination Doctor Table' ) ) + ' ' + Convert( Varchar(10) , @@RowCount )
			
--***Remember to insert the Service Locations here

			insert into 
			providernumber( d.DoctorID,
							ProviderNumberTypeID,
							InsuranceCompanyPlanID,
							LocationID,
							ProviderNumber,
							AttachConditionsTypeID )

					select  d.DoctorID,
							ProviderNumberTypeID,
							InsuranceCompanyPlanID,
							null,
							ProviderNumber,
							AttachConditionsTypeID
					from providernumber pvn
					join Doctor d with (nolock) on d.vendorid = pvn.doctorid
												and d.practiceid = @destPractice 
					

			Print 'Rows Added in ProviderNumber Table ' + Replicate( '.' , 75 - Len( ' Rows Added in ProviderNumber Table ' ) ) + ' ' + Convert( Varchar(10) , @@RowCount )



	End				

	--insert new Patients records
	insert into Patient
	(PracticeID, ReferringPhysicianID, Prefix, FirstName, MiddleName, LastName, Suffix, AddressLine1, AddressLine2, City, State, Country, ZipCode, Gender, MaritalStatus, HomePhone, HomePhoneExt, WorkPhone, WorkPhoneExt, DOB, SSN, EmailAddress, 
	ResponsibleDifferentThanPatient, ResponsiblePrefix, ResponsibleFirstName, ResponsibleMiddleName, ResponsibleLastName, 
	ResponsibleSuffix, ResponsibleRelationshipToPatient, ResponsibleAddressLine1, ResponsibleAddressLine2, ResponsibleCity, 
	ResponsibleState, ResponsibleCountry, ResponsibleZipCode, CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, 
	EmploymentStatus, InsuranceProgramCode, PatientReferralSourceID, PrimaryProviderID, DefaultServiceLocationID, EmployerID, 
	MedicalRecordNumber, MobilePhone, MobilePhoneExt, PrimaryCarePhysicianID, VendorID, VendorImportID)
	select 
	@DestPractice,  ref.Doctorid , pdest.Prefix, pdest.FirstName, pdest.MiddleName, pdest.LastName, pdest.Suffix, 
pdest.AddressLine1, pdest.AddressLine2, pdest.City, pdest.State, pdest.Country,pdest.ZipCode, pdest.Gender, pdest.MaritalStatus, 
pdest.HomePhone, pdest.HomePhoneExt, pdest.WorkPhone, pdest.WorkPhoneExt, pdest.DOB, pdest.SSN, pdest.EmailAddress, 
	pdest.ResponsibleDifferentThanPatient,pdest.ResponsiblePrefix, pdest.ResponsibleFirstName, pdest.ResponsibleMiddleName, pdest.ResponsibleLastName, 
	pdest.ResponsibleSuffix, pdest.ResponsibleRelationshipToPatient, pdest.ResponsibleAddressLine1, pdest.ResponsibleAddressLine2, pdest.ResponsibleCity, 
	pdest.ResponsibleState, pdest.ResponsibleCountry, pdest.ResponsibleZipCode, GetDate(), pdest.CreatedUserID, 
		GetDate(), pdest.ModifiedUserID, 
	pdest.EmploymentStatus, pdest.InsuranceProgramCode, pdest.PatientReferralSourceID, pdest.primarycarephysicianid, pdest.DefaultServiceLocationID, pdest.EmployerID, 
	pdest.MedicalRecordNumber, pdest.MobilePhone, pdest.MobilePhoneExt, pdest.primarycarephysicianid, pdest.PatientID, @VendorImportID 
	from #PatientDest pdest
			left join doctor ref with (nolock) on ref.vendorid = pdest.referringphysicianid
										and ref.practiceid = @destpractice

	Print 'Rows Added in Patient Table ' + Replicate( '.' , 75 - Len( 'Rows Added in Patient Table ' ) ) + ' ' + Convert( Varchar(10) , @@RowCount )
		
	
	--insert journal notes
	insert into PatientJournalNote(		
				CreatedDate,
				CreatedUserID,
				ModifiedDate,
				ModifiedUserID,
				PatientID,
				UserName,
				SoftwareApplicationID,
				Hidden,
				NoteMessage,
				AccountStatus)

	select 	pj.CreatedDate,
			pj.CreatedUserID,
			pj.ModifiedDate,
			pj.ModifiedUserID,
			pdest.PatientID,
			pj.UserName,
			pj.SoftwareApplicationID,
			pj.Hidden,
			pj.NoteMessage,
			pj.AccountStatus
	from patientjournalnote pj with (nolock)
					join patient pdest on pdest.vendorid = pj.patientid
											and pdest.practiceid = @destPractice

	Print 'Rows Added in Patient Journal Table ' + Replicate( '.' , 75 - Len( 'Rows Added in Patient Journal Table ' ) ) + ' ' + Convert( Varchar(10) , @@RowCount )
	


--select * from  Patienttmp where vendorimportid = @vendorimportid
								
	
	--Insert the Patient Cases

	insert into PatientCase (PatientID, [Name], Active, PayerScenarioID,PatientCasetmp.ReferringPhysicianID, EmploymentRelatedFlag, 
	AutoAccidentRelatedFlag, OtherAccidentRelatedFlag, AbuseRelatedFlag, AutoAccidentRelatedState, 
	Notes, ShowExpiredInsurancePolicies, CreatedDate, PatientCasetmp.CreatedUserID, ModifiedDate, PatientCasetmp.ModifiedUserID, PracticeID, 
	CaseNumber, WorkersCompContactInfoID, VendorID, VendorImportID, PregnancyRelatedFlag,StatementActive,EPSDT,FamilyPlanning)

	select p.patientid, [Name], Active, PayerScenarioID, p.ReferringPhysicianID, EmploymentRelatedFlag, 
	AutoAccidentRelatedFlag, OtherAccidentRelatedFlag, AbuseRelatedFlag, AutoAccidentRelatedState, 
	Notes, ShowExpiredInsurancePolicies, GetDate(), pc.CreatedUserID, GetDate(), pc.ModifiedUserID, @DestPractice, 
	CaseNumber, WorkersCompContactInfoID, Pc.PatientCaseID, @VendorImportID, PregnancyRelatedFlag,StatementActive,EPSDT,FamilyPlanning
	from #PatientCase Pc
			Join Patient P with (nolock) on p.vendorid = pc.patientid
							     and p.practiceid  = @destPractice
	

	

	Print 'Rows Added in PatientCase Table ' + Replicate( '.' , 75 - Len( 'Rows Added in Patient Case Table ' ) ) + ' ' + Convert( Varchar(10) , @@RowCount )
	--select * from #PatientCase where name like '%6-%'

	--insert the policies

	insert into InsurancePolicy (PatientCaseID, InsuranceCompanyPlanID, Precedence, PolicyNumber, GroupNumber, PolicyStartDate, 
	PolicyEndDate, CardOnFile, PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, 
	HolderLastName, HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName, PatientInsuranceStatusID, 
	CreatedDate, createduserid,ModifiedDate,modifieduserid, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, HolderState, 
	HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber, Notes, Phone, PhoneExt, Fax, 
	FaxExt, Copay, Deductible, PatientInsuranceNumber, Active, PracticeID, AdjusterPrefix, AdjusterFirstName, 
	AdjusterMiddleName, AdjusterLastName, AdjusterSuffix,vendorimportid)

	select                        pc.patientcaseid, InsuranceCompanyPlanID, Precedence, PolicyNumber, GroupNumber, PolicyStartDate, 
	PolicyEndDate, CardOnFile, PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, 
	HolderLastName, HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName, PatientInsuranceStatusID, 
	Pol.CreatedDate,pol.createduserid, Pol.ModifiedDate,pol.modifieduserid ,HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, HolderState, 
	HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber, Pol.Notes, Phone, PhoneExt, Fax, 
	FaxExt, Copay, Deductible, PatientInsuranceNumber, Pol.Active, @destPractice, AdjusterPrefix, AdjusterFirstName, 
	AdjusterMiddleName, AdjusterLastName, AdjusterSuffix,@vendorimportid
	from  #Policy Pol
			join Patientcase pc with (nolock) on Pc.VendorId = Pol.PatientCaseID
												and pc.practiceid =@destPractice
													

	Print 'Rows Added in InsurancePolicy Table ' + Replicate( '.' , 75 - Len( 'Rows Added in InsurancePolicy Table ' ) ) + ' ' + Convert( Varchar(10) , @@RowCount )

---select * from InsurancePolicytemp where vendorimportid = @Vendorimportid


END
