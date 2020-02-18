-- Server: kprod-db24
--USE superbill_6396_dev;
--USE superbill_6396_prod;
--GO

SELECT  DISTINCT
        6396 AS CustomerID ,
        B.BillID ,
        C.ClaimID ,
        E.EncounterID ,
        C.PracticeID ,
        D.NPI AS 'RoutingPaytoTaxId'
FROM    dbo.Bill_EDI AS B WITH ( NOLOCK )
        INNER JOIN Claim AS C WITH ( NOLOCK ) ON C.ClaimID = B.RepresentativeClaimID
        INNER JOIN dbo.EncounterProcedure AS EP WITH ( NOLOCK ) ON EP.EncounterProcedureID = C.EncounterProcedureID
        INNER JOIN dbo.Encounter AS E WITH ( NOLOCK ) ON E.EncounterID = EP.EncounterID
        INNER JOIN Practice AS PR WITH ( NOLOCK ) ON PR.PracticeID = E.PracticeID
        LEFT JOIN Doctor AS D WITH ( NOLOCK ) ON D.DoctorID = E.DoctorID
WHERE   D.NPI IS NOT NULL;