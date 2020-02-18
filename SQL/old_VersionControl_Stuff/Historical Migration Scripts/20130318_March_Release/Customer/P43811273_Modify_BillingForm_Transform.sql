BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

/*
-- kprod-db39
USE superbill_12900_dev;
GO
USE superbill_12900_prod;
GO
*/

IF EXISTS ( SELECT  *
            FROM    dbo.BillingForm AS BF
            WHERE   BF.PrintingFormID IN (
                    SELECT  PFD.PrintingFormID
                    FROM    dbo.PrintingFormDetails AS PFD
                    WHERE   PFD.Description LIKE '%HCFA%' )
                    AND BF.Transform LIKE '%<data id="CMS1500.1.1_3Signature">Signature on File</data>%'
                    AND BF.Transform NOT LIKE '%PatientsSignatureOnFileFlagBox131%' ) 
    BEGIN
        UPDATE  BF
        SET     BF.Transform = CAST(REPLACE(CAST(BF.Transform AS VARCHAR(MAX)),
                                            '<data id="CMS1500.1.1_3Signature">Signature on File</data>',
                                            '<xsl:choose>
          <xsl:when test="data[@id=''CMS1500.1.PatientsSignatureOnFileFlagBox131''] = 1">
            <data id="CMS1500.1.1_3Signature">Signature on File</data>
          </xsl:when>
        </xsl:choose>') AS TEXT)
        FROM    dbo.BillingForm AS BF
        WHERE   BF.PrintingFormID IN ( SELECT   PFD.PrintingFormID
                                       FROM     dbo.PrintingFormDetails AS PFD
                                       WHERE    PFD.Description LIKE '%HCFA%' )
                AND BF.Transform LIKE '%<data id="CMS1500.1.1_3Signature">Signature on File</data>%'
                AND BF.Transform NOT LIKE '%PatientsSignatureOnFileFlagBox131%'; 	
    END

/*
SELECT  CAST(BF.Transform AS XML) ,
        BF.*
FROM    dbo.BillingForm AS BF
WHERE   BF.PrintingFormID IN ( SELECT   PFD.PrintingFormID
                               FROM     dbo.PrintingFormDetails AS PFD
                               WHERE    PFD.Description LIKE '%HCFA%' )
        AND BF.Transform LIKE '%<data id="CMS1500.1.1_3Signature">Signature on File</data>%'
        AND BF.Transform LIKE '%PatientsSignatureOnFileFlagBox131%';
*/
