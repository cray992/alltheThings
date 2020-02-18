-- ==============
-- Delete Duplicate Rows.
alter table impMWPRO14002
    add RowNumber Int Identity(1,1)

select * from iFeeSchedule A
    where A.RowNumber >
        ( Select Min( RowNumber ) from iFeeSchedule B Where A.Code1 = B.Code1 )

delete A from iFeeSchedule A
    where A.RowNumber >
        ( Select Min( RowNumber ) from iFeeSchedule B Where A.Code1 = B.Code1 )
-- ==============
