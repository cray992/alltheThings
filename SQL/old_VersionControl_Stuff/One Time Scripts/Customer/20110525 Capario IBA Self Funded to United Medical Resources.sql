--Update Insurance Companies to use Capario's United Medical Resources (id:1461,PayerNumber 31107)normal ( id:13121, PayerNumber 31107) ub04
--that were using IBA Self Funded Group(PayerNumber 38234) for Capario

--Normal
UPDATE dbo.InsuranceCompany
SET ClearinghousePayerID = 1461--Capario's United Medical Resources
WHERE ClearinghousePayerID
IN -- IBA Self Funded Group(PayerNumber 38234) for Capario
(
677
)

--UB Institutional
UPDATE dbo.InsuranceCompany
SET ClearinghousePayerID = 13121--Capario's United Medical Resources
WHERE ClearinghousePayerID
IN -- IBA Self Funded Group(PayerNumber 38234) for Capario
(
13037
)