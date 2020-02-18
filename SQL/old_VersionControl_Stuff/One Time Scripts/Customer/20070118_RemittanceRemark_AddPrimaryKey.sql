/* Case 19129: RemittanceRemark table does not have a primary key */

BEGIN TRANSACTION
ALTER TABLE dbo.RemittanceRemark ADD CONSTRAINT
	PK_RemittanceRemark PRIMARY KEY CLUSTERED 
	(
	RemittanceRemarkID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

COMMIT