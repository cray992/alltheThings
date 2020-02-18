BEGIN TRAN

DECLARE @T TABLE (PayerID int, URL varchar(200))

DECLARE @BlueShieldFLUrl varchar(200)
DECLARE @BlueCrossCAUrl varchar(200)
DECLARE @KareoInstructionsUrl varchar(200)

SET @BlueShieldFLUrl = 'http://help.kareo.com/documents/pdf/Eligibility_Enrollment_-_BS_of_FL'
SET @BlueCrossCAUrl = 'http://help.kareo.com/documents/pdf/Eligibility_Enrollment_-_BC_of_CA'
SET @KareoInstructionsUrl = 'http://help.kareo.com/documents/pdf/'

INSERT INTO @T (PayerID, URL)
	SELECT PayerID, @BlueShieldFLUrl FROM Payer WHERE PayerExternalID = 'BS022' AND PayerSourceID = 1

INSERT INTO @T (PayerID, URL)
	SELECT PayerID, @BlueCrossCAUrl FROM Payer WHERE PayerExternalID = 'BC001' AND PayerSourceID = 1

	-- Add the Kareo specific instructions url for any params that have the Eligibility flag set to true and doesn't have an eligibility url
--INSERT INTO @T (PayerID, URL)
--	SELECT	PayerID, @KareoInstructionsUrl
--	FROM	PayerExtraParams
--	WHERE	ParamName = 'Eligibility'
--	AND		ParamValue = 'true'
--	AND		PayerID NOT IN(SELECT PayerID FROM PayerExtraParams WHERE ParamName = 'EligibilityAgreementUrl')

-- Update the PayerExtraParams table based on the temp table
DELETE FROM PayerExtraParams
WHERE PayerID IN (SELECT PayerID FROM @T) AND ParamName = 'EligibilityAgreementUrl'

INSERT INTO PayerExtraParams (PayerID, ParamName, ParamValue)
SELECT PayerID, 'EligibilityAgreementUrl', URL FROM @T

-- Add some non eligibility links

DELETE FROM @T

---- Include some agreement links due to Gateway EDI's buggy crappy service
--INSERT INTO @T (PayerID, URL)
	--SELECT PayerID, 'https://www.claimenroll.com/Download/Temp/PP_5675381.pdf' FROM Payer WHERE PayerExternalID='03202' AND PayerSourceID=3 AND Active=1 AND PayerName LIKE '%Medicare of Montana%'

DELETE FROM PayerExtraParams
WHERE PayerID IN (SELECT PayerID FROM @T) AND ParamName = 'ClaimsAgreementUrl'

INSERT INTO PayerExtraParams (PayerID, ParamName, ParamValue)
SELECT PayerID, 'ClaimsAgreementUrl', URL FROM @T

DELETE FROM @T

---- Include some agreement links due to Gateway EDI's buggy crappy service
--INSERT INTO @T (PayerID, URL)
	--SELECT PayerID, 'https://www.claimenroll.com/Download/Temp/PP_2961187.pdf' FROM Payer WHERE PayerExternalID='03202' AND PayerSourceID=3 AND Active=1 AND PayerName LIKE '%Medicare of Montana%'

DELETE FROM PayerExtraParams
WHERE PayerID IN (SELECT PayerID FROM @T) AND ParamName = 'EraAgreementUrl'

INSERT INTO PayerExtraParams (PayerID, ParamName, ParamValue)
SELECT PayerID, 'EraAgreementUrl', URL FROM @T

-- Override Gateway EDI's buggy crappy service to set RealTimeEligibility = true for some payers
UPDATE	PayerExtraParams
SET		ParamValue='True'
WHERE	PayerID IN	(
					SELECT	PayerID
					FROM	Payer
					WHERE	PayerExternalID IN ('60054','00000','00010','00523','16003','17003','18003','19003')
					AND		PayerSourceID=3
					AND		Active=1
					)
AND		ParamName = 'RealTimeEligibility'					


--Update capario payer(MR005) to set it to active 
--with patienteligibility and agreementurl
--Temporary hack - The bug is we update the payer by name and two payers might come in woth the same name.

DECLARE @PayerMR005 INT

SELECT @PayerMR005 = PayerID
FROM Payer
WHERE PayerExternalID = 'MR005'
AND	PayerSourceID=1

UPDATE Payer
SET Active = 1
WHERE PayerID = @PayerMR005	
AND PayerSourceID = 1

DELETE FROM PayerExtraParams
WHERE PayerID  = @PayerMR005
AND ParamName = 'Eligibility'

INSERT INTO PayerExtraParams
        ( PayerID, ParamName, ParamValue )
VALUES  (@PayerMR005,
          'Eligibility', -- ParamName - varchar(200)
          'True'  -- ParamValue - varchar(200)
          )

DELETE FROM PayerExtraParams
WHERE PayerID  = @PayerMR005
AND ParamName = 'ClaimsAgreementUrl'

INSERT INTO PayerExtraParams
        ( PayerID, ParamName, ParamValue )
VALUES  (@PayerMR005,
          'ClaimsAgreementUrl', -- ParamName - varchar(200)
          'http://www.capario.com/services/resource_center/payer/list/agreements/TrailBlazerMedicare.pdf'  
          )

-- Update Capario payers that we know accept COB (but doesn't show up on website)
declare @PayersAcceptCOB table (PayerID int )

insert into @PayersAcceptCOB
SELECT	PayerID
FROM	Payer
WHERE	PayerExternalID IN ('62308','MR060','MR005')
AND		PayerSourceID=1
AND		Active=1
		

INSERT INTO PayerExtraParams (PayerID, ParamName, ParamValue)
select	PayerID, 'AcceptingCOB', 'True'
from	@PayersAcceptCOB
where	PayerID NOT IN (
		select	PayerID
		from	PayerExtraParams
		where	PayerID IN (select PayerID from @PayersAcceptCOB)
		and		ParamName = 'AcceptingCOB')

DECLARE @PayerID INT

IF NOT EXISTS(SELECT * FROM Payer WHERE PayerSourceID=2 AND PayerExternalID='HCP01' AND Active=1)
BEGIN
	SELECT @PayerID=MAX(PayerID) 
	FROM Payer WHERE PayerSourceID=2
	AND PayerExternalID='HCP01'
	
	IF @PayerID IS NULL
	BEGIN
		INSERT INTO Payer (PayerSourceID, PayerName, PayerExternalID, PayerType, Nationwide, CreateDate, Active)
		VALUES (2, 'HealthCare Partners', 'HCP01', 'Commercial', 1, getdate(), 1)
	END
	ELSE
	BEGIN
		UPDATE Payer
		SET Active=1,
			ModifiedDate=getdate()
		WHERE PayerID = @PayerID
	END
END


--Payer for Gateway EDI which should be used by customers if they want to print paper claims
--SF 183367 (Cannot use the payer ID for electronic claims)
IF NOT EXISTS
(
	SELECT * FROM Payer WHERE PayerSourceID=3 AND PayerExternalID='00000' AND Active=1
)
BEGIN
	--If there doesnt exist an active payer 00000, check if its inactive
	SELECT @PayerID=MAX(PayerID) 
	FROM Payer WHERE PayerSourceID=3
	AND PayerExternalID='00000'
	
	IF @PayerID IS NULL
	BEGIN
		INSERT INTO Payer (PayerSourceID, PayerName, PayerExternalID, PayerType, Nationwide, CreateDate, Active)
		VALUES (3, 'Paper Claim (CMS 1500)', '00000', 'Unknown', 1, getdate(), 1)
	END
	ELSE
	BEGIN
		UPDATE Payer
		SET Active=1,
			ModifiedDate=getdate()
		WHERE PayerID = @PayerID
	END
END

--Another Gateway hack to set SupportsSecondaryBilling for payer 80705. We gather this info from ElectronicCOB flag. 
--Since this payer doesnt support COB but supports secondary billing
-- Update Capario payers that we know accept COB (but doesn't show up on website)
declare @GreatWestPayerID  INT 
SELECT @GreatWestPayerID = P.PayerID
FROM Payer P
WHERE P.PayerName = 'Great West' AND P.PayerSourceID = 3 
AND P.PayerExternalID = '80705'

SELECT @GreatWestPayerID

DELETE FROM PayerExtraParams
WHERE PayerID  = @GreatWestPayerID AND ParamName = 'ElectronicCOB' 

INSERT INTO PayerExtraParams (PayerID, ParamName, ParamValue)
select	@GreatWestPayerID, 'ElectronicCOB', 'True'


-- update some agreement links (FB 3782):

-- Payer "02201"
delete PayerExtraParams where PayerID in (
388506,
388513) and ParamName in ('ClaimsAgreementUrl', 'ERAAgreementUrl')

insert into PayerExtraParams (PayerID, ParamName, ParamValue) values (388506, 'ClaimsAgreementUrl', 'https://www.claimenroll.com/Download/Temp/PP_0170277.pdf')
insert into PayerExtraParams (PayerID, ParamName, ParamValue) values (388513, 'ClaimsAgreementUrl', 'https://www.claimenroll.com/Download/Temp/PP_0170277.pdf')

insert into PayerExtraParams (PayerID, ParamName, ParamValue) values (388506, 'ERAAgreementUrl', 'https://www.claimenroll.com/Download/Temp/PP_7185398.pdf')
insert into PayerExtraParams (PayerID, ParamName, ParamValue) values (388513, 'ERAAgreementUrl', 'https://www.claimenroll.com/Download/Temp/PP_7185398.pdf')


-- Payer "05130"
update Payer set Active=1 where PayerID=386830

delete PayerExtraParams where PayerID in (
386830) and ParamName in ('ClaimsAgreementUrl', 'ERAAgreementUrl')

insert into PayerExtraParams (PayerID, ParamName, ParamValue) values (386830, 'ClaimsAgreementUrl', 'https://www.claimenroll.com/Download/Temp/PP_9246854.pdf')
insert into PayerExtraParams (PayerID, ParamName, ParamValue) values (386830, 'ERAAgreementUrl', 'https://www.claimenroll.com/Download/Temp/PP_4103296.pdf')

COMMIT

--Connect to the server using SQL authentication in order for the linked server to work 
EXEC SHAREDSERVER.Superbill_Shared.dbo.Shared_SyncJob_PayersImport
--EXEC SHAREDSERVER.Superbill_Shared.dbo.Shared_SyncJob_ClearinghousePayersList


