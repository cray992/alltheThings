UPDATE ClaimTransaction SET CreatedUserID=CreatedUserID
WHERE ClaimTransactionTypeCode IN ('CST','ADJ','PAY','END') AND CreatedUserID IS NOT NULL