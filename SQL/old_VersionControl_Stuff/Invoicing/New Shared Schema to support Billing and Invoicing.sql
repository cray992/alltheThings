IF EXISTS(SELECT * FROM sys.objects WHERE name='KareoProductRuleType' AND type='U')
BEGIN	
	IF EXISTS(SELECT * FROM sys.objects WHERE name='FK_KareoProductRule_KareoProductRuleTypeCode' AND type='F')
		ALTER TABLE KareoProductRule DROP CONSTRAINT FK_KareoProductRule_KareoProductRuleTypeCode

	DROP TABLE KareoProductRuleType
END

GO

CREATE TABLE KareoProductRuleType(KareoProductRuleTypeCode CHAR(1) NOT NULL CONSTRAINT PK_KareoProductRuleType PRIMARY KEY
, KareoProductRuleTypeName VARCHAR(50) NOT NULL CONSTRAINT U_KareoProductRuleTypeName UNIQUE)

GO

IF EXISTS(SELECT * FROM sys.objects WHERE name='KareoProductRule' AND type='U')
	DROP TABLE KareoProductRule
GO

CREATE TABLE KareoProductRule(KareoProductRuleID INT IDENTITY(1,1) CONSTRAINT PK_KareoProductRule PRIMARY KEY, 
							  KareoProductRuleName VARCHAR(128) NOT NULL, 
					          KareoProductRuleDescription VARCHAR(500) NULL, KareoProductRuleTypeCode CHAR(1) NOT NULL, KareoProductRuleDef XML,
							  EffectiveStartDate DATETIME NULL, EffectiveEndDate DATETIME NULL, CreatedUserID INT NOT NULL, ModifiedUserID INT NOT NULL, 
							  Active BIT NOT NULL CONSTRAINT DF_KareoProductRule_Active DEFAULT 1, CustomerID INT NULL, EditionTypeID INT NOT NULL,
							  ProviderTypeID INT NULL)

GO

ALTER TABLE KareoProductRule ADD CONSTRAINT FK_KareoProductRule_KareoProductRuleTypeCode
FOREIGN KEY (KareoProductRuleTypeCode) REFERENCES KareoProductRuleType (KareoProductRuleTypeCode)

GO

IF EXISTS(SELECT * FROM sys.objects WHERE name='KareoProductLineItem' AND type='U')
	DROP TABLE KareoProductLineItem
GO

CREATE TABLE KareoProductLineItem(KareoProductLineItemID INT IDENTITY(1,1) CONSTRAINT PK_KareoProductLineItem PRIMARY KEY,
								  KareoProductLineItemName VARCHAR(128), Price MONEY, Active BIT CONSTRAINT DF_KareoProductLineItem_Active DEFAULT 1, 
								  KareoProductLineItemDesc VARCHAR(500), InvoicingInputItemID INT,
								  CreatedDate DATETIME CONSTRAINT DF_KareoProductLineItem_CreatedDate DEFAULT GETDATE(),
								  CreatedUserID INT, 
								  ModifiedDate DATETIME CONSTRAINT DF_KareoProductLineItem_ModifiedDate DEFAULT GETDATE(),
								  ModifiedUserID INT)


GO

IF EXISTS(SELECT * FROM sys.objects WHERE name='KareoProvider' AND type='U')
BEGIN
	IF EXISTS(SELECT * FROM sys.objects WHERE name='FK_KareoProviderToDoctor_KareoProviderID' AND type='F')
		ALTER TABLE KareoProviderToDoctor DROP CONSTRAINT FK_KareoProviderToDoctor_KareoProviderID

	DROP TABLE KareoProvider
END
GO

CREATE TABLE KareoProvider(KareoProviderID INT IDENTITY(1,1) CONSTRAINT PK_KareoProvider PRIMARY KEY,
						   CustomerID INT NOT NULL, ProviderFullName VARCHAR(256), ProviderTypeID INT, PromoExpiration DATETIME, 
						   KareoProductRuleID INT NULL)

GO

IF EXISTS(SELECT * FROM sys.objects WHERE name='KareoProviderToDoctor' AND type='U')
	DROP TABLE KareoProviderToDoctor
GO

CREATE TABLE KareoProviderToDoctor(KareoProviderToDoctorID INT IDENTITY(1,1) CONSTRAINT PK_KareProviderToDoctorID PRIMARY KEY,
								   KareoProviderID INT NOT NULL, CustomerID INT NOT NULL, DoctorID INT NOT NULL)

GO

ALTER TABLE KareoProviderToDoctor ADD CONSTRAINT FK_KareoProviderToDoctor_KareoProviderID
FOREIGN KEY (KareoProviderID) REFERENCES KareoProvider (KareoProviderID)

GO

INSERT INTO KareoProductRuleType(KareoProductRuleTypeCode, KareoProductRuleTypeName)
VALUES('C','Customer')

INSERT INTO KareoProductRuleType(KareoProductRuleTypeCode, KareoProductRuleTypeName)
VALUES('D','Doctor')

INSERT INTO KareoProductRuleType(KareoProductRuleTypeCode, KareoProductRuleTypeName)
VALUES('P','Practice')

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, CreatedUserID, ModifiedUserID)
VALUES('Basic','Basic Edition',49.00,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, CreatedUserID, ModifiedUserID)
VALUES('Team','Team Edition',99.00,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, CreatedUserID, ModifiedUserID)
VALUES('Enterprise','Enterprise Edition',199.00,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, InvoicingInputItemID, CreatedUserID, ModifiedUserID)
VALUES('DMS','Additional Document Management Space',15.00,1,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, InvoicingInputItemID, CreatedUserID, ModifiedUserID)
VALUES('Electronic Claims','Electronic Claim Processing',0.12,2,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, InvoicingInputItemID, CreatedUserID, ModifiedUserID)
VALUES('Electronic Remittance','Electronic Remittance Advice',0.12,4,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, InvoicingInputItemID, CreatedUserID, ModifiedUserID)
VALUES('Eligibility','Eligibility Check',0.30,7,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, InvoicingInputItemID, CreatedUserID, ModifiedUserID)
VALUES('Patient Statement - 1st Page','Patient Statement First Page',0.48,5,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, InvoicingInputItemID, CreatedUserID, ModifiedUserID)
VALUES('Patient Statement - Additional Page','Patient Statement - Additional Page',0.10,6,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, CreatedUserID, ModifiedUserID)
VALUES('Platinum','Platinum Plan',89.00,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, CreatedUserID, ModifiedUserID)
VALUES('Gold','Gold Plan',69.00,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, CreatedUserID, ModifiedUserID)
VALUES('Standard','Standard Plan',0.00,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, CreatedUserID, ModifiedUserID)
VALUES('Co-Branding','Initial Setup of Co-Branding',1000.00,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, CreatedUserID, ModifiedUserID)
VALUES('Co-Branding - Change','Change Request to Co-Branding',500.00,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, CreatedUserID, ModifiedUserID)
VALUES('Hours','',0.00,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, CreatedUserID, ModifiedUserID)
VALUES('Integration - Competitor','Data Import from Supported Competitor',1000.00,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, CreatedUserID, ModifiedUserID)
VALUES('Integration - Standard','Data Import from Standard File Format',0.00,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, CreatedUserID, ModifiedUserID)
VALUES('Interface - Custom','Data Interface using Custom Format',150.00,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, CreatedUserID, ModifiedUserID)
VALUES('Interface - HL7','Data Interface using Standard HL7 Format',500.00,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, CreatedUserID, ModifiedUserID)
VALUES('Superbill','New Custom Form',1500.00,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, CreatedUserID, ModifiedUserID)
VALUES('Superbill - Modification','Modification to Existing Form',250.00,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, CreatedUserID, ModifiedUserID)
VALUES('Training - Exp','Onsite Training Travel Expenses',0.00,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, CreatedUserID, ModifiedUserID)
VALUES('Training - Onsite','Onsite Training',1500.00,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, CreatedUserID, ModifiedUserID)
VALUES('Training - WB Private','Private Web-based Training',150.00,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, CreatedUserID, ModifiedUserID)
VALUES('See Comments','',0.00,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, CreatedUserID, ModifiedUserID)
VALUES('Interest','',0.00,295,295)

INSERT INTO KareoProductLineItem(KareoProductLineItemName, KareoProductLineItemDesc, Price, CreatedUserID, ModifiedUserID)
VALUES('IT Consulting','',0.00,295,295)


GO

DECLARE @XmlDef XML
SET @XMLDef='<kareoproductdef>
	<productdef name="Standard" default="true">
		<lineitems>
			<KareoProductLineItem value="1"/>
			<KareoProductLineItem value="5"/>
			<KareoProductLineItem value="7"/>
		</lineitems>
	</productdef>
</kareoproductdef>'

INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
							 CreatedUserID, ModifiedUserID)
VALUES('Basic Edition - Normal Provider',NULL,'D',@XMLDef,3,1,295,295)

GO

DECLARE @XmlDef XML
SET @XMLDef='<kareoproductdef>
	<productdef name="Standard" default="true">
		<limitations>
			<limit name="promoexp" value=""/>
		</limitations>
		<lineitems>
			<KareoProductLineItem value="1" price="0.00"/>
			<KareoProductLineItem value="5"/>
			<KareoProductLineItem value="7"/>
		</lineitems>
	</productdef>
	<productdef name="Limitation Exception">
		<kareoproductdeflookup value="1"/>
	</productdef>
</kareoproductdef>'

INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
							 CreatedUserID, ModifiedUserID)
VALUES('Basic Edition - Promo Provider',NULL,'D',@XMLDef,3,4,295,295)

GO

DECLARE @XmlDef XML
SET @XMLDef='<kareoproductdef>
	<productdef name="Standard" default="true">
		<lineitems>
			<KareoProductLineItem value="1" price="24.50"/>
			<KareoProductLineItem value="5"/>
			<KareoProductLineItem value="7"/>
		</lineitems>
	</productdef>
</kareoproductdef>'

INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
							 CreatedUserID, ModifiedUserID)
VALUES('Basic Edition - Mid-Level Provider',NULL,'D',@XMLDef,3,2,295,295)

GO

DECLARE @XmlDef XML
SET @XMLDef='<kareoproductdef>
	<productdef name="Standard" default="true">
		<limitations>
			<limit name="encounters" value="75"/>
		</limitations>
		<lineitems>
			<KareoProductLineItem value="1" price="24.50"/>
			<KareoProductLineItem value="5"/>
			<KareoProductLineItem value="7"/>
		</lineitems>
	</productdef>
	<productdef name="Limitation Exception">
		<kareoproductdeflookup value="1"/>
	</productdef>
</kareoproductdef>'

INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
							 CreatedUserID, ModifiedUserID)
VALUES('Basic Edition - Part-Time Provider',NULL,'D',@XMLDef,3,3,295,295)

GO

DECLARE @XmlDef XML
SET @XMLDef='<kareoproductdef>
	<productdef name="Standard" default="true">
		<lineitems>
			<KareoProductLineItem value="4"/>
			<KareoProductLineItem value="6"/>
			<KareoProductLineItem value="8"/>
			<KareoProductLineItem value="9"/>
		</lineitems>
	</productdef>
</kareoproductdef>'

INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
							 CreatedUserID, ModifiedUserID)
VALUES('Basic Edition - Practice Products',NULL,'P',@XMLDef,3,NULL,295,295)

GO

DECLARE @XmlDef XML
SET @XMLDef='<kareoproductdef>
	<productdef name="Standard" default="true">
		<lineitems>
			<KareoProductLineItem value="2"/>
			<KareoProductLineItem value="5" allowance="400"/>
			<KareoProductLineItem value="7"/>
		</lineitems>
	</productdef>
</kareoproductdef>'

INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
							 CreatedUserID, ModifiedUserID)
VALUES('Team Edition - Normal Provider',NULL,'D',@XMLDef,2,1,295,295)

GO

DECLARE @XmlDef XML
SET @XMLDef='<kareoproductdef>
	<productdef name="Standard" default="true">
		<limitations>
			<limit name="promoexp" value=""/>
		</limitations>
		<lineitems>
			<KareoProductLineItem value="2" price="0.00"/>
			<KareoProductLineItem value="5" allowance="400"/>
			<KareoProductLineItem value="7"/>
		</lineitems>
	</productdef>
	<productdef name="Limitation Exception">
		<kareoproductdeflookup value="6"/>
	</productdef>
</kareoproductdef>'

INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
							 CreatedUserID, ModifiedUserID)
VALUES('Team Edition - Promo Provider',NULL,'D',@XMLDef,2,4,295,295)

GO

DECLARE @XmlDef XML
SET @XMLDef='<kareoproductdef>
	<productdef name="Standard" default="true">
		<lineitems>
			<KareoProductLineItem value="2" price="49.50"/>
			<KareoProductLineItem value="5" allowance="200"/>
			<KareoProductLineItem value="7"/>
		</lineitems>
	</productdef>
</kareoproductdef>'

INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
							 CreatedUserID, ModifiedUserID)
VALUES('Team Edition - Mid-Level Provider',NULL,'D',@XMLDef,2,2,295,295)

GO

DECLARE @XmlDef XML
SET @XMLDef='<kareoproductdef>
	<productdef name="Standard" default="true">
		<limitations>
			<limit name="encounters" value="75"/>
		</limitations>
		<lineitems>
			<KareoProductLineItem value="2" price="49.50"/>
			<KareoProductLineItem value="5" allowance="200"/>
			<KareoProductLineItem value="7"/>
		</lineitems>
	</productdef>
	<productdef name="Limitation Exception">
		<kareoproductdeflookup value="6"/>
	</productdef>
</kareoproductdef>'

INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
							 CreatedUserID, ModifiedUserID)
VALUES('Team Edition - Part-Time Provider',NULL,'D',@XMLDef,2,3,295,295)

GO

DECLARE @XmlDef XML
SET @XMLDef='<kareoproductdef>
	<productdef name="Standard" default="true">
		<lineitems>
			<KareoProductLineItem value="4">
				<allowances>
					<allowance providertypeid="1">75</allowance>
					<allowance providertypeid="2">37.5</allowance>
					<allowance providertypeid="3">37.5</allowance>
					<allowance providertypeid="4">75</allowance>
				</allowances>
			</KareoProductLineItem>
			<KareoProductLineItem value="6">
				<allowances>
					<allowance providertypeid="1">100</allowance>
					<allowance providertypeid="2">50</allowance>
					<allowance providertypeid="3">50</allowance>
					<allowance providertypeid="4">100</allowance>
				</allowances>
			</KareoProductLineItem>
			<KareoProductLineItem value="8"/>
			<KareoProductLineItem value="9"/>
		</lineitems>
	</productdef>
</kareoproductdef>'

INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
							 CreatedUserID, ModifiedUserID)
VALUES('Team Edition - Practice Products',NULL,'P',@XMLDef,2,NULL,295,295)

GO

DECLARE @XmlDef XML
SET @XMLDef='<kareoproductdef>
	<productdef name="Standard" default="true">
		<lineitems>
			<KareoProductLineItem value="3"/>
			<KareoProductLineItem value="5" allowance="600"/>
			<KareoProductLineItem value="7"/>
		</lineitems>
	</productdef>
</kareoproductdef>'

INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
							 CreatedUserID, ModifiedUserID)
VALUES('Enterprise Edition - Normal Provider',NULL,'D',@XMLDef,1,1,295,295)

GO

DECLARE @XmlDef XML
SET @XMLDef='<kareoproductdef>
	<productdef name="Standard" default="true">
		<limitations>
			<limit name="promoexp" value=""/>
		</limitations>
		<lineitems>
			<KareoProductLineItem value="3" price="0.00"/>
			<KareoProductLineItem value="5" allowance="600"/>
			<KareoProductLineItem value="7"/>
		</lineitems>
	</productdef>
	<productdef name="Limitation Exception">
		<kareoproductdeflookup value="11"/>
	</productdef>
</kareoproductdef>'

INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
							 CreatedUserID, ModifiedUserID)
VALUES('Enterprise Edition - Promo Provider',NULL,'D',@XMLDef,1,4,295,295)

GO

DECLARE @XmlDef XML
SET @XMLDef='<kareoproductdef>
	<productdef name="Standard" default="true">
		<lineitems>
			<KareoProductLineItem value="3" price="99.50"/>
			<KareoProductLineItem value="5" allowance="300"/>
			<KareoProductLineItem value="7"/>
		</lineitems>
	</productdef>
</kareoproductdef>'

INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
							 CreatedUserID, ModifiedUserID)
VALUES('Enterprise Edition - Mid-Level Provider',NULL,'D',@XMLDef,1,2,295,295)

GO

DECLARE @XmlDef XML
SET @XMLDef='<kareoproductdef>
	<productdef name="Standard" default="true">
		<limitations>
			<limit name="encounters" value="75"/>
		</limitations>
		<lineitems>
			<KareoProductLineItem value="3" price="99.50"/>
			<KareoProductLineItem value="5" allowance="300"/>
			<KareoProductLineItem value="7"/>
		</lineitems>
	</productdef>
	<productdef name="Limitation Exception">
		<kareoproductdeflookup value="11"/>
	</productdef>
</kareoproductdef>'

INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
							 CreatedUserID, ModifiedUserID)
VALUES('Enterprise Edition - Part-Time Provider',NULL,'D',@XMLDef,1,3,295,295)

GO

DECLARE @XmlDef XML
SET @XMLDef='<kareoproductdef>
	<productdef name="Standard" default="true">
		<lineitems>
			<KareoProductLineItem value="4">
				<allowances>
					<allowance providertypeid="1">100</allowance>
					<allowance providertypeid="2">50</allowance>
					<allowance providertypeid="3">50</allowance>
					<allowance providertypeid="4">100</allowance>
				</allowances>
			</KareoProductLineItem>
			<KareoProductLineItem value="6">
				<allowances>
					<allowance providertypeid="1">200</allowance>
					<allowance providertypeid="2">100</allowance>
					<allowance providertypeid="3">100</allowance>
					<allowance providertypeid="4">200</allowance>
				</allowances>
			</KareoProductLineItem>
			<KareoProductLineItem value="8"/>
			<KareoProductLineItem value="9"/>
		</lineitems>
	</productdef>
</kareoproductdef>'

INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
							 CreatedUserID, ModifiedUserID)
VALUES('Enterprise Edition - Practice Products',NULL,'P',@XMLDef,1,NULL,295,295)

GO

----====================================================================================
----PM&R Rules
----====================================================================================
--
--DECLARE @XmlDef XML
--SET @XMLDef='<kareoproductdef>
--	<productdef name="Standard" default="true">
--		<lineitems>
--			<KareoProductLineItem value="1"/>
--			<KareoProductLineItem value="5"/>
--			<KareoProductLineItem value="7"/>
--		</lineitems>
--	</productdef>
--</kareoproductdef>'
--
--INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
--							 CreatedUserID, ModifiedUserID, CustomerID)
--VALUES('Basic Edition - Normal Provider',NULL,'D',@XMLDef,3,1,295,295,1)
--
--GO
--
--DECLARE @XmlDef XML
--SET @XMLDef='<kareoproductdef>
--	<productdef name="Standard" default="true">
--		<limitations>
--			<limit name="promoexp" value=""/>
--		</limitations>
--		<lineitems>
--			<KareoProductLineItem value="1" price="0.00"/>
--			<KareoProductLineItem value="5"/>
--			<KareoProductLineItem value="7"/>
--		</lineitems>
--	</productdef>
--	<productdef name="Limitation Exception">
--		<kareoproductdeflookup value="1"/>
--	</productdef>
--</kareoproductdef>'
--
--INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
--							 CreatedUserID, ModifiedUserID)
--VALUES('Basic Edition - Promo Provider',NULL,'D',@XMLDef,3,4,295,295)
--
--GO
--
--DECLARE @XmlDef XML
--SET @XMLDef='<kareoproductdef>
--	<productdef name="Standard" default="true">
--		<lineitems>
--			<KareoProductLineItem value="1" price="24.50"/>
--			<KareoProductLineItem value="5"/>
--			<KareoProductLineItem value="7"/>
--		</lineitems>
--	</productdef>
--</kareoproductdef>'
--
--INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
--							 CreatedUserID, ModifiedUserID)
--VALUES('Basic Edition - Mid-Level Provider',NULL,'D',@XMLDef,3,2,295,295)
--
--GO
--
--DECLARE @XmlDef XML
--SET @XMLDef='<kareoproductdef>
--	<productdef name="Standard" default="true">
--		<limitations>
--			<limit name="encounters" value="75"/>
--		</limitations>
--		<lineitems>
--			<KareoProductLineItem value="1" price="24.50"/>
--			<KareoProductLineItem value="5"/>
--			<KareoProductLineItem value="7"/>
--		</lineitems>
--	</productdef>
--	<productdef name="Limitation Exception">
--		<kareoproductdeflookup value="1"/>
--	</productdef>
--</kareoproductdef>'
--
--INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
--							 CreatedUserID, ModifiedUserID)
--VALUES('Basic Edition - Part-Time Provider',NULL,'D',@XMLDef,3,3,295,295)
--
--GO
--
--DECLARE @XmlDef XML
--SET @XMLDef='<kareoproductdef>
--	<productdef name="Standard" default="true">
--		<lineitems>
--			<KareoProductLineItem value="4"/>
--			<KareoProductLineItem value="6"/>
--			<KareoProductLineItem value="8"/>
--			<KareoProductLineItem value="9"/>
--		</lineitems>
--	</productdef>
--</kareoproductdef>'
--
--INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
--							 CreatedUserID, ModifiedUserID)
--VALUES('Basic Edition - Practice Products',NULL,'P',@XMLDef,3,NULL,295,295)
--
--GO
--
--DECLARE @XmlDef XML
--SET @XMLDef='<kareoproductdef>
--	<productdef name="Standard" default="true">
--		<lineitems>
--			<KareoProductLineItem value="2"/>
--			<KareoProductLineItem value="5" allowance="400"/>
--			<KareoProductLineItem value="7"/>
--		</lineitems>
--	</productdef>
--</kareoproductdef>'
--
--INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
--							 CreatedUserID, ModifiedUserID)
--VALUES('Team Edition - Normal Provider',NULL,'D',@XMLDef,2,1,295,295)
--
--GO
--
--DECLARE @XmlDef XML
--SET @XMLDef='<kareoproductdef>
--	<productdef name="Standard" default="true">
--		<limitations>
--			<limit name="promoexp" value=""/>
--		</limitations>
--		<lineitems>
--			<KareoProductLineItem value="2" price="0.00"/>
--			<KareoProductLineItem value="5" allowance="400"/>
--			<KareoProductLineItem value="7"/>
--		</lineitems>
--	</productdef>
--	<productdef name="Limitation Exception">
--		<kareoproductdeflookup value="6"/>
--	</productdef>
--</kareoproductdef>'
--
--INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
--							 CreatedUserID, ModifiedUserID)
--VALUES('Team Edition - Promo Provider',NULL,'D',@XMLDef,2,4,295,295)
--
--GO
--
--DECLARE @XmlDef XML
--SET @XMLDef='<kareoproductdef>
--	<productdef name="Standard" default="true">
--		<lineitems>
--			<KareoProductLineItem value="2" price="49.50"/>
--			<KareoProductLineItem value="5" allowance="200"/>
--			<KareoProductLineItem value="7"/>
--		</lineitems>
--	</productdef>
--</kareoproductdef>'
--
--INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
--							 CreatedUserID, ModifiedUserID)
--VALUES('Team Edition - Mid-Level Provider',NULL,'D',@XMLDef,2,2,295,295)
--
--GO
--
--DECLARE @XmlDef XML
--SET @XMLDef='<kareoproductdef>
--	<productdef name="Standard" default="true">
--		<limitations>
--			<limit name="encounters" value="75"/>
--		</limitations>
--		<lineitems>
--			<KareoProductLineItem value="2" price="49.50"/>
--			<KareoProductLineItem value="5" allowance="200"/>
--			<KareoProductLineItem value="7"/>
--		</lineitems>
--	</productdef>
--	<productdef name="Limitation Exception">
--		<kareoproductdeflookup value="6"/>
--	</productdef>
--</kareoproductdef>'
--
--INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
--							 CreatedUserID, ModifiedUserID)
--VALUES('Team Edition - Part-Time Provider',NULL,'D',@XMLDef,2,3,295,295)
--
--GO
--
--DECLARE @XmlDef XML
--SET @XMLDef='<kareoproductdef>
--	<productdef name="Standard" default="true">
--		<lineitems>
--			<KareoProductLineItem value="4">
--				<allowances>
--					<allowance providertypeid="1">0.75</allowance>
--					<allowance providertypeid="2">0.375</allowance>
--					<allowance providertypeid="3">0.375</allowance>
--					<allowance providertypeid="4">0.75</allowance>
--				</allowances>
--			</KareoProductLineItem>
--			<KareoProductLineItem value="6">
--				<allowances>
--					<allowance providertypeid="1">100</allowance>
--					<allowance providertypeid="2">50</allowance>
--					<allowance providertypeid="3">50</allowance>
--					<allowance providertypeid="4">100</allowance>
--				</allowances>
--			</KareoProductLineItem>
--			<KareoProductLineItem value="8"/>
--			<KareoProductLineItem value="9"/>
--		</lineitems>
--	</productdef>
--</kareoproductdef>'
--
--INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
--							 CreatedUserID, ModifiedUserID)
--VALUES('Team Edition - Practice Products',NULL,'P',@XMLDef,2,NULL,295,295)
--
--GO
--
--DECLARE @XmlDef XML
--SET @XMLDef='<kareoproductdef>
--	<productdef name="Standard" default="true">
--		<lineitems>
--			<KareoProductLineItem value="3"/>
--			<KareoProductLineItem value="5" allowance="600"/>
--			<KareoProductLineItem value="7"/>
--		</lineitems>
--	</productdef>
--</kareoproductdef>'
--
--INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
--							 CreatedUserID, ModifiedUserID)
--VALUES('Enterprise Edition - Normal Provider',NULL,'D',@XMLDef,1,1,295,295)
--
--GO
--
--DECLARE @XmlDef XML
--SET @XMLDef='<kareoproductdef>
--	<productdef name="Standard" default="true">
--		<limitations>
--			<limit name="promoexp" value=""/>
--		</limitations>
--		<lineitems>
--			<KareoProductLineItem value="3" price="0.00"/>
--			<KareoProductLineItem value="5" allowance="600"/>
--			<KareoProductLineItem value="7"/>
--		</lineitems>
--	</productdef>
--	<productdef name="Limitation Exception">
--		<kareoproductdeflookup value="11"/>
--	</productdef>
--</kareoproductdef>'
--
--INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
--							 CreatedUserID, ModifiedUserID)
--VALUES('Enterprise Edition - Promo Provider',NULL,'D',@XMLDef,1,4,295,295)
--
--GO
--
--DECLARE @XmlDef XML
--SET @XMLDef='<kareoproductdef>
--	<productdef name="Standard" default="true">
--		<lineitems>
--			<KareoProductLineItem value="3" price="99.50"/>
--			<KareoProductLineItem value="5" allowance="300"/>
--			<KareoProductLineItem value="7"/>
--		</lineitems>
--	</productdef>
--</kareoproductdef>'
--
--INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
--							 CreatedUserID, ModifiedUserID)
--VALUES('Enterprise Edition - Mid-Level Provider',NULL,'D',@XMLDef,1,2,295,295)
--
--GO
--
--DECLARE @XmlDef XML
--SET @XMLDef='<kareoproductdef>
--	<productdef name="Standard" default="true">
--		<limitations>
--			<limit name="encounters" value="75"/>
--		</limitations>
--		<lineitems>
--			<KareoProductLineItem value="3" price="99.50"/>
--			<KareoProductLineItem value="5" allowance="300"/>
--			<KareoProductLineItem value="7"/>
--		</lineitems>
--	</productdef>
--	<productdef name="Limitation Exception">
--		<kareoproductdeflookup value="11"/>
--	</productdef>
--</kareoproductdef>'
--
--INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
--							 CreatedUserID, ModifiedUserID)
--VALUES('Enterprise Edition - Part-Time Provider',NULL,'D',@XMLDef,1,3,295,295)
--
--GO
--
--DECLARE @XmlDef XML
--SET @XMLDef='<kareoproductdef>
--	<productdef name="Standard" default="true">
--		<lineitems>
--			<KareoProductLineItem value="4">
--				<allowances>
--					<allowance providertypeid="1">1</allowance>
--					<allowance providertypeid="2">0.5</allowance>
--					<allowance providertypeid="3">0.5</allowance>
--					<allowance providertypeid="4">1</allowance>
--				</allowances>
--			</KareoProductLineItem>
--			<KareoProductLineItem value="6">
--				<allowances>
--					<allowance providertypeid="1">200</allowance>
--					<allowance providertypeid="2">100</allowance>
--					<allowance providertypeid="3">100</allowance>
--					<allowance providertypeid="4">200</allowance>
--				</allowances>
--			</KareoProductLineItem>
--			<KareoProductLineItem value="8"/>
--			<KareoProductLineItem value="9"/>
--		</lineitems>
--	</productdef>
--</kareoproductdef>'
--
--INSERT INTO KareoProductRule(KareoProductRuleName, KareoProductRuleDescription, KareoProductRuleTypeCode, KareoProductRuleDef, EditionTypeID, ProviderTypeID,
--							 CreatedUserID, ModifiedUserID)
--VALUES('Enterprise Edition - Practice Products',NULL,'P',@XMLDef,1,NULL,295,295)
--
--GO