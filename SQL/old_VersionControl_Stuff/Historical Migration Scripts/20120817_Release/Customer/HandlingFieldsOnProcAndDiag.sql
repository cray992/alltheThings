
--Story: 31614711

-- process the current data 
update ProcedureCodeDictionary set LocalName=NULL where LTrim(RTrim(LocalName))=''
update ProcedureCodeDictionary set BillableCode=NULL where LTrim(RTrim(BillableCode))=''
update DiagnosisCodeDictionary set LocalName=NULL where LTrim(RTrim(LocalName))=''
