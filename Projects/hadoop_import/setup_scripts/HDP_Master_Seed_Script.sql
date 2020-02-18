------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------- Default Values For Setting Up Hadoop Import -------------------------------------------
-------------------------------------------- Modified: Jan 15, 2018                      -------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------


BEGIN

-------------------------------------------------------------- REPORTING LOG --------------------------------------------------------------

  /****** Object:  Table [dbo].[HDP_ColumnsToImport] ******/
  /****** Setting Columns to Import into Hive        ******/

  Use [ReportingLog]

  UPDATE HDP_ColumnsToImport
  SET ColumnImportFlag = 1
  UPDATE HDP_ColumnsToImport
  SET ColumnImportFlag = 0
  WHERE TABLEID = (Select TableId from HDP_TablesToImport where TableName = 'ClaimTransaction') AND
        ColumnName IN
        ('Quantity', 'Code', 'ReferenceID',
                                     'ReferenceData', 'Notes', 'ModifiedDate', 'TIMESTAMP',
                                     'PK_ClaimTransaction', 'BatchKey', 'Original_ClaimTransactionID', 'Claim_ProviderID',
                                                            'IsFirstBill', 'CreatedUserID', 'ModifiedUserID', 'AdjustmentGroupID',
         'Reversible', 'overrideClosingDate', 'FollowUpDate', 'ClaimResponseStatusID')


    /****** Object:  Table [dbo].[HDP_ColumnsToImport] ******/
    /****** Setting Columns For Bucketing       ******/


    UPDATE HDP_ColumnsToImport
    SET isMergeMatch = 0
    UPDATE HDP_ColumnsToImport
    SET isMergeMatch = 1
    WHERE TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'Department') AND ColumnName IN ('DepartmentID')  OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'DiagnosisCodeDictionary') AND ColumnName IN ('DiagnosisCodeDictionaryID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'Doctor') AND ColumnName IN ('DoctorID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'ProcedureCodeCategory') AND ColumnName IN ('ProcedureCodeCategoryID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'Encounter') AND ColumnName IN ('EncounterID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'EncounterDiagnosis') AND ColumnName IN ('EncounterDiagnosisID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'EncounterProcedure') AND ColumnName IN ('EncounterProcedureID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'EncounterStatus') AND ColumnName IN ('EncounterStatusID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'InsuranceCompanyPlan') AND ColumnName IN ('InsuranceCompanyPlanID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'CapitatedAccount') AND ColumnName IN ('CapitatedAccountID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'Other') AND ColumnName IN ('OtherID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'Patient') AND ColumnName IN ('PatientID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'CapitatedAccountToPayment') AND ColumnName IN ('PaymentID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'PayerTypeCode') AND ColumnName IN ('PayerTypeCode') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'Payment') AND ColumnName IN ('PaymentID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'ClaimAccounting_Errors') AND ColumnName IN ('ClaimID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'LastAction') AND ColumnName IN ('LastActionID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'PaymentMethodCode') AND ColumnName IN ('PaymentMethodCode') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'PayerScenarioType') AND ColumnName IN ('PayerScenarioTypeID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'Practice') AND ColumnName IN ('PracticeID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'ICD10DiagnosisCodeDictionary') AND ColumnName IN ('ICD10DiagnosisCodeDictionaryId') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'ClaimStateFollowUp') AND ColumnName IN ('ClaimID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'InsuranceCompany') AND ColumnName IN ('InsuranceCompanyID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'Refund') AND ColumnName IN ('RefundID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'ProcedureCodeRevenueCenterCategory') AND ColumnName IN ('ProcedureCodeRevenueCenterCategoryID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'RefundStatusCode') AND ColumnName IN ('RefundStatusCode') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'RefundToPayments') AND ColumnName IN ('RefundToPaymentsID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'PatientCaseDate') AND ColumnName IN ('PatientCaseDateID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'ServiceLocation') AND ColumnName IN ('ServiceLocationID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'PatientCase') AND ColumnName IN ('PatientCaseID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'PayerScenario') AND ColumnName IN ('PayerScenarioID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'InsurancePolicy') AND ColumnName IN ('InsurancePolicyID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'Adjustment') AND ColumnName IN ('AdjustmentCode') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'Appointment') AND ColumnName IN ('AppointmentID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'AppointmentReason') AND ColumnName IN ('AppointmentReasonID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'TaxonomyCode') AND ColumnName IN ('TaxonomyCode') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'ClaimAccounting_FollowUp') AND ColumnName IN ('ClaimID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'AppointmentToAppointmentReason') AND ColumnName IN ('AppointmentToAppointmentReasonID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'TaxonomySpecialty') AND ColumnName IN ('TaxonomySpecialtyCode') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'TaxonomyType') AND ColumnName IN ('TaxonomyTypeCode') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'InsurancePolicyAuthorization') AND ColumnName IN ('InsurancePolicyAuthorizationID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'PaymentType') AND ColumnName IN ('PaymentTypeID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'ClaimResponseStatus') AND ColumnName IN ('ClaimResponseStatusID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'PaymentClaim') AND ColumnName IN ('PaymentID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'ClaimAccounting') AND ColumnName IN ('ClaimTransactionID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'Claim') AND ColumnName IN ('ClaimID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'ClaimAccounting_Assignments') AND ColumnName IN ('ClaimTransactionID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'ClaimTransaction') AND ColumnName IN ('ClaimTransactionID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'ClaimTransactionType') AND ColumnName IN ('ClaimTransactionTypeCode') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'ClaimAccounting_Billings') AND ColumnName IN ('ClaimTransactionID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'EncounterHistory') AND ColumnName IN ('EncounterID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'ICD9ToICD10Crosswalk') AND ColumnName IN ('ICD9ToICD10CrosswalkID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'ProductDomain_ProductSubscription') AND ColumnName IN ('ProductSubscriptionId') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'Users') AND ColumnName IN ('UserID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'Signup_Order') AND ColumnName IN ('OrderID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'OrderID') AND ColumnName IN ('DiagnosisCodeDictionaryID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'ProviderType') AND ColumnName IN ('ProviderTypeID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'Signup_ProviderLicense') AND ColumnName IN ('ProviderLicenseID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'Signup_ProviderLicenseProduct') AND ColumnName IN ('ProviderLicenseProductID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'Signup_AccountDiscount') AND ColumnName IN ('AccountDiscountID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'MedicareFeeScheduleRVUBatch') AND ColumnName IN ('MedicareFeeScheduleRVUBatchID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'Signup_AccountDiscountType') AND ColumnName IN ('AccountDiscountTypeID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'MedicareFeeScheduleRVU') AND ColumnName IN ('MedicareFeeScheduleRVUID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'Customer') AND ColumnName IN ('CustomerID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'Clearinghouse') AND ColumnName IN ('ClearinghouseID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'Signup_Attribution') AND ColumnName IN ('AttributionID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'ProductDomain_Product') AND ColumnName IN ('ProductId') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'ClearinghousePayersList') AND ColumnName IN ('ClearinghousePayerID') OR
      TABLEID IN (Select TableId from HDP_TablesToImport where TableName = 'ProductDomain_ProductPromoCodes') AND ColumnName IN ('PromoCodeID')

END