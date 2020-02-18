BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;

-- Run this on the development KareoBizClaims or kprod-rs01...
USE KareoBizclaims;
GO

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @customer_ID AS INT ,
    @claim_ID AS INT ,
    @practice_ID AS INT ,
    @claim_k9_number AS VARCHAR(128) ,
    @batch_ID AS INT ,
    @prefetcher_file_name AS VARCHAR(128) ,
    @prefetcher_file_receive_date AS DATETIME ,
    @prefetcher_pcn_number AS VARCHAR(128);
    
DECLARE @claim_messages AS TABLE
    (
      [ClaimMessageId] [int] NOT NULL ,
      [BiztalkMessageId] [varchar](128) NULL ,
      [errors] [text] NULL ,
      [result] [int] NULL ,
      [count] [int] NULL ,
      [startedutc] [datetime] NULL ,
      [durationms] [decimal](18, 0) NULL ,
      [data] [ntext] NULL ,
      [RoutingPayerConnection] [int] NULL ,
      [RoutingPayerNumber] [varchar](30) NULL ,
      [RoutingPayerType] [varchar](30) NULL ,
      [RoutingPayerName] [varchar](128) NULL ,
      [RoutingRoutingPreference] [varchar](512) NULL ,
      [RoutingSourceName] [varchar](128) NULL ,
      [RoutingPaytoName] [varchar](128) NULL ,
      [RoutingPaytoTaxIdType] [char](2) NOT NULL ,
      [RoutingPaytoTaxId] [varchar](20) NOT NULL ,
      [RoutingBillerType] [varchar](20) NULL ,
      [DataDataCreatedDate] [datetime] NULL ,
      [DataOriginalCustomerId] [int] NULL ,
      [DataOriginalPracticeId] [int] NULL ,
      [DataOriginalClaimId] [int] NULL ,
      [DataOriginalBatchId] [int] NULL ,
      [ClaimK9Number] [varchar](128) NULL ,
      [ClaimK9Numbers] [varchar](1024) NULL ,
      [ClaimTotalAmount] [decimal](18, 0) NULL ,
      [ClaimServiceFacilityName] [varchar](128) NULL ,
      [ClaimDiagnoses] [varchar](1024) NULL ,
      [ClaimProcedures] [varchar](1024) NULL ,
      [PatientOriginalId] [int] NULL ,
      [PatientFirstName] [varchar](64) NULL ,
      [PatientLastName] [varchar](64) NULL ,
      [PatientMiddleName] [varchar](64) NULL ,
      [PatientRelationToInsured] [varchar](20) NULL ,
      [ProviderFirstName] [varchar](64) NULL ,
      [ProviderLastName] [varchar](64) NULL ,
      [ProviderMiddleName] [varchar](64) NULL ,
      [ProviderUpin] [varchar](20) NULL ,
      [ProviderSpecialtyCode] [varchar](20) NULL ,
      [PolicyGroupNumber] [varchar](64) NULL ,
      [PolicyPolicyNumber] [varchar](64) NULL ,
      [PayerAddressStreet] [varchar](128) NULL ,
      [PayerAddressCity] [varchar](64) NULL ,
      [PayerAddressState] [varchar](64) NULL ,
      [PayerAddressZipcode] [varchar](64) NULL ,
      [PayerAddressCountry] [varchar](64) NULL ,
      [PayerPhone] [varchar](64) NULL ,
      [CreatedDate] [datetime] NOT NULL ,
      [CreatedUserID] [int] NOT NULL ,
      [ModifiedDate] [datetime] NOT NULL ,
      [ModifiedUserID] [int] NOT NULL ,
      [RoutingClaimTypeId] [int] NOT NULL
    );
	
-- Change the Practice ID    
SET @practice_ID = 3;
-- Change the Customer ID    
SET @customer_ID = 7250;
-- Change the Claim ID    
SET @claim_ID = 1258;
-- Change the Claim K9 Number    
SET @claim_k9_number = '822Z7250';
-- You can find the batch-number from the claim-transactions
-- Change from NULL to check for Batches...
SET @batch_ID = NULL;
 -- 3725747;
-- You can grab the file received date minimum from the claim-message-transactions.
SET @prefetcher_file_receive_date = NULL;
 -- '2012-04-22';
-- You may not have @clearinghouse_file_name at first.
-- Change from NULL to find by Prefetcher File Name (Required: @prefetcher_file_receive_date)...
SET @prefetcher_file_name = NULL;
 -- '042312_6470.csr.pgp';
-- Change from NULL to find by PCN number (Required: @prefetcher_file_receive_date)...
SET @prefetcher_pcn_number = @claim_k9_number;


SELECT  @customer_ID AS 'CustomerID' ,
        @claim_ID AS 'ClaimID' ,
        @practice_ID AS 'PracticeID' ,
        @claim_k9_number AS 'ClaimK9Number';

IF @batch_ID IS NOT NULL 
    BEGIN
        SELECT  *
        FROM    dbo.Batch AS B WITH ( NOLOCK )
        WHERE   B.BatchId = @batch_ID;

        SELECT  *
        FROM    dbo.BatchTransaction AS BT WITH ( NOLOCK )
        WHERE   BT.BatchId = @batch_ID;
    END
 
INSERT  INTO @claim_messages
        ( ClaimMessageId ,
          BiztalkMessageId ,
          errors ,
          result ,
          count ,
          startedutc ,
          durationms ,
          data ,
          RoutingPayerConnection ,
          RoutingPayerNumber ,
          RoutingPayerType ,
          RoutingPayerName ,
          RoutingRoutingPreference ,
          RoutingSourceName ,
          RoutingPaytoName ,
          RoutingPaytoTaxIdType ,
          RoutingPaytoTaxId ,
          RoutingBillerType ,
          DataDataCreatedDate ,
          DataOriginalCustomerId ,
          DataOriginalPracticeId ,
          DataOriginalClaimId ,
          DataOriginalBatchId ,
          ClaimK9Number ,
          ClaimK9Numbers ,
          ClaimTotalAmount ,
          ClaimServiceFacilityName ,
          ClaimDiagnoses ,
          ClaimProcedures ,
          PatientOriginalId ,
          PatientFirstName ,
          PatientLastName ,
          PatientMiddleName ,
          PatientRelationToInsured ,
          ProviderFirstName ,
          ProviderLastName ,
          ProviderMiddleName ,
          ProviderUpin ,
          ProviderSpecialtyCode ,
          PolicyGroupNumber ,
          PolicyPolicyNumber ,
          PayerAddressStreet ,
          PayerAddressCity ,
          PayerAddressState ,
          PayerAddressZipcode ,
          PayerAddressCountry ,
          PayerPhone ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          RoutingClaimTypeId
        )
        SELECT TOP 100
                [ClaimMessageId] ,
                [BiztalkMessageId] ,
                [errors] ,
                [result] ,
                [count] ,
                [startedutc] ,
                [durationms] ,
                [data] ,
                [RoutingPayerConnection] ,
                [RoutingPayerNumber] ,
                [RoutingPayerType] ,
                [RoutingPayerName] ,
                [RoutingRoutingPreference] ,
                [RoutingSourceName] ,
                [RoutingPaytoName] ,
                [RoutingPaytoTaxIdType] ,
                [RoutingPaytoTaxId] ,
                [RoutingBillerType] ,
                [DataDataCreatedDate] ,
                [DataOriginalCustomerId] ,
                [DataOriginalPracticeId] ,
                [DataOriginalClaimId] ,
                [DataOriginalBatchId] ,
                [ClaimK9Number] ,
                [ClaimK9Numbers] ,
                [ClaimTotalAmount] ,
                [ClaimServiceFacilityName] ,
                [ClaimDiagnoses] ,
                [ClaimProcedures] ,
                [PatientOriginalId] ,
                [PatientFirstName] ,
                [PatientLastName] ,
                [PatientMiddleName] ,
                [PatientRelationToInsured] ,
                [ProviderFirstName] ,
                [ProviderLastName] ,
                [ProviderMiddleName] ,
                [ProviderUpin] ,
                [ProviderSpecialtyCode] ,
                [PolicyGroupNumber] ,
                [PolicyPolicyNumber] ,
                [PayerAddressStreet] ,
                [PayerAddressCity] ,
                [PayerAddressState] ,
                [PayerAddressZipcode] ,
                [PayerAddressCountry] ,
                [PayerPhone] ,
                [CreatedDate] ,
                [CreatedUserID] ,
                [ModifiedDate] ,
                [ModifiedUserID] ,
                [RoutingClaimTypeId]
        FROM    dbo.ClaimMessage AS CM WITH ( NOLOCK )
        WHERE   CM.DataOriginalCustomerID = @customer_ID
                AND CM.DataOriginalPracticeID = @practice_ID
                AND CM.DataOriginalClaimId = @claim_ID
        ORDER BY CM.ClaimMessageId DESC;

IF @@ROWCOUNT = 0
    AND @claim_k9_number IS NOT NULL 
    BEGIN
        SELECT  'Did not find Claim ID';

        INSERT  INTO @claim_messages
                ( ClaimMessageId ,
                  BiztalkMessageId ,
                  errors ,
                  result ,
                  count ,
                  startedutc ,
                  durationms ,
                  data ,
                  RoutingPayerConnection ,
                  RoutingPayerNumber ,
                  RoutingPayerType ,
                  RoutingPayerName ,
                  RoutingRoutingPreference ,
                  RoutingSourceName ,
                  RoutingPaytoName ,
                  RoutingPaytoTaxIdType ,
                  RoutingPaytoTaxId ,
                  RoutingBillerType ,
                  DataDataCreatedDate ,
                  DataOriginalCustomerId ,
                  DataOriginalPracticeId ,
                  DataOriginalClaimId ,
                  DataOriginalBatchId ,
                  ClaimK9Number ,
                  ClaimK9Numbers ,
                  ClaimTotalAmount ,
                  ClaimServiceFacilityName ,
                  ClaimDiagnoses ,
                  ClaimProcedures ,
                  PatientOriginalId ,
                  PatientFirstName ,
                  PatientLastName ,
                  PatientMiddleName ,
                  PatientRelationToInsured ,
                  ProviderFirstName ,
                  ProviderLastName ,
                  ProviderMiddleName ,
                  ProviderUpin ,
                  ProviderSpecialtyCode ,
                  PolicyGroupNumber ,
                  PolicyPolicyNumber ,
                  PayerAddressStreet ,
                  PayerAddressCity ,
                  PayerAddressState ,
                  PayerAddressZipcode ,
                  PayerAddressCountry ,
                  PayerPhone ,
                  CreatedDate ,
                  CreatedUserID ,
                  ModifiedDate ,
                  ModifiedUserID ,
                  RoutingClaimTypeId
                )
                SELECT TOP 100
                        [ClaimMessageId] ,
                        [BiztalkMessageId] ,
                        [errors] ,
                        [result] ,
                        [count] ,
                        [startedutc] ,
                        [durationms] ,
                        [data] ,
                        [RoutingPayerConnection] ,
                        [RoutingPayerNumber] ,
                        [RoutingPayerType] ,
                        [RoutingPayerName] ,
                        [RoutingRoutingPreference] ,
                        [RoutingSourceName] ,
                        [RoutingPaytoName] ,
                        [RoutingPaytoTaxIdType] ,
                        [RoutingPaytoTaxId] ,
                        [RoutingBillerType] ,
                        [DataDataCreatedDate] ,
                        [DataOriginalCustomerId] ,
                        [DataOriginalPracticeId] ,
                        [DataOriginalClaimId] ,
                        [DataOriginalBatchId] ,
                        [ClaimK9Number] ,
                        [ClaimK9Numbers] ,
                        [ClaimTotalAmount] ,
                        [ClaimServiceFacilityName] ,
                        [ClaimDiagnoses] ,
                        [ClaimProcedures] ,
                        [PatientOriginalId] ,
                        [PatientFirstName] ,
                        [PatientLastName] ,
                        [PatientMiddleName] ,
                        [PatientRelationToInsured] ,
                        [ProviderFirstName] ,
                        [ProviderLastName] ,
                        [ProviderMiddleName] ,
                        [ProviderUpin] ,
                        [ProviderSpecialtyCode] ,
                        [PolicyGroupNumber] ,
                        [PolicyPolicyNumber] ,
                        [PayerAddressStreet] ,
                        [PayerAddressCity] ,
                        [PayerAddressState] ,
                        [PayerAddressZipcode] ,
                        [PayerAddressCountry] ,
                        [PayerPhone] ,
                        [CreatedDate] ,
                        [CreatedUserID] ,
                        [ModifiedDate] ,
                        [ModifiedUserID] ,
                        [RoutingClaimTypeId]
                FROM    dbo.ClaimMessage AS CM WITH ( NOLOCK )
                WHERE   CM.DataOriginalCustomerID = @customer_ID
                        AND CM.DataOriginalPracticeID = @practice_ID
                        AND CM.ClaimK9Number = @claim_k9_number
                ORDER BY CM.ClaimMessageId DESC;
    END

IF @@ROWCOUNT > 0 
    BEGIN
        SELECT  *
        FROM    @claim_messages;
    END
ELSE 
    BEGIN
        SELECT  'Found no claim-messages';
    END

SELECT TOP 100
        *
FROM    dbo.ClaimMessageTransaction AS CMT WITH ( NOLOCK )
        INNER JOIN @claim_messages AS CM ON CM.ClaimMessageId = CMT.ClaimMessageId;

-- Prefetcher file-searches are very slow...
-- The file can be found in \\kprod-bt01\FileStorage\claims\received\ + PF.FileStorageLocation
IF @prefetcher_file_name IS NOT NULL
    AND @prefetcher_file_receive_date IS NOT NULL 
    BEGIN
        SELECT  PF.PrefetcherFileId ,
                PF.FileName ,
                PF.FileReceiveDate ,
                PF.PrefetcherFileId ,
                PF.SourceAddress ,
                PF.errors ,
                PF.FileStorageLocation
        FROM    dbo.PrefetcherFile AS PF WITH ( NOLOCK )
        WHERE   PF.FileReceiveDate >= @prefetcher_file_receive_date
                AND PF.FileName = @prefetcher_file_name;
    END
ELSE 
    IF @prefetcher_pcn_number IS NOT NULL
        AND @prefetcher_file_receive_date IS NOT NULL 
        BEGIN
            SELECT  PF.PrefetcherFileId ,
                    PF.FileName ,
                    PF.FileReceiveDate ,
                    PF.PrefetcherFileId ,
                    PF.SourceAddress ,
                    PF.errors ,
                    PF.FileStorageLocation
            FROM    dbo.PrefetcherFile AS PF WITH ( NOLOCK )
            WHERE   PF.FileReceiveDate >= @prefetcher_file_receive_date
                    AND PF.data LIKE '%' + @prefetcher_pcn_number + '%';
        END

IF @prefetcher_file_name IS NOT NULL
    AND @prefetcher_file_receive_date IS NOT NULL 
    BEGIN
        SELECT TOP 10
                GER.GatewayEDIResponseId ,
                GER.FileReceiveDate ,
                GER.FileName ,
                GER.CustomerIdCorrelated ,
                GER.ReviewedFlag ,
                GER.RepresentativePcn
        FROM    dbo.GatewayEDIResponse AS GER WITH ( NOLOCK )
        WHERE   GER.FileReceiveDate >= @prefetcher_file_receive_date
                AND GER.FileName = @prefetcher_file_name;
                
        SELECT TOP 10
                PR.ProxymedResponseId ,
                PR.FileReceiveDate ,
                PR.FileName ,
                PR.CustomerIdCorrelated ,
                PR.ReviewedFlag ,
                PR.RepresentativePcn
        FROM    dbo.ProxymedResponse AS PR WITH ( NOLOCK )
        WHERE   PR.FileReceiveDate >= @prefetcher_file_receive_date
                AND PR.FileName = @prefetcher_file_name
                AND PR.CustomerIdCorrelated = @customer_ID;
    END
      
GO
