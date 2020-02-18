-- case PT 43870793
-- we set OfficialDescription to NULL for those records where OfficialDescription is an empty string

update ProcedureCodeDictionary 
	set OfficialDescription=null 
where LTrim(RTrim(OfficialDescription))=''

