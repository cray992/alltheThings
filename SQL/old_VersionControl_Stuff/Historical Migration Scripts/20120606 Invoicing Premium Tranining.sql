INSERT INTO dbo.InvoicingInputItem
        ( InvoicingInputItemName )
VALUES  ( 'premium training'  -- InvoicingInputItemName - varchar(50)
          )

--Use Returned Value
INSERT INTO dbo.KareoProductLineItem
        ( KareoProductLineItemName,
          Price,
          Active,
          KareoProductLineItemDesc,
          InvoicingInputItemID,
          CreatedDate,
          CreatedUserID,
          ModifiedDate,
          ModifiedUserID,
          DefaultDateTypeID,
          Internal
        )
select  'Premium Training - Level 1 or Level 2', -- KareoProductLineItemName - varchar(128)
          1000, -- Price - money
          1, -- Active - bit
          'Premium Training - Level 1 or Level 2', -- KareoProductLineItemDesc - varchar(500)
          14, -- InvoicingInputItemID - int
          GETDATE(), -- CreatedDate - datetime
          NULL, -- CreatedUserID - int
          GETDATE(), -- ModifiedDate - datetime
          NULL, -- ModifiedUserID - int
          1, -- DefaultDateTypeID - int
          0-- Internal - bit
        UNION ALL
select  'Premium Training - Level 3 or Level 4', -- KareoProductLineItemName - varchar(128)
          1500, -- Price - money
          1, -- Active - bit
          'Premium Training - Level 3 or Level 4', -- KareoProductLineItemDesc - varchar(500)
          14, -- InvoicingInputItemID - int
          GETDATE(), -- CreatedDate - datetime
          NULL, -- CreatedUserID - int
          GETDATE(), -- ModifiedDate - datetime
          NULL, -- ModifiedUserID - int
          1, -- DefaultDateTypeID - int
          0-- Internal - bit