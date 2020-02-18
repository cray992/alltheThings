/*=============================================================================
THE FOLLOWING SCRIPT SHOULD BE EXECUTED AGAINST SUPERBILL_SHARED ONLY!!!
=============================================================================*/

--UPDATE CUSTOMER 
--SET DatabaseServerName = 'KPROD-DB04'
--WHERE CustomerID IN (SELECT CustomerID FROM Customer WHERE CustomerType = 'T')
--GO