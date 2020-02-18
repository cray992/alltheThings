/*==============================================================*/
/* Database name:  Database                                     */
/* DBMS name:      Microsoft SQL Server 2000                    */
/* Created on:     6/24/2004 21:23:51                           */
/*==============================================================*/

BEGIN TRAN

alter table dbo.Appointment
   drop constraint FK__Appointme__Appoi__1039A0FC
go


alter table dbo.Appointment
   drop constraint FK__Appointme__Pract__0C691018
go


alter table dbo.EncounterToPatientInsurance
   drop constraint UX_EncounterToPatientInsurance_Encounter_PatIns_Prec
go


alter table dbo.PracticeToInsuranceCompanyPlan
   drop constraint PK_PracticeToInsuranceCompanyPlan
go


if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.tmp_ClearinghouseResponse')
            and   type = 'U')
   drop table dbo.tmp_ClearinghouseResponse
go


/*==============================================================*/
/* Table: tmp_ClearinghouseResponse                             */
/*==============================================================*/
create table dbo.tmp_ClearinghouseResponse (
   ClearinghouseResponseID int                  identity(1 , 1),
   ResponseType         int                  null,
   PracticeID           int                  null,
   SourceAddress        varchar(100)         null,
   FileName             varchar(100)         null,
   FileReceiveDate      datetime             null,
   FileContents         ntext                null,
   ReviewedFlag         bit                  null default 0,
   TIMESTAMP            timestamp            null
)
go


set identity_insert dbo.tmp_ClearinghouseResponse on
go


insert into dbo.tmp_ClearinghouseResponse (ClearinghouseResponseID, ResponseType, PracticeID, SourceAddress, FileName, FileReceiveDate, FileContents, ReviewedFlag)
select ClearinghouseResponseID, ResponseType, PracticeID, SourceAddress, FileName, FileReceiveDate, FileContents, ReviewedFlag
from dbo.ClearinghouseResponse
go


set identity_insert dbo.tmp_ClearinghouseResponse off
go


if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.ClearinghouseResponse')
            and   type = 'U')
   drop table dbo.ClearinghouseResponse
go


if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.tmp_PracticeToInsuranceCompanyPlan')
            and   type = 'U')
   drop table dbo.tmp_PracticeToInsuranceCompanyPlan
go


/*==============================================================*/
/* Table: tmp_PracticeToInsuranceCompanyPlan                    */
/*==============================================================*/
create table dbo.tmp_PracticeToInsuranceCompanyPlan (
   PK_ID                int                  identity(1 , 1),
   PracticeID           int                  not null,
   InsuranceCompanyPlanID int                  not null,
   CreatedDate          datetime             not null default getdate(),
   CreatedUserID        int                  not null default 0,
   ModifiedDate         datetime             not null default getdate(),
   ModifiedUserID       int                  not null default 0,
   RecordTimeStamp      timestamp            not null,
   EClaimsPracticeIsEnrolled bit                  not null default 0,
   EStatementsPracticeIsEnrolled bit                  not null default 0,
   EClaimsProviderID    varchar(32)          null
)
go


set identity_insert dbo.tmp_PracticeToInsuranceCompanyPlan on
go


insert into dbo.tmp_PracticeToInsuranceCompanyPlan (PK_ID, PracticeID, InsuranceCompanyPlanID, CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, EClaimsPracticeIsEnrolled, EStatementsPracticeIsEnrolled, EClaimsProviderID)
select PK_ID, PracticeID, InsuranceCompanyPlanID, CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, EClaimsPracticeIsEnrolled, EStatementsPracticeIsEnrolled, EClaimsProviderID
from dbo.PracticeToInsuranceCompanyPlan
go


set identity_insert dbo.tmp_PracticeToInsuranceCompanyPlan off
go


if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.PracticeToInsuranceCompanyPlan')
            and   type = 'U')
   drop table dbo.PracticeToInsuranceCompanyPlan
go


alter table dbo.ServiceLocationFeeSchedule
   drop column TIMESTAMP
go


/*==============================================================*/
/* Table: ClearinghouseResponse                                 */
/*==============================================================*/
create table dbo.ClearinghouseResponse (
   ClearinghouseResponseID int                  identity(1 , 1),
   ResponseType         int                  null,
   PracticeID           int                  null,
   SourceAddress        varchar(100)         null,
   FileName             varchar(100)         null,
   FileReceiveDate      datetime             null,
   FileContents         ntext                null,
   ReviewedFlag         bit                  null default 0,
   TIMESTAMP            timestamp            null,
   constraint PK_ClearinghouseResponse primary key  (ClearinghouseResponseID)
)

go


set identity_insert dbo.ClearinghouseResponse on
go


insert into dbo.ClearinghouseResponse (ClearinghouseResponseID, ResponseType, PracticeID, SourceAddress, FileName, FileReceiveDate, FileContents, ReviewedFlag)
select ClearinghouseResponseID, ResponseType, PracticeID, SourceAddress, FileName, FileReceiveDate, FileContents, ReviewedFlag
from dbo.tmp_ClearinghouseResponse
go


set identity_insert dbo.ClearinghouseResponse off
go


alter table dbo.EncounterToPatientInsurance
   add constraint UX_EncounterToPatientInsurance_Encounter_Pred unique  (EncounterID, Precedence)
      

go


/*==============================================================*/
/* Table: PracticeToInsuranceCompanyPlan                        */
/*==============================================================*/
create table dbo.PracticeToInsuranceCompanyPlan (
   PK_ID                int                  identity(1 , 1),
   PracticeID           int                  not null,
   InsuranceCompanyPlanID int                  not null,
   CreatedDate          datetime             not null default getdate(),
   CreatedUserID        int                  not null default 0,
   ModifiedDate         datetime             not null default getdate(),
   ModifiedUserID       int                  not null default 0,
   RecordTimestamp      timestamp            not null,
   EClaimsPracticeIsEnrolled bit                  not null default 0,
   EStatementsPracticeIsEnrolled bit                  not null default 0,
   EClaimsProviderID    varchar(32)          null,
   constraint PK_PracticeToInsuranceCompanyPlan primary key  (PracticeID, InsuranceCompanyPlanID)
)
go


set identity_insert dbo.PracticeToInsuranceCompanyPlan on
go


insert into dbo.PracticeToInsuranceCompanyPlan (PK_ID, PracticeID, InsuranceCompanyPlanID, CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, EClaimsPracticeIsEnrolled, EStatementsPracticeIsEnrolled, EClaimsProviderID)
select PK_ID, PracticeID, InsuranceCompanyPlanID, CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, EClaimsPracticeIsEnrolled, EStatementsPracticeIsEnrolled, EClaimsProviderID
from dbo.tmp_PracticeToInsuranceCompanyPlan
go


set identity_insert dbo.PracticeToInsuranceCompanyPlan off
go


alter table dbo.ServiceLocationFeeSchedule
   add RecordTimestamp timestamp null
go

/* NOT SURE WHY THIS WAS GENERATED THIS WAY
alter table dbo.ServiceLocationFeeSchedule
   add constraint PK_SERVICELOCATION_SERVICEL unique  (ServiceLocationID, PracticeFeeScheduleID)
go
*/

alter table dbo.Appointment
   add constraint FK_Appointment_AppointmentResourceType foreign key (AppointmentResourceTypeID)
      references dbo.AppointmentResourceType (AppointmentResourceTypeID)
go


alter table dbo.Appointment
   add constraint FK_Appointment_PracticeResource foreign key (PracticeResourceID)
      references dbo.PracticeResource (PracticeResourceID)
go


alter table dbo.Claim
   add constraint FK_Claim_Practice foreign key (PracticeID)
      references dbo.Practice (PracticeID)
go


alter table dbo.HandheldEncounter
   add constraint FK_HandheldEncounter_Practice foreign key (PracticeID)
      references dbo.Practice (PracticeID)
go

SELECT *
INTO _20040707_PatientAuthorization_NoMatchPatient
FROM PatientAuthorization
WHERE patientid NOT in (select patientid FROM patient)

DELETE 
FROM PatientAuthorization
WHERE patientid NOT in (select patientid FROM patient)


alter table dbo.PatientAuthorization
   add constraint FK_PatientAuthorization_Patient foreign key (PatientID)
      references dbo.Patient (PatientID)
go


alter table dbo.PatientAuthorization
   add constraint FK_PatientAuthorization_PatientInsurance foreign key (PatientInsuranceID)
      references dbo.PatientInsurance (PatientInsuranceID)
go


alter table dbo.PaymentAdvice
   add constraint FK_PaymentAdvice_Practice foreign key (PracticeID)
      references dbo.Practice (PracticeID)
go


alter table dbo.ReferringPhysician
   add constraint FK_ReferringPhysician_Practice foreign key (PracticeID)
      references dbo.Practice (PracticeID)
go


alter table dbo.PracticeToInsuranceCompanyPlan
   add constraint FK_PracticeToInsuranceCompanyPlan_InsuranceCompanyPlan foreign key (InsuranceCompanyPlanID)
      references dbo.InsuranceCompanyPlan (InsuranceCompanyPlanID)
go

commit

