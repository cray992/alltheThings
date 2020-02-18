/* THIS ACTION IS BEING DUPLICATED IN A MIGRATION SCRIPT

use superbill_shared

UPDATE PatientStatementsFormat SET FormatName = 'Kareo Plain Print' WHERE PatientStatementsFormatId = 3
UPDATE PatientStatementsFormat SET Notes = 'Simple format used to save text files' WHERE PatientStatementsFormatId = 3
UPDATE PatientStatementsFormat SET GoodForElectronic = 0 WHERE PatientStatementsFormatId = 3

INSERT PatientStatementsFormat (FormatName, FormatExternalName, LinesPerPage,
 PatientStatementsVendorId, GoodForPrinting, GoodForElectronic, StoredProcedureName, TransformXsltFileName, Notes)
VALUES ('PSC XML - Version KN', 'KN', 10000,
 3, 0, 1, 'BillDataProvider_GetStatementBatchXML',
 'PSC_XML_reformatter_1.xsl', 'XML format used to pass data to PSC')

*/

