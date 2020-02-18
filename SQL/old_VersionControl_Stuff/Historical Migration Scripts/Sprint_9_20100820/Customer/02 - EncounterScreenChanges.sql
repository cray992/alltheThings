alter table Encounter alter column AdmissionHour varchar(5)
GO
alter table Encounter alter column DischargeHour varchar(5)
GO

-- add 00 minutes to existing encounters
update encounter set AdmissionHour=AdmissionHour+':00' where AdmissionHour is not null and LEn(AdmissionHour)=2
update encounter set DischargeHour=DischargeHour+':00' where DischargeHour is not null and LEn(DischargeHour)=2


-- EDINoteReferenceCode
alter table EDINoteReferenceCode add DisplayCMS1500 bit, DisplayUB04 bit
GO

update EDINoteReferenceCode set DisplayCMS1500=1, DisplayUB04=0

insert into EDINoteReferenceCode (Code,	[Definition], ClaimOnly, DisplayCMS1500, DisplayUB04) values ('ALG', 'Allergies', 0, 0, 1)
insert into EDINoteReferenceCode (Code,	[Definition], ClaimOnly, DisplayCMS1500, DisplayUB04) values ('DME', 'Durable Medical Equipment (DME) and Supplies', 0, 0, 1)
insert into EDINoteReferenceCode (Code,	[Definition], ClaimOnly, DisplayCMS1500, DisplayUB04) values ('MED', 'Medications', 0, 0, 1)
insert into EDINoteReferenceCode (Code,	[Definition], ClaimOnly, DisplayCMS1500, DisplayUB04) values ('NTR',  'Nutritional Requirements', 0, 0, 1)
insert into EDINoteReferenceCode (Code,	[Definition], ClaimOnly, DisplayCMS1500, DisplayUB04) values ('ODT', 'Orders for Disciplines and Treatments', 0, 0, 1)
insert into EDINoteReferenceCode (Code,	[Definition], ClaimOnly, DisplayCMS1500, DisplayUB04) values ('RHB', 'Functional Limitations, Reason Homebound, or Both', 0, 0, 1)
insert into EDINoteReferenceCode (Code,	[Definition], ClaimOnly, DisplayCMS1500, DisplayUB04) values ('RLH', 'Reasons Patient Leaves Home', 0, 0, 1)
insert into EDINoteReferenceCode (Code,	[Definition], ClaimOnly, DisplayCMS1500, DisplayUB04) values ('SET', 'Unusual Home, Social Environment, or Both', 0, 0, 1)
insert into EDINoteReferenceCode (Code,	[Definition], ClaimOnly, DisplayCMS1500, DisplayUB04) values ('SFM', 'Safety Measures', 0, 0, 1)
insert into EDINoteReferenceCode (Code,	[Definition], ClaimOnly, DisplayCMS1500, DisplayUB04) values ('SPT', 'Supplementary Plan of Treatment', 0, 0, 1)
insert into EDINoteReferenceCode (Code,	[Definition], ClaimOnly, DisplayCMS1500, DisplayUB04) values ('UPI', 'Updated Information', 0, 0, 1)

update EDINoteReferenceCode set DisplayUB04=1 where Code in ('DCP', 'DGN')
