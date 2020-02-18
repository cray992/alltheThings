/*Add missing procedure codes to the database*/

/*
SELECT  COUNT(*)
FROM    dbo.[_imp00008647_Cpt] C
WHERE   C.[CPT] NOT IN (SELECT  ProcedureCode
                        FROM    dbo.[ProcedureCodeDictionary])

SELECT  *
FROM    dbo.[_imp00008647_Cpt] C
WHERE   C.[CPT] NOT IN (SELECT  ProcedureCode
                        FROM    dbo.[ProcedureCodeDictionary])
*/

INSERT  INTO [ProcedureCodeDictionary] ([ProcedureCode])
        SELECT  C.[CPT]
        FROM    dbo.[_imp00008647_Cpt] C
        WHERE   C.[CPT] NOT IN (SELECT  ProcedureCode
                                FROM    dbo.[ProcedureCodeDictionary])
--

INSERT  INTO dbo.ContractFeeSchedule (
          ProcedureCodeDictionaryID
        , ContractID
        , Gender
        , StandardFee
		, RVU
        )
        SELECT  PCD.ProcedureCodeDictionaryID
              , 17 AS ContractID
              , 'B' AS Gender
              , Price
			  , 0 AS RVU
        FROM    _imp00008647_Cpt C
                INNER JOIN [ProcedureCodeDictionary] PCD
                ON C.CPT = PCD.[ProcedureCode]

--6640


