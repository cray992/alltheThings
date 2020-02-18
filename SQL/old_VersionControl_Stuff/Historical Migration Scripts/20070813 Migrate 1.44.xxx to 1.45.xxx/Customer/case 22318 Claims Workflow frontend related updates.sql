-- Remove the items we don't need
DELETE	FROM ClaimStatusMenuItem
WHERE	MenuItemText = 'Ready' 
AND		ClaimStatusQueryFilter = 'Ready'

DELETE	FROM ClaimStatusMenuItem
WHERE	MenuItemText = 'Errors' 
AND		ClaimStatusQueryFilter = 'Errors'

DELETE	FROM ClaimStatusMenuItem
WHERE	MenuItemText = 'Pending' 
AND		ClaimStatusQueryFilter = 'Pending'

DELETE	FROM ClaimStatusMenuItem
WHERE	MenuItemText = 'All' 
AND		ClaimStatusQueryFilter = 'Ready'

DELETE	FROM ClaimStatusMenuItem
WHERE	MenuItemText = 'All' 
AND		ClaimStatusQueryFilter = 'Errors'

DELETE	FROM ClaimStatusMenuItem
WHERE	MenuItemText = 'All' 
AND		ClaimStatusQueryFilter = 'Pending'

-- Update the menu item text and rank
UPDATE	ClaimStatusMenuItem
SET		MenuItemText = 'All claims',
		[Rank] = 1
WHERE	MenuItemText = 'All'
AND		ClaimStatusQueryFilter = 'All'

UPDATE	ClaimStatusMenuItem
SET		MenuItemText = 'Ready to print paper claims',
		[Rank] = 2
WHERE	MenuItemText = 'Paper Claims to Print'
AND		ClaimStatusQueryFilter = 'ReadyPaperClaimsToPrint'

UPDATE	ClaimStatusMenuItem
SET		MenuItemText = 'Ready to submit electronic claims',
		[Rank] = 3
WHERE	MenuItemText = 'Electronic Claims to Submit'
AND		ClaimStatusQueryFilter = 'ReadyElectronicClaimsToSubmit'

UPDATE	ClaimStatusMenuItem
SET		MenuItemText = 'Ready for patient statements',
		[Rank] = 4
WHERE	MenuItemText = 'Patient Statements to Send'
AND		ClaimStatusQueryFilter = 'ReadyPatientStatementsToSend'

UPDATE	ClaimStatusMenuItem
SET		MenuItemText = 'Rejections',
		[Rank] = 5
WHERE	MenuItemText = 'Rejections'
AND		ClaimStatusQueryFilter = 'ErrorsRejections'

UPDATE	ClaimStatusMenuItem
SET		MenuItemText = 'Denials',
		[Rank] = 6
WHERE	MenuItemText = 'Denials'
AND		ClaimStatusQueryFilter = 'ErrorsDenials'

UPDATE	ClaimStatusMenuItem
SET		MenuItemText = 'No response',
		[Rank] = 7
WHERE	MenuItemText = 'No Response'
AND		ClaimStatusQueryFilter = 'ErrorsNoResponse'

UPDATE	ClaimStatusMenuItem
SET		MenuItemText = 'Pending insurance',
		[Rank] = 8
WHERE	MenuItemText = 'Insurance'
AND		ClaimStatusQueryFilter = 'PendingInsurance'

UPDATE	ClaimStatusMenuItem
SET		MenuItemText = 'Pending patient',
		[Rank] = 9
WHERE	MenuItemText = 'Patient'
AND		ClaimStatusQueryFilter = 'PendingPatient'

UPDATE	ClaimStatusMenuItem
SET		MenuItemText = 'Completed',
		[Rank] = 10
WHERE	MenuItemText = 'Completed'
AND		ClaimStatusQueryFilter = 'Completed'

-- Remove the parent menu id
ALTER TABLE 
		ClaimStatusMenuItem
DROP COLUMN
		ParentMenuItemID