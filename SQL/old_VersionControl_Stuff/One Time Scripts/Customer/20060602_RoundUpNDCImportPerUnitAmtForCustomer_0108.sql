/*=============================================================================
Case 10788 - Batch posting of payments shows $0.01 unapplied in two batches  
-------------------------------------------------------------------------------
Purpose: To round the expected reimbursement and per unit cost figures up to 
         two decimal digits.
=============================================================================*/

UPDATE	NDCImport
SET	[Expec Reimb] = ROUND([Expec Reimb], 2),
	[Per Unit] = ROUND([Per Unit], 2)