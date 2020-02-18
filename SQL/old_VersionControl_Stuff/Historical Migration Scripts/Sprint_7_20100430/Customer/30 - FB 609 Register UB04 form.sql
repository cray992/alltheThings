--select * from sys.tables where name like '%form%'


--select * from BillingForm


--select * from PrintingForm
--select * from PrintingFormDetails
--select * from Document
--select * from DocumentBatch


declare @printingFormID int
set @printingFormID=25

insert into PrintingForm 
	(PrintingFormID, Name, [Description], StoredProcedureName, RecipientSpecific) 
	values 
	(@printingFormID, 'UB04', 'UB-04', 'BillDataProvider_GetUB04DocumentData', 1)

insert into PrintingFormDetails (PrintingFormDetailsID,	PrintingFormID,	SVGDefinitionID, [Description], SVGDefinition, SVGTransform)
values (89, @printingFormID, 76, 'UB-04', '', 1)

insert into BillingForm (BillingFormID, FormType, FormName, Transform, PrintingFormID, MaxProcedures, MaxDiagnosis) 
values (18, 'UB04', 'UB-04', '', @printingFormID, 20, 0)



-- populate default billing form ID for institutional
update InsuranceCompany set InstitutionalBillingFormID=18
