-- Create new place of service codes
-------------------------------------

-- create temp table
select top 0 * into #tempPos from PlaceOfService

insert into #tempPos (PlaceOfServiceCode, [Description]) values ('01', 'Pharmacy')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('03', 'School')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('04', 'Homeless Shelter')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('05', 'Indian Health Service Free-standing Facility')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('06', 'Indian Health Service Provider-based Facility')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('07', 'Tribal 638 Free-standing Facility')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('08', 'Tribal 638 Provider-based Facility')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('11', 'Office')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('12', 'Home')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('13', 'Assisted Living Facility')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('14', 'Group Home')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('15', 'Mobile Unit')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('16', 'Temporary Lodging')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('20', 'Urgent Care Facility')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('21', 'Inpatient Hospital')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('22', 'Outpatient Hospital')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('23', 'Emergency Room – Hospital')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('24', 'Ambulatory Surgical Center')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('25', 'Birthing Center')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('26', 'Military Treatment Facility')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('31', 'Skilled Nursing Facility')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('32', 'Nursing Facility')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('33', 'Custodial Care Facility')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('34', 'Hospice')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('41', 'Ambulance - Land')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('42', 'Ambulance – Air or Water')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('49', 'Independent Clinic')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('50', 'Federally Qualified Health Center')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('51', 'Inpatient Psychiatric Facility')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('52', 'Psychiatric Facility-Partial Hospitalization')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('53', 'Community Mental Health Center')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('54', 'Intermediate Care Facility/Mentally Retarded')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('55', 'Residential Substance Abuse Treatment Facility')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('56', 'Psychiatric Residential Treatment Center')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('57', 'Non-residential Substance Abuse Treatment Facility')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('60', 'Mass Immunization Center')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('61', 'Comprehensive Inpatient Rehabilitation Facility')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('62', 'Comprehensive Outpatient Rehabilitation Facility')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('65', 'End-Stage Renal Disease Treatment Facility')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('71', 'Public Health Clinic')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('72', 'Rural Health Clinic')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('81', 'Independent Laboratory')
insert into #tempPos (PlaceOfServiceCode, [Description]) values ('99', 'Other Place of Service')


insert into PlaceOfService (PlaceOfServiceCode, [Description]) 
select PlaceOfServiceCode, [Description] from #tempPos t 
where t.PlaceOfServiceCode not in (select PlaceOfServiceCode from PlaceOfService)

drop table #tempPos


