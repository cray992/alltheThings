BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

/*
-- kprod-db20
USE superbill_6095_dev;
GO
USE superbill_6095_prod;
GO
*/

BEGIN TRANSACTION;

UPDATE  dbo.ProviderNumberType
SET     Active = 1 ,
        ShowInClaimSettings = 1
WHERE   ANSIReferenceIdentificationQualifier = '1G';

UPDATE  dbo.GroupNumberType
SET     Active = 1 ,
        ShowInClaimSettings = 1
WHERE   ANSIReferenceIdentificationQualifier = '1G';

COMMIT;
