-- FB 25 - Insert transport information for Gateway EDI eligibility

-- Remove identity on both EligibilityVendor and EligibilityTransport tables

--Copied from http://www.eggheadcafe.com/community/aspnet/13/10005322/remove-the-identity-prope.aspx

-- Drop key constraints
ALTER TABLE EligibilityVendor
  DROP CONSTRAINT FK_EligibilityVendor_EligibilityTransportID

ALTER TABLE EligibilityVendor
  DROP Constraint PK_EligibilityVendor_EligibilityVendorID

ALTER TABLE EligibilityTransport
  DROP Constraint PK_EligibilityTransport_EligibilityTransportID

-- Add new columns
ALTER TABLE EligibilityVendor
  ADD EligibilityVendorIDNew int NULL

ALTER TABLE EligibilityTransport
  ADD EligibilityTransportIDNew int NULL

GO

-- Copy old values to new column
UPDATE EligibilityVendor SET EligibilityVendorIDNew = EligibilityVendorID

UPDATE EligibilityTransport SET EligibilityTransportIDNew = EligibilityTransportID

-- Don't allow nulls anymore
ALTER TABLE EligibilityVendor
  ALTER COLUMN EligibilityVendorIDNew int NOT NULL

ALTER TABLE EligibilityTransport
  ALTER COLUMN EligibilityTransportIDNew int NOT NULL

--Drop the old columns
ALTER TABLE EligibilityVendor
  DROP COLUMN EligibilityVendorID

ALTER TABLE EligibilityTransport
  DROP COLUMN EligibilityTransportID

--Rename the new column to the old
EXEC sp_rename 'EligibilityVendor.EligibilityVendorIDNew', 'EligibilityVendorID', 'COLUMN'

EXEC sp_rename 'EligibilityTransport.EligibilityTransportIDNew', 'EligibilityTransportID', 'COLUMN'

--Recreate the keys
ALTER TABLE EligibilityVendor
  ADD Constraint PK_EligibilityVendor_EligibilityVendorID PRIMARY KEY (EligibilityVendorID)

ALTER TABLE EligibilityTransport
  ADD Constraint PK_EligibilityTransport_EligibilityTransportID PRIMARY KEY (EligibilityTransportID)

ALTER TABLE EligibilityVendor WITH NOCHECK
  ADD CONSTRAINT FK_EligibilityVendor_EligibilityTransportID
    FOREIGN KEY(EligibilityTransportID)
    REFERENCES EligibilityTransport(EligibilityTransportID)

--Inert the new transport info
INSERT INTO EligibilityTransport (EligibilityTransportID, TransportName, TransportType, InProduction, ParametersXml)
VALUES (3, 'Gateway EDI Web Service', 'HTTP', 1, '<Parameters>    <Http>      <Url>https://services.gatewayedi.com/Eligibility/Service.asmx</Url>   <Login>11QZ</Login>   <Password>Kareo789</Password>    </Http>    <AnsiX12>   <SubmitterName>KAREO</SubmitterName>   <SubmitterEtin>00739220</SubmitterEtin>   <SubmitterContactName>Kareo Inc Eligibility</SubmitterContactName>   <SubmitterContactPhone>1-888-775-2736</SubmitterContactPhone>   <SubmitterContactEmail>support@kareo.com</SubmitterContactEmail>   <SubmitterContactFax>949-209-3473</SubmitterContactFax>   <ReceiverName>GATEWAYEDI</ReceiverName>   <ReceiverEtin>770545613</ReceiverEtin>    </AnsiX12>  </Parameters>')

INSERT INTO EligibilityVendor (EligibilityVendorID, VendorName, Active, EligibilityTransportID)
VALUES (3, 'Gateway EDI', 1, 3)
