CREATE TABLE #ProviderCriteria(CustomerID INT, EditionTypeID INT, ProviderTypeID INT)
INSERT INTO #ProviderCriteria(CustomerID, EditionTypeID, ProviderTypeID)
VALUES(1,1,1)

INSERT INTO #ProviderCriteria(CustomerID, EditionTypeID, ProviderTypeID)
VALUES(1,1,4)

INSERT INTO #ProviderCriteria(CustomerID, EditionTypeID, ProviderTypeID)
VALUES(1,1,2)

CREATE TABLE #PracticeCriteria(CustomerID INT, EditionTypeID INT, ProviderTypeID INT)
INSERT INTO #PracticeCriteria(CustomerID, EditionTypeID, ProviderTypeID)
VALUES(1,1,NULL)

--Gather Provider KareoProductRules
CREATE TABLE #ProviderToKPR(CustomerID INT, EditionTypeID INT, ProviderTypeID INT, KareoProductRuleID INT, ExceptionProductRuleID INT)
INSERT INTO #ProviderToKPR(CustomerID, EditionTypeID, ProviderTypeID, KareoProductRuleID)
SELECT PC.CustomerID, PC.EditionTypeID, PC.ProviderTypeID, KPR.KareoProductRuleID
FROM #ProviderCriteria PC INNER JOIN KareoProductRule KPR
ON PC.EditionTypeID=KPR.EditionTypeID AND PC.ProviderTypeID=KPR.ProviderTypeID
WHERE KPR.CustomerID IS NULL AND 
((EffectiveStartDate IS NULL AND EffectiveEndDate IS NULL) OR (EffectiveStartDate<=GETDATE() AND EffectiveEndDate IS NULL)
 OR (EffectiveStartDate<=GETDATE() AND GETDATE()<=EffectiveEndDate))
UNION
SELECT PC.CustomerID, PC.EditionTypeID, PC.ProviderTypeID, KPR.KareoProductRuleID
FROM #ProviderCriteria PC INNER JOIN KareoProductRule KPR
ON PC.CustomerID=KPR.CustomerID AND PC.EditionTypeID=KPR.EditionTypeID AND PC.ProviderTypeID=KPR.ProviderTypeID
WHERE 
((EffectiveStartDate IS NULL AND EffectiveEndDate IS NULL) OR (EffectiveStartDate<=GETDATE() AND EffectiveEndDate IS NULL)
 OR (EffectiveStartDate<=GETDATE() AND GETDATE()<=EffectiveEndDate))

--Update ExceptionProductRuleIDs
UPDATE PKPR SET ExceptionProductRuleID=KareoProductRuleDef.value('(//kareoproductdeflookup/@value)[1]','INT')
FROM KareoProductRule KPR INNER JOIN #ProviderToKPR PKPR
ON KPR.KareoProductRuleID=PKPR.KareoProductRuleID
WHERE KareoProductRuleDef.exist('//kareoproductdeflookup')=1

CREATE TABLE #RuleLimitations(KareoProductRuleID INT, LimitationType VARCHAR(50), Val VARCHAR(50))
INSERT INTO #RuleLimitations(KareoProductRuleID, LimitationType, Val)
SELECT PKPR.KareoProductRuleID, KPR.KareoProductRuleDef.value('(kareoproductdef/productdef/limitations/limit/@name)[1]','VARCHAR(50)'),
KPR.KareoProductRuleDef.value('(kareoproductdef/productdef/limitations/limit/@value)[1]','VARCHAR(50)')
FROM KareoProductRule KPR INNER JOIN #ProviderToKPR PKPR
ON KPR.KareoProductRuleID=PKPR.KareoProductRuleID
WHERE PKPR.ExceptionProductRuleID IS NOT NULL

CREATE TABLE #ProviderLineItems(KareoProductRuleID INT, KareoProductLineItemID INT, Price MONEY, Allowance INT, Discount DECIMAL(5,2))
INSERT INTO #ProviderLineItems(KareoProductRuleID, KareoProductLineItemID, Price, Allowance, Discount)
SELECT KPR.KareoProductRuleID, Product.Line.value('@value','INT') KareoProductLineItemID, 
Product.Line.value('@price','MONEY') Price, Product.Line.value('@allowance','INT') Allowance,
Product.Line.value('@discount','DECIMAL(5,2)') Discount
FROM KareoProductRule KPR INNER JOIN #ProviderToKPR PKPR
ON KPR.KareoProductRuleID=PKPR.KareoProductRuleID
CROSS APPLY KPR.KareoProductRuleDef.nodes('//KareoProductLineItem') AS Product(Line)

CREATE TABLE #PracticeToKPR(CustomerID INT, EditionTypeID INT, ProviderTypeID INT, KareoProductRuleID INT, ExceptionProductRuleID INT)
INSERT INTO #PracticeToKPR(CustomerID, EditionTypeID, ProviderTypeID, KareoProductRuleID)
SELECT PC.CustomerID, PC.EditionTypeID, NULL, KPR.KareoProductRuleID
FROM #PracticeCriteria PC INNER JOIN KareoProductRule KPR
ON PC.EditionTypeID=KPR.EditionTypeID AND -1=ISNULL(KPR.ProviderTypeID,-1)
WHERE KPR.CustomerID IS NULL AND 
((EffectiveStartDate IS NULL AND EffectiveEndDate IS NULL) OR (EffectiveStartDate<=GETDATE() AND EffectiveEndDate IS NULL)
 OR (EffectiveStartDate<=GETDATE() AND GETDATE()<=EffectiveEndDate))
UNION
SELECT PC.CustomerID, PC.EditionTypeID, NULL, KPR.KareoProductRuleID
FROM #PracticeCriteria PC INNER JOIN KareoProductRule KPR
ON PC.CustomerID=KPR.CustomerID AND PC.EditionTypeID=KPR.EditionTypeID AND -1=ISNULL(KPR.ProviderTypeID,-1)
WHERE 
((EffectiveStartDate IS NULL AND EffectiveEndDate IS NULL) OR (EffectiveStartDate<=GETDATE() AND EffectiveEndDate IS NULL)
 OR (EffectiveStartDate<=GETDATE() AND GETDATE()<=EffectiveEndDate))

CREATE TABLE #PracticeLineItems(KareoProductRuleID INT, KareoProductLineItemID INT, Price MONEY, Allowance INT, Discount DECIMAL(5,2))
INSERT INTO #PracticeLineItems(KareoProductRuleID, KareoProductLineItemID, Price, Allowance, Discount)
SELECT KPR.KareoProductRuleID, Product.Line.value('@value','INT') KareoProductLineItemID, 
Product.Line.value('@price','MONEY') Price, Product.Line.value('@allowance','INT') Allowance,
Product.Line.value('@discount','DECIMAL(5,2)') Discount
FROM KareoProductRule KPR INNER JOIN #PracticeToKPR PKPR
ON KPR.KareoProductRuleID=PKPR.KareoProductRuleID
CROSS APPLY KPR.KareoProductRuleDef.nodes('//KareoProductLineItem') AS Product(Line)

CREATE TABLE #PracticeLineItemAllowances(KareoProductRuleID INT, KareoProductLineItemID INT, ProviderTypeID INT, Allowance INT)
INSERT INTO #PracticeLineItemAllowances(KareoProductRuleID, KareoProductLineItemID, ProviderTypeID, Allowance)
SELECT KPR.KareoProductRuleID, Allowances.Line.query('..').value('(KareoProductLineItem/@value)[1]','INT') KareoProductLineItemID, 
Allowance.Line.value('@providertypeid','INT') ProviderTypeID, Allowance.Line.value('.','INT') Allowance
FROM KareoProductRule KPR INNER JOIN #PracticeToKPR PKPR
ON KPR.KareoProductRuleID=PKPR.KareoProductRuleID
CROSS APPLY KPR.KareoProductRuleDef.nodes('kareoproductdef/productdef/lineitems/KareoProductLineItem/allowances') AS Allowances(Line)
CROSS APPLY Allowances.Line.nodes('allowance') AS Allowance(Line)


DROP TABLE #ProviderCriteria
DROP TABLE #PracticeCriteria
DROP TABLE #ProviderToKPR
DROP TABLE #PracticeToKPR
DROP TABLE #RuleLimitations
DROP TABLE #ProviderLineItems
DROP TABLE #PracticeLineItems
DROP TABLE #PracticeLineItemAllowances