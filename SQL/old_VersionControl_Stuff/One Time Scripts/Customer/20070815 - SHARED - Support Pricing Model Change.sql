
DECLARE
	@KareoProductRule_1 INT,
	@KareoProductRule_2 INT,
	@KareoProductRule_3 INT,
	@KareoProductRule_4 INT,
	@KareoProductRule_5 INT,
	@KareoProductRule_SupportUsage INT,
	@CutOverDate DATETIME



-- for testing purposes
SET @CutOverDate = '9/1/07'



-- Actual production
-- SET @CutOverDate = '9/30/07 23:59:59'




---- New Product Rules
		INSERT INTO [Superbill_Shared].[dbo].[KareoProductLineItem]
				   ([KareoProductLineItemName]
				   ,[Price]
				   ,[Active]
				   ,[KareoProductLineItemDesc]
				   ,[InvoicingInputItemID]
				   ,[CreatedDate]
				   ,[CreatedUserID]
				   ,[ModifiedDate]
				   ,[ModifiedUserID])
			 VALUES
				   ('Support - Self Service'
				   ,0.00
				   ,1
				   ,'Support - Free Self Support'
				   ,NULL
				   ,GETDATE()
				   ,951
				   ,GETDATE()
				   ,951
					)
		SET @KareoProductRule_1 = @@IDENTITY

		INSERT INTO [Superbill_Shared].[dbo].[KareoProductLineItem]
				   ([KareoProductLineItemName]
				   ,[Price]
				   ,[Active]
				   ,[KareoProductLineItemDesc]
				   ,[InvoicingInputItemID]
				   ,[CreatedDate]
				   ,[CreatedUserID]
				   ,[ModifiedDate]
				   ,[ModifiedUserID])
			 VALUES
				   ('Support - LEVEL 1'
				   ,99
				   ,1
				   ,'Support - LEVEL 1, 3 cases/mo.'
				   ,NULL
				   ,GETDATE()
				   ,951
				   ,GETDATE()
				   ,951
					)
		SET @KareoProductRule_2 = @@IDENTITY



		INSERT INTO [Superbill_Shared].[dbo].[KareoProductLineItem]
				   ([KareoProductLineItemName]
				   ,[Price]
				   ,[Active]
				   ,[KareoProductLineItemDesc]
				   ,[InvoicingInputItemID]
				   ,[CreatedDate]
				   ,[CreatedUserID]
				   ,[ModifiedDate]
				   ,[ModifiedUserID])
			 VALUES
				   ('Support - LEVEL 2'
				   ,299
				   ,1
				   ,'Support - LEVEL 2, 10 cases/mo.'
				   ,NULL
				   ,GETDATE()
				   ,951
				   ,GETDATE()
				   ,951
					)
		SET @KareoProductRule_3 = @@IDENTITY


		INSERT INTO [Superbill_Shared].[dbo].[KareoProductLineItem]
				   ([KareoProductLineItemName]
				   ,[Price]
				   ,[Active]
				   ,[KareoProductLineItemDesc]
				   ,[InvoicingInputItemID]
				   ,[CreatedDate]
				   ,[CreatedUserID]
				   ,[ModifiedDate]
				   ,[ModifiedUserID])
			 VALUES
				   ('Support - LEVEL 3'
				   ,499
				   ,1
				   ,'Support - LEVEL 3, 20 cases/mo.'
				   ,NULL
				   ,GETDATE()
				   ,951
				   ,GETDATE()
				   ,951
					)
		SET @KareoProductRule_4 = @@IDENTITY


		INSERT INTO [Superbill_Shared].[dbo].[KareoProductLineItem]
				   ([KareoProductLineItemName]
				   ,[Price]
				   ,[Active]
				   ,[KareoProductLineItemDesc]
				   ,[InvoicingInputItemID]
				   ,[CreatedDate]
				   ,[CreatedUserID]
				   ,[ModifiedDate]
				   ,[ModifiedUserID])
			 VALUES
				   ('Support - LEVEL 4'
				   ,899
				   ,1
				   ,'Support - LEVEL 4, 40 cases/mo.'
				   ,NULL
				   ,GETDATE()
				   ,951
				   ,GETDATE()
				   ,951
					)
		SET @KareoProductRule_5 = @@IDENTITY



		INSERT INTO [Superbill_Shared].[dbo].[KareoProductLineItem]
				   ([KareoProductLineItemName]
				   ,[Price]
				   ,[Active]
				   ,[KareoProductLineItemDesc]
				   ,[InvoicingInputItemID]
				   ,[CreatedDate]
				   ,[CreatedUserID]
				   ,[ModifiedDate]
				   ,[ModifiedUserID])
			 VALUES
				   ('Support - Telephone Support'
				   ,150
				   ,1
				   ,'Support - Usage fee for telephone support.'
				   ,NULL
				   ,GETDATE()
				   ,951
				   ,GETDATE()
				   ,951
					)
		SET @KareoProductRule_SupportUsage = @@IDENTITY




		INSERT INTO [Superbill_Shared].[dbo].[KareoProductLineItem]
				   ([KareoProductLineItemName]
				   ,[Price]
				   ,[Active]
				   ,[KareoProductLineItemDesc]
				   ,[InvoicingInputItemID]
				   ,[CreatedDate]
				   ,[CreatedUserID]
				   ,[ModifiedDate]
				   ,[ModifiedUserID])
			 VALUES
				   ('Support - Additional Usage Fee'
				   ,49
				   ,1
				   ,'Support - Usage Fee per case over support subscription.'
				   ,NULL
				   ,GETDATE()
				   ,951
				   ,GETDATE()
				   ,951
					)
		SET @KareoProductRule_SupportUsage = @@IDENTITY




-- Turn off the existing Product Rule
		UPDATE k
		SET EffectiveStartDate = '1/1/1990', EffectiveEndDate = DATEADD(s, -1, @CutOverDate)
		FROM [KareoProductRule] k
		WHERE KareoProductRuleDef.exist('/kareoproductdef/productdef/lineitems/KareoProductLineItem[@value eq "10"]') = 1
		OR KareoProductRuleDef.exist('/kareoproductdef/productdef/lineitems/KareoProductLineItem[@value eq "11"]') = 1
		OR KareoProductRuleDef.exist('/kareoproductdef/productdef/lineitems/KareoProductLineItem[@value eq "12"]') = 1
		or KareoProductRuleID = 5



-- get copy of current business rule
		SELECT [KareoProductRuleName]
			   ,'Pricing Model 2007' AS [KareoProductRuleDescription]
			   ,[KareoProductRuleTypeCode]
			   ,[KareoProductRuleDef]
			   ,@CutOverDate AS [EffectiveStartDate]
			   ,CAST(NULL AS DATETIME) [EffectiveEndDate]
			   ,951 AS [CreatedUserID]
			   ,951 AS [ModifiedUserID]
			   ,[Active]
			   ,[CustomerID]
			   ,[EditionTypeID]
			   ,[ProviderTypeID]
		INTO #KareoProductRule
		FROM [KareoProductRule] k
		WHERE KareoProductRuleDef.exist('/kareoproductdef/productdef/lineitems/KareoProductLineItem[@value eq "10"]') = 1
			OR KareoProductRuleDef.exist('/kareoproductdef/productdef/lineitems/KareoProductLineItem[@value eq "11"]') = 1
			OR KareoProductRuleDef.exist('/kareoproductdef/productdef/lineitems/KareoProductLineItem[@value eq "12"]') = 1
			or KareoProductRuleID = 5



		-- Remove Support at the provider level.
		Update kpr
		SET  KareoProductRuleDef.modify('       
				delete(/kareoproductdef/productdef/lineitems/KareoProductLineItem[@value="10"])') 
		from #KareoProductRule kpr

		Update kpr
		SET  KareoProductRuleDef.modify('       
				delete(/kareoproductdef/productdef/lineitems/KareoProductLineItem[@value="11"])') 
		from #KareoProductRule kpr

		Update kpr
		SET  KareoProductRuleDef.modify('       
				delete(/kareoproductdef/productdef/lineitems/KareoProductLineItem[@value="12"])') 
		from #KareoProductRule kpr


		----------------- Update Basic Edition (increase subscription, eClaim, pClaim)
		UPDATE #KareoProductRule
		SET KareoProductRuleDef=
			'<kareoproductdef>
			  <productdef name="Standard" default="true">
				<lineitems>
				  <KareoProductLineItem value="1" price="69.00"/>
				  <KareoProductLineItem value="5" price="0.12"/>
				  <KareoProductLineItem value="7" />
				  <KareoProductLineItem value="28" />
				</lineitems>
			  </productdef>
			</kareoproductdef>'
		WHERE kareoproductRuleName = 'Basic Edition - Normal Provider'

		UPDATE #KareoProductRule
		SET KareoProductRuleDef= 
			'<kareoproductdef>
			  <productdef name="Standard" default="true">
				<limitations>
				  <limit name="promoexp" value="" />
				</limitations>
				<lineitems>
				  <KareoProductLineItem value="1" price="0.00" />
				  <KareoProductLineItem value="5" price="0.12"/>
				  <KareoProductLineItem value="7" />
				  <KareoProductLineItem value="28" />
				</lineitems>
			  </productdef>
			  <productdef name="Limitation Exception">
				<kareoproductdeflookup value="1" />
			  </productdef>
			</kareoproductdef>'
		WHERE kareoproductRuleName = 'Basic Edition - Promo Provider'


		UPDATE #KareoProductRule
		SET KareoProductRuleDef= 
			'<kareoproductdef>
			  <productdef name="Standard" default="true">
				<lineitems>
				  <KareoProductLineItem value="1" price="34.50" />
				  <KareoProductLineItem value="5" price="0.12"/>
				  <KareoProductLineItem value="7" />
				  <KareoProductLineItem value="28" />
				</lineitems>
			  </productdef>
			</kareoproductdef>'
		WHERE kareoproductRuleName = 'Basic Edition - Mid-Level Provider'

		UPDATE #KareoProductRule
		SET KareoProductRuleDef=
			'<kareoproductdef>
			  <productdef name="Standard" default="true">
				<lineitems>
				  <KareoProductLineItem value="1" price="34.50" />
				  <KareoProductLineItem value="5" price="0.12"/>
				  <KareoProductLineItem value="7" />
				  <KareoProductLineItem value="28" />
				</lineitems>
			  </productdef>
			</kareoproductdef>'
		WHERE kareoproductRuleName = 'Basic Edition - Part-Time Provider'

		UPDATE #KareoProductRule
		SET KareoProductRuleDef=
			'<kareoproductdef>
			  <productdef name="Standard" default="true">
				<lineitems>
				  <KareoProductLineItem value="1" price="0" />
				  <KareoProductLineItem value="5" price="0.12"/>
				  <KareoProductLineItem value="7" />
				  <KareoProductLineItem value="28" />
				</lineitems>
			  </productdef>
			</kareoproductdef>'
		WHERE kareoproductRuleName = 'Basic Edition - Bundled Provider'


		UPDATE #KareoProductRule
		SET KareoProductRuleDef=
			'<kareoproductdef>
			  <productdef name="Standard" default="true">
				<lineitems>
				  <KareoProductLineItem value="4" />
				  <KareoProductLineItem value="6" price="0.12"/>
				  <KareoProductLineItem value="8" />
				  <KareoProductLineItem value="9" />
				</lineitems>
			  </productdef>
			</kareoproductdef>'
		WHERE kareoproductRuleName = 'Basic Edition - Practice Products'


----------------- Update Team Edition (increase subscription, eClaim, pClaim)

		UPDATE #KareoProductRule
		SET KareoProductRuleDef=
			'<kareoproductdef>
			  <productdef name="Standard" default="true">
				<lineitems>
				  <KareoProductLineItem value="2" price="64.50" />
				  <KareoProductLineItem value="5" allowance="200" />
				  <KareoProductLineItem value="7" />
				</lineitems>
			  </productdef>
			</kareoproductdef>'
		WHERE kareoproductRuleName = 'Team Edition - Mid-Level Provider'




		UPDATE #KareoProductRule
		SET KareoProductRuleDef=
			'<kareoproductdef>
			  <productdef name="Standard" default="true">
				<lineitems>
				  <KareoProductLineItem value="2" price="64.50" />
				  <KareoProductLineItem value="5" allowance="200" />
				  <KareoProductLineItem value="7" />
				</lineitems>
			  </productdef>
			</kareoproductdef>'
		WHERE kareoproductRuleName = 'Team Edition - Part-Time Provider'







		INSERT INTO [Superbill_Shared].[dbo].[KareoProductRule]
			   ([KareoProductRuleName]
			   ,[KareoProductRuleDescription]
			   ,[KareoProductRuleTypeCode]
			   ,[KareoProductRuleDef]
			   ,[EffectiveStartDate]
			   ,[EffectiveEndDate]
			   ,[CreatedUserID]
			   ,[ModifiedUserID]
			   ,[Active]
			   ,[CustomerID]
			   ,[EditionTypeID]
			   ,[ProviderTypeID])

		SELECT [KareoProductRuleName]
			   ,[KareoProductRuleDescription]
			   ,[KareoProductRuleTypeCode]
			   ,[KareoProductRuleDef]
			   ,[EffectiveStartDate]
			   ,[EffectiveEndDate]
			   ,[CreatedUserID]
			   ,[ModifiedUserID]
			   ,[Active]
			   ,[CustomerID]
			   ,[EditionTypeID]
			   ,[ProviderTypeID]
		FROM #KareoProductRule




		INSERT INTO [Superbill_Shared].[dbo].[KareoProductRule]
			   ([KareoProductRuleName]
			   ,[KareoProductRuleDescription]
			   ,[KareoProductRuleTypeCode]
			   ,[KareoProductRuleDef]
			   ,[EffectiveStartDate]
			   ,[EffectiveEndDate]
			   ,[CreatedUserID]
			   ,[ModifiedUserID]
			   ,[Active]
			   ,[CustomerID]
			   ,[EditionTypeID]
			   ,[ProviderTypeID])
		VALUES(
				'Customer Products'
			   ,'Pricing Model 2007'
			   ,'C'
			   ,'<kareoproductdef>
				  <productdef name="Standard" default="true">
					<lineitems>
					  <KareoProductLineItem value="' + CAST(@KareoProductRule_1 AS VARCHAR) + '" column="SupportTypeID" columnvalue="4" />
					  <KareoProductLineItem value="' + CAST(@KareoProductRule_2 AS VARCHAR) + '" column="SupportTypeID" columnvalue="3" />
					  <KareoProductLineItem value="' + CAST(@KareoProductRule_3 AS VARCHAR) + '" column="SupportTypeID" columnvalue="2" />
					  <KareoProductLineItem value="' + CAST(@KareoProductRule_4 AS VARCHAR) + '" column="SupportTypeID" columnvalue="1" />
					  <KareoProductLineItem value="' + CAST(@KareoProductRule_5 AS VARCHAR) + '" column="SupportTypeID" columnvalue="5" />

					  <KareoProductLineItem value="' + CAST(@KareoProductRule_SupportUsage AS VARCHAR) + '" allowance="0" column="SupportTypeID" columnvalue="4" />
					  <KareoProductLineItem value="' + CAST(@KareoProductRule_SupportUsage AS VARCHAR) + '" allowance="3" column="SupportTypeID" columnvalue="3" />
					  <KareoProductLineItem value="' + CAST(@KareoProductRule_SupportUsage AS VARCHAR) + '" allowance="10" column="SupportTypeID" columnvalue="2" />
					  <KareoProductLineItem value="' + CAST(@KareoProductRule_SupportUsage AS VARCHAR) + '" allowance="20" column="SupportTypeID" columnvalue="1" />
					  <KareoProductLineItem value="' + CAST(@KareoProductRule_SupportUsage AS VARCHAR) + '" allowance="40" column="SupportTypeID" columnvalue="5" />

					</lineitems>
				  </productdef>
				</kareoproductdef>'
			   ,@CutOverDate
			   ,NULL
			   ,951
			   ,951
			   ,1
			   ,NULL
			   ,0
			   ,NULL
				)



DROP TABLE #KareoProductRule

GO

ALTER TABLE BillingInvoicing_Invoices ADD SupportTypeID INT

ALTER TABLE CustomerSettingsLog ADD SupportTypeID INT

GO



UPDATE [KareoProductLineItem]
SET [Price] = 129.00
WHERE [KareoProductLineItemID] = 2




RETURN

SELECT * FROM [KareoProductLineItem]

-- Resets
DELETE [KareoProductRule]
WHERE KareoProductRuleID > 18

DELETE [KareoProductLineItem]
WHERE [KareoProductLineItemID] >= 28






SELECT * FROM [BillingInvoicing_KareoProductRule]
WHERE invoiceRUnID = 118

SELECT * FROM BillingInvoicing_InvoiceEdits
SELECT * FROM [BillingInvoicing_InvoiceRun]
SELECT * FROM BillingInvoicing_CustomerProviders WHERE [InvoiceRunID] = 118
SELECT * FROM BillingInvoicing_KareoProviders WHERE [InvoiceRunID] = 136
SELECT * FROM [BillingInvoicing_InvoiceDetail] WHERE [InvoiceRunID] = 88 
SELECT * FROM BillingInvoicing_Invoices WHERE [InvoiceRunID] = 100
SELECT * FROM BillingInvoicing_KareoProductRuleLineItem WHERE [InvoiceRunID] = 122
SELECT * FROM BillingInvoicing_KareoProductRule  WHERE [InvoiceRunID] = 137



SELECT * FROM supportType

SELECT * FROM [KareoProduct]
SELECT * FROM [KareoProductLineItem]
SELECT * FROM [KareoProductRule]
SELECT * FROM [KareoProductRuleType]



SELECT * FROM #KareoProductRule where KareoproductRuleName = 'Basic Edition - Promo Provider'




