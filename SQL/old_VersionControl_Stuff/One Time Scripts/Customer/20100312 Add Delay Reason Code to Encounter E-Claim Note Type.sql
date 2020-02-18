/*
      SF 105737 - Add the Delay Reason Code to the Encounter Miscellaneous E-Claim Note Type drop down.
*/
IF NOT EXISTS(SELECT * FROM EDINoteReferenceCode WHERE Code='DRC')
BEGIN
      -- Include Delay Reason Code
      INSERT INTO EDINoteReferenceCode (Code, Definition, ClaimOnly)
      VALUES ('DRC', 'Delay Reason Code', 1)
END
