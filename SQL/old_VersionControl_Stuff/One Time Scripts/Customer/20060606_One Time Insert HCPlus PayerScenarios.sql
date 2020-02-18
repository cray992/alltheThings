BEGIN TRANSACTION

INSERT INTO PayerScenario (Name, PayerScenarioTypeID) VALUES('V - Contract Bill', '1')
INSERT INTO PayerScenario (Name, PayerScenarioTypeID) VALUES('G - Deceased', '2')
INSERT INTO PayerScenario (Name, PayerScenarioTypeID) VALUES('A - Default Billing Code', '2')
INSERT INTO PayerScenario (Name, PayerScenarioTypeID) VALUES('F - Facility Responsible', '1')
INSERT INTO PayerScenario (Name, PayerScenarioTypeID) VALUES('HC - Forward HCP Collectn', '2')
INSERT INTO PayerScenario (Name, PayerScenarioTypeID) VALUES('K - Hurricane Related', '1')
INSERT INTO PayerScenario (Name, PayerScenarioTypeID) VALUES('HK - Hurricane-Poss W/Off', '2')
INSERT INTO PayerScenario (Name, PayerScenarioTypeID) VALUES('Z - Incomplete Claim', '2')
INSERT INTO PayerScenario (Name, PayerScenarioTypeID) VALUES('II - Incomplete Narrative', '2')
INSERT INTO PayerScenario (Name, PayerScenarioTypeID) VALUES('PC - Invalid PCS or PAN', '2')
INSERT INTO PayerScenario (Name, PayerScenarioTypeID) VALUES('MN - No Medical Necessity', '2')
INSERT INTO PayerScenario (Name, PayerScenarioTypeID) VALUES('NP - No PAN on File', '1')
INSERT INTO PayerScenario (Name, PayerScenarioTypeID) VALUES('NC - Not Covered Transprt', '2')
INSERT INTO PayerScenario (Name, PayerScenarioTypeID) VALUES('PP - Payment Plan', '1')
INSERT INTO PayerScenario (Name, PayerScenarioTypeID) VALUES('P - PIP (auto insurance)', '1')
INSERT INTO PayerScenario (Name, PayerScenarioTypeID) VALUES('RT - Stmnts Returned', '2')
GO
-- save Kareo Name in Description
UPDATE PayerScenario
SET Description = Name where PayerScenarioID in (1, 2, 4, 6, 9, 10, 12, 14, 15, 16)
GO

-- rename Kareo scenarios that are not used by HCPlus
UPDATE PayerScenario
SET Name = 'ZZ' where PayerScenarioID in (1, 2, 4, 6, 9, 10, 12, 14, 15, 16)
GO

UPDATE PayerScenario
SET Name = 'B - BCBS' WHERE PayerScenarioID = 3
UPDATE PayerScenario
SET Name = 'C - Commercial' WHERE PayerScenarioID = 5
UPDATE PayerScenario
SET Name = 'M - Medicare Patient' WHERE PayerScenarioID = 7
UPDATE PayerScenario
SET Name = 'D - Medicaid Patient' WHERE PayerScenarioID = 8
UPDATE PayerScenario
SET Name = 'S - Self Pay' WHERE PayerScenarioID = 11
UPDATE PayerScenario
SET Name = 'W - WorkersComp' WHERE PayerScenarioID = 13
GO

-- SELECT * FROM PAYERSCENARIO ORDER BY NAME
-- ROLLBACK
-- COMMIT