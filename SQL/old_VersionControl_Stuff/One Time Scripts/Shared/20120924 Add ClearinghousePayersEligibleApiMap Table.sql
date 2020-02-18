USE Superbill_Shared

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClearinghousePayersEligibleApiMap]') AND type in (N'U'))
BEGIN
RETURN;
END

CREATE TABLE ClearinghousePayersEligibleApiMap
(
	ClearinghousePayerID [int] UNIQUE,
	EligibleApiPayerNumber [varchar](32) NOT NULL,
	EligibleApiPayerName [varchar](1000) NOT NULL,
	Active [bit] DEFAULT(0),
	Constraint fk_ClearighousePayerID FOREIGN KEY (ClearinghousePayerID)
	REFERENCES ClearinghousePayersList(ClearinghousePayerID)
)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (18, 2, 'Aetna AETNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1593, 2, 'Aetna AETNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (4433, 2, 'Aetna AETNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (12253, 2, 'Aetna AETNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (14348, 2, 'Aetna AETNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (14350, 2, 'Aetna AETNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (14351, 2, 'Aetna AETNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (14352, 2, 'Aetna AETNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (14353, 2, 'Aetna AETNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (14355, 2, 'Aetna AETNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (14356, 2, 'Aetna AETNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (14357, 2, 'Aetna AETNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (14358, 2, 'Aetna AETNA', 1)



INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (4599, 151, 'Blue Cross Blue Shield of Georgia BCBS OF GEORGIA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (4601, 268, 'Blue Cross Blue Shield of Illinois BLUE CROSS BLUE SHIELD OF ILLINOIS', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (4627, 44, 'Empire Blue Cross and Blue Shield EMPIRE HEALTH CHOICE ASSURANCE INC', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (14599, 44, 'Empire Blue Cross and Blue Shield EMPIRE HEALTH CHOICE ASSURANCE INC', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16997, 44, 'Empire Blue Cross and Blue Shield EMPIRE HEALTH CHOICE ASSURANCE INC', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (198, 271, 'Blue Cross Blue Shield of Texas BLUE CROSS BLUE SHIELD TEXAS', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (4643, 271, 'Blue Cross Blue Shield of Texas BLUE CROSS BLUE SHIELD TEXAS', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (5101, 271, 'Blue Cross Blue Shield of Texas BLUE CROSS BLUE SHIELD TEXAS', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (5102, 271, 'Blue Cross Blue Shield of Texas BLUE CROSS BLUE SHIELD TEXAS', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7145, 271, 'Blue Cross Blue Shield of Texas BLUE CROSS BLUE SHIELD TEXAS', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (10516, 271, 'Blue Cross Blue Shield of Texas BLUE CROSS BLUE SHIELD TEXAS', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (10651, 271, 'Blue Cross Blue Shield of Texas BLUE CROSS BLUE SHIELD TEXAS', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (10652, 271, 'Blue Cross Blue Shield of Texas BLUE CROSS BLUE SHIELD TEXAS', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (4622, 'BCNVC', 'Blue Cross Blue Shield of Nevada BLUE CROSS BLUE SHIELD NV', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (14592, 'BCNVC', 'Blue Cross Blue Shield of Nevada BLUE CROSS BLUE SHIELD NV', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (4655, 39, 'Anthem Blue Cross California BLUE CROSS OF CALIFORNIA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (4656, 39, 'Anthem Blue Cross California BLUE CROSS OF CALIFORNIA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (12455, 39, 'Anthem Blue Cross California BLUE CROSS OF CALIFORNIA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (4663, 00361, 'Blue Shield of California BLUE SHIELD OF CALIFORNIA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (12517, 00361, 'Blue Shield of California BLUE SHIELD OF CALIFORNIA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (4598, 267, 'Blue Cross Blue Shield of Florida BCBS OF FL', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (12019, 267, 'Blue Cross Blue Shield of Florida BCBS OF FL', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (282, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (283, 1, 'CIGNA HealthCare - PPO CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (285, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (286, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (297, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (447, 1, 'EQUICORE CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (448, 1, 'EQUICORE - PPO CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (615, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (616, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (617, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (618, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (619, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (620, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (622, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (623, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (624, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (626, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (627, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (628, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1171, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1172, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1173, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1923, 1, 'Connecticut General CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (2028, 1, 'EQUICORE CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (2029, 1, 'EQUICORE - PPO CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (6611, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (6612, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (6905, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7692, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (8212, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (12745, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7694, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7695, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (14752, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (14753, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (14755, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (14756, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (15259, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (15260, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1876, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1877, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1897, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (12717, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (12759, 1, 'CIGNA HealthCare - PPO CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (12781, 1, 'Connecticut General CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (12851, 1, 'CIGNA HealthCare - HMO CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (6398, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (6421, 1, 'Connecticut General CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (6521, 1, 'EQUICORE CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1872, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1873, 1, 'CIGNA HealthCare - PPO CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (4744, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (4748, 1, 'CIGNA HealthCare - HMO CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (4784, 1, 'Connecticut General CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (4785, 1, 'Connecticut General CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (4906, 1, 'EQUICORE CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (4908, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (17049, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (12600, 1, 'EQUICORE CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (12621, 1, 'EQUICORE - PPO CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (17379, 1, 'CIGNA HealthCare CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (17389, 1, 'CIGNA CIGNA', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (844, 431, 'Medicare Part A & B - All States MEDICARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (15602, 431, 'Medicare Part A & B - All States MEDICARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (15604, 431, 'Medicare Part A & B - All States MEDICARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (849, 431, 'Medicare Part A & B - All States MEDICARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (15608, 431, 'Medicare Part A & B - All States MEDICARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (9954, 431, 'Medicare Part A & B - All States MEDICARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (9955, 431, 'Medicare Part A & B - All States MEDICARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (9960, 431, 'Medicare Part A & B - All States MEDICARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (9970, 431, 'Medicare Part A & B - All States MEDICARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (9974, 431, 'Medicare Part A & B - All States MEDICARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (11185, 431, 'Medicare Part A & B - All States MEDICARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (11423, 431, 'Medicare Part A & B - All States MEDICARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (17322, 431, 'Medicare Part A & B - All States MEDICARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (17329, 431, 'Medicare Part A & B - All States MEDICARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (5301, 'AID58', 'Nevada Medicaid - First Health Services Corp NEVADA MEDICAID', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (795, 'AID01', 'Florida Medicaid FLORIDA MEDICAID', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (430, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1431, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1432, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1433, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1434, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1435, 112, 'UnitedHealthcare of Alabama UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1436, 112, 'UnitedHealthcare of Arizona Inc. UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1437, 112, 'UnitedHealthcare of Arkansas UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1438, 112, 'UnitedHealthcare of California-Northern California UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1439, 112, 'UnitedHealthcare of California-Southern California UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1440, 112, 'UnitedHealthcare of Colorado Inc. UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1441, 112, 'UnitedHealthcare of Florida UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1442, 112, 'UnitedHealthcare of Georgia UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1443, 112, 'UnitedHealthcare of Illinois UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1444, 112, 'UnitedHealthcare of Kentucky UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1445, 112, 'UnitedHealthcare of Mississippi UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1446, 112, 'UnitedHealthcare of New England UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1448, 112, 'UnitedHealthcare of North Carolina Inc. UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1449, 112, 'UnitedHealthcare of Ohio UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1450, 112, 'UnitedHealthcare of Texas - Dallas UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1451, 112, 'UnitedHealthcare of Texas - Houston UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1452, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1455, 112, 'UnitedHealthcare of the Midwest-Choice Choice Plus Select Select Plus UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1456, 112, 'UnitedHealthcare of the Midwest-Medicare Complete (f. PHP of Midwest PHP o UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1457, 112, 'UnitedHealthcare of Upstate New York UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1458, 112, 'UnitedHealthcare of Utah UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1459, 112, 'UnitedHealthcare of Virginia UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1460, 112, 'UnitedHealthcare Plans of Puerto Rico UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (6781, 112, 'UnitedHealthcare of the Midlands - HMO (Choice Select) UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (6782, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (6783, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7032, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7033, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7034, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7036, 112, 'UnitedHealthcare of New York (includes NY & NJ) UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7037, 112, 'UnitedHealthcare of the Midlands - HMO (Choice Select) UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7038, 112, 'UnitedHealthcare of the Midlands - PPO (Choice Plus Select Plus Self Fund UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (8190, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (8191, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (8192, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (8229, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (8230, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (8231, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (8232, 112, 'UnitedHealthcare of New York (includes NY & NJ) UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (8233, 112, 'UnitedHealthcare of the Midlands - HMO (Choice Select) UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (8234, 112, 'UnitedHealthcare of the Midlands - PPO (Choice Plus Select Plus Self Fund UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (14930, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16380, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7514, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7515, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7516, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (2004, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (5864, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (5865, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (5866, 112, 'UnitedHealthcare of Alabama UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (5867, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (5869, 112, 'UnitedHealthcare of Tennessee UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (5872, 112, 'UnitedHealthcare of Florida UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (6030, 112, 'UnitedHealthcare of Utah UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (11879, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (11880, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (13547, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (15866, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (15883, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7931, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7932, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7938, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7942, 112, 'UnitedHealthcare of Alabama UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7944, 112, 'UnitedHealthcare of Arkansas UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7945, 112, 'UnitedHealthcare of California-Northern California UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7946, 112, 'UnitedHealthcare of California-Southern California UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7948, 112, 'UnitedHealthcare of Florida UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7949, 112, 'UnitedHealthcare of Georgia UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7950, 112, 'UnitedHealthcare of Illinois UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7952, 112, 'UnitedHealthcare of Mississippi UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7953, 112, 'UnitedHealthcare of New England UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7956, 112, 'UnitedHealthcare of Ohio UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7959, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7960, 112, 'UnitedHealthcare of the Midlands - HMO (Choice Select) UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7961, 112, 'UnitedHealthcare of the Midlands - PPO (Choice Plus Select Plus Self Fund UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7962, 112, 'UnitedHealthcare of the Midwest-Choice Choice Plus Select Select Plus UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7963, 112, 'UnitedHealthcare of the Midwest-Medicare Complete (f. PHP of Midwest PHP o UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7964, 112, 'UnitedHealthcare of Upstate New York UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7965, 112, 'UnitedHealthcare of Utah UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7966, 112, 'UnitedHealthcare of Virginia UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7967, 112, 'UnitedHealthcare Plans of Puerto Rico UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (5857, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (5858, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (1351, 112, 'UnitedHealthcare of the Midlands - PPO (Choice Plus Select Plus Self Fund UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7008, 112, 'UnitedHealthcare of the Midlands - HMO (Choice Select) UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7021, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (11881, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (12564, 112, 'Evercare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (13047, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (13124, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (8223, 112, 'UnitedHealthcare of the Midlands - HMO (Choice Select) UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (8224, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (9370, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (13553, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (14979, 112, 'Evercare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16303, 112, 'UnitedHealthcare of the Midlands - PPO (Choice Plus Select Plus Self Fund UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16342, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16347, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16348, 112, 'UnitedHealthcare of Alabama UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16349, 112, 'UnitedHealthcare of Arizona Inc. UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16350, 112, 'UnitedHealthcare of Arizona Inc. UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16351, 112, 'UnitedHealthcare of Arizona Inc. UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16352, 112, 'UnitedHealthcare of California-Northern California UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16353, 112, 'UnitedHealthcare of California-Southern California UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16354, 112, 'UnitedHealthcare of California-Northern California UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16355, 112, 'UnitedHealthcare of California-Southern California UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16356, 112, 'UnitedHealthcare of Colorado Inc. UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16357, 112, 'UnitedHealthcare of Colorado Inc. UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16358, 112, 'UnitedHealthcare of Florida UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16359, 112, 'UnitedHealthcare of Georgia UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16360, 112, 'UnitedHealthcare of Illinois UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16361, 112, 'UnitedHealthcare of Kentucky UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16362, 112, 'UnitedHealthcare of Kentucky UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16363, 112, 'UnitedHealthcare of Louisiana UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16364, 112, 'UnitedHealthcare of Louisiana UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16365, 112, 'UnitedHealthcare of Mississippi UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16366, 112, 'UnitedHealthcare of New England UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16367, 112, 'UnitedHealthcare of New York (includes NY & NJ) UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16368, 112, 'UnitedHealthcare of New York (includes NY & NJ) UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16369, 112, 'UnitedHealthcare of New York (includes NY & NJ) UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16370, 112, 'UnitedHealthcare of New York (includes NY & NJ) UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16371, 112, 'UnitedHealthcare of North Carolina Inc. UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16372, 112, 'UnitedHealthcare of North Carolina Inc. UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16373, 112, 'UnitedHealthcare of Ohio UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16374, 112, 'UnitedHealthcare of Tennessee UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16375, 112, 'UnitedHealthcare of Tennessee UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16376, 112, 'UnitedHealthcare of Texas - Dallas UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16377, 112, 'UnitedHealthcare of Texas - Dallas UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16378, 112, 'UnitedHealthcare of Texas - Houston UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16379, 112, 'UnitedHealthcare of Texas - Houston UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16381, 112, 'UnitedHealthcare of the Midlands - HMO (Choice Select) UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16382, 112, 'UnitedHealthcare of the Midlands - PPO (Choice Plus Select Plus Self Fund UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16383, 112, 'UnitedHealthcare of the Midwest-Choice Choice Plus Select Select Plus UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16384, 112, 'UnitedHealthcare of the Midwest-Medicare Complete (f. PHP of Midwest PHP o UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16386, 112, 'UnitedHealthcare of Upstate New York UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16387, 112, 'UnitedHealthcare of Utah UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16388, 112, 'UnitedHealthcare of Virginia UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16389, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (16390, 112, 'UnitedHealthcare Plans of Puerto Rico UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (7900, 112, 'UnitedHealthcare of the Midlands - HMO (Choice Select) UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (2036, 112, 'Evercare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (5401, 112, 'UnitedHealthcare of the Midlands - PPO (Choice Plus Select Plus Self Fund UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (5402, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (5405, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (5406, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (5408, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (5837, 112, 'UnitedHealthcare of the Midwest-Medicare Complete (f. PHP of Midwest PHP o UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (5609, 112, 'UnitedHealthcare of the Midwest-Medicare Complete (f. PHP of Midwest PHP o UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (6871, 112, 'UnitedHealthcare of the Midwest-Medicare Complete (f. PHP of Midwest PHP o UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (6872, 112, 'UnitedHealthcare of the Midwest-Medicare Complete (f. PHP of Midwest PHP o UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (13248, 112, 'UnitedHealthcare of the Midwest-Medicare Complete (f. PHP of Midwest PHP o UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (13258, 112, 'UnitedHealthcare of the Midwest-Medicare Complete (f. PHP of Midwest PHP o UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (13272, 112, 'UnitedHealthcare of the Midwest-Medicare Complete (f. PHP of Midwest PHP o UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (8300, 112, 'UnitedHealthcare of the Midwest-Medicare Complete (f. PHP of Midwest PHP o UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (4916, 112, 'Evercare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (4877, 112, 'UnitedHealthcare UNITED HEALTH CARE', 1)

INSERT INTO ClearinghousePayersEligibleApiMap (ClearinghousePayerID, EligibleApiPayerNumber, EligibleApiPayerName, Active)
VALUES (17434, 112, 'UnitedHealthcare of Louisiana UNITED HEALTH CARE', 1)