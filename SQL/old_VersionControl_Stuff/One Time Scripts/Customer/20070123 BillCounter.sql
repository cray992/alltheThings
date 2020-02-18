IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].SystemProcedureCounter') AND type in (N'U'))
DROP TABLE [dbo].SystemProcedureCounter
GO

-- table used to determine When to recompile counter
create table SystemProcedureCounter (ProcedureName varchar(250), ExecutionCount INT, RecompileInterval INT)
GO

CREATE UNIQUE CLUSTERED INDEX [PK_SystemProcedureCounter] ON [dbo].[SystemProcedureCounter] 
(
	[ProcedureName] ASC
)WITH (PAD_INDEX  = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]



INSERT INTO SystemProcedureCounter (ProcedureName, ExecutionCount, RecompileInterval)
SELECT 'BillDataProvider_GetEDIBillXML', 0, 10
