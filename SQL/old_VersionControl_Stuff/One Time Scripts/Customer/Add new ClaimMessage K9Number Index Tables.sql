

CREATE TABLE ClaimMessage_K9Number(ClaimMessageID INT, Num1 INT, Num2 INT, ZNumber BIT)

CREATE TABLE ClaimMessage_K9Numbers(ClaimMessageID INT, Num1 INT, Num2 INT)

CREATE CLUSTERED INDEX ClaimMessage_K9Number
ON ClaimMessage_K9Number (Num1, Num2, ZNumber, ClaimMessageID)

CREATE CLUSTERED INDEX ClaimMessage_K9Numbers
ON ClaimMessage_K9Numbers (Num1, Num2, ClaimMessageID)