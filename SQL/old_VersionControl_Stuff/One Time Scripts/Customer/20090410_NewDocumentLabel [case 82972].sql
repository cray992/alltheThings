

insert into DocumentLabelType (DocumentLabelTypeID, Name, [Description], SortOrder) values (17, 'Letter of Medical Necessity', 'Letter of Medical Necessity', 17)
insert into DocumentLabelType (DocumentLabelTypeID, Name, [Description], SortOrder) values (18, 'Medical Record Request', 'Medical Record Request', 18)
insert into DocumentLabelType (DocumentLabelTypeID, Name, [Description], SortOrder) values (19, 'Tests', 'Tests', 19)

-- alphabetically sort labels (except "Other")
select DocumentLabelTypeID, Row_Number ( )    OVER (order by Name asc) [Rank]  into #tmp from DocumentLabelType
update DocumentLabelType 
	set SortOrder=t.[Rank]
from DocumentLabelType d
	join #tmp t on t.DocumentLabelTypeID=d.DocumentLabelTypeID
update DocumentLabelType set SortOrder=100 where [Name]='Other'
drop table #tmp
