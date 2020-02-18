CREATE TABLE DateKey(DKID INT, Dt DATETIME, D INT, LastDay BIT, WD INT, WDIM INT, LastWD BIT, LastWEDay BIT, LastWKDay BIT, Wk INT, Mo INT, MoID INT, MoDays INT, Yr INT)
GO

INSERT INTO DateKey
SELECT * FROM superbill_shared..DateKey

CREATE UNIQUE CLUSTERED INDEX CI_DateKey_Dt
ON DateKey (Dt, D, LastDay, WD, WDIM, LastWD, LastWEDay, LastWKDay, Mo, MoDays, Yr)