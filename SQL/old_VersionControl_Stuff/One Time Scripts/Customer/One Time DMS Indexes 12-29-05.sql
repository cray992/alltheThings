CREATE NONCLUSTERED INDEX IX_DMSFileInfo_MimeType
ON DMSFileInfo (MimeType)

CREATE NONCLUSTERED INDEX IX_DMSFileInfo_DMSDocumentID
ON DMSFileInfo (DMSDocumentID)

CREATE NONCLUSTERED INDEX IX_DMSDocument_DocumentName
ON DMSDocument (DocumentName)

CREATE NONCLUSTERED INDEX IX_DMSDocument_DocumentLabelTypeID
ON DMSDocument (DocumentLabelTypeID)

CREATE NONCLUSTERED INDEX IX_DMSDocument_DocumentStatusTypeID
ON DMSDocument (DocumentStatusTypeID)

CREATE NONCLUSTERED INDEX IX_DMSDocument_PracticeID
ON DMSDocument (PracticeID)


