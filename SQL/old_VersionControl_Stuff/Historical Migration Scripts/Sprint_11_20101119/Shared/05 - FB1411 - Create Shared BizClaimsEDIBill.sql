
CREATE TABLE [dbo].[BizClaimsEDIBill](
	[BizClaimsEDIBillID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[BillID] [int] NOT NULL,
	[BillStateCode] [char](1) NOT NULL,
	[BillStateModifiedDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ConfirmedDate] [datetime] NULL,
 CONSTRAINT [PK_BizClaimsEDIBill] PRIMARY KEY CLUSTERED 
(
	[BizClaimsEDIBillID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[BizClaimsEDIBill]  WITH CHECK ADD  CONSTRAINT [FK_BizClaimsEDIBill_Customer_CustomerID] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO

ALTER TABLE [dbo].[BizClaimsEDIBill] CHECK CONSTRAINT [FK_BizClaimsEDIBill_Customer_CustomerID]
GO

ALTER TABLE [dbo].[BizClaimsEDIBill] ADD  CONSTRAINT [DF_BizClaimsEDIBill_BillStateCode]  DEFAULT ('R') FOR [BillStateCode]
GO

ALTER TABLE [dbo].[BizClaimsEDIBill] ADD  CONSTRAINT [DF_BizClaimsEDIBill_BillStateModifiedDate]  DEFAULT (getdate()) FOR [BillStateModifiedDate]
GO

ALTER TABLE [dbo].[BizClaimsEDIBill] ADD  CONSTRAINT [DF_BizClaimsEDIBill_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

CREATE NONCLUSTERED INDEX [IX_BizClaimsEDIBill] ON [dbo].[BizClaimsEDIBill] 
(
	[CustomerID] ASC,
	[BillID] ASC
)

CREATE NONCLUSTERED INDEX [IX_BizClaimsEDIBill_BillStateCode_ConfirmedDate_BillStateModifiedDate] ON [dbo].[BizClaimsEDIBill] 
(
	[BillStateCode] ASC,
	[ConfirmedDate] ASC,
	[BillStateModifiedDate] ASC
)