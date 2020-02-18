-- Import Data Cleanup Script.

use superbill_0285_prod

delete from impMWPHY1575 where code = 'NJS01'

delete from impMWPHY1576 where code = 'H'

delete from impMWPHY1577 where code = 'GAD01'

-- select * from practice

Insert Into Practice
( [Name] )
Values
( 'Dr. Nicholas Stephanou' )

Select * From Practice

Insert Into Practice
( [Name] )
Values
( 'Dr. Edward Lord' )

Insert Into Practice
( [Name] )
Values
( 'Tomball' )

Insert Into Practice
( [Name] )
Values
( 'Dr. Samuel Bharksuwan' )
