USE superbill_34239_dev
--USE superbill_34239_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON


UPDATE dbo.Patient SET ssn = (CASE WHEN LEN(pd.patssn) >= 6 THEN RIGHT('000' + pd.patssn, 9) ELSE '' END) FROM dbo.Patient AS pat
INNER JOIN dbo.[_import_2_1_PatientDemographics20112014] as pd ON
    pd.patfirstname = pat.FirstName AND
    pd.patlastname = pat.LastName AND
    DATEADD(hh,12,CAST(pd.patdob AS DATETIME)) = pat.DOB 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into patient Successfully '   

--ROLLBACK
--COMMIT
