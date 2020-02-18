/*----------------------------------

DATABASE UPDATE SCRIPT

v1.39.xxxx to v1.40.xxxx
----------------------------------*/

----------------------------------
--BEGIN TRAN 
----------------------------------

use KareoBizclaims

--------------------------------------------------------------------------------
-- CASE 15474 - PCNs to define correlation instead of EINs
--------------------------------------------------------------------------------
ALTER TABLE ProxymedResponse ADD RepresentativePcn varchar(64) 
GO

ALTER TABLE OfficeAllyResponse ADD RepresentativePcn varchar(64) 
GO

ALTER TABLE GatewayEdiResponse ADD RepresentativePcn varchar(64) 
GO

ALTER TABLE BizclaimsResponse ADD RepresentativePcn varchar(64) 
GO

---------------------------------------------------------------------------------
-- Case 00000:   Name of case
---------------------------------------------------------------------------------


--ROLLBACK
--COMMIT

