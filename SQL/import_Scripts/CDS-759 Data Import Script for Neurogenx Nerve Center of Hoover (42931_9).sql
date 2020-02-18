--USE superbill_42931_dev
USE superbill_42931_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 9
SET @SourcePracticeID = 1
SET @VendorImportID = 2

SET NOCOUNT ON 

/*
==========================================================================================================================================
QA COUNT CHECK
==========================================================================================================================================
*/
/*

CREATE TABLE #tempdocqa (firstname VARCHAR(65), lastname VARCHAR(65), NPI INT , [External] INT) INSERT INTO #tempdocqa (firstname, lastname, NPI, [External])
SELECT DISTINCT d.firstname ,d.lastname, d.npi, d.[External] FROM dbo._import_2_9_Doctor d WHERE d.PracticeID = @SourcePracticeID

SELECT COUNT(*) AS [Existing Renderring Doctors To Be Updated] FROM dbo.Doctor d 
INNER JOIN #tempdocqa i ON d.FirstName = i.firstname AND d.LastName = i.lastname AND d.NPI = i.npi
WHERE d.PracticeID = @TargetPracticeID AND d.[External] = 0 

SELECT COUNT(*) AS [Existing Referring Doctors To Be Updated] FROM dbo.Doctor d 
INNER JOIN #tempdocqa i ON d.FirstName = i.firstname AND d.LastName = i.lastname AND d.NPI = i.npi
WHERE d.PracticeID = @TargetPracticeID AND d.[External] = 1 DROP TABLE #tempdocqa

--SELECT DISTINCT COUNT(DISTINCT i.insurancecompanyid) AS [Insurance Company Records To Be Inserted] FROM _import_2_9_InsuranceCompany i
--INNER JOIN dbo.[_import_2_9_InsuranceCompanyPlan] icp ON i.InsuranceCompanyID = icp.InsuranceCompanyID
--INNER JOIN dbo.[_import_2_9_InsurancePolicy] ip ON icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID AND ip.PracticeID = @SourcePracticeID

--SELECT COUNT(DISTINCT ptic.pk_id) AS [Practice to Insurance Company Records To Be Inserted] FROM _import_2_9_PracticetoInsuranceCompany ptic 
--INNER JOIN dbo._import_2_9_InsuranceCompany ic ON ptic.InsuranceCompanyId = ic.InsuranceCompanyID AND ptic.PracticeID = @SourcePracticeID
--INNER JOIN dbo.[_import_2_9_InsuranceCompanyPlan] icp ON ic.InsuranceCompanyID = icp.InsuranceCompanyID
--INNER JOIN dbo.[_import_2_9_InsurancePolicy] ip ON icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID AND ip.PracticeID = @SourcePracticeID

--SELECT COUNT(DISTINCT icp.insurancecompanyplanid) AS [Insurance Company Plan Records To Be Inserted] FROM _import_2_9_InsuranceCompanyPlan icp
--INNER JOIN dbo._import_2_9_InsuranceCompany ic ON icp.insurancecompanyid = ic.insurancecompanyid
--INNER JOIN dbo.[_import_2_9_InsurancePolicy] ip ON icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID AND ip.PracticeID = @SourcePracticeID

--SELECT COUNT(*) AS [Existing Insurance Company Records to be Updated with ReviewCode] FROM dbo.InsuranceCompany ic
--INNER JOIN dbo.InsuranceCompanyPlan icp ON ic.InsuranceCompanyID = icp.InsuranceCompanyID 
--INNER JOIN dbo.InsurancePolicy ip ON ip.PracticeID = @SourcePracticeID AND icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID
--WHERE ic.ReviewCode = '' OR ic.ReviewCode IS NULL

--SELECT COUNT(*) AS [Existing Insurance Company Plan Records to be Updated with ReviewCode] FROM dbo.InsuranceCompanyPlan icp 
--INNER JOIN dbo.InsurancePolicy ip ON ip.PracticeID = @SourcePracticeID AND icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID
----WHERE icp.ReviewCode = '' OR icp.ReviewCode IS NULL

--SELECT COUNT(*) AS [Referring Provider Records To Be Inserted] FROM dbo._import_2_9_Doctor d 
--WHERE NOT EXISTS(SELECT * FROM dbo.Doctor d2 WHERE d.FirstName = d2.FirstName AND d.LastName = d2.LastName AND d.NPI = d2.NPI AND d2.[External] = 1 AND d2.PracticeID = @TargetPracticeID)
--AND d.[External] = 1 AND d.PracticeID = @SourcePracticeID

SELECT COUNT(*) AS [Patients To Be Inserted] FROM dbo._import_2_9_Patient p WHERE p.PracticeID = @SourcePracticeID 
AND NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Patient Alert Records To Be Inserted] FROM dbo._import_2_9_PatientAlert pa 
--INNER JOIN dbo._import_2_9_Patient p ON pa.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Patient Journal Records To Be Inserted] FROM dbo._import_2_9_PatientJournalNote pjn
--INNER JOIN dbo._import_2_9_Patient p ON pjn.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Patient Case Records To Be Inserted] FROM dbo._import_2_9_PatientCase pc 
--INNER JOIN dbo._import_2_9_Patient p ON pc.PatientID = p.PatientID AND pc.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Patient Case Date Records To Be Inserted] FROM dbo._import_2_9_PatientCaseDate pcd 
--INNER JOIN dbo._import_2_9_PatientCase pc ON pcd.PatientCaseID = pc.PatientCaseID AND pc.PracticeID = @SourcePracticeID
--INNER JOIN dbo._import_2_9_Patient p ON pc.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Insurance Policy Records To Be Inserted] FROM dbo._import_2_9_InsurancePolicy ip
--INNER JOIN dbo._import_2_9_PatientCase pc ON ip.patientcaseid = pc.PatientCaseID AND pc.PracticeID = @SourcePracticeID
--INNER JOIN dbo._import_2_9_Patient p ON pc.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

--SELECT COUNT(*) AS [Insurance Policy Authorization Records To Be Inserted] FROM dbo._import_2_9_InsurancePolicyAuthorization ipa 
--INNER JOIN dbo._import_2_9_InsurancePolicy ip ON ipa.InsurancePolicyID = ip.InsurancePolicyID AND ip.PracticeID = @SourcePracticeID
--INNER JOIN dbo._import_2_9_PatientCase pc ON ip.PatientCaseID = pc.PatientCaseID AND pc.PracticeID = @SourcePracticeID
--INNER JOIN dbo._import_2_9_Patient p ON pc.PatientID = p.PatientID AND p.PracticeID = @SourcePracticeID
--WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Appointment Records To Be Inserted] FROM dbo._import_2_9_Appointment a
INNER JOIN dbo._import_2_9_Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Appointment Reason Records To Be Inserted] FROM dbo._import_2_9_AppointmentReason ars
WHERE NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE ars.Name = ar.Name AND ar.PracticeID = @TargetPracticeID) AND ars.PracticeID = @SourcePracticeID

SELECT COUNT(*) AS [Practice Resource Records To Be Inserted] FROM dbo._import_2_9_PracticeResource prs 
WHERE NOT EXISTS (SELECT * FROM dbo.PracticeResource pr WHERE prs.ResourceName = pr.resourcename AND prs.PracticeID = @TargetPracticeID) and prs.practiceid = @SourcePracticeID

SELECT COUNT(*) AS [Appointment to Appointment Reason Records To Be Inserted] FROM dbo._import_2_9_AppointmentToAppointmentReason atar 
INNER JOIN dbo._import_2_9_Appointment a ON atar.AppointmentID = a.AppointmentID
INNER JOIN dbo._import_2_9_Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Appointment to Resource - Doctor Resource Records To Be Inserted] FROM dbo._import_2_9_AppointmentToResource atr
INNER JOIN dbo._import_2_9_Appointment a ON atr.AppointmentID = a.AppointmentID AND a.PracticeID = @SourcePracticeID
INNER JOIN dbo._import_2_9_Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 
AND atr.AppointmentResourceTypeID = 1 AND atr.PracticeID = @SourcePracticeID

SELECT COUNT(*) AS [Appointment to Resource - Practice Resource Records To Be Inserted] FROM dbo._import_2_9_AppointmentToResource atr
INNER JOIN dbo._import_2_9_Appointment a ON atr.AppointmentID = a.AppointmentID AND a.PracticeID = @SourcePracticeID
INNER JOIN dbo._import_2_9_Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 
AND atr.AppointmentResourceTypeID = 2 AND atr.PracticeID = @SourcePracticeID

SELECT COUNT(*) AS [Appointment Recurrence Records To Be Inserted] FROM dbo._import_2_9_AppointmentRecurrence ar 
INNER JOIN dbo._import_2_9_Appointment a ON ar.AppointmentID = a.AppointmentID AND a.PracticeID = @SourcePracticeID
INNER JOIN dbo._import_2_9_Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 

SELECT COUNT(*) AS [Appointment Recurrence Exception Records To Be Inserted] FROM dbo._import_2_9_AppointmentRecurrenceException are 
INNER JOIN dbo._import_2_9_Appointment a ON are.AppointmentID = a.AppointmentID AND a.PracticeID = @SourcePracticeID
INNER JOIN dbo._import_2_9_Patient p ON a.PatientID = p.PatientID AND a.PracticeID = @SourcePracticeID
WHERE NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 


*/

/*
==========================================================================================================================================
DELETE SCRIPT
==========================================================================================================================================
*/

/*
DELETE FROM dbo.InsurancePolicyAuthorization WHERE InsurancePolicyID IN (SELECT InsurancePolicyID FROM dbo.InsurancePolicy WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy Auth records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.AppointmentRecurrenceException WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment  WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @TargetPracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment Recurr Excep records deleted'
DELETE FROM dbo.AppointmentRecurrence WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment  WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @TargetPracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment Recurr records deleted'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @TargetPracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @TargetPracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @TargetPracticeID)
DELETE FROM dbo.Patient WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.ServiceLocation WHERE VendorImportID = @VendorImportID AND PracticeID = @TargetPracticeID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Service Location records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.PracticeToInsuranceCompany WHERE PracticeID = @TargetPracticeID AND InsuranceCompanyID IN (SELECT InsuranceCompanyID FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Practice To Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
*/


UPDATE dbo.[_import_2_9_Doctor] SET NPI = '1558566299' WHERE DoctorID = 2

--SET IDENTITY_INSERT dbo.Practice ON

--PRINT ''
--PRINT 'Inserting Into Practice DELETE ME...'
--INSERT INTO dbo.Practice
--        ( PracticeID ,
--		  Name ,
--          EIN ,
--          MedicareGroupProviderNumber ,
--          AdministrativeContactPrefix ,
--          AdministrativeContactFirstName ,
--          AdministrativeContactMiddleName ,
--          AdministrativeContactLastName ,
--          AdministrativeContactSuffix ,
--          AdministrativeContactPhone ,
--          AdministrativeContactEmailAddress ,
--          AddressLine1 ,
--          AddressLine2 ,
--          City ,
--          State ,
--          Country ,
--          ZipCode ,
--          Phone ,
--          PhoneExt ,
--          Fax ,
--          FaxExt ,
--          WebSite ,
--          Notes ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          BillingAddressLine1 ,
--          BillingAddressLine2 ,
--          BillingCity ,
--          BillingState ,
--          BillingCountry ,
--          BillingZipCode ,
--          BillingPhone ,
--          BillingPhoneExt ,
--          BillingEmailAddress ,
--          AdministrativeContactPhoneExt ,
--          EnrolledForEStatements ,
--          EClaimsSendEnabled ,
--          EStatementsSendEnabled ,
--          EStatementsSendInTestMode ,
--          EStatementsLogin ,
--          EStatementsPassword ,
--          EStatementsNotes ,
--          EmailAddress ,
--          AdministrativeContactAddressLine1 ,
--          AdministrativeContactAddressLine2 ,
--          AdministrativeContactCity ,
--          AdministrativeContactState ,
--          AdministrativeContactCountry ,
--          AdministrativeContactZipCode ,
--          AdministrativeContactFax ,
--          AdministrativeContactFaxExt ,
--          BillingContactPrefix ,
--          BillingContactFirstName ,
--          BillingContactMiddleName ,
--          BillingContactLastName ,
--          BillingContactSuffix ,
--          BillingFax ,
--          BillingFaxExt ,
--          EClaimsEnrollmentStatusID ,
--          EClaimsNotes ,
--          CalendarStartTime ,
--          CalendarEndTime ,
--          CalendarIntervalMinutes ,
--          CalendarUseAppointmentPrimaryReasonColor ,
--          MedicalOfficeReportMaxDate ,
--          Active ,
--          ProcedureModifiersNumber ,
--          EStatementsVendorId ,
--          CalendarUseTimeblockColor ,
--          CalendarShowTimeblockLegend ,
--          DNIS ,
--          EStatementsPreferredPrintFormatId ,
--          EStatementsPreferredElectronicFormatId ,
--          EStatementsCustomText1 ,
--          EStatementsCustomText2 ,
--          EnforceTimeblockRules ,
--          NPI ,
--          EOSchedulingProviderID ,
--          EORenderingProviderID ,
--          EOSupervisingProviderID ,
--          EOServiceLocationID ,
--          EOShowProcedureDescription ,
--          EOShowDiagnosisDescription ,
--          EOPopulateCopay ,
--          EditionTypeID ,
--          SupportTypeID ,
--          Metrics ,
--          EStatementsMinimumAllowableBalance ,
--          EStatementsDaysBetweenStatements ,
--          PracticeAddressTypeID ,
--          RemitAddressTypeID ,
--          VisaAccepted ,
--          MastercardAccepted ,
--          AmexAccepted ,
--          DiscoverAccepted ,
--          OfficeHours ,
--          EligibilityDefaultProviderID ,
--          EligibilityAlwaysUseDefaultProvider ,
--          EStatementsShowPracticeNameInReturnAddress ,
--          MetricDRO ,
--          AppointmentRemindersEnabled ,
--          AppointmentRemindersDefault ,
--          AppointmentRemindersCCList ,
--          EOClaimTypes ,
--          EOClaimTypeDefaultID ,
--          EOShowAllEncounters ,
--          EODefaultRevenueCodeID ,
--          CustomNameText ,
--          WizardComplete ,
--          CurrentWizardStep ,
--          OnStepExit ,
--          PreferredPayerSourceID ,
--          EStatementsBillingSequenceID ,
--          EStatementsBillingDelay ,
--          PatientPaymentID ,
--          PhonecallRemindersEnabled ,
--          EStatementsMaxStatementsSent ,
--          EOCheckCodesOnApproval ,
--          ChecklistComplete ,
--          EhrDataMigrationStatus ,
--          IsLegacyEHRPartner ,
--          EOClaimTypePrintDefaultID
--        )
--SELECT 
--		  9 ,
--		  Name ,
--          EIN ,
--          MedicareGroupProviderNumber ,
--          AdministrativeContactPrefix ,
--          AdministrativeContactFirstName ,
--          AdministrativeContactMiddleName ,
--          AdministrativeContactLastName ,
--          AdministrativeContactSuffix ,
--          AdministrativeContactPhone ,
--          AdministrativeContactEmailAddress ,
--          AddressLine1 ,
--          AddressLine2 ,
--          City ,
--          State ,
--          Country ,
--          ZipCode ,
--          Phone ,
--          PhoneExt ,
--          Fax ,
--          FaxExt ,
--          WebSite ,
--          Notes ,
--          GETDATE() ,
--          0 ,
--          GETDATE() ,
--          0 ,
--          BillingAddressLine1 ,
--          BillingAddressLine2 ,
--          BillingCity ,
--          BillingState ,
--          BillingCountry ,
--          BillingZipCode ,
--          BillingPhone ,
--          BillingPhoneExt ,
--          BillingEmailAddress ,
--          AdministrativeContactPhoneExt ,
--          EnrolledForEStatements ,
--          EClaimsSendEnabled ,
--          EStatementsSendEnabled ,
--          EStatementsSendInTestMode ,
--          EStatementsLogin ,
--          EStatementsPassword ,
--          EStatementsNotes ,
--          EmailAddress ,
--          AdministrativeContactAddressLine1 ,
--          AdministrativeContactAddressLine2 ,
--          AdministrativeContactCity ,
--          AdministrativeContactState ,
--          AdministrativeContactCountry ,
--          AdministrativeContactZipCode ,
--          AdministrativeContactFax ,
--          AdministrativeContactFaxExt ,
--          BillingContactPrefix ,
--          BillingContactFirstName ,
--          BillingContactMiddleName ,
--          BillingContactLastName ,
--          BillingContactSuffix ,
--          BillingFax ,
--          BillingFaxExt ,
--          EClaimsEnrollmentStatusID ,
--          EClaimsNotes ,
--          CalendarStartTime ,
--          CalendarEndTime ,
--          CalendarIntervalMinutes ,
--          CalendarUseAppointmentPrimaryReasonColor ,
--          MedicalOfficeReportMaxDate ,
--          Active ,
--          ProcedureModifiersNumber ,
--          EStatementsVendorId ,
--          CalendarUseTimeblockColor ,
--          CalendarShowTimeblockLegend ,
--          DNIS ,
--          EStatementsPreferredPrintFormatId ,
--          EStatementsPreferredElectronicFormatId ,
--          EStatementsCustomText1 ,
--          EStatementsCustomText2 ,
--          EnforceTimeblockRules ,
--          NPI ,
--          EOSchedulingProviderID ,
--          EORenderingProviderID ,
--          EOSupervisingProviderID ,
--          EOServiceLocationID ,
--          EOShowProcedureDescription ,
--          EOShowDiagnosisDescription ,
--          EOPopulateCopay ,
--          EditionTypeID ,
--          SupportTypeID ,
--          Metrics ,
--          EStatementsMinimumAllowableBalance ,
--          EStatementsDaysBetweenStatements ,
--          PracticeAddressTypeID ,
--          RemitAddressTypeID ,
--          VisaAccepted ,
--          MastercardAccepted ,
--          AmexAccepted ,
--          DiscoverAccepted ,
--          OfficeHours ,
--          EligibilityDefaultProviderID ,
--          EligibilityAlwaysUseDefaultProvider ,
--          EStatementsShowPracticeNameInReturnAddress ,
--          MetricDRO ,
--          AppointmentRemindersEnabled ,
--          AppointmentRemindersDefault ,
--          AppointmentRemindersCCList ,
--          EOClaimTypes ,
--          EOClaimTypeDefaultID ,
--          EOShowAllEncounters ,
--          EODefaultRevenueCodeID ,
--          CustomNameText ,
--          WizardComplete ,
--          CurrentWizardStep ,
--          OnStepExit ,
--          PreferredPayerSourceID ,
--          EStatementsBillingSequenceID ,
--          EStatementsBillingDelay ,
--          PatientPaymentID ,
--          PhonecallRemindersEnabled ,
--          EStatementsMaxStatementsSent ,
--          EOCheckCodesOnApproval ,
--          ChecklistComplete ,
--          EhrDataMigrationStatus ,
--          IsLegacyEHRPartner ,
--          EOClaimTypePrintDefaultID
--FROM dbo.[_import_2_9_Practice]
--WHERE PracticeID = @SourcePracticeID
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--SET IDENTITY_INSERT dbo.Practice OFF

--PRINT ''
--PRINT 'Inserting Into Doctor - Renderring DELETE ME...'
--INSERT INTO dbo.Doctor
--        ( PracticeID ,
--          Prefix ,
--          FirstName ,
--          MiddleName ,
--          LastName ,
--          Suffix ,
--          SSN ,
--          AddressLine1 ,
--          AddressLine2 ,
--          City ,
--          State ,
--          Country ,
--          ZipCode ,
--          HomePhone ,
--          HomePhoneExt ,
--          WorkPhone ,
--          WorkPhoneExt ,
--          PagerPhone ,
--          PagerPhoneExt ,
--          MobilePhone ,
--          MobilePhoneExt ,
--          DOB ,
--          EmailAddress ,
--          Notes ,
--          ActiveDoctor ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          Degree ,
--          TaxonomyCode ,
--          VendorID ,
--          VendorImportID ,
--          FaxNumber ,
--          FaxNumberExt ,
--          [External] ,
--          NPI ,
--          ProviderTypeID ,
--          ProviderPerformanceReportActive ,
--          ProviderPerformanceScope ,
--          ProviderPerformanceFrequency ,
--          ProviderPerformanceDelay ,
--          ProviderPerformanceCarbonCopyEmailRecipients ,
--          ExternalBillingID ,
--          GlobalPayToAddressFlag ,
--          GlobalPayToName ,
--          GlobalPayToAddressLine1 ,
--          GlobalPayToAddressLine2 ,
--          GlobalPayToCity ,
--          GlobalPayToState ,
--          GlobalPayToZipCode ,
--          GlobalPayToCountry ,
--          KareoSpecialtyId
--        )
--SELECT    
--		  @TargetPracticeID , -- PracticeID - int
--          i.prefix , -- Prefix - varchar(16)
--          i.firstname , -- FirstName - varchar(64)
--          i.MiddleName , -- MiddleName - varchar(64)
--          i.LastName , -- LastName - varchar(64)
--          i.Suffix , -- Suffix - varchar(16)
--          i.SSN , -- SSN - varchar(9)
--          i.AddressLine1 , -- AddressLine1 - varchar(256)
--          i.AddressLine2 , -- AddressLine2 - varchar(256)
--          i.City , -- City - varchar(128)
--          i.State , -- State - varchar(2)
--          i.Country , -- Country - varchar(32)
--          i.ZipCode , -- ZipCode - varchar(9)
--          i.HomePhone , -- HomePhone - varchar(10)
--          i.HomePhoneExt , -- HomePhoneExt - varchar(10)
--          i.WorkPhone , -- WorkPhone - varchar(10)
--          i.WorkPhoneExt , -- WorkPhoneExt - varchar(10)
--          i.PagerPhone , -- PagerPhone - varchar(10)
--          i.PagerPhoneExt , -- PagerPhoneExt - varchar(10)
--          i.MobilePhone , -- MobilePhone - varchar(10)
--          i.MobilePhoneExt , -- MobilePhoneExt - varchar(10)
--          i.DOB , -- DOB - datetime
--          i.EmailAddress , -- EmailAddress - varchar(256)
--          i.Notes , -- Notes - text
--          1 , -- ActiveDoctor - bit
--          GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0 , -- ModifiedUserID - int
--          i.Degree , -- Degree - varchar(8)
--          i.TaxonomyCode , -- TaxonomyCode - char(10)
--          i.DoctorID , -- VendorID - varchar(50)
--          @VendorImportID , -- VendorImportID - int
--          i.FaxNumber , -- FaxNumber - varchar(10)
--          i.FaxNumberExt , -- FaxNumberExt - varchar(10)
--          0 , -- External - bit
--          i.NPI , -- NPI - varchar(10)
--          i.ProviderTypeID , -- ProviderTypeID - int
--          i.ProviderPerformanceReportActive , -- ProviderPerformanceReportActive - bit
--          i.ProviderPerformanceScope , -- ProviderPerformanceScope - int
--          i.ProviderPerformanceFrequency , -- ProviderPerformanceFrequency - char(1)
--          i.ProviderPerformanceDelay , -- ProviderPerformanceDelay - int
--          i.ProviderPerformanceCarbonCopyEmailRecipients , -- ProviderPerformanceCarbonCopyEmailRecipients - varchar(max)
--          i.ExternalBillingID , -- ExternalBillingID - varchar(50)
--          i.GlobalPayToAddressFlag , -- GlobalPayToAddressFlag - bit
--          i.GlobalPayToName , -- GlobalPayToName - varchar(128)
--          i.GlobalPayToAddressLine1 , -- GlobalPayToAddressLine1 - varchar(256)
--          i.GlobalPayToAddressLine2 , -- GlobalPayToAddressLine2 - varchar(256)
--          i.GlobalPayToCity , -- GlobalPayToCity - varchar(128)
--          i.GlobalPayToState , -- GlobalPayToState - varchar(2)
--          i.GlobalPayToZipCode , -- GlobalPayToZipCode - varchar(9)
--          i.GlobalPayToCountry , -- GlobalPayToCountry - varchar(32)
--          i.KareoSpecialtyId  -- KareoSpecialtyId - int
--FROM dbo.[_import_2_9_Doctor] i WHERE i.PracticeID = @SourcePracticeID AND i.DoctorID = 2 AND
--NOT EXISTS (SELECT * FROM dbo.Doctor d WHERE d.VendorID = i.DoctorID AND d.PracticeID = @TargetPracticeID)
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


CREATE TABLE #tempdoc (doctorid INT, firstname VARCHAR(65), lastname VARCHAR(65), NPI INT , [External] INT)
INSERT INTO #tempdoc (doctorid, firstname, lastname, NPI , [External] )
SELECT DISTINCT
		  d.doctorid ,
		  d.firstname ,-- firstname - varchar(65)
          d.lastname, -- lastname - varchar(65)
          d.npi ,  -- NPI - int
		  d.[External]
FROM dbo._import_2_9_Doctor d 
WHERE d.PracticeID = @SourcePracticeID 

UPDATE dbo.Doctor 
	SET VendorID = i.DoctorID
FROM dbo.Doctor d
INNER JOIN #tempdoc i ON
	i.FirstName = d.FirstName AND
    i.LastName = d.LastName AND
    i.NPI = d.NPI 
WHERE d.PracticeID = @TargetPracticeID AND d.[External] = 0

UPDATE dbo.Doctor 
	SET VendorID = i.DoctorID
FROM dbo.Doctor d
INNER JOIN #tempdoc i ON
	i.FirstName = d.FirstName AND
    i.LastName = d.LastName AND
    i.NPI = d.NPI 
WHERE d.PracticeID = @TargetPracticeID AND d.[External] = 1

CREATE TABLE #tempsl
( id INT , NAME VARCHAR(128))

INSERT INTO #tempsl
        ( id, NAME )
SELECT DISTINCT
		  sl.ServiceLocationID, -- id - int
          osl.Name  -- NAME - varchar(128)
FROM dbo.ServiceLocation sl 
INNER JOIN dbo._import_2_9_ServiceLocation osl ON
	osl.Name = sl.Name and
	OSl.PracticeID = @TargetPracticeID

PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
        ( 
		  PracticeID , 
          ReferringPhysicianID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Gender ,
          MaritalStatus ,
          HomePhone ,
          HomePhoneExt ,
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          ResponsiblePrefix ,
          ResponsibleFirstName ,
          ResponsibleMiddleName ,
          ResponsibleLastName ,
          ResponsibleSuffix ,
          ResponsibleRelationshipToPatient ,
          ResponsibleAddressLine1 ,
          ResponsibleAddressLine2 ,
          ResponsibleCity ,
          ResponsibleState ,
          ResponsibleCountry ,
          ResponsibleZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          InsuranceProgramCode ,
          --PatientReferralSourceID ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          --EmployerID ,
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
          EmergencyName ,
          EmergencyPhone ,
          EmergencyPhoneExt ,
          Ethnicity ,
          Race ,
          LicenseNumber ,
          LicenseState ,
          Language1 ,
          Language2
        )
SELECT DISTINCT
		  @TargetPracticeID , -- PracticeID - int
          rd.doctorID , -- ReferringPhysicianID - int
          p.Prefix , -- Prefix - varchar(16)
          p.FirstName , -- FirstName - varchar(64)
          p.MiddleName , -- MiddleName - varchar(64)
          p.LastName , -- LastName - varchar(64)
          p.Suffix , -- Suffix - varchar(16)
          p.AddressLine1 , -- AddressLine1 - varchar(256)
          p.AddressLine2 , -- AddressLine2 - varchar(256)
          p.City , -- City - varchar(128)
          p.[State] , -- State - varchar(2)
          p.Country , -- Country - varchar(32)
          p.ZipCode , -- ZipCode - varchar(9)
          p.Gender , -- Gender - varchar(1)
          p.MaritalStatus , -- MaritalStatus - varchar(1)
          p.HomePhone , -- HomePhone - varchar(10)
          p.HomePhoneExt , -- HomePhoneExt - varchar(10)
          p.WorkPhone , -- WorkPhone - varchar(10)
          p.WorkPhoneExt , -- WorkPhoneExt - varchar(10)
          p.DOB , -- DOB - datetime
          p.SSN , -- SSN - char(9)
          p.EmailAddress , -- EmailAddress - varchar(256)
          p.responsibledifferentthanpatient , -- ResponsibleDifferentThanPatient - bit
          p.ResponsiblePrefix , -- ResponsiblePrefix - varchar(16)
          p.ResponsibleFirstName , -- ResponsibleFirstName - varchar(64)
          p.ResponsibleMiddleName , -- ResponsibleMiddleName - varchar(64)
          p.ResponsibleLastName , -- ResponsibleLastName - varchar(64)
          p.ResponsibleSuffix , -- ResponsibleSuffix - varchar(16)
          p.ResponsibleRelationshipToPatient , -- ResponsibleRelationshipToPatient - varchar(1)
          p.ResponsibleAddressLine1 , -- ResponsibleAddressLine1 - varchar(256)
          p.ResponsibleAddressLine2 , -- ResponsibleAddressLine2 - varchar(256)
          p.ResponsibleCity , -- ResponsibleCity - varchar(128)
          p.ResponsibleState , -- ResponsibleState - varchar(2)
          p.ResponsibleCountry , -- ResponsibleCountry - varchar(32)
          p.ResponsibleZipCode , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          p.EmploymentStatus , -- EmploymentStatus - char(1)
          p.insuranceprogramcode  , -- InsuranceProgramCode - char(2)
          --prs.PatientReferralSourceID , -- PatientReferralSourceID - int
          pp.DoctorID , -- PrimaryProviderID - int
          CASE WHEN sl.ServiceLocationID IS NULL THEN (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @TargetPracticeID) ELSE sl.ServiceLocationID END , -- DefaultServiceLocationID - int
          --emp.EmployerID , -- EmployerID - int
          p.MedicalRecordNumber , -- MedicalRecordNumber - varchar(128)
          p.MobilePhone , -- MobilePhone - varchar(10)
          p.MobilePhoneExt , -- MobilePhoneExt - varchar(10)
          pcp.DoctorID , -- PrimaryCarePhysicianID - int
          p.PatientID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          p.CollectionCategoryID , -- CollectionCategoryID - int
          p.active , -- Active - bit
          p.sendemailcorrespondence , -- SendEmailCorrespondence - bit
          p.phonecallremindersenabled , -- PhonecallRemindersEnabled - bit
          p.EmergencyName , -- EmergencyName - varchar(128)
          p.EmergencyPhone , -- EmergencyPhone - varchar(10)
          p.EmergencyPhoneExt , -- EmergencyPhoneExt - varchar(10)
          p.Ethnicity , -- Ethnicity - varchar(64)
          p.Race , -- Race - varchar(64)
          p.LicenseNumber , -- LicenseNumber - varchar(64)
          p.LicenseState , -- LicenseState - varchar(2)
          p.Language1 , -- Language1 - varchar(64)
          p.Language2  -- Language2 - varchar(64)
FROM dbo.[_import_2_9_Patient] p
LEFT JOIN dbo.Doctor pp ON
	p.primaryproviderid = pp.VendorID AND
	pp.PracticeID = @TargetPracticeID
LEFT JOIN dbo.Doctor rd ON 
	p.referringphysicianid = rd.VendorID AND 
	rd.PracticeID = @TargetPracticeID
LEFT JOIN dbo.Doctor pcp ON	
	p.primarycarephysicianid = pcp.VendorID  AND
	pcp.PracticeID = @TargetPracticeID
LEFT JOIN dbo.#tempsl tsl ON
	p.DefaultServiceLocationID = tsl.id 
LEFT JOIN dbo.ServiceLocation sl ON
	tsl.NAME = sl.Name AND
    sl.PracticeID = @TargetPracticeID
WHERE p.PracticeID = @SourcePracticeID 
AND NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.DOB = p.dob AND pp.PracticeID = @TargetPracticeID) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment...'
INSERT INTO dbo.Appointment
        ( PatientID ,
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
          Subject ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          AppointmentResourceTypeID ,
          AppointmentConfirmationStatusCode ,
		  AllDay ,
          PatientCaseID ,
          Recurrence ,
          RecurrenceStartDate ,
          RangeEndDate ,
          RangeType ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm , 
		  InsurancePolicyAuthorizationID
        )
SELECT 
		  p.PatientID , -- PatientID - int
          @TargetPracticeID , -- PracticeID - int
          CASE WHEN SL.ServiceLocationID IS NULL THEN SL2.ServiceLocationID ELSE SL.ServiceLocationID END , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.appointmenttype , -- AppointmentType - varchar(1)
          i.appointmentid , -- Subject - varchar(64)
          i.notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          i.ModifiedDate , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.appointmentresourcetypeid , -- AppointmentResourceTypeID - int
          i.appointmentconfirmationstatuscode , -- AppointmentConfirmationStatusCode - char(1)
		  i.AllDay ,
          pc.PatientCaseID ,
          i.recurrence ,
          i.RecurrenceStartDate ,
          NULL ,
          i.RangeType ,
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttm , -- StartTm - smallint
          i.endtm , -- EndTm - smallint
		  CASE WHEN ipa.InsurancePolicyAuthorizationID IS NOT NULL THEN ipa.InsurancePolicyAuthorizationID ELSE NULL END
FROM dbo.[_import_2_9_Appointment] i
	INNER JOIN dbo.Patient p ON
		p.VendorID = i.patientid AND
		p.VendorImportID = @VendorImportID
	LEFT JOIN dbo.PatientCase pc ON
		pc.VendorID = i.patientcaseid AND
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.DateKeyToPractice dk ON
        dk.[PracticeID] = @TargetPracticeID AND
        dk.Dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
	LEFT JOIN dbo.InsurancePolicyAuthorization ipa ON
		ipa.VendorID = i.insurancepolicyauthorizationid AND
		ipa.VendorImportID = @VendorImportID
	LEFT JOIN dbo.#tempsl tsl ON
		i.ServiceLocationID = tsl.id 
	LEFT JOIN dbo.ServiceLocation sl ON
		tsl.NAME = sl.Name AND
		sl.PracticeID = @TargetPracticeID
	LEFT JOIN dbo.ServiceLocation SL2 ON 
		SL2.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @TargetPracticeID)
WHERE i.PracticeID = @SourcePracticeID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into PracticeResource...'
INSERT INTO dbo.PracticeResource
        ( PracticeResourceTypeID ,
          PracticeID ,
          ResourceName ,
          ModifiedDate ,
          CreatedDate
        )
SELECT DISTINCT
		  i.practiceresourcetypeid , -- PracticeResourceTypeID - int
          @TargetPracticeID , -- PracticeID - int
          i.resourcename , -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
FROM dbo.[_import_2_9_PracticeResource] i
WHERE i.resourcename <> '' AND NOT EXISTS (SELECT * FROM dbo.PracticeResource pr WHERE pr.ResourceName = i.resourcename AND pr.PracticeID = @TargetPracticeID) and i.practiceid = @SourcePracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into AppointmentReason...'
INSERT  INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
          DefaultColorCode ,
          Description ,
          ModifiedDate 
        )
SELECT DISTINCT
		  @TargetPracticeID , -- PracticeID - int
          i.Name , -- Name - varchar(128)
          i.DefaultDurationMinutes , -- DefaultDurationMinutes - int
          i.DefaultColorCode , -- DefaultColorCode - int
          i.[Description] , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[_import_2_9_AppointmentReason] i
WHERE i.name <> '' AND NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE i.Name = ar.Name AND ar.PracticeID = @TargetPracticeID) and i.practiceid = @SourcePracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

CREATE TABLE #apptreason
(
	appointmentid INT , 
	reasonname VARCHAR(50)
)

PRINT ''
PRINT 'Inserting Into #apptreason...'
INSERT INTO #apptreason
	(appointmentid, reasonname)
SELECT DISTINCT
	atar.AppointmentID ,
	ar.Name
FROM dbo.[_import_2_9_AppointmentReason] ar
INNER JOIN dbo.[_import_2_9_AppointmentToAppointmentReason] atar ON
	ar.AppointmentReasonID = atar.AppointmentReasonID AND
	ar.PracticeID = @SourcePracticeID
INNER JOIN dbo.[_import_2_9_Appointment] a ON 
	a.PracticeID = @SourcePracticeID AND
	a.AppointmentID = atar.AppointmentID
WHERE ar.PracticeID = @SourcePracticeID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment to Appointment Reason...'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          sar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @TargetPracticeID  -- PracticeID - int
	FROM #apptreason ar
		INNER JOIN dbo.AppointmentReason sar ON
			sar.AppointmentReasonID = (SELECT MAX(AppointmentReasonID) FROM dbo.AppointmentReason sar2 
									  WHERE sar2.Name = ar.reasonname AND sar2.PracticeID = @TargetPracticeID) 
	INNER JOIN dbo.Appointment a ON 
		a.PracticeID = @TargetPracticeID AND
		ar.appointmentid = a.[Subject]
WHERE a.CreatedDate > DATEADD(mi,-5,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

CREATE TABLE #appttopracres
(
	appointmentid INT , 
	pracresourcename VARCHAR(50)
)

PRINT ''
PRINT 'Inserting Into #appttopracres...'
INSERT INTO #appttopracres
	(appointmentid, pracresourcename)
SELECT DISTINCT
	atr.AppointmentID ,
	pr.ResourceName
FROM dbo.[_import_2_9_AppointmentToResource] atr
INNER JOIN dbo.[_import_2_9_PracticeResource] pr ON
	atr.ResourceID = pr.PracticeResourceID  AND
	atr.PracticeID = @SourcePracticeID
INNER JOIN dbo.[_import_2_9_Appointment] a ON 
	a.AppointmentID = atr.AppointmentID AND
	a.PracticeID = @SourcePracticeID
WHERE atr.AppointmentResourceTypeID = 2
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment to Resource - Practice Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          2 , -- AppointmentResourceTypeID - int
          pr.PracticeResourceID , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @TargetPracticeID  -- PracticeID - int
FROM #appttopracres atpr
	INNER JOIN dbo.PracticeResource pr ON	
		pr.ResourceName = atpr.pracresourcename AND
		pr.PracticeID = @TargetPracticeID
	INNER JOIN dbo.Appointment a ON
		a.[Subject] = atpr.appointmentid AND
		a.PracticeID = @TargetPracticeID
WHERE a.CreatedDate > DATEADD(mi,-5,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment to Resource - Doctor Resource'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
	      a.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          CASE 
			WHEN d.DoctorID IS NULL THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'Timothy' AND LastName = 'Bortz' AND PracticeID = @TargetPracticeID AND [External]= 0 AND ActiveDoctor = 1) 
		  ELSE d.DoctorID END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @TargetPracticeID  -- PracticeID - int
FROM dbo.[_import_2_9_AppointmentToResource] i
	INNER JOIN dbo.Appointment a ON
		a.[Subject] = i.appointmentid AND
		a.PracticeID = @TargetPracticeID
	LEFT JOIN dbo.Doctor d ON
		i.resourceid = d.VendorID AND
		d.PracticeID = @TargetPracticeID
WHERE a.CreatedDate > DATEADD(mi,-5,GETDATE()) AND i.AppointmentResourceTypeID = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

CREATE TABLE #apptrecurappt (AppointmentID INT, RangeEndDate DATETIME)

INSERT INTO #apptrecurappt
        ( AppointmentID, RangeEndDate )
SELECT DISTINCT
		  i.AppointmentID, -- AppointmentID - int
          i.RangeEndDate  -- RangeEndDate - datetime
FROM dbo.[_import_2_9_Appointment] i
WHERE i.PracticeID = @SourcePracticeID 


PRINT ''
PRINT 'Updating Appointment RangeEndDate...'
UPDATE dbo.Appointment
	SET RangeEndDate = i.RangeEndDate
FROM dbo.Appointment a 
INNER JOIN #apptrecurappt i ON
	i.AppointmentID = a.[Subject] AND
    a.PracticeID = @TargetPracticeID
WHERE a.CreatedDate > DATEADD(mi,-2,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated...'

USE superbill_42931_prod
GO 
DISABLE TRIGGER ALL ON dbo.AppointmentRecurrence
GO


DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 9
SET @SourcePracticeID = 1
SET @VendorImportID = 2

SET XACT_ABORT ON

PRINT ''
PRINT 'Inserting Into Appointment Recurrence...'
INSERT INTO dbo.AppointmentRecurrence
        ( AppointmentID ,
          Type ,
          WeeklyNumWeeks ,
          WeeklyOnSunday ,
          WeeklyOnMonday ,
          WeeklyOnTuesday ,
          WeeklyOnWednesday ,
          WeeklyOnThursday ,
          WeeklyOnFriday ,
          WeeklyOnSaturday ,
          DailyType ,
          DailyNumDays ,
          MonthlyType ,
          MonthlyNumMonths ,
          MonthlyDayOfMonth ,
          MonthlyWeekTypeOfMonth ,
          MonthlyTypeOfDay ,
          YearlyType ,
          YearlyDayTypeOfMonth ,
          YearlyTypeOfDay ,
          YearlyDayOfMonth ,
          YearlyMonth ,
          RangeType ,
          RangeEndOccurrences ,
          RangeEndDate ,
          ModifiedDate ,
          ModifiedUserID ,
          StartDate 
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          i.[Type] , -- Type - char(1)
          i.WeeklyNumWeeks , -- WeeklyNumWeeks - int
          i.WeeklyOnSunday , -- WeeklyOnSunday - bit
          i.WeeklyOnMonday , -- WeeklyOnMonday - bit
          i.WeeklyOnTuesday , -- WeeklyOnTuesday - bit
          i.WeeklyOnWednesday , -- WeeklyOnWednesday - bit
          i.weeklyonthursday , -- WeeklyOnThursday - bit
          i.WeeklyOnFriday , -- WeeklyOnFriday - bit
          i.WeeklyOnSaturday , -- WeeklyOnSaturday - bit
          i.DailyType , -- DailyType - char(1)
          i.DailyNumDays , -- DailyNumDays - int
          i.MonthlyType , -- MonthlyType - char(1)
          i.MonthlyNumMonths , --  - int
          i.MonthlyDayOfMonth , -- MonthlyDayOfMonth - int
          i.MonthlyWeekTypeOfMonth , -- MonthlyWeekTypeOfMonth - char(1)
          i.MonthlyTypeOfDay , -- MonthlyTypeOfDay - char(1)
          i.YearlyType , -- YearlyType - char(1)
          i.YearlyDayTypeOfMonth , -- YearlyDayTypeOfMonth - char(1)
          i.YearlyTypeOfDay , -- YearlyTypeOfDay - char(1)
          i.YearlyDayOfMonth , -- YearlyDayOfMonth - int
          i.YearlyMonth , -- YearlyMonth - int
          i.RangeType , -- RangeType - char(1)
          i.RangeEndOccurrences , -- RangeEndOccurrences - int
          a.RangeEndDate , -- RangeEndDate - datetime
          i.ModifiedDate , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.StartDate  -- StartDate - datetime
FROM dbo.[_import_2_9_AppointmentRecurrence] i 
INNER JOIN dbo.Appointment a ON
	i.AppointmentID = a.[Subject] AND
	a.PracticeID = @TargetPracticeID 
WHERE a.CreatedDate > DATEADD(mi,-2,GETDATE()) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

USE superbill_42931_prod
GO
 ENABLE TRIGGER ALL ON dbo.AppointmentRecurrence
GO


USE superbill_42931_prod
GO
 DISABLE TRIGGER ALL ON dbo.AppointmentRecurrenceException
GO
SET XACT_ABORT ON

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 9
SET @SourcePracticeID = 1
SET @VendorImportID = 2

PRINT ''
PRINT 'Inserting Into Appointment Recurrence Exception...'
INSERT INTO dbo.AppointmentRecurrenceException
        ( AppointmentID ,
          ExceptionDate ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
	      a.AppointmentID , -- AppointmentID - int
          i.exceptiondate , -- ExceptionDate - datetime
          i.ModifiedDate , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_2_9_AppointmentRecurrenceException] i
INNER JOIN dbo.Appointment a ON 
	i.AppointmentID = a.[subject] AND
	a.PracticeID = @TargetPracticeID 
WHERE a.CreatedDate > DATEADD(mi,-2,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

USE superbill_42931_prod
GO
ENABLE TRIGGER ALL ON dbo.AppointmentRecurrenceException

GO

DROP TABLE #tempdoc
--DROP TABLE #tempemp
DROP TABLE #tempsl
DROP TABLE #apptreason 
DROP TABLE #appttopracres
DROP TABLE #apptrecurappt


--COMMIT 
--ROLLBACK
