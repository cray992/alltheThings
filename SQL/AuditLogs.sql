USE KareoAudit
GO
SET TRAN ISOLATION LEVEL READ UNCOMMITTED
SELECT --TOP 100
a.UserName, c.Description, b.Description, a.EntityTypeText, a.SubEntityTypeText, a.ChangeSet, a.CreatedDate
FROM dbo.AuditLog a
INNER JOIN dbo.AuditType b ON
b.AuditTypeID=a.AuditTypeID
INNER JOIN dbo.AuditActionType c ON
c.AuditActionTypeID=a.AuditActionTypeID
WHERE a.CustomerId= 6187
ORDER BY a.CreatedDate DESC
