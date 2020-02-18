IF EXISTS(SELECT * FROM sys.objects WHERE name='BillDataProvider_GetHCFADocumentDataWithBackground' AND type='P')
	DROP PROCEDURE BillDataProvider_GetHCFADocumentDataWithBackground
GO

UPDATE PrintingForm SET RecipientSpecific=1, StoredProcedureName='BillDataProvider_GetHCFADocumentDataWithBackground_MultiForm'
WHERE PrintingFormID=11

GO