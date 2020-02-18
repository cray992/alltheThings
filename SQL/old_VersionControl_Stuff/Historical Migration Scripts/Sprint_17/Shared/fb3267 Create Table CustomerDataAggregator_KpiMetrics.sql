
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CustomerDataAggregator_KeyPerformanceIndicators_Data](
	[ReportKeyID] INT NOT NULL CONSTRAINT [FK_CustomerDataAggregator_KeyPerformanceIndicators_Data_CustomerDataAggregator_ReportKeys] FOREIGN KEY REFERENCES [dbo].[CustomerDataAggregator_ReportKeys]([ReportKeyID]),
	[CustomerID] INT NOT NULL,
	--
	[DistinctDays] INT NULL,
	[PaymentAmount] MONEY NULL,
	[ChargeAmount] MONEY NULL,
	[DistinctDaysDroMetric] FLOAT NULL,
	--
	[ClaimsCreated] INT NULL,
	[Denials] INT NULL,
	[Rejections] INT NULL,
	[DenialsPercentMetric] FLOAT NULL,
	[RejectionsPercentMetric] FLOAT NULL,
	[ClaimsAgedOver120] INT NULL,
	[TotalOutstandingRevenue] FLOAT NULL,
	[PercentOfReceivablesAgedOver120Metric] FLOAT NULL
 CONSTRAINT [PK_CustomerDataAggregator_KeyPerformanceIndicators_Data] PRIMARY KEY CLUSTERED 
(
	[ReportKeyID] ASC,
	[CustomerID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[CustomerDataAggregator_KeyPerformanceIndicators_ReportParameters](
	[ReportKeyID] INT NOT NULL CONSTRAINT [FK_CustomerDataAggregator_KeyPerformanceIndicators_ReportParameter_CustomerDataAggregator_ReportKeys] FOREIGN KEY REFERENCES [dbo].[CustomerDataAggregator_ReportKeys]([ReportKeyID]),
	[AsOfDate] DATETIME NOT NULL
 CONSTRAINT [PK_CustomerDataAggregator_KeyPerformanceIndicators_ReportParameters] PRIMARY KEY CLUSTERED 
(
	[ReportKeyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]