-- repopulate insurance policies info - guarantor first name, last name

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ImportPatientWohl1]') AND type in (N'U'))
	DROP TABLE [dbo].[ImportPatientWohl1]
GO

select * into ImportPatientWohl1 from ImportPatientWohl

declare
	@Medicare varchar(50)

set @Medicare = 'Medicare Of So. Cal.'



update ImportPatientWohl1 set 
	SecondInsuranceName=PrimaryInsuranceName,
	SecondGroupNumber=PrimaryGroupNumber,
	SecondMemberNumber=PrimaryMemberNumber,
	SecondGuarantorFirstName=PrimaryGuarantorFirstName,
	SecondGuarantorLastName=PrimaryGuarantorLastName,
	SecondGuarantorRelation=PrimaryGarantorRelation
where 
	MedicareID>'' or MedicalID>''

update ImportPatientWohl1 set 
	PrimaryInsuranceName=@Medicare,
	PrimaryGroupNumber=null,
	PrimaryMemberNumber=MedicareID,
	PrimaryGuarantorFirstName=null,
	PrimaryGuarantorLastName=null,
	PrimaryGarantorRelation=null
where 
	MedicareID>'' or MedicalID>''


update ImportPatientWohl1 set 
	PrimaryGuarantorFirstName=null,
	PrimaryGuarantorLastName=null,
	Addr1=null,
	Addr2=null,
	City=null,
	State=null,
	ZIP=null
where PrimaryGarantorRelation='I'

--begin tran
update InsurancePolicy set 
	HolderFirstName= (select PrimaryGuarantorFirstName from ImportPatientWohl1 where [ID]=(select VendorID from Patient where PatientID=(select PatientID from PatientCase where PatientCaseID=InsurancePolicy.PatientCaseID))),
	HolderLastName=(select PrimaryGuarantorLastName from ImportPatientWohl1 where [ID]=(select VendorID from Patient where PatientID=(select PatientID from PatientCase where PatientCaseID=InsurancePolicy.PatientCaseID))),
	HolderAddressLine1=(select Addr1 from ImportPatientWohl1 where [ID]=(select VendorID from Patient where PatientID=(select PatientID from PatientCase where PatientCaseID=InsurancePolicy.PatientCaseID))),
	HolderAddressLine2=(select Addr2 from ImportPatientWohl1 where [ID]=(select VendorID from Patient where PatientID=(select PatientID from PatientCase where PatientCaseID=InsurancePolicy.PatientCaseID))),
	HolderCity=(select City from ImportPatientWohl1 where [ID]=(select VendorID from Patient where PatientID=(select PatientID from PatientCase where PatientCaseID=InsurancePolicy.PatientCaseID))),
	HolderState=(select State from ImportPatientWohl1 where [ID]=(select VendorID from Patient where PatientID=(select PatientID from PatientCase where PatientCaseID=InsurancePolicy.PatientCaseID))),
	HolderCountry=null,
	HolderZipCode=(select ZIP from ImportPatientWohl1 where [ID]=(select VendorID from Patient where PatientID=(select PatientID from PatientCase where PatientCaseID=InsurancePolicy.PatientCaseID))),
	HolderGender='U'

from InsurancePolicy
where PatientCaseID in (select PatientCaseID from patientcase where PatientID in (select PatientID from Patient where VendorImportID=1))

select * from InsurancePolicy where PatientCaseID=14760
select * from ImportPatientWohl where ID=227

--rollback tran
