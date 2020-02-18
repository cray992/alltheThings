UPDATE PCD SET TypeOfServiceCode=1
FROM         ProcedureCodeDictionary PCD
WHERE     (TypeOfServiceCode IN ('A', 'J', 'P', 'R')) AND (OfficialName NOT LIKE '%dme%') AND (OfficialName LIKE '%mg%' OR
                      OfficialName LIKE '%inj%')

