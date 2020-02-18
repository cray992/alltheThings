--select * from superbill_shared.dbo.customer where customertype='N'
--248

BEGIN TRAN

DECLARE @PracticeID int
SET @PracticeID = 2


DECLARE @ContractID int
SET @ContractID = 1

alter table fi_proc add PCD int

update fi_proc 
set pcd = pcd.procedurecodedictionaryid
from fi_proc p inner join procedurecodedictionary pcd on pcd.procedurecode = p.[proc]

insert into contractfeeschedule (createddate,modifieddate,createduserid,modifieduserid,contractid,gender,standardfee,procedurecodedictionaryid, rvu)
select 
	getdate(),getdate(),0,0,
	@ContractID,
	'B',
	Fee,
	PCD,
	0
FROM 
	fi_proc


insert into vendorimport (vendorname,vendorformat,datecreated,notes) values ('MBS','Custom',GETDATE(),'Flick')
DECLARE @VendorImportID int
SET @VendorImportID = SCOPE_IDENTITY()


INSERT INTO
	Doctor
	(PracticeID,[External],Prefix,FirstName,MiddleName,LastName,Suffix,AddressLine1,AddressLine2,City,State,ZipCode,WorkPhone,VendorImportID, VendorID)
SELECT
	@PracticeID, 1, '', COALESCE(First,''), COALESCE(Middle,''), COALESCE(Last,''), '', AddressLine1, AddressLine2, City,State,Zip,Phone, @VendorImportID, ID
FROM
	FI_RefPhys

INSERT INTO Patient
	(PracticeID, ReferringPhysicianID, Prefix,FirstName,MiddleName,LastName,Suffix,AddressLine1,AddressLine2,City,State,ZipCode,
	Gender, MaritalStatus, HomePhone, DOB, CreatedDate,ModifiedDate,CreatedUserID,ModifiedUserID, VendorImportID, VendorID)
SELECT
	@PracticeID, ref.DoctorID, '', COALESCE(p.First,''),COALESCE(p.Middle,''),COALESCE(p.Last,''),'', p.AddressLine1, p.AddressLine2, p.City,p.State, p.Zip,
	p.Sex, p.Marital, p.Phone, p.DOB, GETDATE(), GETDATE(),0,0, @VendorImportID, p.ID
FROM
	FI_Patient p
	LEFT OUTER JOIN Doctor ref ON ref.[External] = 1 AND ref.VendorImportID = @VendorImportID AND ref.VendorID = p.RefID

INSERT INTO PatientCase (PatientID, PracticeID, Name, PayerScenarioID, Active)
SELECT PatientID, PracticeID, 'Default Case', 5, 1 
FROM Patient WHERE VendorImportID = @VendorImportID

--COMMIT
--ROLLBACK