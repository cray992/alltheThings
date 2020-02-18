------------------------------------------------------------------------------
----FB 2729 - Create  bit column in Customer table for editing patient cases
--------------after Encounter has been approved.
------------------------------------------------------------------------------


USE Superbill_Shared
                        
                  
ALTER TABLE [dbo].[Customer] 
ADD EncounterApprovedCaseSelectorEnabled BIT NOT NULL, 
	CONSTRAINT [DF_Customers_EncounterApprovedCaseSelectorEnabled]  
	DEFAULT ((0)) FOR [EncounterApprovedCaseSelectorEnabled]
GO					
UPDATE [dbo].[Customer]
SET EncounterApprovedCaseSelectorEnabled = 1
WHERE CustomerID = '242'




