-- Allow Create table through Support Tools
USE [superbill_1190_dev]
GO
CREATE USER [KAREOPROD\p-bizclaims-svc] FOR LOGIN [KAREOPROD\p-bizclaims-svc]
GO
USE [superbill_1190_dev]
GO
ALTER ROLE [db_owner] ADD MEMBER [KAREOPROD\p-bizclaims-svc]
GO
