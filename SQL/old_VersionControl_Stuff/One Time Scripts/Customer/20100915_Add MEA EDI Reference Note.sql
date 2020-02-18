-- Apply hack from SF 126915 to all customers (if not already applied)
IF NOT EXISTS (SELECT * FROM EDINoteReferenceCode WHERE Code = 'MEA')
BEGIN
INSERT INTO EDINoteReferenceCode (Code, Definition, ClaimOnly, DisplayCMS1500, DisplayUB04)
VALUES ('MEA', 'Test Measurement', 0, 1, 0)
END