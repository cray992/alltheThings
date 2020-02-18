
/*==============================================================*/
/* Table: Customer Properties                                   */
/*==============================================================*/
IF NOT EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'CustomerProperties'
	AND	TYPE = 'U'
)
BEGIN
CREATE TABLE [dbo].[CustomerProperties](
	[CustomerPropertyID] [int] IDENTITY(1,1) NOT NULL,
	[Key] [varchar](50) NOT NULL,
	[Value] [varchar](max) NOT NULL)
	

	ALTER TABLE dbo.[CustomerProperties]
	ADD CONSTRAINT PK_CustomerProperties
	PRIMARY KEY ([CustomerPropertyID])

END

IF DB_NAME() NOT LIKE 'CustomerModel%'
BEGIN
	/*==============================================================*/
	/* Table: Set Customer Name,ID                                  */
	/*==============================================================*/
	DECLARE @CustomerID INT
	SELECT @CustomerID = CustomerID from [sharedserver].[superbill_shared].dbo.[Customer] where DatabaseName=DB_NAME()

	DECLARE @IdExists BIT
	SELECT @IdExists = (SELECT COUNT([Key]) FROM dbo.CustomerProperties WHERE [Key] = 'CustomerID')

	IF @IdExists = 0
	BEGIN
		INSERT INTO dbo.CustomerProperties([Key], [Value]) VALUES('CustomerID', @CustomerID)
	END
END