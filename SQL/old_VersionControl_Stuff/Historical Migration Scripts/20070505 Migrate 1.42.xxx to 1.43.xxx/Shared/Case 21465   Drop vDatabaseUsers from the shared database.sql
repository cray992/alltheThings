

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vDatabaseUsers]'))
DROP VIEW [dbo].[vDatabaseUsers]