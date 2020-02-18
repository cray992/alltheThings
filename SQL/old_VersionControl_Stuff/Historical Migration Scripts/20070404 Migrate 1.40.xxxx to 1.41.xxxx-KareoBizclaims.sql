-- DROP TABLE dbo.ClaimTrackerTrends

CREATE TABLE dbo.ClaimTrackerTrends(

		[sDate] varchar(64),
		[dateActual] datetime,

		[goodMedAvantBatches] int,
		[medavantReportsProducedDuringLast24Hours] int,
		[erasMedAvantRetrievedDuringLast24Hours] int,

		[goodGatewayEDIBatches] int,
		[gatewayediReportsProducedDuringLast24Hours] int,
		[erasGatewayEDIRetrievedDuringLast24Hours] int,

		[goodOfficeAllyBatches] int,
		[officeallyReportsProducedDuringLast24Hours] int,
		[erasOfficeAllyRetrievedDuringLast24Hours] int,

		[chargesSentToClearinghouse] Money,
		[chargesRejectedByClearinghouse] Money,
		[claimsSent] int,
		[payerRejectedCharges] Money,
		[payerAcceptedCharges] Money,
		[claimsRejectedByClearinghouse] int,

		[chargesSentToClearinghouseL] Money,
		[chargesRejectedByClearinghouseL] Money,
		[claimsSentL] int,
		[payerRejectedChargesL] Money,
		[payerAcceptedChargesL] Money,
		[claimsRejectedByClearinghouseL] int,

		[activeCustomers] int,
		[activePractices] int,
		[activeProviders] int,
		[activePayers] int,
		[activePatients] int
)
