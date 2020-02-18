--Update Insurance Companies to use Capario's United Healthcare (id:1431,PayerNumber 87726)
--that were using Mamsi Life(PayerNumber 52148) for Capario

UPDATE dbo.InsuranceCompany
SET ClearinghousePayerID = 1431--Capario's United Healthcare
WHERE ClearinghousePayerID
IN --Mamsi Life(PayerNumber 52148) for Capario
(
6683,
11431,
8686,
12399
)