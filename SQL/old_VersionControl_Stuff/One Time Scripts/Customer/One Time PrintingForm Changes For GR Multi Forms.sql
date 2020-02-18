UPDATE PrintingForm SET StoredProcedureName='BillDataProvider_GetHCFADocumentData_MultiForm'
WHERE PrintingFormID=1

UPDATE PrintingForm SET StoredProcedureName='BillDataProvider_GetIOCFormXml_MultiForm', RecipientSpecific=1
WHERE PrintingFormID=3

UPDATE PrintingForm SET StoredProcedureName='BillDataProvider_GetNORFormXml_MultiForm'
WHERE PrintingFormID=4

UPDATE PrintingForm SET StoredProcedureName='BillDataProvider_GetLienFormXml_MultiForm'
WHERE PrintingFormID=10

UPDATE PrintingForm SET StoredProcedureName='BillDataProvider_GetHCFADocumentDataWithBackground_MultiForm'
WHERE PrintingFormID=11
