BEGIN TRAN
UPDATE  CPL
SET IsEnrollmentRequired = 
--SELECT cpl.clearinghousepayerid, cpl.isenrollmentrequired,
     CAST(CASE WHEN CPL.ClearinghouseID = 3
                                         THEN --Gateway
                                              CASE WHEN EnrollmentRequiredRecord.PayerID IS NOT NULL
                                                   THEN 1
                                                   ELSE 0
                                              END
                                         WHEN CPL.ClearinghouseID = 1
                                         THEN CASE WHEN AgreementUrlRecord.PayerID IS NOT NULL
                                                   THEN 1
                                                   ELSE 0
                                              END
                                         ELSE IsEnrollmentRequired
                                    END AS BIT)
FROM    dbo.ClearinghousePayersList AS CPL
        JOIN dbo.Clearinghouse CH ON CH.ClearinghouseID = CPL.ClearinghouseID
        INNER JOIN CLEARINGHOUSEPAYERS.ClearinghousePayers.dbo.Payer AS CPP ON CPL.ClearinghouseID = CPP.PayerSourceID
                                                              AND CPL.PayerNumber = CPP.PayerExternalID COLLATE Latin1_General_CI_AS
                                                              AND CPL.Name = CPP.PayerName COLLATE Latin1_General_CI_AS
                                                              AND CPP.Active = 1
        LEFT JOIN CLEARINGHOUSEPAYERS.ClearinghousePayers.dbo.PayerExtraParams
        AS EnrollmentRequiredRecord ON EnrollmentRequiredRecord.PayerID = CPP.PayerID
                                             AND EnrollmentRequiredRecord.ParamName IN ( 'ClaimEnrollmentRequired', 'EraEnrollmentRequired' ) AND EnrollmentRequiredRecord.ParamValue = 'True'
        LEFT JOIN CLEARINGHOUSEPAYERS.ClearinghousePayers.dbo.PayerExtraParams
        AS AgreementUrlRecord ON AgreementUrlRecord.PayerID = CPP.PayerID
                                 AND AgreementUrlRecord.ParamName IN (
                                 'ClaimsAgreementUrl', 'EraAgreementUrl',
                                 'EligibilityAgreementUrl' ) AND AgreementUrlRecord.ParamValue <> ''
WHERE   CPL.ClearinghouseID IN ( 1, 3 ) 
COMMIT TRAN