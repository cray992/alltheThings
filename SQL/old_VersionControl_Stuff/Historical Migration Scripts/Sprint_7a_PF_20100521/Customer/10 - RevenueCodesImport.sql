set nocount on

alter table RevenueCodeCategory add Code varchar(4) null
GO

update RevenueCodeCategory set Code='11', Name='Room and Board- Private (Medical or General)' where RevenueCodeCategoryID=1
insert into RevenueCodeCategory (Code, Name) values ('12', 'Room and Board-Semi-Private Two Bed')
insert into RevenueCodeCategory (Code, Name) values ('13', 'Semi-Private- Three and Four Beds')
insert into RevenueCodeCategory (Code, Name) values ('14', 'Private (Delux)')
insert into RevenueCodeCategory (Code, Name) values ('15', 'Room and Board Ward')
insert into RevenueCodeCategory (Code, Name) values ('16', 'Other Room and Board')
insert into RevenueCodeCategory (Code, Name) values ('17', 'Nursery')
insert into RevenueCodeCategory (Code, Name) values ('18', 'Leave of Absence')
insert into RevenueCodeCategory (Code, Name) values ('19', 'Subacute Care')
insert into RevenueCodeCategory (Code, Name) values ('20', 'Intensive Care')
insert into RevenueCodeCategory (Code, Name) values ('21', 'Coronary Care')
insert into RevenueCodeCategory (Code, Name) values ('22', 'Special Charges')
insert into RevenueCodeCategory (Code, Name) values ('23', 'Incremental Nursing Care Rate')
insert into RevenueCodeCategory (Code, Name) values ('24', 'All Inclusive Ancillary')
insert into RevenueCodeCategory (Code, Name) values ('25', 'Pharmacy')
insert into RevenueCodeCategory (Code, Name) values ('26', 'IV Therapy')
insert into RevenueCodeCategory (Code, Name) values ('27', 'Medical/Surgical Supplies and Devices')
insert into RevenueCodeCategory (Code, Name) values ('28', 'Oncology')
insert into RevenueCodeCategory (Code, Name) values ('29', 'Durable Medical Equipment')
insert into RevenueCodeCategory (Code, Name) values ('30', 'Laboratory-Clinical')
insert into RevenueCodeCategory (Code, Name) values ('31', 'Laboratory Anatomical')
insert into RevenueCodeCategory (Code, Name) values ('32', 'Radiology-Diagnostic')
insert into RevenueCodeCategory (Code, Name) values ('33', 'Radiology-Therapeutic')
insert into RevenueCodeCategory (Code, Name) values ('34', 'Nuclear Medicine')
insert into RevenueCodeCategory (Code, Name) values ('35', 'CT Scan')
insert into RevenueCodeCategory (Code, Name) values ('36', 'Operating Room Services')
insert into RevenueCodeCategory (Code, Name) values ('37', 'Anesthesia')
insert into RevenueCodeCategory (Code, Name) values ('38', 'Blood')
insert into RevenueCodeCategory (Code, Name) values ('39', 'Blood Storage and Processing')
insert into RevenueCodeCategory (Code, Name) values ('40', 'Other Imaging Services')
insert into RevenueCodeCategory (Code, Name) values ('41', 'Respiratory Services')
insert into RevenueCodeCategory (Code, Name) values ('42', 'Physical Therapy')
insert into RevenueCodeCategory (Code, Name) values ('43', 'Occupational Therapy')
insert into RevenueCodeCategory (Code, Name) values ('44', 'Speech-Language Pathology')
insert into RevenueCodeCategory (Code, Name) values ('45', 'Emergency Room')
insert into RevenueCodeCategory (Code, Name) values ('46', 'Pulmonary Function')
insert into RevenueCodeCategory (Code, Name) values ('47', 'Audiology')
insert into RevenueCodeCategory (Code, Name) values ('48', 'Cardiology')
insert into RevenueCodeCategory (Code, Name) values ('49', 'Ambulatory Surgical Care')
insert into RevenueCodeCategory (Code, Name) values ('50', 'Outpatient Services')
insert into RevenueCodeCategory (Code, Name) values ('51', 'Clinic')
insert into RevenueCodeCategory (Code, Name) values ('52', 'Freestanding Clinic')
insert into RevenueCodeCategory (Code, Name) values ('53', 'Osteopathic Services')
insert into RevenueCodeCategory (Code, Name) values ('54', 'Ambulance')
insert into RevenueCodeCategory (Code, Name) values ('55', 'Skilled Nursing (Home Health & CORFs only)')
insert into RevenueCodeCategory (Code, Name) values ('56', 'Medical Social Services')
insert into RevenueCodeCategory (Code, Name) values ('57', 'Home Health Aide (Home Health)')
insert into RevenueCodeCategory (Code, Name) values ('58', 'Other Visits (Home Health)')
insert into RevenueCodeCategory (Code, Name) values ('59', 'Units of Service (Home Health)')
insert into RevenueCodeCategory (Code, Name) values ('60', 'Oxygen (Home Health)')
insert into RevenueCodeCategory (Code, Name) values ('61', 'Magnetic Resonance Imaging (MRI)')
insert into RevenueCodeCategory (Code, Name) values ('62', 'Medical/Surgical Supplies')
insert into RevenueCodeCategory (Code, Name) values ('63', 'Drugs Requiring Specific Identification')
insert into RevenueCodeCategory (Code, Name) values ('64', 'Home IV Therapy Services')
insert into RevenueCodeCategory (Code, Name) values ('65', 'Hospice Services')
insert into RevenueCodeCategory (Code, Name) values ('66', 'Respite Care (HHA Only)')
insert into RevenueCodeCategory (Code, Name) values ('67', 'Outpatient Special Residence Charges')
insert into RevenueCodeCategory (Code, Name) values ('70', 'Cast Room')
insert into RevenueCodeCategory (Code, Name) values ('71', 'Recovery Room')
insert into RevenueCodeCategory (Code, Name) values ('72', 'Labor Room/Delivery')
insert into RevenueCodeCategory (Code, Name) values ('73', 'EKG/ECG (Electrocardiogram)')
insert into RevenueCodeCategory (Code, Name) values ('74', 'EEG (Electroencephalogram)')
insert into RevenueCodeCategory (Code, Name) values ('75', 'Gastro-Intestinal Services')
insert into RevenueCodeCategory (Code, Name) values ('76', 'Treatment/Observation Room')
insert into RevenueCodeCategory (Code, Name) values ('77', 'Preventive Care Services')
insert into RevenueCodeCategory (Code, Name) values ('79', 'Lithotripsy')
insert into RevenueCodeCategory (Code, Name) values ('80', 'Renal Dialysis- Inpatient')
insert into RevenueCodeCategory (Code, Name) values ('81', 'Organ Acquisition')
insert into RevenueCodeCategory (Code, Name) values ('82', 'Hemodialysis- Outpatient or Home')
insert into RevenueCodeCategory (Code, Name) values ('83', 'Peritoneal Dialysis- Outpatient or Home')
insert into RevenueCodeCategory (Code, Name) values ('84', 'Continuous Ambulatory Peritoneal Dialysis (CAPD)- Outpatient/Home')
insert into RevenueCodeCategory (Code, Name) values ('85', 'Continuous Cycling Peritoneal Dialysis (CCPD)- Outpatient or Home')
insert into RevenueCodeCategory (Code, Name) values ('90', 'Psychiatric/Psychological Treatments')
insert into RevenueCodeCategory (Code, Name) values ('91', 'Psychiatric/Psychological Services')
insert into RevenueCodeCategory (Code, Name) values ('92', 'Other Diagnostic Services')
insert into RevenueCodeCategory (Code, Name) values ('94', 'Other Therapeutic Services')
insert into RevenueCodeCategory (Code, Name) values ('95', 'Other Therapeutic Services')
insert into RevenueCodeCategory (Code, Name) values ('96', 'Professional Fees')
insert into RevenueCodeCategory (Code, Name) values ('97', 'Professional Fees')
insert into RevenueCodeCategory (Code, Name) values ('98', 'Professional Fees')
insert into RevenueCodeCategory (Code, Name) values ('99', 'Patient Convenience Items')

update RevenueCode set RevenueCategoryID=39 where Code='490'


insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 110,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=11
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 111,'Medical/Surgical/Gyn', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=11
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 112,'OB', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=11
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 113,'Pediatric', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=11
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 114,'Psychiatric', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=11
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 115,'Hospice', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=11
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 116,'Detoxification', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=11
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 117,'Oncology', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=11
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 118,'Rehabilitation', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=11
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 119,'Other', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=11
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 120,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=12
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 121,'Medical/Surgical/Gyn', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=12
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 122,'OB', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=12
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 123,'Pediatric', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=12
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 124,'Psychiatric', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=12
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 125,'Hospice', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=12
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 126,'Detoxification', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=12
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 127,'Oncology', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=12
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 128,'Rehabilitation', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=12
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 129,'Other', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=12
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 130,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=13
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 131,'Medical/Surgical/Gyn', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=13
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 132,'OB', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=13
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 133,'Pediatric', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=13
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 134,'Psychiatric', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=13
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 135,'Hospice', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=13
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 136,'Detoxification', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=13
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 137,'Oncology', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=13
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 138,'Rehabilitation', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=13
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 139,'Other', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=13
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 140,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=14
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 141,'Medical/Surgical/Gyn', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=14
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 142,'OB', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=14
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 143,'Pediatric', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=14
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 144,'Psychiatric', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=14
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 145,'Hospice', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=14
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 146,'Detoxification', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=14
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 147,'Oncology', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=14
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 148,'Rehabilitation', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=14
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 149,'Other', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=14
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 150,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=15
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 151,'Medical/Surgical/Gyn', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=15
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 152,'OB', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=15
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 153,'Pediatric', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=15
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 154,'Psychiatric', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=15
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 155,'Hospice', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=15
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 156,'Detoxification', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=15
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 157,'Oncology', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=15
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 158,'Rehabilitation', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=15
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 159,'Other', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=15
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 160,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=16
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 164,'Sterile Environment', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=16
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 167,'Self Care', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=16
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 168,'Rehabilitation', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=16
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 169,'Other', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=16
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 170,'Newborn (well baby)', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=17
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 171,'Newborn-level I Routine', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=17
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 172,'Newborn-level II Low-birth weight', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=17
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 173,'Newborn-level III Sick baby', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=17
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 174,'Newborn-level IV Severly ill baby/ICU', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=17
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 179,'Boarder baby', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=17
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 180,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=18
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 181,'Reserved', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=18
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 182,'Patient Convenience Charges Billable Billable', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=18
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 183,'Therapeutic Leave Billable', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=18
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 184,'ICF/MR-any reason Billable', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=18
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 185,'Nursing Home (for hospitalization) Billable', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=18
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 189,'Other Leave of Absence', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=18
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 190,'General Classification', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=19
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 191,'Subacute Care-level I Skilled Care', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=19
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 192,'Subacute Care-level II Comprehensive Care', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=19
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 193,'Subacute Care-level III Complex Care', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=19
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 194,'Subacute Care-level IV Intensive Care', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=19
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 199,'Other Subacute Care', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=19
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 200,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=20
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 201,'Surgical', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=20
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 202,'Medical', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=20
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 203,'Pediatric', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=20
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 204,'Psychiatric', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=20
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 206,'Intermediate ICU', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=20
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 207,'Burn Care', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=20
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 208,'Trauma', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=20
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 209,'Other Intensive Care', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=20
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 210,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=21
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 211,'Myocardial Infarction', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=21
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 212,'Pulmonary Care', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=21
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 213,'Heart Transplant', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=21
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 214,'Intermediate CCU', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=21
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 219,'Other Coronary Care', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=21
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 221,'Admission Charge', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=22
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 222,'Technical Support Charge', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=22
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 223,'U.R. Service Charge', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=22
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 224,'Medically Necessary Late Discharge', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=22
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 229,'Other Special Charges', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=22
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 230,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=23
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 231,'Nursery', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=23
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 232,'OB', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=23
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 233,'ICU', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=23
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 234,'CCU', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=23
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 235,'Hospice', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=23
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 239,'Other', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=23
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 240,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=24
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 249,'Other Inclusive Ancillary', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=24
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 250,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=25
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 251,'Generic Drugs', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=25
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 252,'Non-generic Drugs', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=25
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 253,'Take Home Drugs', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=25
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 254,'Drugs incidental to other Diagnostic Services', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=25
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 255,'Drugs incidental to Radiology', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=25
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 256,'Experimental Drugs', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=25
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 257,'Non-prescription', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=25
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 258,'IV Solutions', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=25
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 259,'Other Pharmacy', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=25
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 260,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=26
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 261,'Infusion Pump', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=26
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 262,'IV Therapy/Pharmacy Services', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=26
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 263,'IV Therapy/Drug/Supply Delivery', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=26
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 264,'IV Therapy/Supplies', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=26
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 269,'Other IV Therapy', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=26
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 270,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=27
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 271,'Non-Sterile Supply', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=27
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 272,'Sterile Supply', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=27
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 273,'Take Home Supplies', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=27
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 274,'Prosthetic/Orthotic Devices', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=27
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 275,'Pace Maker', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=27
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 276,'Intraocular Lens', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=27
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 277,'Oxygen-Take Home', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=27
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 278,'Other Implants', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=27
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 279,'Other Supplies/Devices', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=27
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 280,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=28
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 289,'Other Oncology', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=28
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 290,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=29
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 291,'Rental', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=29
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 292,'Purchase of New DME', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=29
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 293,'Purchase of Used DME', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=29
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 294,'Supplies/Drug for DME Effectiveness', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=29
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 299,'Other Equipment', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=29
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 300,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=30
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 301,'Chemistry', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=30
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 302,'Immunology', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=30
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 303,'Renal Patient (home)', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=30
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 304,'Non-routine Dialysis', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=30
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 305,'Hematology', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=30
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 306,'Bacteriology & Microbiology', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=30
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 307,'Urology', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=30
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 309,'Other Laboratory', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=30
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 310,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=31
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 311,'Cytology', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=31
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 312,'Histology', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=31
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 314,'Biopsy', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=31
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 319,'Other', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=31
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 320,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=32
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 321,'Angiocardiography', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=32
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 322,'Arthrography', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=32
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 323,'Arteriography', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=32
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 324,'Chest X-ray', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=32
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 329,'Digital Subtraction Angiography', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=32
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 330,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=33
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 331,'Chemotherapy-injected', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=33
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 332,'Chemotherapy-oral', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=33
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 333,'Radiation Therapy', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=33
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 335,'Chemotherapy-IV', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=33
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 339,'Other', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=33
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 340,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=34
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 341,'Diagnostic', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=34
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 342,'Therapeutic', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=34
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 343,'Diagnostic Radiopharmaceuticals', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=34
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 344,'Therapeutic Radiopharmaceuticals', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=34
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 349,'Other', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=34
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 350,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=35
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 351,'Head Scan', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=35
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 352,'Body Scan', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=35
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 359,'Other CT Scans', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=35
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 360,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=36
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 361,'Minor Surgery', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=36
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 362,'Organ Transplant-Other Than Kidney', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=36
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 367,'Kidney Transplant', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=36
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 369,'Other Operating Room Services', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=36
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 370,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=37
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 371,'Anesthesia incident to Radiology', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=37
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 372,'Anesthesia incident to Other Diagnostic Services', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=37
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 374,'Acupuncture', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=37
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 379,'Other Anesthesia', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=37
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 380,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=38
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 381,'Packed Red Cells', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=38
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 382,'Whole Blood', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=38
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 383,'Blood-Plasma', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=38
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 384,'Blood-Platelets', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=38
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 385,'Blood-Leucocytes', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=38
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 386,'Blood-Other Components', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=38
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 387,'Blood-Other Derivatives', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=38
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 389,'Other Blood', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=38
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 390,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=39
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 391,'Blood Administration', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=39
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 399,'Other Blood Storage & Processing', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=39
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 400,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=40
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 401,'Diagnostic Mammography', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=40
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 402,'Ultrasound', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=40
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 403,'Screening Mammography', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=40
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 404,'Positron Emission Tomography', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=40
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 409,'Other Imaging Services', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=40
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 410,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=41
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 412,'Inhalation Services', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=41
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 413,'Hyperbaric Oxygen Therapy', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=41
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 419,'Other Respiratory Services', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=41
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 420,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=42
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 421,'Visit Charge', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=42
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 422,'Hourly Charge', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=42
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 423,'Group Rate', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=42
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 424,'Evaluation or Re-evaluation', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=42
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 429,'Other Physical Therapy', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=42
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 430,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=43
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 431,'Visit Charge', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=43
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 432,'Hourly Charge', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=43
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 433,'Group Rate', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=43
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 434,'Evaluation or Re-evaluation', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=43
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 439,'Other Occupational Therapy', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=43
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 440,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=44
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 441,'Visit Charge', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=44
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 442,'Hourly Charge', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=44
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 443,'Group Rate', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=44
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 444,'Evaluation or Re-evaluation', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=44
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 449,'Other Speech-Language Pathology', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=44
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 450,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=45
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 451,'EMTALA Emergency Medical Screening Services', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=45
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 452,'ER Beyond EMTALA Screening', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=45
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 456,'Urgent Care', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=45
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 459,'Other Emergency Room', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=45
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 460,'Other Emergency Room', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=46
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 469,'Other Pulmonary Function', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=46
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 470,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=47
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 471,'Diagnostic', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=47
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 472,'Treatment', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=47
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 479,'Other Audiology', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=47
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 480,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=48
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 481,'Cardiac Cath Lab', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=48
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 482,'Stress Test', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=48
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 483,'Echocardiology', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=48
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 489,'Other Cardiology', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=48
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 499,'Other Ambulatory Surgical Care', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=49
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 500,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=50
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 509,'Other Outpatient', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=50
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 510,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=51
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 511,'Chronic Pain Center', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=51
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 512,'Dental Clinic', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=51
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 513,'Psychiatric', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=51
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 514,'OB-GYN', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=51
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 515,'Pediatric', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=51
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 516,'Urgent Care Clinic', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=51
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 517,'Family Practice Clinic', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=51
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 519,'Other Clinic', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=51
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 520,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=52
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 521,'Rural Health-Clinic', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=52
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 522,'Rural Health-Home', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=52
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 523,'Family Practice', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=52
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 526,'Urgent Care Clinic', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=52
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 529,'Other Freestanding Clinic', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=52
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 530,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=53
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 531,'Osteopathic Therapy', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=53
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 539,'Other Osteopathic Services', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=53
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 540,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=54
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 541,'Supplies', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=54
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 542,'Medical Transport', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=54
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 543,'Heart Mobile', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=54
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 544,'Oxygen', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=54
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 545,'Air Ambulance', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=54
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 546,'NeoNatal', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=54
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 547,'Pharmacy', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=54
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 548,'Telephone Transmission EKG', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=54
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 549,'Other Ambulance', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=54
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 550,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=55
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 551,'Visit Charge', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=55
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 552,'Hourly Charge', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=55
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 559,'Other Skilled Nursing', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=55
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 560,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=56
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 561,'Visit Charge', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=56
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 562,'Hourly Charge', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=56
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 569,'Other Medical Social Services', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=56
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 570,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=57
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 571,'Visit Charge', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=57
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 572,'Hourly Charge', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=57
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 579,'Other Home Health Aide', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=57
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 580,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=58
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 581,'Visit Charge', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=58
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 582,'Hourly Charge', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=58
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 583,'Dietician', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=58
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 589,'Other Home Health Visits', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=58
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 590,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=59
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 599,'Other Home Health Units', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=59
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 600,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=60
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 601,'Oxygen-State/Equip/Supply/Cont.', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=60
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 602,'Oxygen-State/Equip/Supply/Under 1 LPM', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=60
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 603,'Oxygen-State/Equip/Over 4 LPM', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=60
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 604,'Oxygen-Portable Add-on', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=60
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 610,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=61
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 611,'Brain (including brain stem)', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=61
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 612,'Spinal Cord (including spine)', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=61
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 619,'Other MRI', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=61
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 621,'Supplies Incidental to Radiology', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=62
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 622,'Supplies Incidental to Other Diagnostic Services', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=62
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 623,'Surgical Dressing', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=62
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 624,'FDA Investigational Devices', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=62
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 630,'General Classification', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=63
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 631,'Single Source Drug', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=63
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 632,'Multiple Source Drug', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=63
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 633,'Restrictive Prescription', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=63
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 634,'Erythropoietin (EPO) less than 10,000 units', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=63
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 635,'Erythropoietin (EPO) more than 10,000 units', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=63
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 636,'Drugs Requiring Detailed Coding', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=63
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 640,'General Classification', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=64
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 641,'Nonroutine Nursing, Central Line', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=64
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 642,'IV Site Care, Central Line', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=64
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 643,'IV Start/Change, Peripheral Line', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=64
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 644,'Nonroutine Nursing, Peripheral Line', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=64
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 645,'Training, Patient/Caregiver, Central Line', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=64
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 646,'Training, Disabled Patient, Central Line', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=64
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 647,'Training, Patient/Caregiver, Peripheral Line', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=64
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 648,'Training, Disabled Patient, Peripheral Line', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=64
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 649,'Other IV Therapy Services', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=64
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 650,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=65
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 651,'Routine Home Care', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=65
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 652,'Continuous Home Care', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=65
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 655,'Inpatient Respite Care', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=65
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 656,'General Inpatient Care', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=65
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 657,'Physician Service', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=65
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 659,'Other Hospice', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=65
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 660,'General Classification', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=66
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 661,'Hourly Charge/Skilled Nursing', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=66
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 662,'Hourly Charge/Home Health Aide/Homemaker', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=66
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 670,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=67
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 671,'Hospital Based', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=67
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 672,'Contracted', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=67
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 679,'Other Special Residence Charges', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=67
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 700,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=70
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 709,'Other Cast Room', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=70
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 710,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=71
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 719,'Other Recovery Room', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=71
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 720,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=72
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 721,'Labor', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=72
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 722,'Delivery', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=72
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 723,'Circumcision', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=72
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 724,'Birthing Center', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=72
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 729,'False Labor', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=72
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 730,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=73
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 731,'Holter Monitor', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=73
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 732,'Telemetry', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=73
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 739,'Computerized EKG/ECG', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=73
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 740,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=74
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 741,'Electronystogmography', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=74
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 742,'Diagnostic Sleep Disorder', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=74
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 749,'Other EEG', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=74
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 750,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=75
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 759,'Other Gastro-Intestinal', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=75
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 760,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=76
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 761,'Treatment Room', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=76
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 762,'Observation Room', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=76
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 769,'Other Treatment Room', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=76
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 770,'General Classification', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=77
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 771,'Vaccine Administration', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=77
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 779,'Other', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=77
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 790,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=79
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 799,'Other Lithotripsy', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=79
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 800,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=80
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 801,'Inpatient Hemodialysis', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=80
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 802,'Inpatient Peritoneal (Non-CAPD)', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=80
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 803,'Inpatient Continuous Ambulatory Peritoneal Dialysis (CAPD)', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=80
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 804,'Inpatient Continuous Cycling Peritoneal Dialysis', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=80
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 809,'Other Inpatient Dialysis', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=80
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 810,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=81
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 811,'Living Donor', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=81
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 812,'Cadaver Donor', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=81
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 813,'Unknown Donor', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=81
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 814,'Unsuccessful Organ Search-Donor Bank Charges', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=81
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 819,'Other', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=81
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 820,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=82
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 821,'Hemodialysis/Composite or Other Rate', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=82
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 822,'Home Supplies (Not used in Michigan)', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=82
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 823,'Home Equipment (Not used in Michigan)', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=82
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 824,'Maintenance/100% (Not used in Michigan)', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=82
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 825,'Support Services', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=82
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 829,'Other Outpatient Hemodialysis', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=82
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 830,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=83
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 831,'Peritoneal/Composite or Other Rate', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=83
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 832,'Home Supplies (Not used in Michigan)', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=83
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 833,'Home Equipment (Not used in Michigan)', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=83
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 834,'Maintenance/100% (Not used in Michigan)', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=83
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 835,'Support Services', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=83
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 839,'Other Peritoneal Dialysis', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=83
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 840,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=84
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 841,'CAPD/Composite or Other Rate', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=84
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 842,'Home Supplies (Not used in Michigan)', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=84
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 843,'Home Equipment (Not used in Michigan)', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=84
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 844,'Maintenance/100% (Not used in Michigan)', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=84
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 845,'Support Services', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=84
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 849,'Other Outpatient CAPD', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=84
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 850,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=85
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 851,'CCPD/Composite or Other Rate', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=85
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 852,'Home Supplies (Not used in Michigan)', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=85
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 853,'Home Equipment (Not used in Michigan)', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=85
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 854,'Maintenance/100% (Not used in Michigan)', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=85
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 855,'Support Services', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=85
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 859,'Other CCPD', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=85
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 900,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=90
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 901,'Electroshock Treatment', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=90
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 902,'Milieu Therapy', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=90
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 903,'Play Therapy', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=90
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 904,'Activity Therapy', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=90
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 909,'Other', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=90
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 910,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=91
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 911,'Rehabilitation', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=91
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 912,'Partial Hospitalization', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=91
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 914,'Individual Therapy', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=91
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 915,'Group Therapy', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=91
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 916,'Family Therapy', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=91
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 917,'Bio Feedback ', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=91
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 918,'Testing', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=91
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 919,'Other', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=91
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 920,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=92
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 921,'Peripheral Vascular Lab', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=92
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 922,'Electromyelogram', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=92
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 923,'Pap Smear', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=92
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 924,'Allergy Test', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=92
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 925,'Pregnancy Test', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=92
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 929,'Other Diagnostic Services', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=92
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 940,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=94
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 941,'Recreational Therapy', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=94
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 942,'Education/Training/Diabetes Education', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=94
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 943,'Cardiac Rehabilitation', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=94
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 944,'Clinic-O/P Drug Rehabilitation', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=94
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 945,'Clinic-O/P Alcohol Rehabilitation', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=94
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 946,'Complex Medical Equipment-Routing', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=94
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 947,'Complex Medical Equipment-Ancillary', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=94
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 949,'Psoriasis Treatment Center', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=94
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 950,'Reserved ', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=95
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 951,'Athletic Training', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=95
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 952,'Kinesiotherapy', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=95
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 960,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=96
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 961,'Psychiatric', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=96
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 962,'Opthalmology', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=96
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 963,'Anesthesiologist (MD)', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=96
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 964,'Anesthetist (CRNA)', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=96
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 969,'Midwife', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=96
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 971,'Laboratory', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=97
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 972,'Radiology-Diagnostic', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=97
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 973,'Radiology-Therapeutic', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=97
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 974,'Radiology-Nuclear Medicine', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=97
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 975,'Operating Room', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=97
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 976,'Respiratory Therapy', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=97
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 977,'Physical Therapy', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=97
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 978,'Occupational Therapy', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=97
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 979,'Speech Pathology', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=97
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 981,'Emergency Room', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=98
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 982,'Outpatient Services', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=98
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 983,'Clinic', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=98
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 984,'Medical Social Services', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=98
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 985,'EKG', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=98
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 986,'EEG', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=98
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 987,'Hospital Visit', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=98
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 988,'Consultation', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=98
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 989,'Private Duty Nurse', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=98
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 990,'General', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=99
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 991,'Cafeteria/Guest Tray', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=99
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 992,'Private Linen Service', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=99
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 993,'Telephone/Telegraph', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=99
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 994,'TV/Radio', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=99
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 995,'Non-Patient Room Rentals', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=99
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 996,'Late Discharge Charge', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=99
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 997,'Admission Kits', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=99
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 998,'Beauty Shop/Barber', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=99
insert into RevenueCode (Code, StandardAbbrevation, RevenueCodeUnitID, RevenueCategoryID) select 999,'Other Patient Convenience Items', 1, RevenueCodeCategoryID from RevenueCodeCategory RCC where RCC.Code=99
