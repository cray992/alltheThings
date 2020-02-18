

------------ Select 
-- select case when dcd.OfficialName <> i.Description 
--         THEN 'to be updated'
--         ELSE ''
--         END, dcd.DiagnosisCode, dcd.OfficialName, i.Description
-- FROM icd9Nov2007_DiagnosesCode i
-- inner join superbill_shared.dbo.DiagnosisCodeDictionary dcd
--         -- on replace(dcd.DiagnosisCode, '.', '') = i.Code                                 -- 13516 matches
--         on LEFT( replace(dcd.DiagnosisCode, '.', '') + '000', LEN(i.Code) ) = i.Code -- 13612 matches
-- where dcd.Active = 1
-- 
-- UNION ALL
-- 
-- select 'to be inactive', dcd.DiagnosisCode, dcd.OfficialName, i.Description
-- FROM icd9Nov2007_DiagnosesCode i
-- RIGHT join superbill_shared.dbo.DiagnosisCodeDictionary dcd
--         on LEFT( replace(dcd.DiagnosisCode, '.', '') + '000', LEN(i.Code) ) = i.Code
-- where i.Code is null
--         AND dcd.Active = 1
-- 
-- UNION ALL
-- 
-- select 'to be added', 
-- 	case 
-- 		when isnumeric( left(i.Code, 1) )=1 THEN left( i.Code, 3) + '.' + right( i.code, len(i.code) - 3 )
-- 		when 'E' = left(i.Code, 1) THEN left( i.Code, 4) + '.' + right( i.code, len(i.code) - 4 )
-- 		when 'V' = left(i.Code, 1) THEN left( i.Code, 3) + '.' + right( i.code, len(i.code) - 3 )
-- 	END
-- , dcd.OfficialName, i.Description
-- FROM icd9Nov2007_DiagnosesCode i
-- LEFT join superbill_shared.dbo.DiagnosisCodeDictionary dcd
--          on LEFT( replace(dcd.DiagnosisCode, '.', '') + '000', LEN(i.Code) ) = i.Code
--         AND dcd.Active = 1
-- where dcd.DiagnosisCodeDictionaryID is null
-- 
-- 
-- 
-- 




-------------- Updates Shared
update dcd
SET OfficialName = i.Description, ModifiedDate = getdate(), ModifiedUserID=951
FROM [kdev-db03].migrationX_dev.dbo.icd9Nov2007_DiagnosesCode i
inner join superbill_shared.dbo.DiagnosisCodeDictionary dcd                    -- 13516 matches
        on LEFT( replace(dcd.DiagnosisCode, '.', '') + '000', LEN(i.Code) ) = i.Code -- 13612 matches
where dcd.Active = 1
        AND dcd.OfficialName <> i.Description 


--------------- Adds New Records

insert into Superbill_Shared.dbo.DiagnosisCodeDictionary( Active, CreatedUserID, DiagnosisCode, ModifiedUserID, OfficialName )
select 1, 
        951, --phong
	case 
		when isnumeric( left(i.Code, 1) )=1 THEN left( i.Code, 3) + '.' + right( i.code, len(i.code) - 3 )
		when 'E' = left(i.Code, 1) THEN left( i.Code, 4) + '.' + right( i.code, len(i.code) - 4 )
		when 'V' = left(i.Code, 1) THEN left( i.Code, 3) + '.' + right( i.code, len(i.code) - 3 )
	END as DiagnosisCode,
        951,
        i.Description
FROM [kdev-db03].migrationX_dev.dbo.icd9Nov2007_DiagnosesCode i
LEFT join superbill_shared.dbo.DiagnosisCodeDictionary dcd
         on LEFT( replace(dcd.DiagnosisCode, '.', '') + '000', LEN(i.Code) ) = i.Code
        AND dcd.Active = 1
where dcd.DiagnosisCodeDictionaryID is null






