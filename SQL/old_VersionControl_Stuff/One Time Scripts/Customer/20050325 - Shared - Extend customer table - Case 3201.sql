/*

SHARED DATABASE UPDATE SCRIPT

v1.23.1878 to v1.24.xxxx
*/
----------------------------------

--BEGIN TRAN 
----------------------------------

---------------------------------------------------------------------------------------
--case 3201:  


CREATE TABLE [KareoProduct] (
	[KareoProductID] [int] IDENTITY (1, 1) NOT NULL ,
	[ProductName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Price] [money] NOT NULL CONSTRAINT [DF_KareoProduct_Price] DEFAULT(0),
	[CurrentlyOffered] [bit] NOT NULL CONSTRAINT [DF_KareoProduct_CurrentlyOffered] DEFAULT(1),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_KareoProduct_CreatedDate] DEFAULT (getdate()),

	CONSTRAINT [PK_KareoProduct] PRIMARY KEY  CLUSTERED 
	(
		[KareoProductID]
	)  ON [PRIMARY]

)
GO

INSERT INTO [KareoProduct] (ProductName, Price)
VALUES ('Kareo Basic Edition',149)
INSERT INTO [KareoProduct] (ProductName, Price)
VALUES ('Kareo Enterprise Edition',299)

INSERT INTO [KareoProduct] (ProductName, Price)
VALUES ('Standard Support',0)
INSERT INTO [KareoProduct] (ProductName, Price)
VALUES ('Gold Support',79)
INSERT INTO [KareoProduct] (ProductName, Price)
VALUES ('Platinum Support',99)

GO

CREATE TABLE [CustomerKareoProduct] (
	[CustomerID] int NOT NULL,
	[KareoProductID] int NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_CustomerKareoProduct_CreatedDate] DEFAULT (getdate()),
	CONSTRAINT [PK_CustomerKareoProduct] PRIMARY KEY  CLUSTERED 
	(
		[CustomerID],
		[KareoProductID]
	)  ON [PRIMARY],
	CONSTRAINT [FK_CustomerKareoProduct_CustomerID] FOREIGN KEY 
	(
		[CustomerID]
	) REFERENCES [Customer] (
		[CustomerID]
	),
	CONSTRAINT [FK_CustomerKareoProduct_KareoProductID] FOREIGN KEY 
	(
		[KareoProductID]
	) REFERENCES [KareoProduct] (
		[KareoProductID]
	)
)

GO

ALTER TABLE [Customer]
ADD
	LicenseCount int CONSTRAINT [DF_Customer_LicenseCount] DEFAULT(1)

ALTER TABLE [Customer]
ADD
	CustomerTypeTransitionPending bit CONSTRAINT [DF_Customer_CustomerTypeTransitionPending] DEFAULT(1)

GO

---------------------------------------------------------------------------------------
--case XXXX - Description

---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
